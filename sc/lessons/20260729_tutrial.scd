// #31 Trigger Ugens
// simple sine ver
(
{
	var trigger = Dust.kr(density: 3);
	var freq = TRand.kr(
		lo: 400,
		hi: 2000,
		trig: trigger
	);
	var envelope = EnvGen.kr(
		Env.perc(
			attackTime: 0.001,
			releaseTime: 0.05
		),
		gate: trigger
	);
	var output = SinOsc.ar(
		freq: freq,
		mul: envelope * 0.3
	);
	[output, output]
}.play;
)

// resonator ver
(
{
	var trigger = Dust.kr(density: 2);
	var freq = TExpRand.kr(lo: 500, hi: 2500, trig: trigger);
	var decay = TRand.kr(lo: 0.2, hi: 2.5, trig:trigger);
	var amp = TRand.kr(lo: 0.05, hi: 0.2, trig: trigger);
	var envelope = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar(mul: envelope);
	var output = Ringz.ar(
		in: exciter,
		freq: freq,
		decaytime: decay
	);
	output = output * amp;
	[output, output]
}.play;
)

// #32 multiple property
(
{
	var trigger = Dust.kr(density: 20.0);
	var material = TRand.kr(lo: 0.5, hi: 1.5, trig: trigger);
	var freq = TRand.kr(lo: 660, hi: 2500, trig: trigger) * material;
	var decayTime = TRand.kr(lo: 0.005, hi: 0.015, trig: trigger) * material;
	var amp = TRand.kr(lo: 0.05, hi: 0.15, trig: trigger);
	var pan = TRand.kr(lo: -1.0, hi: 1.0, trig: trigger);
	var envelope = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar(mul: envelope);
	var resonator = Ringz.ar(in: exciter, freq: freq, decaytime: decayTime);
	var output = resonator * amp;
	Pan2.ar(in: output, pos: pan);
}.play;
)

// #33 Common Cause Parameter
// Step-1. Size of Drop
(
{
	var wind = LFNoise1.kr(freq: 0.1).range(0.3, 1.5);
	var trigger = Dust.kr(density: wind * 3);
	var dropSize = TRand.kr(lo: 0.5, hi: 1.5, trig: trigger);

	var baseFrequency = 2000;
	var baseDecayTime = 2.0;
	var baseAmplitude = 0.08;

	var frequency = baseFrequency / dropSize;
	var decayTime = baseDecayTime * dropSize;
	var amplitude = baseAmplitude * dropSize;
	var pan = TRand.kr(lo: -1, hi: 1, trig: trigger) * wind;

	var envelope = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar(mul: envelope * amplitude);
	var output = Ringz.ar(in: exciter, freq: frequency, decaytime: decayTime);
	Pan2.ar(in: output, pos: pan);
}.play;
)

// #34 Conbine Multiple Controller
// Step-1. Weather and Wind
(
{
	var weather = LFNoise1.kr(freq: 0.002).range(0.5, 2.0);
	var wind = LFNoise2.kr(freq: 0.3).range(0.7, 1.3);

	var density = weather * wind * 3;
	var trigger = Dust.kr(density: density);

	var dropSize = TRand.kr(lo: 0.5, hi: 1.5, trig: trigger);

	var baseFrequency = weather.linexp(
		inMin: 0.5,
		inMax: 2.0,
		outMin: 1000,
		outMax: 1800)
	;
	var baseDecay = 0.5;
	var baseAmplitude = 0.08;

	var frequency = baseFrequency / dropSize;
	var decayTime = baseDecay * dropSize;
	var amplitude = baseAmplitude * dropSize;
	var pan = TRand.kr(lo: -1.0, hi: 1.0, trig: trigger);

	var envelope = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar(mul: envelope * amplitude);
	var resonator = Ringz.ar(in: exciter, freq: frequency, decaytime: decayTime);
	Pan2.ar(in: resonator, pos: pan);
}.play
)

// #35 Separate Code in Global and Local
(
{
	// ----- Global ----- //
	var weather = LFNoise1.kr(freq: 0.1).range(0.7, 1.5);
	var wind = LFNoise2.kr(freq: 0.2).range(0.8, 1.2);

	var baseDensity = 3;
	var baseFrequency = 1500;
	var baseDecay = 0.5;
	var baseAmplitude = 0.08;

	//var density = baseDensity * weather * wind;
	var density = weather.linexp(inMin: 0.5, inMax: 2.0, outMin: 0.5, outMax: 20);

	// ----- Event ----- //
	var trigger = Dust.kr(density: density);
	var dropSize = TRand.kr(lo: 0.6, hi: 1.4, trig: trigger);
	var pan = TRand.kr(lo: -1, hi: 1, trig: trigger);
	var frequency = baseFrequency / dropSize;
	var decayTime = baseDecay * dropSize;
	var amplitude = baseAmplitude * dropSize;
	var envelope = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar(mul: envelope * amplitude);
	var resonator = Ringz.ar(in: exciter, freq: frequency, decaytime: decayTime);

	Pan2.ar(in: resonator, pos: pan);
}.play;
)


