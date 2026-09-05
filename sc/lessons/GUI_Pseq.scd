s.quit;
s.meter;
(
~pattern = [0, 2, 4, 7, 4, 2];
~currentStep = 0;

SynthDef(\stepTone, {
	|freq = 440|
	var env;
	env = EnvGen.kr(Env.perc(0.01, 0.2), doneAction: 2);
	Out.ar(0, (SinOsc.ar(freq) * env * 0.3) ! 2);
}).add;

~w = Window(
	name: "Step Visualizer",
	bounds: Rect(200, 200, 500, 200)
).front;

~view = UserView(
	parent: ~w,
	bounds: Rect(0, 0, 500, 200)
);

~view.drawFunc = {
	var stepCount, spacing;
	stepCount = ~pattern.size;
	spacing = 400 / stepCount;

	~pattern.do { |degree, i|
		var x, y, size;
		x = 50 + (i * spacing);
		y = 100 - (degree * 5);
		size = if(i == ~currentStep) {
			40;
		} {
			20;
		};
		Pen.fillOval(Rect(x - (size / 2), y - (size / 2), size, size));
	};
};

~player = Routine({
	loop {
		~pattern.do { |degree, i|
			// update GUI
			{
				~currentStep = i;
				~view.refresh;
			}.defer;
			// sound
			Synth(
				\stepTone,
				[\freq, (degree + 60).midicps]
			);
			0.25.wait;
		};
	};
}).play;
)

