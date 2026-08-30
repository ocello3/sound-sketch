s.boot;
s.quit;

// Integrator - state
/*
内部状態を保持できるUGenです。入力信号を積分して出力します。積分の結果は、時間とともに変化するため、入力信号がゼロでない場合、出力は増加または減少します。
Acceleration - Integrator -> Velocity - Integrator -> Position
前回の自身への出力を保持して次の出力を算出する過程は、自分自身へのフィードバック回路と捉えることができる。

*/
// Integratorを使わない場合（Noiseの出力）
(
{
	WhiteNoise.kr(0.1)
}.scope;
)

// Noiseの出力をIntegratorに入力した場合 -> 変化が積算される
(
{
	Integrator.kr(
		WhiteNoise.kr(0.1)
	)
}.scope;
)

// #StateをIntegrate（蓄積）する
(
{
	// ----- Variables ----- //
	var weather01;
	var rainAmount;
	var wetness01;
	var brightness;
	var output;

	// ----- State ----- //
	weather01 = LFNoise1.kr(freq: 0.05).range(0.0, 1.0);
	rainAmount = weather01 - 0.5;
	wetness01 = Integrator.kr(in: rainAmount * 0.002, coef: 0.999);
	wetness01 = wetness01.clip(0.0, 1.0);

	// ----- Mapping ----- //
	brightness = wetness01.linlin(0.0, 1.0, 6000, 800);

	// ----- Sound ----- //
	output = PinkNoise.ar(mul: 0.5);
	output = HPF.ar(in: output, freq: brightness);
	output = Pan2.ar(in: output, pos: 0);

	// -----Safety ----- //
	output = LeakDC.ar(output);
	output = Limiter.ar(output);
	output;
}.play;
)

// Integratorを使って状態の変化のコントール
(
{
	var change;
	var state;
	change = LFNoise1.kr(freq: 0.3);
	state = Integrator.kr(in: change, coef: 0.995);
	state.poll(trig: 1, label: "state");
	Silent.ar(2);
}.play;
)

// Integratorを使った物理モデル
// 速度を積分すると位置になる
(
{
	var acceleration, velocity, position;
	acceleration = LFNoise1.kr(freq: 0.2);
	velocity = Integrator.kr(in: acceleration * 0.01, coef: 0.999); // 物理シミュレーションではなく、単に前の状態を強く保持するという意味でのcoef=0.999
	position = Integrator.kr(in: velocity * 0.01, coef: 0.999);
	acceleration.poll(trig: 1, label: "acceleration");
	velocity.poll(trig: 1, label: "velocity");
	position.poll(trig: 1, label: "position");
	Silent.ar(2);
}.play;
)
