import oscP5.*;
import netP5.*;
import themidibus.*;

class Output
{  
  NetAddress remote;
  MidiBus midi;
  
  int numTracks;
  
  public Output(int numTracks, String remoteIP, int remotePort, String midiDeviceName)
  {
    remote = new NetAddress(remoteIP,remotePort);
    
    this.numTracks = numTracks;
    
    if(!midiDeviceName.equals(""))
    {
        midi = new MidiBus(this, -1, midiDeviceName);
    }
    
    init();
  }
  
  public void init()
  {
    for(int i=0;i<numTracks;i++)
    {
      sendTrackMute(i,true);
      sendTrackVolume(i,0.85);
    }
  }
 
  public void sendMessage(OscMessage m)
  {
    osc.send(m,remote); 
  }
  
  public void sendMidiNote(int channel, int pitch, int velocity)
  {
    midi.sendNoteOn(channel, pitch, velocity);
  }
  
  
  //FUNCTIONS TO CALL
  public void sendTrackMute(int track, boolean mute)
  {
    //to override
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