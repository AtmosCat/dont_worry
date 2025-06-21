<img src="https://github.com/user-attachments/assets/6a2b673c-00b9-462e-b8b7-1c037022b16c" alt="icon" width="400"/>

# 📱 빌린 돈, 빌려준 돈 전용 기록장 **돈워리**

> 직관적인 채무 기록 관리 앱  
> Flutter 기반 | Android / iOS 지원

> **돈워리는 단순한 가계부 앱이 아닙니다.**  
> 기존 가계부에서 다루기 어려웠던 '빌린 돈'과 '빌려준 돈'의 흐름을 명확히 연결하여, 직관적으로 기록하고 관리할 수 있도록 설계한 전문 기록장입니다.  
> 단기 거래에 대한 맥락 보존과 다양한 방식의 상환 처리를 모두 지원하며, 향후 알림톡 연동 기능 등으로 확장될 예정입니다.

---

## ✨ 소개

**돈워리**는 친구에게 빌린 돈, 부모님께 빌려준 돈 등 **일시적인 개인 간 채무 거래를 정리**할 수 있도록 돕는 앱입니다.  
단순한 금액 기록을 넘어, **누구에게, 왜, 언제 거래했고 언제 상환했는지**까지 투명하게 기록할 수 있어 잊지 않고 관리할 수 있습니다.

---

## 🎯 개발 배경

대부분의 가계부 앱은 월급, 소비, 고정 지출 등 반복적인 수입과 지출 관리에 최적화되어 있습니다.  
하지만 빌리고 갚은 돈, 빌려주고 돌려받은 돈 같은 **단기적인 채무 관계**는 그 흐름을 명확히 추적하기 어렵습니다.  

예를 들어, 친구에게 5만 원을 빌렸다가 나중에 갚은 내역을 기록해야 할 때,  
갚은 내역이 언제, 누구에게 빌린 기록인지 직관적으로 기록하기 어려우며 **연결된 기록이라는 점을 명확히 나타내기 어렵습니다.**

**돈워리**는 이러한 불편함을 해소하기 위해,  
- **빌린 내역 ↔ 갚은 내역**,  
- **빌려준 내역 ↔ 돌려받은 내역**  
을 하나의 흐름으로 이어서 직관적으로 보여주는 앱으로 개발되었습니다.

---

## ⚙️ 주요 기능

- **상세한 거래 기록**
  - 빌린 돈, 빌려준 돈에 대해 거래자 / 거래일 / 금액 / 상환일 / 메모(이율 등) 기록 가능

- **거래 상대별 내역 관리**
  - 특정 인물과의 채무 관계를 하나의 흐름으로 확인 가능

- **상환 처리 기능**
  - 과거에 기록한 채무 내역 중 선택하여 직접 상환 처리 가능
  - 오래된 내역부터 자동 상환 처리 or 일부 상환 선택 등 다양한 방식 지원

---

## 🎨 UI/UX 디자인

<img src="https://github.com/user-attachments/assets/e2c1f843-a7be-4f83-b63e-2bd874e74b1b" alt="UI" width="600"/>

---

## 🛠 기술 스택 및 구조

> Flutter 기반으로 설계되었으며, 모듈화된 구조와 Firebase 기반 기능을 활용합니다.

## 🧩 기술 스택

| 분류            | 이름                                                                 |
|-----------------|----------------------------------------------------------------------|
| Architecture    | MVVM (`ViewModel - Repository - DAO`) 구조 구현                      |
| 상태 관리       | `MultiProvider`, `ChangeNotifier` 기반 상태관리                      |
| 비동기 처리     | `Future`, `async/await`, `Firebase Functions`                         |
| 데이터 처리     | `Provider` 기반 상태 연동 / JSON 파싱                      |
| 데이터 저장     | `SharedPreferences`, `Firebase Firestore`, `SQFLite`             |
| 활용 API        | Google AdMob, Firebase Firestore   |
| UI Frameworks   | Flutter, Material Design 위젯, 커스텀 테마(다크모드/라이트모드 지원)   |

---

## 🖼 스크린샷

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/b23f03f5-d055-4bef-9775-190980773f0c" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/c9072091-2f64-434f-96bf-481837a49361" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/67e54154-6d34-4fac-92d1-2cf113087491" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/d73e085b-d031-43e3-99da-ec8c464b10d1" width="200"/></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/cc9fcae0-ee75-4166-92ae-c8304bad444c" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/bec96d3b-58ad-453b-865a-266f5c966036" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/d7468ac4-9b36-4085-a2e1-0719c59f1a6b" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/ba4f2129-548a-485d-9466-644e93dacef2" width="200"/></td>
  </tr>
</table>

---

## 💰 비즈니스 모델

- **현재 수익 구조**
  - 📢 **광고 수익화**  
    Google AdMob 기반 광고를 앱 내 유저 흐름을 방해하지 않도록 최적화하여 배치

- **향후 수익 모델**
  - 💎 **프리미엄 멤버십**
    - 광고 제거
    - 상환일 도래 시 사용자 + 거래 상대방에게 카카오 알림톡 자동 전송
    - 프라이버시 모드 / 대출이력 정리 PDF 내보내기 / 암호 잠금 기능 등 추가 검토 예정

---

## 🔮 향후 계획

- 🔧 **알림 기능 고도화**  
  Firebase Functions 기반 푸시 알림 설정 세분화 및 시간대별 예약 발송 기능 구현 예정

- 📨 **유저 간 상환일 알림 자동화**  
  백엔드 DB 기반 사용자 간 관계 매칭 → 상환일 도래 시 **카카오 알림톡 연동** 자동 전송 기능 개발

---

## 📲 다운로드
[![App Store](https://img.shields.io/badge/App%20Store-%230078D6?style=for-the-badge&logo=apple&logoColor=white)](https://apps.apple.com/kr/app/%EB%8F%88%EC%9B%8C%EB%A6%AC-%EB%B9%8C%EB%A0%A4%EC%A4%80-%EB%8F%88-%EB%B9%8C%EB%A6%B0-%EB%8F%88-%EA%B8%B0%EB%A1%9D/id6744556730)

---

## 📌 문의 / 피드백

이슈나 개선 요청은 GitHub Issues를 통해 전달해주세요.  
버그 제보, 기능 제안, 서비스 아이디어 모두 환영합니다.

---

## 📝 라이선스

본 프로젝트는 MIT License 하에 공개되어 있습니다.
