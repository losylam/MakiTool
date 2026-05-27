class HubManager
{
  ArrayList<Hub> hubs;
  PApplet parent;
  
  public HubManager(PApplet parent)
  {
    this.parent = parent; 
    hubs = new ArrayList<Hub>();
  } 
  
  public void draw()
  {
    pushStyle();
    pushMatrix();
    translate(width/2,height/2);
    fill(50);
    ellipseMode(CENTER);
    ellipse(0,0,globalRadius/3,globalRadius/3);
    
    
    for(int i=0;i<hubs.size();i++)
    {
      float angle = (i*1.f/hubs.size())*PI*2;
      hubs.get(i).update();
      hubs.get(i).set(cos(angle)*globalRadius,sin(angle)*globalRadius);
      hubs.get(i).draw();
    }
    
    popMatrix();
    popStyle();
  }
  
  public void reset()
  {
   for(int i=0;i<hubs.size();i++)
   {
     hubs.get(i).reset();
   }
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
    
    hubs.add(new Hub(parent, hubs.size(), t , startTrack,numTracks, portName));
  }
}