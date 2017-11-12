//Global variables
HubManager hubManager;
OutputManager outputManager;
OscP5 osc;

//global variables
int totalTracks;

//play settings
boolean useVolume = true; // if false, volume pin will have no effect

//display settings
int globalRadius = 300;
int flowerRadius = 200;
int flowerSize = 80;

PFont Font;

void setup()
{
  fullScreen(2); //force on second display
  
  frameRate(60);
  //size(1280,800);
  background(0);

  Font = createFont("Arial Bold", 20);
  textAlign(CENTER);
  textFont(Font);

  osc = new OscP5(this,64000);
  
  initHubs();
  initOutputs();  
}

void draw()
{
  background(0);
  //hubManager.draw();
}

void initHubs()
{
  hubManager = new HubManager(this);
  
  String[] hubLines = loadStrings("hubs.txt");
  
  int startTrack = 0;
  
  for(int i=0;i<hubLines.length;i++)
  {
    if(hubLines[i].charAt(0) == '#') continue;
    String[] hubSplit = hubLines[i].split(",");
    String type = hubSplit[2];
    int numTracks = parseInt(hubSplit[1]);
    String portName = hubSplit[0];
    
    int targetStart = startTrack;
    if(type.equals("trigger")) targetStart = 0;
    
    hubManager.addHub(portName,targetStart,numTracks,type);
    
    if(type.equals("track")) startTrack += numTracks;
    
  }
  
  totalTracks = startTrack;
}

void initOutputs()
{
  outputManager = new OutputManager();
  
  String[] outputLines = loadStrings("outputs.txt");
  
  for(int i=0;i<outputLines.length;i++)
  {
    String[] outputSplit = outputLines[i].split(",");
    String type = outputSplit[0];
    String remoteIP = outputSplit[1];
    int remotePort = parseInt(outputSplit[2]);
    String midiPortName = "";
    if(outputSplit.length >= 4) midiPortName = outputSplit[3];
    
    outputManager.addOutput(type,totalTracks,remoteIP,remotePort,midiPortName);
  }
}


//Methods called from hubs
void trackMuteCallback(int track, boolean mute)
{
  outputManager.sendTrackMute(track,mute);
}

void trackVolumeCallback(int track, float volume)
{
  outputManager.sendTrackVolume(track,volume);
}

void triggerCallback(int trigger)
{
  outputManager.sendTrigger(trigger);
}


//test
void keyPressed()
{
  switch(key)
  {
    case ' ':
    hubManager.reset();
    break;
    
    case '1':
    hubManager.hubs.get(0).toggleTrackActive(0);
    break;
    
    case '2':
    hubManager.hubs.get(0).toggleTrackActive(1);
    break;
    
    case '+':
    hubManager.hubs.get(1).setTrackVolume(0,hubManager.hubs.get(1).trackVolumes[0]+.1f);
    break;
    
     case '-':
    hubManager.hubs.get(1).setTrackVolume(0,hubManager.hubs.get(1).trackVolumes[0]-.1f);
    break;
    
    case 't':
    hubManager.hubs.get(4).triggerTrack(0);
    break;
    
    case 'v':
    for(int i=0;i<hubManager.hubs.size();i++) hubManager.hubs.get(i).showText = !hubManager.hubs.get(i).showText;
  }
}