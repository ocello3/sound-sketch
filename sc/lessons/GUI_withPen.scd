s.quit;

// UserViewとPenを用いて描画する
(
// GUI
~w = Window(
	name: "Amplitude Visual",
	bounds: Rect(200, 200, 400, 300)
).front;
~view = UserView(
	parent: ~w,
	bounds: Rect(0, 0, 400, 300)
);
~amp = 0;
~view.drawFunc = { // UserViewの描画を記述する
	/* 音量を円のサイズにMappingする
	var size, x, y;
	size = ~amp.linlin(inMin: 0, inMax: 0.2, outMin: 20, outMax: 200);
	x = 200 - (size / 2);
	y = 150 - (size / 2);
	Pen.fillOval(
		rect: Rect(x, y, size, size)
	);
	*/
	// 音量に応じて横長の長方形にする
	var width, height, x, y;
	width = ~amp.linexp(0, 0.2, 20, 200);
	height = 300 * 0.1;
	x = (400 - 200) / 2;
	y = 300 / 2;
	Pen.fillRect(
		rect: Rect(x, y, width, height);
	);
};

// Language側でOSCを受信して~ampを更新する
OSCdef(
	key: \ampReceiver,
	func: {
		|msg|
		var amp;
		amp = msg[3];
		{
			~amp = amp; // global変数として宣言した~ampに受信した数値を割り当てる
			~view.refresh; // 音量が変わった時に画面を更新する
		}.defer;
	},
	path: '/amp'
);

// Synth
SynthDef(name: \testTone,
	ugenGraphFunc: {
		var sig, amp;
		sig = SinOsc.ar(440) * 0.2 * SinOsc.kr(0.5).range(0, 1);
		amp = Amplitude.kr(sig);
		SendReply.kr(
			trig: Impulse.kr(30),
			cmdName: '/amp',
			values: [amp]
		);
		Out.ar(0, sig ! 2);
	}
).add;

// 実行
x = Synth(defName: \testTone);

)