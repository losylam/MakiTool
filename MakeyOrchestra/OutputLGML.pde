class LGMLOutput extends Output
{
  public LGMLOutput(int numTracks, String remoteIP, int remotePort, String midiDeviceName)
  {
    super(numTracks,remoteIP,remotePort,midiDeviceName);
    println("New LGML Output : "+numTracks+" tracks ("+remoteIP+":"+remotePort+")");
  }
  
  public  void sendTrackMute(int track, boolean mute)
  {
    OscMessage m = new OscMessage("/node/looper/tracks/"+track+"/mute");
    m.add(mute?1.0:0.0);
    osc.send(m,remote);
  }
  
  public void sendTrackVolume(int track, float volume)
  {
    //to override
    OscMessage m = new OscMessage("/node/looper/tracks/"+track+"/volume");
    volume = map(volume, 0, 1, 0, 0.8);
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