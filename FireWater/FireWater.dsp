import("stdfaust.lib");


fireWater = hslider("fireWater",0,0,1,0.01);
vol = hslider("vol", 0, 0,1,0.01):si.smoo;
fireDens = (fireWater:max(0.3) - 0.3)*140;
waterflow = (1-fireWater)*100 +50;
fireVol = fireWater;
waterVol = 1-(fireWater*2) : max(0);
//100-140

//Utilities-----------
lfNoise(freq) = no.lfnoise0(freq):si.smooth(ba.tau2pole(1/freq));
randRange0(freq, lo, hi) = no.lfnoise0(freq)*((hi-lo)*0.5)+(lo+((hi-lo)*0.5));
randRange1(freq, lo, hi) = lfNoise(freq)*((hi-lo)*0.5)+(hi-(lo));
dust(freq, thresh) = no.lfnoise(freq) >(thresh);
clip(in, thresh) = in : min(thresh) : max(thresh * -1);

//FIRE------------------
phutBalance=0.4;
popBalance=1;
hissBalance=0.05;
woofBalance=0.3;

hiss(freq) = no.noise * lfNoise(freq)*lfNoise(freq): fi.resonhp(randRange1(freq*0.4,2500,10000),3,0.5)*hissBalance;
phut(freq) = en.ar(0.00001, randRange1(5, 0.0,0.02), dust(freq, 0.7))*no.noise : fi.resonlp(randRange1(freq,900,3000),4,0.5) * phutBalance * lfNoise(freq);
pop(freq) = en.ar(0.000001,0.00001,dust(freq, 0.7)):fi.resonlp(randRange1(freq*10,600,15000),1,1) * popBalance * lfNoise(freq*0.2)*lfNoise(freq*0.5);
woof(freq) = no.pink_noise * lfNoise(freq)*lfNoise(freq)*100: fi.resonlp(randRange1(freq*0.4,80,150),3,0.5) : clip(_, 1): fi.resonlp(2000,1,1);

fire = woof(1) + woof(1 + fireDens*0.4) + hiss(fireDens*0.05 ) + phut(fireDens*0.9) + pop(1 +(fireDens*100) ) : clip(_, 1): co.limiter_1176_R4_mono*fireVol;




//WATER
trigs = dust(waterflow, 0.7);
env = en.ar(0.015,1,trigs);
freq = ba.midikey2hz(randRange0(waterflow, 70, 98)) + (lfNoise(20)*300) + (env*17);
someWater = os.osc(freq)*0.3*env:fi.fi.lowpass3e(700);
stream = (someWater+someWater)*0.2*waterVol;




process = (stream+(fire))*vol;