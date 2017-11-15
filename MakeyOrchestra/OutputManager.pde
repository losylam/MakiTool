class OutputManager
{
  ArrayList<Output> outputs;
  
  public OutputManager()
  {
    outputs = new ArrayList<Output>();
  }
  
  public void addOutput(String type, int numTracks, String remoteIP, int remotePort, String midiName)
  {
    Output output = null;
    
    if(type.equals("live"))
    {
      output = new LiveOutput(numTracks, remoteIP,remotePort,midiName);
    }else if(type.equals("ardour"))
    {
      output = new ArdourOutput(numTracks, remoteIP,remotePort,midiName);
    }else if(type.equals("LGML"))
    {
      output = new LGMLOutput(numTracks, remoteIP,remotePort,midiName);
    }
    
    if(output == null)
    {
      println("Output type unknown : "+type);
      return;
    }
    
    outputs.add(output);
  }
  
  public void sendTrackMute(int track, boolean mute)
  {
    for(int i=0;i<outputs.size();i++) outputs.get(i).sendTrackMute(track,mute);
  }
  
  public void sendTrackVolume(int track, float volume)
  {
    for(int i=0;i<outputs.size();i++) outputs.get(i).sendTrackVolume(track,volume);
  }
  
  public void sendTrigger(int trigger)
  {
    for(int i=0;i<outputs.size();i++) outputs.get(i).sendTrigger(trigger);
 }
}