#ifndef MAKEY_H
#define MAKEY_H

#include "Arduino.h"

////////////////////////
// DEFINED CONSTANTS////
////////////////////////

#define BUFFER_LENGTH    3     // 3 bytes gives us 24 samples
//#define TARGET_LOOP_TIME 694   // (1/60 seconds) / 24 samples = 694 microseconds per sample
//#define TARGET_LOOP_TIME 758  // (1/55 seconds) / 24 samples = 758 microseconds per sample
#define TARGET_LOOP_TIME 744  // (1/56 seconds) / 24 samples = 744 microseconds per sample

//#define TARGET_LOOP_TIME 416   // (1/100 seconds) / 24 samples = 694 microseconds per sample

#define NUM_INPUTS 18

 //SPECIAL FOR BROKEN MAKEY
 /*
const int makeyPinNumbers[NUM_INPUTS] = {
  12, 8, 13,     // top of makey makey board
  5, 4, 3,       // left side of female header, KEYBOARD
  23, 22, 21, 20, 19, 18   // right side of female header, MOUSE
};
*/


const int makeyPinNumbers[NUM_INPUTS] = {
  12, 8, 13, 15, 7, 6,     // top of makey makey board
  5, 4, 3, 2, 1, 0,        // left side of female header, KEYBOARD
  23, 22, 21, 20, 19, 18   // right side of female header, MOUSE
};


///////////////////////////
// NOISE CANCELLATION /////
///////////////////////////
#define SWITCH_THRESHOLD_OFFSET_PERC  5    // number between 1 and 49
                                           // larger value protects better against noise oscillations, but makes it harder to press and release
                                           // recommended values are between 2 and 20
                                           // default value is 5

#define SWITCH_THRESHOLD_CENTER_BIAS 55   // number between 1 and 99
                                          // larger value makes it easier to "release" keys, but harder to "press"
                                          // smaller value makes it easier to "press" keys, but harder to "release"
                                          // recommended values are between 30 and 70
                                          // 50 is "middle" 2.5 volt center
                                          // default value is 55
                                          // 100 = 5V (never use this high)
                                          // 0 = 0 V (never use this low
                                          
        

class Makey {
public:
    
    
    ///////////////////////////
    // FUNCTIONS //////////////
    ///////////////////////////
    void setup();
    void update();
    void initializeArduino();
    void initializeInputs();
    void updateMeasurementBuffers();
    void updateBufferSums();
    void updateBufferIndex();
    void updateInputStates();
    void addDelay();
    
    void sendTouch();
    
    typedef void(*onEvent)(int);
    
    void (*onTouch) (int);
    void (*onRelease) (int);
    
    void addCallbackTouch (onEvent);
    void addCallbackRelease (onEvent);
    

};

#endif
