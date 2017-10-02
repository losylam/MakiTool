class LiveOutput extends OSCOutput
{
  public LiveOutput(int numTracks, String remoteIP, int remotePort, String midiDeviceName)
  {
    super(numTracks,remoteIP,remotePort,midiDeviceName);
    println("New Live Output : "+numTracks+" tracks ("+remoteIP+":"+remotePort+")");
    
    muteAddress = "/live/mute";
    volumeAddress = "/live/volume";
  }
  
  public void sendTrigger(int trigger)
  {
    //to override
    println("Send trigger note :"+trigger);
    sendMidiNote(1,trigger,127,true);
  }
}