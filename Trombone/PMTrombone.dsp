import("stdfaust.lib");


// fund = hslider("fundFreq", 440, 223.88, 932.33, 0.1);
// vibratoHz = hslider("vibratoHz", 4, 0, 10, 0.01);
// vibratoWidth = hslider("vibratoWidth", 0.15, 0, 1, 0.01);

// //phasor
// phasor(freq) = (+(freq/ma.SR) ~ ma.decimal);
// //sine
// osc(freq, amp) = sin(phasor(freq)*2*ma.PI)*amp; 
// //AM
// am(freq, amt) = 1 - ((osc(freq,0.5)+0.5) * amt);
// //FM
// fm(freq, amt) = 1 + (osc(freq,amt));
// //partial


pressure = 0.1
trombone = pm.brassModel_ui(pressure);
//NEED TO FIND ARGUMENTS FOR NOTES
//Note  Press   Tube    Lips    Mute
//

process = trombone;