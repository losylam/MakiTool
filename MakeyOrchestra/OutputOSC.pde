class OSCOutput extends Output
{
  
  public String muteAddress;
  public String volumeAddress;
  public String triggerAddress;
  
  public OSCOutput(int numTracks, String remoteIP, int remotePort, String midiDeviceName)
  {
    super(numTracks,remoteIP,remotePort,midiDeviceName);
    
    println(" > New OSC Output");
    
    muteAddress = "/orchestra/mute";
    volumeAddress = "/orchestra/volume";
    triggerAddress = "/orchestra/trigger";
  }
  
  public  void sendTrackMute(int track, boolean mute)
  {
    if(muteAddress != null && muteAddress.length() == 0) return;
    
     OscMessage m = new OscMessage(muteAddress);
    m.add(track);
    m.add(mute?1:0);
    osc.send(m,remote);
  }
  
  public void sendTrackVolume(int track, float volume)
  {
    if(volumeAddress.length() == 0) return;
    
    OscMessage m = new OscMessage(volumeAddress);
    m.add(track);
    m.add(volume);
    osc.send(m,remote);
  }
  
  public void sendTrigger(int trigger)
  {
    if(triggerAddress.length() == 0) return;
    
    OscMessage m = new OscMessage(triggerAddress);
    m.add(trigger);
    osc.send(m,remote);
  }
}