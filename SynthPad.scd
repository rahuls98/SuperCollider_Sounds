s.boot;

//Synth body
(
SynthDef(\pad, {
	arg atk=0.3, dur=3 , rel=0.5, curv= -2, gate=1, amp=1, //envelope arguments
	pitch = 40,
	tune1= -0.06, lffreq1=1.5, lf1low=0.14, lf1high=0.2, //signal1 arguments
	tune2= 0.06, lffreq2=2, lf2low=0.74, lf2high=0.8, //signal2 arguments
	tune3= -12.06, //tune3 is one octave below the first tune
	filtFreq = 2500; //low pass filter argument
	//pWidth1 = 0.2,

	var env, osc1, osc2, osc3, f1, f2, f3, sig1, sig2, lfo1, lfo2, sus;
	sus = dur-atk;

	//Pulse width modulation : lffreq1 - oscillating speed | range overwrites default oscillate limits to range values
	lfo1 = SinOsc.kr(lffreq1).range(lf1low, lf1high);
	lfo2 = SinOsc.kr(lffreq2).range(lf2low, lf2high);

	//frequencies for 3 oscillators
	f1 = (pitch+tune1).midicps;
	f2 = (pitch+tune2).midicps;
	f3 = (pitch+tune3).midicps;

	env = EnvGen.ar(Env.linen(atk, sus, rel, curve:curv),  gate, doneAction:2); //(env,gate,doneAction) - da:end synth after seq fin
	osc1 = Pulse.ar(f1, lfo1);
	osc2 = Pulse.ar(f2, lfo2);
	osc3 = Pulse.ar(f3, lfo1);

	sig1 = Mix.ar([osc1*0.333, osc2*0.333, osc3*0.333]); //mix of oscillators
	sig1 = RLPF.ar(sig1, filtFreq) ; //apply low pass filter
	sig2 = DelayC.ar(sig1, 0.2, 0.05); //signal with slight delay for a stereo effect
	Out.ar(0, [sig1,sig2]*env*amp); //apply env and amp, start array from bus 0 and increase bus from thereon
}).add;
)

(
Pbind(
	\instrument, \pad,
	\pitch, Pseq([
		[52,68,71,76],
		[52,68,71,75],
		[52,66,69,74],
		[52,67,72],
		[52,64,66,71],
		[47,63,66,71]
	], 1),
	\dur, Pseq([2,2,2,2,4,4], 1),
	\amp, Pseq([0.7,0.7,0.7,0.7,0.7,0.7],1)
).play
)

p = Synth.new(\pad);
p.set(\pitch, 45);
p.set(\lffreq1, 3);
p.free;

s.quit;