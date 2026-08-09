{
	LPF.ar(
		Saw.ar(220),
		1000
	)
}.play;

{
	LPF.ar(
		WhiteNoise.ar(0.2),
		8000
	)
}.play;

{
	SinOsc.ar(440) * 0.2
	+
	SinOsc.ar(442) * 0.2
}.play;

{
	SinOsc.ar(
		SinOsc.kr(1).range(220, 880), // 1Hzで220〜880を往復する
		mul: 0.2
	)
}.play;

{
	LPF.ar(
		WhiteNoise.ar(),
		SinOsc.kr(0.1).range(300, 5000),
		mul: 0.2
	)
}.play;

// Envelope
{
	var env = EnvGen.kr( // 設計図を時間に沿って再生するUGen
		Env.perc(0.01, 1.0), // 時間変化の設計図
		doneAction: 2 // Synth終了
	);
	SinOsc.ar(440, mul: env * 0.2)
}.play;

// SynthDef
(
SynthDef(\simpleTone, {
	|freq = 440|

	var env = EnvGen.kr(
		Env.perc(0.01, 1),
		doneAction: 2
	);

	Out.ar(
		0,
		SinOsc.ar(freq, mul: env * 0.2)
	);
}).add;
)
Synth(\simpleTone, [\freq, 660]);

// SynthDef with Gate
(
SynthDef(\adsrTone, {
	|freq = 440, gate = 1|

	var env = EnvGen.kr(
		Env.adsr(
			attackTime: 0.01,
			decayTime: 0.2,
			sustainLevel: 0.7,
			releaseTime: 0.5
		),
		gate: gate,
		doneAction: 2
	);

	Out.ar(
		0,
		SinOsc.ar(freq) * env * 0.2
	);
}).add;
)
x = Synth(\adsrTone);
x.set(\gate, 0);

// Bus System
b = Bus.audio(s, 1);

// Osc Synth
(
SynthDef(\osc, {
	Out.ar(
		b,
		Saw.ar(220, 0.2)
	);
}).add;
)

// Filter Synth
(
SynthDef(\filter, {
	var sig;
	sig = In.ar(b, 1);
	sig = LPF.ar(sig, 800);
	Out.ar(0, sig);
}).add;
)

y = Synth(\filter);
x = Synth(\osc);



