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
