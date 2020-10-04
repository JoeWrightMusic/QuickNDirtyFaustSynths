import("stdfaust.lib");

f = hslider("freq",440.9,50,2000,0.01);
vib = hslider("vib",4.5,0.001,7,0.01);
vibWid = hslider("vibWid",0.007,0,0.05,0.01);
phasor(freq) = (+(freq/ma.SR) ~ ma.decimal);
osc(freq, amp) = sin(phasor(freq)*2*ma.PI)*amp;
vibrato = 1+ osc(vib, vibWid);

organ(freq) = (
    no.noise*(0.01*vibrato):fi.highpass(10, 223):fi.lowpass(10,8000) +
    osc(freq*vibrato+no.lfnoise(4410)*freq*0.03,   0.05*vibrato) + 
    osc(freq*2*vibrato+no.lfnoise(4410)*freq*0.05, 0.2*vibrato) + 
    osc(freq*3*vibrato+no.lfnoise(4410)*freq*0.06, 0.5*vibrato) + 
    osc(freq*4*vibrato+no.lfnoise(4410)*freq*0.08, 0.04*vibrato) + 
    osc(freq*5*vibrato+no.lfnoise(4410)*freq*0.1, 0.15*vibrato) + 
    osc(freq*6*vibrato+no.lfnoise(4410)*freq*0.11, 0.05*vibrato) + 
    osc(freq*7*vibrato+no.lfnoise(4410)*freq*0.13, 0.01*vibrato) +
    osc(freq*8*vibrato+no.lfnoise(4410)*freq*0.15, 0.003*vibrato) + 
    osc(freq*9*vibrato+no.lfnoise(4410)*freq*0.16, 0.001*vibrato) 
)<:(_*0.7)+(_:fi.resonbp(223.08,1,1));

process = organ(f)/7;