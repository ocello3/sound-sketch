// Bus with two SynthDef

(
b = Bus.audio(s, 1);

SynthDef(\osc, {
	Out.ar(
		b,
		Pulse.ar(220, mul: 0.2)
	);
}).add;

SynthDef(\filter, {
	var sig;
	sig = In.ar(b, 1);
	sig = LPF.ar(sig, 300);
	Out.ar(0, sig);
}).add;
)
y = Synth(\filter);
x = Synth(\osc);

// No 17, Control Bus
(
c = Bus.control(s, 1);
SynthDef(\lfo, {
	|out|
	Out.kr(
		out,
		SinOsc.kr(0.3).range(300, 3000)
	);
}).add;
)

// control bus
(
c = Bus.control(s, 1);
SynthDef(\lfo, {
	|out|
	Out.kr(
		out,
		SinOsc.kr(0.3).range(300, 3000)
	);
}).add;
SynthDef(\filterSaw, {
	|inBus|
	var cutoff;
	var sig;
	cutoff = In.kr(inBus);
	sig = Saw.ar(220, 0.2);
	sig = LPF.ar(sig, cutoff);
	Out.ar(0, sig);
}).add;
x = Synth(\lfo, [
	\out, c
]);
y = Synth(\filterSaw, [
	\inBus, c
]);
)


