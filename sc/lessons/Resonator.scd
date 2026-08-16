s.boot;
s.quit;

// Exciter（励振）とResonator（共鳴）
(
{
	var trig = Dust.kr(2);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.01),
		gate: trig
	);
	var exciter = WhiteNoise.ar * env * 0.3; // エネルギー＝励振信号
	var sig = Ringz.ar(
		exciter,
		freq: 1200,
		decaytime: 1.3
	);
	[sig, sig] * 0.4
}.play;
)

// 複数のRingzを重ねる
// 物質は一般的に複数の固有振動を持つので、複数のRingzを重ねることで、よりリアルな音を作ることができる
(
{
	var trigger = Dust.kr(1);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar * env * 0.3;
	var sig =
	Ringz.ar(exciter, freq: 30, decaytime: 1) +
	Ringz.ar(exciter, freq: 200, decaytime: 0.5) +
	Ringz.ar(exciter, freq: 300, decaytime: 0.3);
	sig = sig * 0.4;
	[sig, sig]
}.play;
)
(
{
	var trigger = Dust.kr(1);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.01),
		gate: trigger
	);
	var exciter = WhiteNoise.ar * env * 0.3;
	var sig =
	Ringz.ar(exciter, freq: 30, decaytime: 1) +
	Ringz.ar(exciter, freq: 200, decaytime: 0.5) +
	Ringz.ar(exciter, freq: 300, decaytime: 0.3);
	sig = sig * 0.4;
	[sig, sig]
}.play;
)

// Klank（複数のRingzを実装しやすくする関数）
(
{
	var trigger = Dust.kr(1);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.01),
		trigger
	);
	var exciter = WhiteNoise.ar * env * 0.3;
	var sig = Klank.ar(
		`[ // バッククオートは参照を渡すための演算子（Ref Array）信号データと設定データを区別するため
			[600, 1100, 2700], // freq: 共鳴周波数
			[1.0, 0.4, 0.15], // amplitude
			[2.0, 5.0, 8.0] // reduction time: 減衰時間
		],
		exciter
	);
	sig = sig * 0.4;
	[sig, sig]
}.play;
)

// DynKlank パラメータが時間変化するKlank
// 応用例：コップに水を入れると音程が下がる、弦を押さえると長さが変わる、ドアを少し開けると共鳴が変わる
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
