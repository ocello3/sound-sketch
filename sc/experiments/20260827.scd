/* なねの状態のシミュレーション
Pseqでシーケンスをコントロールする
まず、SynthDefとする
*/
(
{
	var position, force, velocity;
	var spring = 0.005, damping = 0.001, impulse;
	var state;
	var freq, output, env, trigger, excitation;

	// state
	state = LocalIn.kr(numChannels: 2);
	position = state[0];
	velocity = state[1];

	// event
	trigger = Dust.kr(density: 0.5);
	impulse = Decay.kr(in: trigger, decayTime: 0.01) * 0.5; // バネに力を加えるのは一瞬（trigger）ではなく、短い時間

	// dynamics
	force = (-1 * position * spring) - (velocity * damping) + impulse; // positionと逆向きに力が働く＆velocityが大きいほどバネ抵抗が大きくなる
	velocity = Integrator.kr(in: force, coef: 0.999); // 初期値は0、前の状態 * coef + in（減衰系）
	position = Integrator.kr(in: velocity, coef: 0.999);
	LocalOut.kr([position, velocity]);
	position.poll(trig: 1, label: "position");
	velocity.poll(trig: 1, label: "velocity");

	// sound
	freq = position.linexp(-1, 1, 500, 5000);
	env = Decay2.kr(in: trigger, attackTime: 0.001, decayTime: 0.03);
	excitation = WhiteNoise.ar(mul: env * 0.3);
	output = Ringz.ar(in: excitation, freq: freq, decaytime: 0.5);
	output = LeakDC.ar(output);
	output = Limiter.ar(output,level: 0.8);
	output = HPF.ar(output, freq: 20);
	output ! 2
}.play;
)
