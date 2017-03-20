HubManager hubManager;
OutputManager outputManager;

//Global variables
OscP5 osc;
int totalTracks = 0;

void setup()
{
  osc = new OscP5(this,64000);
  
  initHubs();
  initOutputs();
}

void draw()
{
  hubManager.update();
}

void initHubs()
{
  hubManager = new HubManager(this);
  
  String[] hubLines = loadStrings("hubs.txt");
  
  int startTrack = 0;
  
  for(int i=0;i<hubLines.length;i++)
  {
    
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