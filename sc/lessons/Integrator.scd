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