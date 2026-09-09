s.quit;
s.freeAll;

(
~visualStep = 0;
~musicState = (
	step: 0,
	degree: 0,
	freq: 0
);
~animation.stop;
~player.stop;
~clock = TempoClock(80 / 60); // bpm = 80
~degrees = [0, 2, 4, 7, 4, 2];
~size = 500;

~w = Window(
	name: "Step Visualizer",
	bounds: Rect(200, 200, ~size, ~size)
).front;
~w.onClose = {
	CmdPeriod.run; // windowを閉じた時にCmd + .を実行して全て停止する
};
~w.alwaysOnTop = true; // windowを最前面に固定する
~w.background = Color.white; // 背景色の指定

~view = UserView(parent: ~w, bounds: Rect(0, 0, ~size, ~size));

~view.drawFunc = {
	var degreeRange, rectCount, margin, degreeHeight, rectWidth, rectHeight;

	degreeRange = 12: // 1 octave from tmp
	rectCount = ~degrees.size;
	margin = ~size * 0.1;
	degreeHeight = (~size - (margin * 2)) / degreeRange;
	rectWidth = (~size / rectCount) + (margin * 2);
	rectHeight = ~size * 0.01;

	~degrees.do { |degree, i|
		var x, y, color;

		x = i * width + (width / 2);
		y = ~height - ((degree * ~height / 12) + ());

		if ((i - ~visualStep).abs < 0.5) {
			color = Color.grey(0.0); // 0: black, 1: white
		} {
			color = Color.grey(0.7);
		};

		Pen.fillColor = color;
		Pen.fillRect(Rect(x, y, width, height));
	};
};

SynthDef(\stepTone, {
	|freq = 440|
	var env;
	env = EnvGen.kr(Env.perc(0.01, 0.2), doneAction: 2);
	Out.ar(0, (SinOsc.ar(freq) * env * 0.3) ! 2);
}).add;

~player = Pbind( // Pbindは複数のPatternから値を取り出してEvent {step: 2, freq: 293, dur: 1}を作っている
	\instrument, \stepTone,
	\step, Pseq((0 .. (~degrees.size - 1)), inf), // GUIのために追加, [0, 1, 2, 3, 4, 5]
	\degree, Pseq(~degrees, inf),
	\root, 0,
	\octave, 5,
	\dur, 1,
	\finish, { // Eventのplay処理前に実行され、Eventデータを操作できる
		var state; // deferされるタイミングは処理前なのでEventはnilであるため、初期化する
		state = (
			step: ~step, // global変数ではなく、実行されているEventのEnvironmentから値を取得する記法
			degree: ~degree,
			freq: ~freq
		);
		{
			~musicState = state;
			~view.refresh;
		}.defer;
	}
).play(~clock);

~animation = Routine({
	loop {
		var difference;

		difference = ~musicState[\step] - ~visualStep;
		~visualStep = ~visualStep + (difference * 0.2);
		~view.refresh;
		(1 / 60).wait;
	};
}).play(AppClock);
)
