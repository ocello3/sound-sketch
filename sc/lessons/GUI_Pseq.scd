s.quit;
s.freeAll;

(
~state = (
	currentStep: 0,
	visualStep: 0
);
~animation.stop;
~player.stop;
~clock = TempoClock(80 / 60); // bpm = 80
~degrees = [0, 2, 4, 7, 4, 2];
~width = 500;
~height = 200;

~w = Window(
	name: "Step Visualizer",
	bounds: Rect(200, 200, ~width, ~height)
).front;

~view = UserView(parent: ~w, bounds: Rect(0, 0, ~width, ~height));

~view.drawFunc = {
	var stepCount, spacing;

	stepCount = ~degrees.size;
	spacing = ~width / (stepCount + 1);

	~degrees.do { |degree, i|
		var x, y, size;

		x = (i + 1) * spacing;
		y = ~height / 2 - (degree * ~height / 40);

		if ((i - ~state[\visualStep]).abs < 0.5) {
			size = 40;
		} {
			size = 20;
		};

		Pen.fillOval(Rect(x - (size / 2), y - (size / 2), size, size));
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
	\step, Pseq((0 .. (~degrees.size - 1)), inf), // GUIのために追加
	\degree, Pseq(~degrees, inf),
	\root, 0,
	\octave, 5,
	\dur, 1,
	\finish, { // Eventのplay処理前に実行され、Eventデータを操作できる
		var step;
		step = ~step; // deferされるタイミングは処理前なのでEventはnilであるため、初期化する
		{
			~state[\currentStep] = step;
			~view.refresh;
		}.defer;
	}
).play(~clock);

~animation = Routine({
	loop {
		var difference;

		difference = ~state[\currentStep] - ~state[\visualStep];
		~state[\visualStep] = ~state[\visualStep] + (difference * 0.2);
		~view.refresh;
		(1 / 60).wait;
	};
}).play(AppClock);
)



