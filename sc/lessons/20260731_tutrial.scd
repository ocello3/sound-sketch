// #26 Control Bus

(
~weatherBus = Bus.control(server: s, numChannels: 1);

~world = {
	var weather = LFNoise1.kr(freq: 0.01).range(0.5, 2.0);
	Out.kr(bus: ~weatherBus, channelsArray: weather);
	Silent.ar(2); // Synthにしてplayで実行するため
}.play;

~rain = {
	var weather = In.kr(bus: ~weatherBus, numChannels: 1);
	var trigger = Dust.kr(density: weather * 3);
	var envelope = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01), gate: trigger
	);
	var output = WhiteNoise.ar(mul: envelope * 0.3);
	[output, output]
}.play;
)

// #27 Distinguish State and Mapping
(
{
	var weather01 = LFNoise1.kr(freq: 0.01).range(lo: 0.0, hi: 1.0); // 0=sunny, 1=rainy
	var wind01 = LFNoise2.kr(freq: 0.2).range(lo: 0.0, hi: 1.0);

	var density = weather01.linexp(inMin: 0.0, inMax: 1.0, outMin: 1.0, outMax: 15.0);
	var baseFreq = weather01.linlin(0.0, 1.0, 2200, 900); // sunny=high, rainy=low
	var panSpread = wind01.linlin(0.0, 1.0, 0.1, 1.0); // less wind=central, more wind=spread

	var trigger = Dust.kr(density: density);
	var env = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.01),
		gate: trigger
	);
	var output = WhiteNoise.ar(mul: env * 0.3);

	var pan = TRand.kr(lo: -1 * panSpread, hi: panSpread, trig: trigger);
	Pan2.ar(in: output, pos: pan);
}.play;
)

// #40 Minimum Feecback Loop
/*
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
	var feedback = LocalIn.ar(numChannels: 1); // 自身の前回の出力（遅延された値）を受け取る
	var input = WhiteNoise.ar(mul: 0.001);
	var output = input + feedback * 0.98;
	LocalOut.ar(channelsArray: output); // 信号を次の出力として自身をLocalInに送る

	[output, output];
}.play;
)

// #41 Delay
/*
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
	var feedbackGain = 0.95;
	var delayTime = 0.005;
	var inputLevel = 0.02;
	var outputLevel = 0.6;

	// ----- Signal Chain ----- //
	var feedback = LocalIn.ar(numChannels: 1);
	var excitation = WhiteNoise.ar(mul: inputLevel);
	var delayed = DelayC.ar(in: feedback, maxdelaytime: 1.0, delaytime: delayTime);
	var output = excitation + delayed * feedbackGain;
	LocalOut.ar(output);

	output = Pan2.ar(in: output, pos: 0);
	output = output * outputLevel;

	// ----- Safety ----- //
	output = LeakDC.ar(output);
	output = HPF.ar(in: output, freq: 20);
	output = Limiter.ar(in: output, level: 0.8);
	output;
}.play;
)

// #43 Karplus-Strong (LPF after Delay)
/*
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

// #45 Multiple Resonator
(
{
	// ----- Variables ----- //
	var trigger;
	var env;
	var excitation;
	var r1, r2, r3;
	var output;

	// ----- Mapping ----- //
	var inputLevel = 0.4;
	var outputLevel = 0.3;

	// ----- Excitation ----- //
	trigger = Dust.kr(density: 2.0);
	env = EnvGen.kr(
		Env.perc(attackTime: 0.001, releaseTime: 0.02),
		gate: trigger
	);
	excitation = WhiteNoise.ar(mul: env * inputLevel);

	// ----- Resonators ----- //
	r1 = Ringz.ar(in: excitation, freq: 900, decaytime: 0.1);
	r2 = Ringz.ar(in: excitation, freq: 1300, decaytime: 0.3);
	r3 = Ringz.ar(in: excitation, freq: 1300, decaytime: 1.5);
	output = r1 + r2 + r3;
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











