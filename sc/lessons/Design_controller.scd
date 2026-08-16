// freqやampをコントロールするための上位のパラメータ
(
{
	// ----- Controller ----- //
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

// 前のコードのwindなどをコントロールするためのさらに上位のパラメータ
(
{
	// ----- Global controller ----- //
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

// 最上位のパラメータを正規化した場合
(
{
	var weather01 = LFNoise1.kr(freq: 0.01).range(lo: 0.0, hi: 1.0); // 0=sunny, 1=rainy
	var wind01 = LFNoise2.kr(freq: 0.2).range(lo: 0.0, hi: 1.0);

	var density = weather01.linexp(inMin: 0.0, inMax: 1.0, outMin: 1.0, outMax: 15.0);
	var baseFreq = weather01.linlin(0.0, 1.0, 2200, 900); // sunny=high, rainy=low
	var panSpread = wind01.linlin(0.0, 1.0, 0.1, 1.0); // less wind=central, more wind=spread

	var trigger = Dust.kr(density: density);
	var env = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01),
		gate: trigger
	);
	var output = WhiteNoise.ar(mul: env * 0.3);

	var pan = TRand.kr(lo: -1 * panSpread, hi: panSpread, trig: trigger);
	Pan2.ar(in: output, pos: pan);
}.play;
)
