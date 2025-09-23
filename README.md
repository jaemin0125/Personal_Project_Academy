## 프로젝트명

### 분 조 장 (분류하고 조언하는 AI 장인)
YOLO 기반 객체 인식 AI를 활용해 사용자가 업로드한 쓰레기 이미지를 분석하고,  
배출 규정에 맞는 **분리배출 가이드**와 지역별 대형폐기물 스티커 가격을 제공하는 웹서비스입니다.  

---

## 프로젝트 소개
- 일상에서 헷갈리기 쉬운 분리배출 방법을 자동으로 알려주는 서비스
- 쓰레기 사진을 업로드하면 AI가 객체를 인식
- 분리배출 규정을 DB에서 찾아 안내
- 대형 폐기물의 경우 사용자의 **주소(지역 정보)** 에 맞는 폐기물 스티커 가격을 DB에서 찾아 안내
- 친환경 생활 실천을 돕는 AI 기반 웹 애플리케이션

---

## 기술 스택
- **Frontend**: JSP, TailwindCSS, DaisyUI, Toast UI Editor
- **Backend**: JAVA, Spring MVC, My Batis, AJAX
- **Database**: MySQL  
- **AI server**: Python, Flask, YOLOv5m

---

## 주요 기능

 - 쓰레기 이미지 업로드 및 객체 인식

 - 분리배출 규정 제공 (wasteGuide DB 기반)

 - 카카오 주소 API 연동을 통한 주소 입력

 - 대형 폐기물의 경우 로그인한 사용자의 주소를 활용하여 폐기물 스티커 가격 제공 (stickerPrice DB 기반)

 - 관리자 전용 게시판 / 배출 규정 관리 기능
   
---

## 기능별 실행 화면

### 메인 화면
<img width="800" height="700" alt="image" src="https://github.com/user-attachments/assets/e170ea62-9ea4-447f-b07d-c148e68196c1" />

### 사진 업로드
<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/17f4286b-bd4b-4c47-ba65-904773d05e2d" />

### 추론
<img width="485" height="31" alt="image" src="https://github.com/user-attachments/assets/0cdd6e94-7517-4516-9af8-a92573b5918d" />

### 결과
<img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/b36372d0-7772-42a5-a2f5-0085e3c25c7f" />
<img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/18079406-8be0-4e21-91ab-355d16218d2e" />
<img width="800" height="300" alt="image" src="https://github.com/user-attachments/assets/6c6423c2-6b46-409d-be96-bf168007a0d2" />

### 관리자 페이지
<img width="800" height="500" alt="image" src="https://github.com/user-attachments/assets/da1ba494-1d26-4ed6-9f6b-cf0a0304dc1f" />
<img width="800" height="400" alt="image" src="https://github.com/user-attachments/assets/4727c46b-c48a-4deb-b2c6-ae119063ed92" />











