// Exciter（励振）とResonator（共鳴）
(
{
	var trig = Dust.kr(2);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.01),
		gate: trig
	);
	var exciter = WhiteNoise.ar * env;
	var sig = Ringz.ar(
		exciter,
		freq: 1200,
		decaytime: 2
	);
	[sig, sig] * 0.2
}.play;
)

// #26 multipe resonance
// Modes - 複数の固有振動
(
{
	var trigger = Dust.kr(1);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar * env;
	var sig =
	Ringz.ar(exciter, freq: 30, decaytime: 1) +
	Ringz.ar(exciter, freq: 200, decaytime: 0.5) +
	Ringz.ar(exciter, freq: 300, decaytime: 0.3);
	sig = sig * 0.15;
	[sig, sig]
}.play;
)

// #27 Klank = multipe Ringz
(
{
	var trigger = Dust.kr(1);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.01),
		trigger
	);
	var exciter = WhiteNoise.ar * env;
	var sig = Klank.ar(
		`[
			[1000, 1800, 3200], // freq
			[1.0, 0.4, 0.15], // amplitude
			[2.0, 5.0, 8.0] // reduction time
		],
		exciter
	);
	sig = sig * 0.15;
	[sig, sig]
}.play;
)

// #28 grammer - backquate
// Klank -> Ref（Arrayへの参照を渡す） -> Array
// 信号データと設定データの区別のためにRef形式にする
// `は参照にする演算子

// #29 DynKlank パラメータが時間変化するKlank
(
{
	var trigger = Dust.kr(density: 2.0);
	var env = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar * env;
	var shift1 = LFNoise2.kr(freq: 1).range(0.5, 1.5);
	var shift2 = LFNoise2.kr(freq: 2).range(0.5, 1.5);
	var shift3 = LFNoise2.kr(freq: 4).range(0.5, 1.5);
	var sig = DynKlank.ar(
		specificationsArrayRef: `[
			[500 * shift1, 900 * shift2, 1500 * shift3],
			[0.5, 0.3, 0.4],
			[1.2, 1.0, 0.7]
		],
		input: exciter
	);
	sig = sig * 0.15;
	[sig, sig]
}.play;
)
