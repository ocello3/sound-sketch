s.boot;
s.quit;

// #20 Event
// Inpulse.kr(2) 一定間隔
// Dust.kr(5) ランダム
// Changed ある値が変化したら

// Dust
// Envelopeのgateをトリガーする
(
{
	var trigger = Dust.kr(12);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.03),
		gate: trigger
	);
	var noise = WhiteNoise.ar;
	var sig = HPF.ar(noise, 4000);
	sig = sig * env * 0.3;
	[sig, sig]
}.play;
)

// 応用編（雨の音のシミュレーション）
(
{
	var densitiy = LFNoise1.kr(0.2).range(1, 4); // 雨の密度を調整できる
	var trigger = Dust.kr(densitiy);
	var env = EnvGen.kr(
		Env.perc(0.001, 0.3), // Envelopeで雨の音を調整できる
		gate: trigger
	);
	var sig = WhiteNoise.ar;
	sig = HPF.ar(sig, 2000);
	sig = sig * env * 0.08;
	[sig, sig]
}.play;
)
