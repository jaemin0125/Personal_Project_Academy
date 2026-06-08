## 프로젝트명

### ♻️ 분 조 장 (분류하고 조언하는 AI 장인)
YOLO 기반 객체 인식 AI를 활용해 사용자가 업로드한 쓰레기 이미지를 분석하고,  
배출 규정에 맞는 **분리배출 가이드**와 지역별 대형폐기물 스티커 가격을 제공하는 웹서비스입니다.  

### 💡 Refactoring Focus
본 프로젝트는 초기 기능 구현에 그치지 않고, 웹 보안 강화, 데이터 무결성 확보, 확장성 있는 아키텍처 설계, 그리고 일관된 UX/UI 고도화를 목표로 전면 리팩토링을 진행하여 완성도를 극대화했습니다.

---

## 프로젝트 소개
- 일상에서 헷갈리기 쉬운 분리배출 방법을 자동으로 알려주는 서비스
- 쓰레기 사진을 업로드하면 AI가 객체를 인식
- 분리배출 규정을 DB에서 찾아 안내
- 대형 폐기물의 경우 사용자의 **주소(지역 정보)** 에 맞는 폐기물 스티커 가격을 DB에서 찾아 안내
- 친환경 생활 실천을 돕는 AI 기반 웹 애플리케이션

---

## 기술 스택
- **Frontend**: JSP, TailwindCSS, DaisyUI, Toast UI Editor, SortableJs
- **Backend**: JAVA, Spring MVC, My Batis, AJAX
- **Database**: MySQL  
- **AI server**: Python, Flask, YOLOv5m

---
## 🔥주요 Refactoring

1. 보안 및 다층 데이터 검증
- 서버 사이드 유효성 검증: 클라이언트(프론트엔드) 검증에만 의존하지 않고, 백엔드(Spring)단에서 복합 정규표현식(Regex)을 도입하여 악의적인 데이터 변조 및 올바르지 않은 파라미터 유입을 원천 차단했습니다.

- 안전한 사용자 인증: 비밀번호 변경 및 휴대폰 인증 로직 실행 시 고난도 정규식 검증 체계를 적용하여 계정 보안 등급을 대폭 향상했습니다.

2. 회원 관리 체계 및 자동화 스케줄러 도입
- 데이터 기반 이력 관리: 회원 테이블에 lastLoginDate 필드를 활용하여 사용자의 마지막 로그인 시점을 정밀하게 추적합니다.

- 휴면 계정 전환 배치(Scheduler) 구현: 1년 이상 장기 미접속 회원을 자동으로 휴면 상태로 전환하는 스케줄러 로직을 설계 및 반영하여 회원 데이터의 활성도를 유지하고 개인정보 보호 규정을 준수합니다.

3. 모바일 인증(MO) 기반 본인 확인 고도화
- Octomo API 연동: 회원가입 및 아이디/비밀번호 찾기 및 휴면 해제 프로세스에 MO(Mobile Originated) 인증 시스템을 도입하여 허위 계정 생성을 방지하고 사용자 식별 신뢰성을 높였습니다.

4. UX/UI 일관성 및 최적화

---

## 주요 기능

 - 쓰레기 이미지 업로드 및 AI 객체 인식

 - 분리배출 규정 제공 (wasteGuide DB 기반)

 - 카카오 주소 API 연동을 통한 주소 입력

 - 대형 폐기물의 경우 로그인한 사용자의 주소를 활용하여 폐기물 스티커 가격 제공 (stickerPrice DB 기반)

 - 관리자 전용 대시보드(배출 규정, 게시판, 회원정보 관리)
 
---

## 📸 기능별 실행 화면 (Before & After UI 리팩토링)

<br>

| 기능 구분 | 기존 디자인 (Before) | 리팩토링 및 고도화 내용 (After) |
| :---: | :---: | :--- |
| **메인 화면** | <img src="https://github.com/user-attachments/assets/07fd055c-e4f5-41df-b978-393f94e221cc" width="400" alt="기존 메인 화면" /> | 수정 내용 없음 |
| **사진 업로드 & 추론** | <img src="https://github.com/user-attachments/assets/17f4286b-bd4b-4c47-ba65-904773d05e2d" width="400" alt="기존 업로드 및 추론" /> | 수정 내용 없음 |
| **분리배출 결과 안내** | <img src="https://github.com/user-attachments/assets/b36372d0-7772-42a5-a2f5-0085e3c25c7f" width="400" alt="기존 결과 화면" /> | 수정 내용 없음 |
| **관리자 대시보드 1** | <img src="https://github.com/user-attachments/assets/f93444c5-aed3-4c65-846b-5666918a7a2f" width="400" alt="기존 관리자 페이지 1" /> | <img src="https://github.com/user-attachments/assets/664dcb55-be51-44f7-afac-e6a524327d29" width="400" alt="리팩토링 후 관리자 페이지 1" /><br>➔ **DaisyUI 적용 및 가독성 개선 완료** |
| **관리자 대시보드 2** | <img src="https://github.com/user-attachments/assets/df1ce780-85d8-4555-9523-c9ed0c7bfe1c" width="400" alt="기존 관리자 페이지 2" /> | <img src="https://github.com/user-attachments/assets/68d627dc-7e58-4310-afa7-1859f626e2c0" width="400" alt="리팩토링 후 관리자 페이지 2" /><br>➔ **SortableJS 기반 컴포넌트 최적화 반영** |
| **관리자 대시보드 3** | <div align="center" style="width:400px; color:#888;">(기존 기능 없음)</div> | <img src="https://github.com/user-attachments/assets/5fe2e41b-4dc5-4f31-8e63-f61cd8b0969c" width="400" alt="신규 관리자 기능" /><br>➔ **[신규] 회원 정보 관리 및 보안 제어 센터 추가** |
| **Octomo 본인 인증** | <div align="center" style="width:400px; color:#888;">(기존 기능 없음)</div> | <img src="https://github.com/user-attachments/assets/adb4649a-fdbd-4364-a3cf-524f75cda7ed" width="400" alt="Octomo MO 인증 구동 화면" /><br>➔ **[신규] MO 인증 기반 아이디/비밀번호 찾기 및 휴면 해제 로직 고도화** |






 
