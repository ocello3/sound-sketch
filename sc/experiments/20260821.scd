s.quit;

/*
todo
resonanceを~material01を使ってパラメータをコントロールしたい
mixerを整備する：シグナルを変数でまとめる
*/

(
~material01 = 0.6; // 0=soft, 1=hard
~rain01 = 0.5; // 0=weak, 1=hard

// 風の音
{
	var base;
	var wobble;
	var cutoff;
	var sig;
	base = LFNoise2.kr(0.1).range(1500, 3500);
	wobble = LFNoise1.kr(6).range(-300, 300);
	cutoff = base + wobble;
	sig = WhiteNoise.ar(0.08);
	sig = LPF.ar(sig, cutoff);
	[sig, sig]
}.play;

// 雨の音
{
	var densitiy = LFNoise1.kr(0.2).range(1, 4); // 雨の密度を調整できる
	var trigger = Dust.kr(densitiy);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.3), // Envelopeで雨の音を調整できる
		gate: trigger
	);
	var sig = WhiteNoise.ar;
	sig = HPF.ar(sig, 2000);
	sig = sig * env * 0.1;
	[sig, sig]
}.play;

SynthDef(\resonance, {
	|freq = 60, decayTime = 1.3, brightness = 3000, amp = 0.3|
	var env;
	var excitation;
	var output;
	// var freq = ~material01.linexp(0.0, 1.0, 500, 5000);
	// var decayTime = ~material01.linlin(0.0, 1.0, 0.08, 2.0);
	// var brightness = ~material01.linlin(0.0, 1.0, 2500, 7000);

	env = EnvGen.kr(
		Env.perc(attackTime: 0.0005, releaseTime: 0.1),
	);
	excitation = WhiteNoise.ar(mul: env * 0.7);
	excitation = HPF.ar(in: excitation, freq: brightness);

	output = Ringz.ar(in: excitation, freq: freq, decaytime: decayTime);
	output = output * amp;
	DetectSilence.ar(in: output, amp: 0.0001, time: 0.1, doneAction: 2);
	output = Pan2.ar(output);

	Out.ar(
		0,
		output
	);
}).add;

Pbind(
    \instrument, \resonance,
	\scale, Scale.minor,
	\octave, Pseq([8, 7, 8, 6], inf),
	\degree, Pseq([3, 2, 5, 2, 4], inf),
	\decayTime, Pseq([0.1, 0.01, 1.8], inf),
	\dur, Pseq([1, 0.2, 1.8], inf),
	\brightness, Pwhite(2500, 7000),
    \amp, Pwhite(0.1, 0.5, inf)
).play;
)


// output = Pan2.ar(output);

// ----- Safety ----- //
	output = output;
	output = LeakDC.ar(output);
	output = HPF.ar(output, freq: 20);
	output = Limiter.ar(output);
	output;
)