s.boot;
s.quit;

// Bus System
/* 信号の通路｜音や制御信号が流れるための共有の通路
UGen
    ↓
Synth（小さな回路）
    ↓
Bus（配線）
    ↓
Synth（別の回路）
    ↓
Group（システム）

*/
// Audio Bus
(
b = Bus.audio(s, 1);
SynthDef(\osc, {
	Out.ar(
		bus: b, // スピーカーではなく、バスbへ送る
		chnannelsArray: Saw.ar(220, 0.2)
	);
}).add;
SynthDef(\filter, {
    var sig;
    sig = In.ar(b, 1); // バスbから受け取る
    sig = LPF.ar(sig, 800);
    Out.ar(0, sig);
}).add;
)
y = Synth(\filter);
x = Synth(\osc);

// Control Bus
(
c = Bus.control(s, 1);
SynthDef(\lfo, {
	|out|
	Out.kr(
		out,
		SinOsc.kr(0.3).range(300, 3000)
	);
}).add;
SynthDef(\filterSaw, {
	|inBus|
	var cutoff;
	var sig;
	cutoff = In.kr(inBus);
	sig = Saw.ar(220, 0.2);
	sig = LPF.ar(sig, cutoff);
	Out.ar(0, sig);
}).add;
)
(
x = Synth(\lfo, [
	\out, c
]);
y = Synth(\filterSaw, [
	\inBus, c
]);
)

// Control Busその2
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