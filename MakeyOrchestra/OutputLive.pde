class LiveOutput extends Output
{
  public LiveOutput(int numTracks, String remoteIP, int remotePort, String midiDeviceName)
  {
    super(numTracks,remoteIP,remotePort,midiDeviceName);
    println("New Live Output : "+numTracks+" tracks ("+remoteIP+":"+remotePort+")");
  }
  
  public  void sendTrackMute(int track, boolean mute)
  {
     OscMessage m = new OscMessage("/live/mute");
    m.add(track);
    m.add(mute?1:0);
    osc.send(m,remote);
  }
  
  public void sendTrackVolume(int track, float volume)
  {
    //to override
    OscMessage m = new OscMessage("/live/volume");
    m.add(track);
    m.add(volume);
    println("send : "+m.address());
    osc.send(m,remote);
  }
  
  public void sendTrigger(int trigger)
  {
    //to override
    println("Send trigger note :"+trigger);
    sendMidiNote(1,trigger,127);
  }
}