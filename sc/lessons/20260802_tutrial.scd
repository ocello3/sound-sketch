// #50 Describe State in Code

s.boot;
s.quit;

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
	+ (weather01 * 0.8);

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

// #51 State with Time Record (Lag)
(
{
	var weather01;
	var wetness01;
	var trigger;
	var env;
	var output;

	// ----- State ----- //
	weather01 = LFNoise1.kr(freq: 0.05).range(0.0, 0.1);
	wetness01 = Lag.kr(in: weather01, lagTime: 5.0); // slow change

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

// #52 Difference Response Speed by Lag
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

// #53 Integrated State
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

// #54 State of Material
(
{
	// ----- Variables ----- //
	var material01;

	var resonanceFreq;
	var decayTime;
	var brightness;

	var trigger;
	var env;

	var excitation;
	var output;

	// ----- State ----- //
	material01 = 1.0;

	// ----- Mapping ----- //
	resonanceFreq = material01.linexp(0.0, 1.0, 500, 5000);
	decayTime = material01.linlin(0.0, 1.0, 0.08, 2.0);
	brightness = material01.linlin(0.0, 1.0, 2500, 7000);

	// ----- Excitation ----- //
	trigger = Dust.kr(density: 1.5);
	env = EnvGen.kr(
		Env.perc(attackTime: 0.01, releaseTime: 0.1),
		gate: trigger
	);
	excitation = WhiteNoise.ar(mul: env * 0.5);
	excitation = HPF.ar(in: excitation, freq: brightness);

	// ----- Resonator ----- //
	output = Ringz.ar(in: excitation, freq: resonanceFreq, decaytime: decayTime);
	output = Pan2.ar(output);

	// ----- Safety ----- //
	output = output;
	output = LeakDC.ar(output);
	output = HPF.ar(output, freq: 20);
	output = Limiter.ar(output);
	output;
}.play;
)

// #55 Multiple Role in One State




