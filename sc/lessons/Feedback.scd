s.boot;
s.quit;

/* シンプルなフィードバックループ
        ┌──────────────┐
        │              │
        ▼              │
LocalIn ─→ Gain ─→ LocalOut
    │
    ▼
 Speaker
*/
(
{
	var feedback, input, output;
	feedback = LocalIn.ar(numChannels: 1); // 自身の前回の出力（遅延された値）を受け取る
	input = WhiteNoise.ar(mul: 0.01);
	output = input + feedback * 0.98; // エネルギーを少し減衰させる。feedbackの初期値は0なので、最初はinputだけが出力される
	LocalOut.ar(channelsArray: output); // 信号を次の出力として自身をLocalInに送る
	[output, output];
}.play;
)

/* Delay
          ┌──────────────────────────┐
          │                          │
          ▼                          │
LocalIn → Delay → Gain → LocalOut
                │
                ▼
             Speaker
*/
(
{
	// ----- Mapping ----- //
	var feedbackGain = 0.5; // 0.5 - 0.99
	var delayTime = 0.2; // 0.01 - 0.8
	var inputLevel = 0.1;
	var outputLevel = 0.6;

	// ----- Signal Chain ----- //
	var feedback = LocalIn.ar(numChannels: 1);
	var excitation = WhiteNoise.ar(mul: inputLevel);
	var delayed = DelayC.ar(in: feedback, maxdelaytime: 1.0, delaytime: delayTime); // 入力はfeedback
	var output = excitation + delayed * feedbackGain; // delayの出力を減衰させて再度入力に戻す
	LocalOut.ar(output); // outputをLocalInに送る

	output = Pan2.ar(in: output, pos: 0);
	output = output * outputLevel;

	// ----- Safety ----- //
	output = LeakDC.ar(output);
	output = HPF.ar(in: output, freq: 20);
	output = Limiter.ar(in: output, level: 0.8);
	output;
}.play;
)

/* Karplus-Strong (DelayにLPFを適用する)
Delayによるフィードバック機構は弦の振動と捉えることができ、間隔を5msくらいにすることで、音程を持つ音を生成することができる。
周波数 = 1 ÷ Delay時間
フィードバックにおいて、Delay時間と相性の良い周波数（共鳴周波数）だけが何度も強調される。
ギターの弦は弾いた瞬間は高音成分が多く、時間の経過とともに高音成分が減衰するためLPFでシミュレートすることができる。
            ┌─────────────────────────────┐
            │                             │
            ▼                             │
LocalIn → Delay → LPF → Feedback Gain → LocalOut
      ▲
      │
Excitation（Dust）
*/
(
{
	// ----- Mapping ----- //
	var feedbackGain = 0.998;
	var delayTime = 0.07;
	var inputLevel = 1.2;
	var outputLevel = 0.8;
	var trigger;
	var env;
	var feedback;
	var excitation;
	var delayed;
	var output;

	// ----- Event ----- //

	trigger = Dust.kr(density: 0.5);
	env = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.05),
		gate: trigger
	);

	// ----- Signal Chain ----- //
	feedback = LocalIn.ar(numChannels: 1);
	excitation = WhiteNoise.ar(mul: env * inputLevel);
	delayed = DelayC.ar(in: feedback, maxdelaytime: 0.1, delaytime: delayTime);
	delayed = LPF.ar(in: delayed, freq: 8000);
	output = excitation + delayed * feedbackGain;
	LocalOut.ar(output);
	output = Pan2.ar(in: output, pos: 0);

	// ----- Master Gain ----- //
	output = output * outputLevel;

	// ----- Safety ----- //
	output = LeakDC.ar(output);
	output = HPF.ar(output, freq: 20);
	output = Limiter.ar(output, level: 0.8);
	output;
}.play;
)


// なねの状態のシミュレーション
/*
force = -position × spring

                    ┌──────────────────────┐
                    │                      ↓
position ──× -spring──→ force ──→ Integrator ──→ velocity
                    ↑                         │
                    │                         ↓
velocity ──× -damping┘                    Integrator
                                                │
                                                ↓
                                             position
                                                │
                                                └───────┐
                                                        │
                                                        └→ feedback
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

