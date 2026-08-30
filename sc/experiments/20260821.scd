s.quit;

(
// Audio Bus
~windAudioBus = Bus.audio(s, 2);
~rainAudioBus = Bus.audio(s, 2);
~resonanceAudioBus = Bus.audio(s, 2);
~masterLevel = 1;
~masterOutput = {
	var wind, rain, resonance, output;
	wind = In.ar(~windAudioBus, 2);
	rain = In.ar(~rainAudioBus, 2);
	resonance = In.ar(~resonanceAudioBus, 2);
	output = wind + rain + resonance;
	// output = wind;
	output = output * ~masterLevel;
	output = LeakDC.ar(output);
	output = HPF.ar(output, freq: 20);
	output = Limiter.ar(output);
	Out.ar(0, output);
}.play;

// Control Bus
~materialControlBus = Bus.control(s, 1);
~materialState = {
	var material01;
	material01 = LFNoise0.kr(freq: 1/5).range(0, 1); // 0=soft, 1=hard
	Out.kr(~materialControlBus, material01);
}.play;
~rainControlBus = Bus.control(s, 1);
~rainState = {
	var rain01;
	rain01 = LFNoise0.kr(freq: 1/8).range(0,1); // 0=weak, 1=hard
	Out.kr(~rainControlBus, rain01);
}.play;
~windControlBus = Bus.control(s, 1);
~windState = {
	var wind01;
	wind01 = LFNoise0.kr(freq: 1/4).range(0, 1); // 0=weak, 1=hard
	Out.kr(~windControlBus, wind01);
}.play;

// 風の音
~wind = {
	var wind01, base, wobble, cutoff, sig;
	wind01 = In.kr(~windControlBus, 1);
	base = wind01.range(1500, 3500);
	base = LFNoise2.kr(0.1).range(base - 1000, base + 1000);
	base.poll(trig: 1, label: "base");
	wobble = LFNoise1.kr(6).range(wind01 * (-5), wind01 * 5);
	cutoff = base + wobble;
	sig = WhiteNoise.ar(wind01.range(0.05, 0.4));
	sig = LPF.ar(sig, cutoff);
	Out.ar(~windAudioBus, [sig, sig]);
}.play;

// 雨の音
~rain = {
	var rain01 = In.kr(~rainControlBus, 1);
	var density = rain01.range(0.2, 4); // 雨の密度を調整できる
	var trigger = Dust.kr(density);
	var env = EnvGen.kr(
		Env.perc(0.001, rain01.range(0.1, 0.5)), // Envelopeで雨の音を調整できる
		gate: trigger
	);
	var sig = WhiteNoise.ar;
	var pan = TRand.kr(lo: -1 * rain01, hi: rain01, trig: trigger);
	sig = HPF.ar(sig, rain01.range(2000, 800));
	sig = sig * env * rain01.range(0.1, 0.3);
	sig = Pan2.ar(sig, pan);
	Out.ar(~rainAudioBus, sig);
}.play;

// Resonance
SynthDef(\resonance, {
	|freq = 60, decayTime = 1.3, brightness = 3000, amp = 0.3|
	var wind01 = In.kr(~windControlBus, 1);
	var rain01 = In.kr(~rainControlBus, 1);
	var env;
	var excitation;
	var output;
	var pan = wind01.range(-1, 1);
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
	output = Pan2.ar(output, pan);

	Out.ar(~resonanceAudioBus, output);
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