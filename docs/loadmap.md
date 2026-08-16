
# 全体
短期目標：SuperColliderを使えるようになる
中期目標：『Designing Sound』を自力で読めるようになる
長期目標：信号処理を使って現象をシミュレーションする

第1部 SuperColliderの基礎
サーバとクライアント
UGen
.ar / .kr
Signal
Env
SynthDef
Synth
Node
Group
Audio Bus
Control Signal
Control Bus
Nodeの順序
addAction
Buffer
Sample

第2段階
DSP部品を学びます。
Integrator
Delay
Feedback
OnePole
OneZero
Comb
Allpass
Ringz
LeakDC

次の数回は、この流れをさらに発展させていきます。
複数のControllerを組み合わせる（速い変化と遅い変化を重ねる）
Busを使って同じControl Signalを複数のSynthで共有する
Patterns を導入して、「イベントを記述する」という別の世界を見る

第3部 Patterns

第4部 Buffer

第5部 Designing Sound実践
風
焚き火
波
森
足音
雪
ドア
水滴

第6部 DSPシミュレーション
ブラウン運動
振り子
マススプリング
共鳴
カオス

第7部 p5.jsとの融合





# SuperColliderの文法
UGen
    ↓
Signal
    ↓
LFO
    ↓
Envelope
    ↓
SynthDef
    ↓
Gate
    ↓
ADSR
    ↓
Synth
    ↓
Bus
    ↓
Group
    ↓
Effect

# 数値シミュレーション
SuperCollider文法
      ↓
UGenに慣れる
      ↓
Designing Sound
      ↓
DSP（信号処理）
      ↓
Physical Modeling
      ↓
数値シミュレーション