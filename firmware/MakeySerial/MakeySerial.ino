#include "makey.h"

Makey makey;

void setup()
{
  Serial.begin(9600);
  
  makey.setup();
  makey.addCallbackTouch(&onMakeyTouch);
  makey.addCallbackRelease(&onMakeyRelease);
  
  
}

void loop()
{
   makey.update(); 
   
  while(Serial.available() > 0)
  {
    char c = Serial.read();
    Serial.write('e'); //echo
    Serial.write(c);
    Serial.write(255);
  }
}

void onMakeyTouch(int touchID)
{
  sendTouch(touchID,true);
}

void onMakeyRelease(int touchID)
{
  sendTouch(touchID,false);
}


void sendTouch(int touchID, bool value)
{
   Serial.write('p');
   Serial.write(touchID);
   Serial.write(value);
   Serial.write(255);
}
