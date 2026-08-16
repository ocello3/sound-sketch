s.boot;
s.quit;

// Trigger Ugens
(
{
	var trigger = Dust.kr(density: 3);
	var freq = TRand.kr( // triggerによりランダムな値を生成する vs LFNoiseは一定周期で値を生成する
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

// Resonatorとの組み合わせ
(
{
	var trigger = Dust.kr(density: 2);
	var freq = TExpRand.kr(lo: 500, hi: 2500, trig: trigger); // 指数分布の乱数を返す
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

// 多くのパラメータを制御する
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
