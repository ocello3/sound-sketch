s.quit;

// One- Pole = 状態を保つフィルター、状態をなめらかにする

(
{
	var trigger, input, output;

	trigger = Dust.kr(2);
	input = Decay.kr(in: trigger, decayTime: 0.01);
	output = OnePole.kr(in: input, coef: 0.99);
	[input, output];
}.plot(1);
)

