// Safety
output = LeakDC.ar(output);
output = Limiter.ar(output,level: 0.8);
output = HPF.ar(output, freq: 20);
output

// Release SynthDef
DetectSilence.ar(in: output, amp: 0.0001, time: 0.1, doneAction: 2);

