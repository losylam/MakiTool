class HubManager
{
  ArrayList<Hub> hubs;
  PApplet parent;
  
  public HubManager(PApplet parent)
  {
    this.parent = parent; 
    hubs = new ArrayList<Hub>();
  } 
  
  public void update()
  {
    for(int i=0;i<hubs.size();i++) hubs.get(i).update();
  }
  
  public void addHub(String portName, int startTrack, int numTracks, String type)
  {
    HubType t = null;
    if(type.equals("track")) t = HubType.TRACK;
    else if(type.equals("trigger")) t = HubType.TRIGGER;
    
    if(t == null)
    {
      println("Hub type unknown : " + type);
      return;
    }
    
    hubs.add(new Hub(parent, t , startTrack,numTracks, portName));
  }
}