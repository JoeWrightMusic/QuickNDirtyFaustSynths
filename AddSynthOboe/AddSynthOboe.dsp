import("stdfaust.lib");

//OBOE ARGUMENTS
//choose note & define range (Bb3-Bb5)
fund = hslider("fundFreq", 440, 223.88, 932.33, 0.1);
vibratoHz = hslider("vibratoHz", 4, 0, 10, 0.01);
vibratoWidth = hslider("vibratoWidth", 0.15, 0, 1, 0.01);

//phasor
phasor(freq) = (+(freq/ma.SR) ~ ma.decimal);
//sine
osc(freq, amp) = sin(phasor(freq)*2*ma.PI)*amp; 
//AM
am(freq, amt) = 1 - ((osc(freq,0.5)+0.5) * amt);
//FM
fm(freq, amt) = 1 + (osc(freq,amt));
//partial
partial(fund, ratio, amp) = sin(
        phasor(fund*ratio*fm(vibratoHz, 
        vibratoWidth*0.0022*ratio*ratio)
    )*2*ma.PI)*amp;

oboe(fund, amp) = (
    no.noise*0.03 +
    partial(fund, 1.000, 0.260) +
    partial(fund, 1.986, 1.080) +
    partial(fund, 2.968, 0.080) +
    partial(fund, 3.987, 0.100) +
    partial(fund, 4.989, 0.040) +
    partial(fund, 5.956, 0.010) +
    partial(fund, 6.974, 0.010) +
    partial(fund, 7.977, 0.005) 

)*amp*am(vibratoHz, vibratoWidth); 



process = oboe(fund, 0.1);