// ===== Safety =====

output = LeakDC.ar(output);

output = Limiter.ar(
    output,
    level: 0.8
);

output = HPF.ar(
    output,
    freq: 20
);

output