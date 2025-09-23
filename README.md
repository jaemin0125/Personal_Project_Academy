# 프로젝트 이름

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

## 📂 프로젝트 구조
```plaintext
project-root/
 ├── frontend/      # 프론트엔드 코드
 ├── backend/       # 백엔드 코드
 ├── ai-model/      # AI 모델 관련 코드
 └── docs/          # 문서 및 참고 자료
```

---

## 주요 기능

 - 쓰레기 이미지 업로드 및 객체 인식

 - 분리배출 규정 및 지역별 폐기물 스티커 가격 제공 (wasteGuide DB 기반)

 - 카카오 주소 API 연동을 통한 주소 입력

 - 게시판 / 배출 규정 관리 기능
