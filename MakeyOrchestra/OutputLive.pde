class LiveOutput extends Output
{
  public LiveOutput(int numTracks, String remoteIP, int remotePort, String midiDeviceName)
  {
    super(numTracks,remoteIP,remotePort,midiDeviceName);
    println("New Live Output : "+numTracks+" tracks ("+remoteIP+":"+remotePort+")");
  }
  
  public  void sendTrackMute(int track, boolean mute)
  {
    
  }
  
  public void sendTrackVolume(int track, float volume)
  {
    //to override
  }
  
  public void sendTrigger(int trigger)
  {
    //to override
  }
}