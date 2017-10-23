class ArdourOutput extends Output
{
  public ArdourOutput(int numTracks, String remoteIP, int remotePort, String midiDeviceName)
  {
    super(numTracks,remoteIP,remotePort,midiDeviceName);
    println("New Live Output : "+numTracks+" tracks ("+remoteIP+":"+remotePort+")");
  }
  
  public  void sendTrackMute(int track, boolean mute)
  {
    println("sent mute, track : " + track) ;
    OscMessage m = new OscMessage("/strip/fader");
    m.add(track + 1);
    m.add(mute?0:0.8);
    osc.send(m,remote);
  }
  
  public void sendTrackVolume(int track, float volume)
  {
    println("sent volume, track : " + track + ", volume :"+volume);
    //to override
    OscMessage m = new OscMessage("/strip/fader");
    m.add(track + 1);
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