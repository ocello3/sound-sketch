s.boot;
s.quit;

// #1 Basic
・
// 信号の流れの例（Saw -> LPF -> Out）
(
{ // `{}`は関数オブジェクト
	LPF.ar( // `LPF.ar()`では、LPFがクラスでarがクラスメソッド
		Saw.ar(220), // `WhiteNoise.ar(0.2)`も試す
		1000 // work: 周波数を変更してみる
	)
}.play;
)

// 2つのSin回路の出力を足し合わせる
(
{
	SinOsc.ar(440) * 0.2 + SinOsc.ar(442) * 0.2
}.play;
)

// UGenでUGenを制御する（モジュレーション）
// 例：ビブラート、サイレン、フィルターの開閉、パンニング、トレモロ
(
{
	SinOsc.ar(
		SinOsc.kr(1).range(220, 880), // freqが1Hzでモジュレートされる. 0.5Hz, 300-5000も試す
		mul: 0.2
	)
}.play;
)

// WhiteNoiseをLPFでフィルタリングする例（波の音）
(
{
	LPF.ar(
		WhiteNoise.ar(),
		SinOsc.kr(0.1).range(300, 5000),
		mul: 0.2
	)
}.play;
)

// Envelope
(
{
	var env = EnvGen.kr( // 設計図を使って時間に沿って再生するUGen
		Env.perc(attackTime: 0.01, releaseTime: 1.0), // 時間変化の設計図
		doneAction: 2 // Synth終了
	);
	SinOsc.ar(440, mul: env * 0.2) // 今回は音量にenvを利用したが、周波数にも利用できる
}.play;
)

// SynthDef
(
SynthDef(\adsrTone, {
	|freq = 440, gate = 1|

	var env = EnvGen.kr(
		Env.adsr(
			attackTime: 0.01,
			decayTime: 0.2,
			sustainLevel: 0.7,
			releaseTime: 0.5
		),
		gate: gate, // gateが1のときは音が鳴り、0のときはreleaseTimeに沿って音が消える
		doneAction: 2
	);

	Out.ar(
		0,
		SinOsc.ar(freq) * env * 0.2
	);
}).add;
)
x = Synth(\adsrTone); // 音が鳴り続ける
x.set(\gate, 0); // 音が止まる
/*
gateの考え方：イベントの開始と終了を信号として扱える
雨なら、雨粒が生まれ（gate = 1）、地面に当たって消える（gate = 0）
鳥なら、鳴き始めめ（gate = 1）、鳴き終わる（gate = 0）
*/

// Bus System
/* 信号の通路｜音や制御信号が流れるための共有の通路
UGen
    ↓
Synth（小さな回路）
    ↓
Bus（配線）
    ↓
Synth（別の回路）
    ↓
Group（システム）

*/
(
b = Bus.audio(s, 1);
SynthDef(\osc, {
	Out.ar(
		bus: b, // スピーカーではなく、バスbへ送る
		chnannelsArray: Saw.ar(220, 0.2)
	);
}).add;
SynthDef(\filter, {
    var sig;
    sig = In.ar(b, 1); // バスbから受け取る
    sig = LPF.ar(sig, 800);
    Out.ar(0, sig);
}).add;
)
y = Synth(\filter);
x = Synth(\osc);
