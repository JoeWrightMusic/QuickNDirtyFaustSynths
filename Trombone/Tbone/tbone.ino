#include <Audio.h>
#include "trombone.h"

trombone  tbone;
AudioOutputI2S out;
AudioControlSGTL5000 audioShield;
AudioConnection patchCord0(tbone,0,out,0);
AudioConnection patchCord1(tbone,0,out,1);


int fsrPin = 14; 
int reading = 0;

//PM parameters for c3-b4
float tubeLengths[24] = {
  3.500, 3.280, 3.085, 2.935, 2.760, 2.600,  
  2.460, 2.310, 2.075, 1.930, 1.790, 1.660,   
  1.540, 1.420, 1.310, 1.210, 1.120, 1.030,   
  0.950, 0.880, 0.820, 2.310, 2.170, 2.060
  };
float lipTensions[24] = {
  0.63, 0.63, 0.63, 0.64, 0.64, 0.64,
  0.64, 0.64, 0.60, 0.59, 0.58, 0.57, 
  0.56, 0.55, 0.54, 0.53, 0.52, 0.51, 
  0.50, 0.49, 0.48, 0.84, 0.85, 0.86 
  };
float pressures[24] = {
  0.05, 0.05, 0.05, 0.05, 0.05, 0.05,
  0.05, 0.05, 0.05, 0.05, 0.05, 0.05,
  0.05, 0.05, 0.05, 0.05, 0.05, 0.05,
  0.05, 0.05, 0.05, 0.07, 0.07, 0.07
  };
void setup() {
  Serial.begin(9600); 

  
  AudioMemory(20);
  audioShield.enable();
  audioShield.volume(0.01);
}


void loop() {
//reading = analogRead(fsrPin);
//tube = reading/1023.0;
for(int i=0; i<24; i++){
  Serial.println(tubeLengths[i]);
  tbone.setParamValue("length", tubeLengths[i]);
  tbone.setParamValue("lipsTension", lipTensions[i]);
  tbone.setParamValue("pressure", pressures[i]);
  tbone.setParamValue("vibratoHz", 0);
  tbone.setParamValue("vibratoWidth", 0);
  tbone.setParamValue("vol", 0.1+(i*0.005));
  delay(1000);
}
}
