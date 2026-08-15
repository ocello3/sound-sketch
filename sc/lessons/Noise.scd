s.boot;
s.quit;

// LFNoiseの基礎
(
{
	var freq;
	freq = LFNoise2.kr(2).range(200, 800); // 2Hzの周期でランダムな周波数を生成する
	SinOsc.ar(freq, 0, 0.2)
}.play;
)


(
{
	var amp = LFNoise0.kr(2).range(0.05, 0.3); // 2Hzの周期で音量をランダムに変化させる（次の更新タイミングまで値を保持する）
	// 0: 次の値まで段階的に変化する
	// 1: 次の値まで線形に変化する
	// 2: 次の値まで滑らかに・加速度的に変化する
	SinOsc.ar(440, 0, amp)
}.play;
)

(
{
	var freq;
	freq = WhiteNoise.kr(mul: 1).range(200, 800); // krの周期でランダムな周波数を生成する
	SinOsc.ar(freq, 0, 0.2)
}.play;
)

(
{
	var amp = LFNoise0.kr(20).range(0.05, 0.5); // 音量は段階的に変化
	var freq = LFNoise2.kr(2).range(100, 1200); // 周波数は加速度的に変化
	SinOsc.ar(freq, 0, amp)
}.play;
)

// LFNoiseをローパスフィルタのカットオフに使用する
(
{
	var cutoff1, cutoff2, sig1, sig2;
	cutoff1 = LFNoise2.kr(2).range(400, 4000);
	cutoff2 = LFNoise1.kr(1).range(600, 5000);
	sig1 = LPF.ar(
		WhiteNoise.ar(0.4),
		cutoff1
	);
	sig2 = LPF.ar(
		WhiteNoise.ar(0.4),
		cutoff2
	);
	[sig1, sig2]
}.play;
)

// 複数の時間軸を持つ場合（周波数）
(
x = {
	var slow;
	var fast;
	var freq;
	slow = LFNoise2.kr(0.1).range(300, 700);
	fast = LFNoise1.kr(4).range(-30, 30);
	freq = slow + fast;
	SinOsc.ar(freq, mul: 0.5) ! 2;
}.play;
)

// 複数の時間軸を持つ場合（フィルター周波数）
(
{
	var base;
	var wobble;
	var cutoff;
	var sig;
	base = LFNoise2.kr(0.1).range(1500, 3500);
	wobble = LFNoise1.kr(6).range(-300, 300);
	cutoff = base + wobble;
	sig = WhiteNoise.ar(0.2);
	sig = LPF.ar(sig, cutoff);
	[sig, sig]
}.play;
)
