import processing.serial.*;

enum HubType {
  TRACK, TRIGGER
};

color[] hubColors = {color(50,255,0),color(50,0,255),color(255,255,0),color(255,100,0),color(0,255,255)};

class Hub extends PVector
{
  Serial port;
  HubType type;
  PApplet parent;
  
  int index;
  String portName;
  boolean isConnected;
  
  int numTracks;
  int startTrack;
  
  color hubColor;
  
  boolean[] trackActives;//not used in triggers
  float[] trackVolumes; //also used for trigger animations
  float[] trackDims; //for volume animation
  float[] trackAlphas; //for ui 
  
  //serial
  int bufferIndex;
  int[] buffer;
  
  boolean showText;
  
  public Hub(PApplet parent, int index, HubType type, int startTrack, int numTracks, String portName )
  {
    println("New Hub ("+type+":"+portName+") : "+startTrack+">"+numTracks);

    this.index = index;
    this.parent = parent;
    this.portName = portName;
    this.type = type;
    this.startTrack = startTrack;
    this.numTracks = numTracks;
    
    hubColor = hubColors[index];
    
    trackActives = new boolean[numTracks];
    trackVolumes = new float[numTracks];
    trackAlphas = new float[numTracks];
    trackDims = new float[numTracks];
    
    for(int i=0;i<numTracks;i++)
    {
      trackAlphas[i] = 0;
      trackActives[i] = false;
      trackVolumes[i] = type == HubType.TRACK?.85f:0;
    }
    
    buffer = new int[32];
    
    showText = true;
    
    connect();
  }
  public void reset()
  {
    for(int i=0;i<numTracks;i++)
    {
      trackAlphas[i] = 0;
      setTrackActive(i,false);
      setTrackVolume(i,.85f);
    }
  }
  
  public void draw()
  {
    //update volumes depending on dims
    for(int i=0;i<numTracks;i++)
    {
      if(trackDims[i] == 0) continue;
      setTrackVolume(i, trackVolumes[i] + trackDims[i]);
    }
    
    pushStyle();
    pushMatrix();
    translate(x,y);
    fill(hubColor);
    noStroke();
    ellipseMode(CENTER);
    ellipse(0,0,flowerRadius/3,flowerRadius/3);
    
    for(int i=0;i<numTracks;i++)
    {
      float angle = (i*1.f/numTracks)*PI*2;
      float dist = type == HubType.TRACK?trackVolumes[i]:1; //0-1 depending on volume
      dist = map(dist,0,1,.2f,1);
      trackAlphas[i] += (int(trackActives[i])-trackAlphas[i])*.2f;
      
      noFill();
      stroke(hubColor);
      strokeWeight(4);
      PVector trackEdge = new PVector(cos(angle)*(flowerRadius*dist-flowerSize/2),sin(angle)*(flowerRadius*dist-flowerSize/2));
      PVector trackCenter = new PVector(cos(angle)*flowerRadius*dist,sin(angle)*flowerRadius*dist);
      
      line(0,0,trackEdge.x,trackEdge.y);
      ellipse(trackCenter.x,trackCenter.y,flowerSize,flowerSize);
      noStroke();
      fill(255,trackAlphas[i]*255);
      float targetSize = type == HubType.TRACK?(flowerSize+(cos(millis()/300.f)-.5f)*flowerSize/2):flowerSize;
      ellipse(trackCenter.x,trackCenter.y,targetSize,targetSize);     
      
      if(showText)
      {
        fill(hubColor);
        textSize(34);
        //        text((startTrack+i+1)+"",trackCenter.x+flowerSize*.75f,trackCenter.y+flowerSize*.75f);
        text((startTrack+i+1)+"",trackCenter.x,trackCenter.y+12);
      }
    }
    
    popMatrix();
    popStyle();
  }
  
  public void connect()
  {
    if (port != null)
    {
      port = null;
    }

    try
    {
      port = new Serial(parent, portName, 9600); 
      isConnected = true;
      hubColor = hubColors[index];
    }
    catch(Exception e)
    {
      println("Could not connect to "+portName+" : "+e.getMessage());
      isConnected = false;
      hubColor = color(255,0,0);
    }
  }

  public void update()
  {
    processSerial();
  }

  public void processSerial()
  {
    if (!isConnected) return;
    while (port.available () > 0)
    {
      int c = port.read();
      switch(c)
      {
        case 255:
        processBuffer();
        bufferIndex = 0;
        break;
        
        case 112: //p
        bufferIndex = 0;
        break;
        
        default:
        if(bufferIndex < 31)
        {
          buffer[bufferIndex] = c;
          bufferIndex++;
        }
      }
    }
  }
  
  public void processBuffer()
  {
    int pin = buffer[0];
    int val = buffer[1];
    int track = type ==HubType.TRACK?floor(pin/3):pin; // if TRIGGER all pins are a trigger track
    int command = type == HubType.TRACK?pin%3:0; //if TRIGGER all pins are a trigger track
    
    if(track >= numTracks)
    {
      println("Wrong track : "+track);
      return;
    }
    
     switch(command)
    {
      case 0: //Mute
      if(val == 1)
      {
        if(type == HubType.TRACK) toggleTrackActive(track);
        else triggerTrack(track);
      }
      break;
      
      case 1: //Volume up
      trackDims[track] = (val == 1)?.01f:0f;
      break;
      
      case 2: //Volume down
      trackDims[track] = (val == 1)?-.01f:0f;
      break;
      
    }
  }
  
  public void toggleTrackActive(int index)
  {
    setTrackActive(index,!trackActives[index]);
  }
  
  public void setTrackActive(int index, boolean value)
  {
    trackActives[index] = value;
    trackMuteCallback(startTrack+index,!trackActives[index]);
  }
  
  public void setTrackVolume(int index, float value)
  {
    if(!useVolume) return;
    trackVolumes[index] = min(max(value,0),1);
    trackVolumeCallback(startTrack+index,trackVolumes[index]);
  }
  
  public void triggerTrack(int index)
  {
    trackVolumes[index] = 0;
    trackAlphas[index] = 1;
    triggerCallback(startTrack+index);
  }
}