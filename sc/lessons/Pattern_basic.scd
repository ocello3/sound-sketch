s.boot;
s.quit;

/* Patternの他の関数との比較
LFNoise = 時間とともに連続的に変化する
Dust = 確率的にイベントを発生させる
TRand = イベント発生時に値を決める
Pattern = イベントを「いつ・どんな順番で」発生させるか決める -> 時間構造を記述する
*/

/* degree
0 → C
1 → D
2 → E
3 → F
4 → G
5 → A
6 → B
*/

(
Pbind( // PatternからEventを生成する
    \instrument, \default,
    \degree, Pseq([0, 2, 4, 7], inf), // 順番に値を生成する
    \dur, Prand([0.1, 0.4, 1.0], inf), // リストからランダムに値を選ぶ
    \amp, Pwhite(0.1, 0.5, inf), // 0.1〜0.5の範囲でランダムに値を選ぶ
).play;
)

// SynthDefをdegreeで制御する方法
(
SynthDef(\tone, {
	|freq = 440, amp = 0.1|
	var env, output;

	env = EnvGen.kr(
		Env.perc(attackTime: 0.01, releaseTime: 0.2),
		doneAction: 2
	);

	output = SinOsc.ar(freq: freq, mul: env * amp);

	Out.ar(0, output ! 2);
}).add;

Pbind(
	\instrument, \tone,
	\scale, Scale.major, // scaleを指定できる
	\octave, 8, // octaveの指定
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\dur, 0.3
).play;
)

