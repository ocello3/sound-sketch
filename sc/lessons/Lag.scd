// Stateは変数ではなく信号であることを意識する

(
{
	// -----Variables ----- //
	var weather01;
	var wind01;
	var panSpread;
	var pan;
	var trigger;
	var env;
	var output;

	// ----- State ----- //
	weather01 = LFNoise1.kr(freq: 0.01).range(0.0, 1.0);
	wind01 = (LFNoise2.kr(freq: 0.3).range(0.0, 1.0) * 0.2)
	+ (weather01 * 0.8); // weatherがwindに少し影響する

	// ----- Mapping ----- //
	panSpread = wind01.linlin(0.0, 0.1, 0.1, 1.0);

	// ----- Excitation ----- //
	trigger = Dust.kr(density: 2.0);
	env = EnvGen.kr(
		Env.perc(attackTime: 0.01, releaseTime: 0.1),
		gate: trigger
	);
	pan = TRand.kr(lo: -1 * panSpread, hi: panSpread, trig: trigger);
	output = WhiteNoise.ar(mul: env * 0.3);
	output = Pan2.ar(in: output, pos: pan);
	output;
}.play;
)


// Lagを用いることでStateは時間の履歴を保有することができる
(
{
	var weather01;
	var wetness01;
	var trigger;
	var env;
	var output;

	// ----- State ----- //
	weather01 = LFNoise1.kr(freq: 0.05).range(0.0, 0.1);
	wetness01 = Lag.kr(in: weather01, lagTime: 5.0); // Lagにより信号の変化を遅らせる

	// ----- Mapping ----- //
	trigger = Dust.kr(density: wetness01.linexp(0.0, 1.0, 0.5, 8.0));
	env = EnvGen.kr(
		Env.perc(attackTime: 0.01, releaseTime: 0.1),
		gate: trigger
	);
	output = WhiteNoise.ar(mul: env * 0.3);
	output = Pan2.ar(in: output, pos: 0);

	// ----- Safety ----- //
	output = LeakDC.ar(output);
	output = HPF.ar(output, freq: 20);
	output = Limiter.ar(output, level: 0.8);
	output;
}.play;
)

// Lagでの複数の反応時間
/*
Weather
    │
    ├── Brightness（すぐ反応）
    │
    └── GroundWetness（ゆっくり反応）
            │
            ▼
        DropDensity
*/
(
{
	// ----- Variables ----- //
	var weather01;
	var wetness01;
	var brightness;
	var density;
	var trigger;
	var env;
	var output;

	// ----- State ----- //
	weather01 = LFNoise1.kr(freq: 0.05).range(0.0, 1.0);
	wetness01 = Lag.kr(in: weather01, lagTime: 0.1);

	// ----- Mapping ----- //
	brightness = weather01.linlin(0.0, 1.0, 8000, 800);
	density = wetness01.linexp(0.0, 1.0, 0.3, 8.0);

	// ----- Excitation ----- //
	trigger = Dust.kr(density: density);
	env = EnvGen.kr(
		Env.perc(attackTime: 0.01, releaseTime: 0.1),
		gate: trigger
	);
	output = WhiteNoise.ar(mul: env * 0.3);
	output = HPF.ar(in: output, freq: brightness);
	output = Pan2.ar(in: output, pos: 0);

	// ----- Safety ----- //
	output = LeakDC.ar(output);
	output = HPF.ar(output, freq: 20);
	output = Limiter.ar(output, level: 0.8);
	output;
}.play;
)
