
(
SynthDef(\lfo, { // outなのでcontrol busに接続する
	|out|
	Out.kr(
		out,
		SinOsc.kr(3).range(1000, 8000)
	);
}).add;

SynthDef(\filteredSaw, { // inなのでcontrol busから受け取る
	|inBus|
	var cutoff;
	var sig;
	cutoff = In.kr(inBus); // get value from inBus
	sig = Saw.ar(220, 0.2);
	sig = LPF.ar(sig, cutoff);
	Out.ar(0, sig);
}).add;
)

(
// launch
c = Bus.control(s, 1); // control bus
x = Synth(\lfo, [
	\out, c
]);
y = Synth(\filteredSaw, [
	\inBus, c
]);
)

// #18 Integrator - state
{
	WhiteNoise.kr(0.1)
}.scope;

{
	Integrator.kr(
		WhiteNoise.kr(0.01)
	)
}.scope;

// #20 Event
// Inpulse.kr(2) 一定間隔
// Dust.kr(5) ランダム
// Changed ある値が変化したら

// #21 Noise
{
	var freq;
	freq = LFNoise2.kr(2).range(200, 800);
	SinOsc.ar(freq, 0, 0.2)
}.play;

{
	var amp = LFNoise0.kr(2).range(0.05, 0.3);
	SinOsc.ar(440, 0, amp)
}.play;

{
	var freq;
	freq = WhiteNoise.kr(1).range(200, 800);
	SinOsc.ar(freq, 0, 0.2)
}.play;

// #22 LFNoise 0, 1, 2
{
	LFNoise2.kr(1)
}.scope;

{
	var amp = LFNoise0.kr(20).range(0.05, 0.5);
	var freq = LFNoise2.kr(2).range(100, 1200);
	SinOsc.ar(freq, 0, amp)
}.play;

(
{
	var cutoff;
	cutoff = LFNoise2.kr(2).range(400, 4000);
	LPF.ar(
		WhiteNoise.ar(0.4),
		cutoff
	)
}.play;
)

// #23 multiple time scale in a phenomenon
// simple
(
x = {
	var base;
	var sig;
	base = LFNoise2.kr(0.1).range(300, 700);
	sig = SinOsc.ar(base);
	sig = sig * 0.15;
	[sig, sig]
}.play;
)

// add minor wobble
(
x.free;
x = {
	var base;
	var wobble;
	var freq;
	var sig;

	base = LFNoise2.kr(0.1).range(300, 700);

	wobble = LFNoise1.kr(4).range(-30, 30);

	freq = base + wobble;
	freq.poll(2, "freq");

	sig = SinOsc.ar(freq);
	sig = sig * 0.15;

	[sig, sig]
}.play;
)

// control filter
(
{
	var base;
	var wobble;
	var cutoff;
	var sig;
	base = LFNoise2.kr(0.1).range(1500, 3500);
	wobble = LFNoise1.kr(6).range(-300, 300);
	cutoff = base + wobble;
	sig = 　WhiteNoise.ar(0.2);
	sig = LPF.ar(sig, cutoff);
	[sig, sig]
}.play;
)

(
{
	var base;
	var wobble;
	var tremolo;
	var freq;
	var amp;
	var sig;

	base = LFNoise2.kr(0.1).range(300, 700);
	wobble = LFNoise1.kr(4).range(-30, 30);

	tremolo = LFNoise2.kr(1).range(0.05, 0.2);

	freq = base + wobble;
	amp = tremolo;

	sig = SinOsc.ar(freq);
	sig = sig * amp;

	[sig, sig]
}.play;
)





