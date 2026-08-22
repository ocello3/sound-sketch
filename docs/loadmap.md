# SuperCollider Learning Roadmap

## Goal

SuperColliderを使って、

1. 音響信号処理を理解する
2. 音響現象をモデル化する
3. State → Mapping → DSP という設計で音のシステムを作る
4. 数値シミュレーションとして時間発展するシステムを記述する
5. 音だけでなく、StateやSequenceをGUIで可視化する

ことを目標とする。

---

# 1. SuperCollider Fundamentals

## Language / Signal

- [x] 基本文法
- [x] Function
- [x] UGen
- [x] `.ar` / `.kr`
- [x] Signal graph
- [x] `.play`
- [x] `var`
- [x] Collection / Array
- [x] Ref / backquote

## Server Architecture

- [x] Server
- [x] Client
- [x] Synth
- [x] SynthDef
- [x] Node
- [x] Group
- [x] Node order
- [x] addAction

## Bus

- [x] Audio Bus
- [x] Control Bus
- [x] BusとSynthの関係
- [x] Control Signal
- [x] Silent.ar()

---

# 2. Basic Sound Synthesis

## Envelope / Event

- [x] Env
- [x] EnvGen
- [x] gate / trigger
- [x] Dust
- [x] TRand
- [x] Event-driven control

## Noise

- [x] WhiteNoise
- [x] PinkNoise
- [x] LFNoise1
- [x] LFNoise2
- [x] Noiseによる連続的なState

## Filtering

- [x] HPF
- [x] LPF
- [ ] BPF
- [ ] RLPF
- [ ] Resonant filtering

## Spatialization

- [x] Pan2
- [ ] Splay
- [ ] Multichannel spatialization

---

# 3. Resonance / Physical Sound

- [x] Ringz
- [x] Klank
- [x] Resonanceの考え方
- [x] 複数共鳴
- [ ] DynKlank
- [ ] Comb
- [ ] Allpass
- [ ] Reverb

---

# 4. State and Mapping

## State

- [x] Stateという考え方
- [x] Global State
- [x] Event State
- [x] State hierarchy
- [x] 0–1 normalization

## Mapping

- [x] range
- [x] linlin
- [x] linexp
- [x] Mappingの考え方
- [x] 複数パラメータへのMapping
- [x] 上位Stateから下位パラメータを生成する設計
- [ ] 非線形Mappingの設計
- [ ] 複数Stateから一つのパラメータを生成する設計

## Temporal State

- [x] Lag
- [x] Control Signalによる状態変化
- [x] 時間スケールの設計
- [x] Integrator
- [ ] State update / difference equation
- [ ] 安定性
- [ ] 平衡状態

---

# 5. Feedback / DSP

- [x] LocalIn
- [x] LocalOut
- [x] Feedback loop
- [x] Delay
- [x] Delay timeと周波数の関係
- [x] Feedback gain
- [x] Gain Staging
- [x] Safety filter
- [ ] Comb filter
- [ ] Allpass filter
- [ ] ResonatorとしてのFeedback
- [ ] Feedbackによる物理モデル
- [ ] FeedbackとIntegratorの関係

---

# 6. Pattern — Minimum

> 目的：簡単な音のスケッチを時間方向に構成できるようにする。

- [ ] Patternの基本概念
- [ ] Pseq
- [ ] Prand
- [ ] Pwhite
- [ ] Pbind
- [ ] EventとPattern
- [ ] Pattern → Synth
- [ ] Tempo / Clockの基本
- [ ] StateとPatternを組み合わせる

### Patternを使った小さな音のスケッチ

- [ ] リズムスケッチ
- [ ] 音高シーケンス
- [ ] Density / Durationの変化
- [ ] Random event sequence

---

# 7. Designing Sound / Sound Sketches

## A: Phenomenon-driven

- [x] 雨
- [x] 水滴
- [x] 風
- [x] Weather / Wind State
- [ ] 波
- [ ] 森
- [ ] 焚き火
- [ ] 煙
- [ ] 木が割れる音
- [ ] 木が倒れる音
- [ ] 足音
- [ ] 素材音
- [ ] その他の身近な音

## Design Principles

- [x] 音を材料として考える
- [x] EventとContinuous Signalの区別
- [x] State → Mapping → DSP
- [x] 複数パラメータを共通Stateから制御
- [x] 時間スケールの設計
- [ ] 階層的なイベント設計
- [ ] 物理的意味を持つMapping
- [ ] Emergent behavior

---

# 8. B: Numerical Simulation

> 音響現象の背後にある時間発展を数値モデルとして理解する。

- [x] Integrator
- [x] Stateの時間発展
- [ ] Difference equation
- [ ] Decay
- [ ] Equilibrium
- [ ] Mass-Spring system
- [ ] Pendulum
- [ ] Coupled oscillators
- [ ] Brownian motion
- [ ] Random walk
- [ ] Resonant system
- [ ] Nonlinear system
- [ ] Chaos

---

# 9. GUI / Visualization

> Stateや音響パラメータを可視化し、音だけでは把握しにくい「楽器の状態」を見る。

- [ ] SuperCollider GUI basics
- [ ] Slider
- [ ] Knob
- [ ] Number display
- [ ] Control Signal → GUI
- [ ] Volume meter
- [ ] State visualization
- [ ] Multiple State visualization
- [ ] Sequence visualization
- [ ] Tempo / Beat visualization
- [ ] FFT visualization
- [ ] Instrument State visualization

---

# 10. Buffer / Sample / Analysis

- [ ] Buffer
- [ ] Sample playback
- [ ] Recording
- [ ] FFT
- [ ] Spectral analysis
- [ ] Onset detection
- [ ] Amplitude analysis
- [ ] Audio analysis → State

---

# 11. Advanced System Design

- [ ] State hierarchy
- [ ] World model
- [ ] Global State / Local State / Event State
- [ ] State transitions
- [ ] Multiple interacting systems
- [ ] Generative sound system
- [ ] Pattern + State + DSP
- [ ] DSP + Numerical simulation
- [ ] Sound + GUI visualization

---

# Learning Approach

## A / B alternating

### A: Phenomenon

現象や音を題材にして、

State → Mapping → DSP

という設計で音を作る。

### B: Model

Aで使った仕組みを、

- 数値モデル
- 時間発展
- フィードバック
- 差分方程式
- 物理モデル

として理解する。

AとBを交互に進めることで、

「音を作るためのDSP」と
「現象を記述するための数値モデル」

を相互に理解する。

---

# Current Progress

現在は、

**State / Mapping → Temporal State → Feedback / Simulation**

を学習中。

次の短期目標は、

1. Pattern Minimumを習得
2. 簡単な音のスケッチを作る
3. Integrator / Simulationを深める
4. GUIによるState visualizationへ進む

とする。