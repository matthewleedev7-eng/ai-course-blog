---
title: "안드레이 카파시 (Andrej Karpathy) - 밑바닥부터 만드는 딥러닝과 GPT (Zero to Hero)"
description: "전 테슬라 AI 총괄이자 OpenAI 창립 멤버인 안드레이 카파시의 전설적인 명강의! 복잡한 프레임워크 없이 순수 파이썬으로 역전파 엔진부터 나노GPT까지 직접 코딩해보는 실전 무료 코스"
provider: "YouTube & GitHub"
url: "https://github.com/karpathy/nn-zero-to-hero"
level: "중고급"
duration: "총 8개 영상 (약 20시간 + 자율 실습)"
language: "영어 (자동 번역 자막 및 주피터 노트북 완비)"
hasCertificate: false
tags: ["Karpathy", "GPT", "PyTorch", "딥러닝밑바닥", "LLM구현", "오픈소스"]
isFree: true
featured: true
rating: 5.0
publishedDate: "2026-01-25"
badge: "엔지니어 필독"
---

## 📌 어떤 강의인가요?
전 테슬라(Tesla)의 오토파일럿 AI 총괄이자 오픈AI(OpenAI)의 창립 멤버인 **안드레이 카파시(Andrej Karpathy)**가 전 세계 개발자들을 위해 무료로 제작해 공개한 **신경망 및 거대언어모델(LLM) 밑바닥 구현 명강의 시리즈**입니다.

PyTorch나 TensorFlow 같은 거대 프레임워크의 마법 뒤에 숨겨진 수학적 원리를 한 줄 한 줄 코딩하며 파헤칩니다. 아주 작은 스칼라 역전파 엔진인 **micrograd** 제작부터 시작하여, 문맥 예측 2-gram 모델, 다층 퍼셉트론(MLP), 배치 정규화(BatchNorm), 수동 역전파 계산, WaveNet, 그리고 마침내 **트랜스포머 기반의 nanoGPT(GPT-2 아키텍처)를 바닥부터 빌드하고 셰익스피어 데이터로 직접 사전학습**시키는 전 과정을 친절하게 가르쳐줍니다.

전 세계 수많은 실리콘밸리 AI 연구원과 엔지니어들이 "AI의 블랙박스를 부숴준 최고의 강의"로 손꼽는 전설적인 오픈소스 커리큘럼입니다.

---

## 🎯 추천 대상
- `import torch`나 `model.fit()`을 쓰면서도 신경망 내부에서 텐서와 그래디언트가 어떻게 흐르는지 답답했던 분
- 트랜스포머(Transformer)와 셀프 어텐션(Self-Attention)의 수식과 구현 코드를 밑바닥부터 체득하고 싶은 개발자
- 최고 수준의 AI 석학이 코드를 짜고 디버깅하는 실제 사고방식과 엔지니어링 팁을 1:1 과외처럼 엿보고 싶은 분

---

## 📚 주요 커리큘럼 구성
1. **Building micrograd**: 가장 작은 역전파(Backpropagation) 엔진과 스칼라 신경망을 순수 파이썬으로 구현
2. **Makemore Part 1**: 문자 단위 언어 모델(Bigram) 구현, 카운트 행렬과 신경망 접근법 비교
3. **Makemore Part 2 (MLP)**: Bengio 2003 논문 기반 다층 퍼셉트론 아키텍처 및 손실 함수(Cross-Entropy) 구현
4. **Makemore Part 3 (Activations & Gradients)**: 가중치 초기화(Kaiming init), 배치 정규화(BatchNorm), 그래디언트 소실/폭주 디버깅
5. **Makemore Part 4 (Manual Backprop)**: 역전파를 프레임워크 없이 손으로 수학적 미분하여 텐서 계산 직접 구현
6. **Makemore Part 5 (WaveNet)**: 계층적 트리 구조를 통한 합성곱(CNN) 스타일의 장기 의존성 모델링
7. **Let's build GPT from scratch**: Attention Is All You Need 논문의 멀티헤드 어텐션을 직접 짜고 GPT-2 아키텍처 완벽 구현
8. **Let's build the GPT Tokenizer**: 바이트 페어 인코딩(BPE) 토크나이저 알고리즘을 밑바닥부터 파이썬으로 구현

---

## 💡 수강 팁 & 학습 가이드
- 카파시의 공식 깃허브 저장소(`github.com/karpathy/nn-zero-to-hero`)에 각 강의별 **주피터 노트북(Jupyter Notebook)과 실습 연습문제, Google Colab 직결 링크**가 완벽하게 정리되어 있습니다.
- 영상을 멍하니 보기만 하지 마시고, 카파시와 함께 Colab을 열어두고 키보드로 코드를 똑같이 타이핑하며 실행해 보는 것을 강력히 추천합니다.
