import("stdfaust.lib");

//OBOE ARGUMENTS
//choose note & define range (Bb3-Bb5)
fund = hslider("fundFreq", 60, 60, 72, 0.001):ba.midikey2hz;
vibratoHz = hslider("vibratoHz", 4, 0, 10, 0.01)+(randomize(0.7));
trigger = button("trigger");
randomize(amt)=no.sparse_noise(5)*amt+(amt)+(0.002);
vSlowEnv = en.adsr(2*randomize(2),0.0,1,0.03,trigger);
fastEnv1 = en.adsr(0.01*randomize(1.5),0.01,0.8,0.03,trigger);
fastEnv2 = en.adsr(0.02*randomize(1.5),0.02,0.8,0.03,trigger);
fastEnv3 = en.adsr(0.04*randomize(2.5),0.04,0.8,0.03,trigger);
fastEnv4 = en.adsr(0.08*randomize(2.5),0.08,0.8,0.03,trigger);
fastEnv7 = en.adsr(0.14*randomize(3.5),0.14,0.8,0.03,trigger);
medEnv = en.adsr(0.2*randomize(1.5),0.05,0.8,0.03,trigger);
vibratoWidth = hslider("vibratoWidth", 0.45, 0, 1, 0.01)*vSlowEnv*randomize(0.4);
vol = hslider("vol", 1, 0, 1, 0.001);

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
        vibratoWidth*.0028*ratio)
    )*2*ma.PI)*amp;

pulse = os.pulsetrain(fund*fm(vibratoHz, 
        vibratoWidth*.0018),0.88):fi.bandpass(
            3,110,1720
            // fund*fm(vibratoHz, vibratoWidth*.0018)-(fund*0.05),
            // fund*fm(vibratoHz, vibratoWidth*.0018)+(fund*0.05)
        );
oboe(fund, amp) = (
    no.noise*0.003*fastEnv1 +
    partial(fund, 1, 0.30)*fastEnv4*vol +
    partial(fund, 2, 0.580)*fastEnv2*vol +
    partial(fund, 3, 0.680)*fastEnv3*vol +
    partial(fund, 4, 0.150)*fastEnv4*vol +
    partial(fund, 5, 0.080)*fastEnv4*vol +
    partial(fund, 6, 0.020)*fastEnv7*vol +
    partial(fund, 7, 0.01)*medEnv*vol +
    partial(fund, 8, 0.003)*medEnv*vol +
    (pulse*0.15)*en.adsr(0.01,0.01,0.8,0.03,trigger)
)*amp*am(vibratoHz, vibratoWidth):fi.resonbp(fund*fm(vibratoHz, 
        vibratoWidth*.0018),0.025,200)*vol ; 



process = oboe(fund, 0.1)<:_,_;