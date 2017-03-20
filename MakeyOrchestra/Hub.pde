import processing.serial.*;

enum HubType {
  TRACK, TRIGGER
};

color[] hubColors = {color(255,0,0),color(0,255,0),color(0,0,255),color(255,255,0),color(255,0,255),color(0,255,255)};

class Hub extends PVector
{
  Serial port;
  String portName;
  boolean isConnected;
  int numTracks;
  int startTrack;
  int index;
  HubType type;
  PApplet parent;


  public Hub(PApplet parent, int index, HubType type, int startTrack, int numTracks, String portName )
  {
    this.index = index;
    this.parent = parent;
    this.portName = portName;
    this.type = type;
    this.startTrack = startTrack;
    this.numTracks = numTracks;

    println("New Hub ("+type+":"+portName+") : "+startTrack+">"+numTracks);
    connect();
  }
  
  public void draw()
  {
    pushStyle();
    pushMatrix();
    translate(x,y);
    fill(hubColors[index]);
    noStroke();
    ellipseMode(CENTER);
    ellipse(0,0,flowerRadius/3,flowerRadius/3);
    
    for(int i=0;i<numTracks;i++)
    {
      float angle = (i*1.f/numTracks)*PI*2;
      float dist = 1; //0-1 depending on volume
      noFill();
      stroke(hubColors[index]);
      strokeWeight(3);
      PVector trackPos = new PVector(cos(angle)*flowerRadius*dist,sin(angle)*flowerRadius*dist);
      line(0,0,trackPos.x,trackPos.y);
      noStroke();
      fill(hubColors[index]);
      ellipse(trackPos.x,trackPos.y,flowerSize,flowerSize);
      
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
    }
    catch(Exception e)
    {
      println("Could not connect to "+portName);
      isConnected = false;
    }
  }

  public void update()
  {
    processSerial();
  }

  public void processSerial()
  {
    if (!isConnected) return;
    while (port.available() > 0)
    {
      //process
    }
  }
}