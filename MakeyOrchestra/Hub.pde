import processing.serial.*;

enum HubType {TRACK,TRIGGER};
  
class Hub
{
  Serial port;
  String portName;
  boolean isConnected;
  int numTracks;
  int startTrack;
  HubType type;
  PApplet parent;
  
  public Hub(PApplet parent, HubType type, int startTrack, int numTracks, String portName )
  {
    this.parent = parent;
    this.portName = portName;
    this.type = type;
    this.startTrack = startTrack;
    this.numTracks = numTracks;
    
    println("New Hub ("+type+":"+portName+") : "+startTrack+">"+numTracks);
    connect();
  }
  
  public void connect()
  {
    if(port != null)
    {
      port = null;
    }
    
    try
    {
      port = new Serial(parent,portName,9600); 
      isConnected = true;
    }catch(Exception e)
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
    if(!isConnected) return;
    while(port.available() > 0)
    {
      //process
    }
  }
}