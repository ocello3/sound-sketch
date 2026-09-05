s.quit;

/*
標準機能
Slider
Knob
Button
NumberBox
MultiSliderView
EnvelopeView
LevelIndicator
Scope
FreqScope
SoundFileView
UserView（Penを組み合わせることで自由に描画できる）
*/

// 標準のGUI
s.meter; // 入力・出力レベルメーター
s.scope; // 波形
s.freqscope; // スペクトル

/* 習得のプロセス
1. Window
2. Slider / Knob
3. LevelIndicator
4. Scope
5. FreqScope
6. AmplitudeをGUIに表示
7. FFTの値をGUIに送る
8. UserView + Pen
9. FFTを自分で描画
10. 音量で円を動かす
11. spectral centroidで円の位置を動かす
12. FFTを粒子や線にマッピングする
① SuperCollider GUI + 音量の可視化
② Pseq step visualizer
③ Teenage Engineering的なUIアニメーション
*/

/* SendReplyによるフロー
          scsynth
             │
       Amplitude.kr
             │
             ↓
       SendReply
             │
             │ OSC
             ↓
          Language
             │
             ↓
       GUIを更新
*/

// 音量をGUIに送って表示する
/*
                    SuperCollider

       Language                       Server
          │                             │
          │                         SinOsc
          │                             │
          │                        Amplitude
          │                             │
          │                       SendReply
          │                             │
          │ <────── OSC message ────────┘
          │
       amp = 0.5
          │
          ↓
       GUI更新
*/
(
// GUI
~w = Window(name: "Amplitude", bounds: Rect(200, 200, 400, 200)).front;
~level = LevelIndicator(parent: ~w, bounds: Rect(50, 50, 300, 30));

// Language側 = Receiver
OSCdef(
	key: \ampReceiver,
	func: {
		|msg| // [/amp, 1006, -1, 0.0259]
		var amp;
		amp = msg[3];
		{
			~level.value = amp
		}.defer; // 更新タイミングをGUIと同期する
	},
	path: '/amp'
);

// Server側
SynthDef(\testTone, {
	var sig, amp;
	sig = SinOsc.ar(440) * 0.2;
	amp = Amplitude.kr(sig); // Server上に存在する変数なので、SendReplyによりLanguage側に送信する
	SendReply.kr(trig: Impulse.kr(30), cmdName: '/amp', values: [amp]); // [amp]をOSCメッセージ名'/amp'として30回/sの間隔で送信する
	Out.ar(0, sig ! 2);
}).add;

x = Synth(\testTone);

)
