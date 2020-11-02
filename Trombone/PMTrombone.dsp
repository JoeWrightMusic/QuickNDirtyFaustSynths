import("stdfaust.lib");


tubeLength = hslider("length",3.3,0,5,0.01);
lipsTension = hslider("lipsTension",0.62,0,1,0.01);
mute = hslider("mute",0,0,1,0.01);
pressure = hslider("pressure",0.05,0,1,0.01);

vol = hslider("vol",1,0,2,0.01);
vibratoHz = hslider("vibratoHz", 4, 0, 10, 0.01);
vibratoWidth = hslider("vibratoWidth", 0.15, 0, 1, 0.01);
//phasor
phasor(freq) = (+(freq/ma.SR) ~ ma.decimal);
//sine
osc(freq, amp) = sin(phasor(freq)*2*ma.PI)*amp; 

trombone = pm.brassModel(tubeLength,lipsTension,mute,pressure);
ampVib = vol+osc(vibratoHz, vibratoWidth);
process = trombone*ampVib;





/*c3-g3
3.5 0.63
2.28 0.63
3.085 0.63
2.935 0.64
2.76 0.64
2.6 0.64
2.47 0.65
2.33 0.65

//G#3-Eb4
2.075 0.6
1.93   0.59
1.79   0.58
1.66   0.57
1.54    0.56
1.42    0.55
1.31    0.54
1.21    0.53

//E4-G#4
1.12    0.52
1.03    0.51
0.95    0.5
0.88    0.49
0.82    0.48

A4-B4
2.31    0.84     0.07
2.17    0.85     0.07
2.06    0.86     0.07
