#include <Audio.h>
#include "Oboe.h"
#define btSerial Serial4

Oboe oboe;
AudioOutputI2S out;
AudioControlSGTL5000 audioShield;
AudioConnection patchCord0(oboe,0,out,0);
AudioConnection patchCord1(oboe,0,out,1);

int fsrPin = A0; 

void setup() {
  AudioMemory(200);
  audioShield.enable();
  audioShield.volume(1);
  oboe.setParamValue("vol", 0.2);
}

int gate = 0;
float midiNote = 0;
int fsrReading = 0;
int prevReading = 0;

void loop() {
  fsrReading = analogRead(fsrPin);
  midiNote = map(fsrReading, 0,1023,60,72);
  midiNote = round(midiNote);

//oboe array from touchpads
//oboe function takes care of notes/envs
  
  if(prevReading!=fsrReading){gate=0;}
  else{gate=1;}
  if(fsrReading==0){gate=0;}

  oboe.setParamValue("fundFreq",midiNote);
  oboe.setParamValue("trigger",gate); 
  
}
