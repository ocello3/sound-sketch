
var ctrl = SinOsc.kr(1);

// language側のデバッグ方法
ctrl.postln; // a SinOsc

// UGen側のデバッグ方法
ctrl.poll( trig: 10, label:"ctrl"); // サーバー上の信号の数値が表示される
ctrl.scope; // 信号の変化を画面で確認することができる

// その他
ctrl.free; // synthごとに停止してみる
s.freeAll; // 全てのsynthを停止してみる

// Node Treeの確認
s.plotTree;
