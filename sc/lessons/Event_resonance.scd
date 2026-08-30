s.quit;

// 何かに小さな衝撃が加わった音
(
SynthDef(\eventResonance, {
	|freq = 1000, decayTime = 0.3, amp = 0.2|
	var trigger, env, excitation, output;

	trigger = Dust.kr(density: 0.3);
	env = Decay2.kr(in: trigger, attackTime: 0.001, decayTime: 0.02);
	excitation = WhiteNoise.ar(mul: env);
	output = Ringz.ar(in: excitation, freq: freq, decaytime: decayTime);
	output = output * amp;

	// Release synth
	DetectSilence.ar(in: output, amp: 0.0001, time: 0.1, doneAction: 2);

	// Safety
	output = LeakDC.ar(output);
	output = Limiter.ar(output,level: 0.8);
	output = HPF.ar(output, freq: 20);

	Out.ar(0, Pan2.ar(output));
}).add;

/*x = Synth(\eventResonance,
	[
		\freq, 800,
		\decayTime, 1.5,
		\amp, 0.4
	]
);*/

Pbind(
	\instrument, \eventResonance,
	\freq, Pseq([1500, 1800, 900, 1500], inf),
	\decayTime, Pseq([0.1, 0.2, 0.08, 0.15], inf),
	\amp, Pwhite(0.05, 0.15, inf),
	\dur, Pwhite(0.2, 1.0, inf)
).play;
)
