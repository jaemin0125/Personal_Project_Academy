<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  

<c:set var="pageTitle" value="분조장" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>


<div class="content px-4 md:px-12 py-12 space-y-20">
  <!-- 업로드 박스 -->
  <section class="text-center">
    <div class="text-2xl mb-6">
      분리수거 나만 헷갈리는 거 아니죠?<br>
      사진만 업로드 하세요! AI가 분석하고 우리 동네 배출 기준까지 알려드려요.
    </div>
    <div class="flex items-center justify-center">
      <form action="/upload" method="post" enctype="multipart/form-data">
        <input type="file" id="realUpload" name="file" accept="image/*" class="hidden" onchange="this.form.submit()" />
        <div class="w-80 h-80 border-4 border-dashed border-[#58c43a] flex items-center justify-center bg-white rounded-lg cursor-pointer hover:bg-green-100 transition"
          onclick="$('#realUpload').click();">
          <div class="text-center text-gray-600">
            <i class="fas fa-upload text-4xl mb-2"></i>
            <p class="text-xl">클릭하여 사진 업로드</p>
          </div>
        </div>
      </form>
    </div>
  </section>

<hr class="border-t border-gray-300 my-12" />	
  <!-- 최근 업데이트된 쓰레기 섹션 -->
  <section class="text-center">
	 <h2 class="text-2xl font-bold mb-8">최근 업데이트된 쓰레기</h2>
    <div class="flex justify-center space-x-6 overflow-x-auto scrollbar-hide">
      <!-- 예시 이미지들 -->
      <div class="flex-shrink-0 w-80 h-80 bg-gray-100 rounded-lg flex items-center justify-center">
        <img src="https://picsum.photos/300/300?random=1" class="object-cover w-full h-full rounded-lg" />
      </div>
      <div class="flex-shrink-0 w-80 h-80 bg-gray-100 rounded-lg flex items-center justify-center">
        <img src="https://picsum.photos/300/300?random=2" class="object-cover w-full h-full rounded-lg" />
      </div>
      <div class="flex-shrink-0 w-80 h-80 bg-gray-100 rounded-lg flex items-center justify-center">
        <img src="https://picsum.photos/300/300?random=3" class="object-cover w-full h-full rounded-lg" />
      </div>
      <div class="flex-shrink-0 w-80 h-80 bg-gray-100 rounded-lg flex items-center justify-center">
        <img src="https://picsum.photos/300/300?random=4" class="object-cover w-full h-full rounded-lg" />
      </div>
      <div class="flex-shrink-0 w-80 h-80 bg-gray-100 rounded-lg flex items-center justify-center">
        <img src="https://picsum.photos/300/300?random=5" class="object-cover w-full h-full rounded-lg" />
      </div>
    </div>
      <!-- 페이지네이션 점 -->
      <div class="mt-6 flex justify-center space-x-1">
        <div class="w-2 h-2 bg-[#58c43a] rounded-full"></div>
        <div class="w-2 h-2 bg-gray-300 rounded-full"></div>
        <div class="w-2 h-2 bg-gray-300 rounded-full"></div>
        <div class="w-2 h-2 bg-gray-300 rounded-full"></div>
        <div class="w-2 h-2 bg-gray-300 rounded-full"></div>
      </div>
  </section>

<hr class="border-t border-gray-300 my-12" />
  <!-- 오늘의 검색 TOP 10 -->
  <section class="text-center">
    <h2 class="text-2xl font-bold mb-8">오늘의 검색 TOP 10</h2>
    <ol class="list-decimal list-inside text-left max-w-md mx-auto text-lg space-y-3">
      <li>플라스틱 컵</li> <!-- 이것들도 a태그로 수정 예정 -->
      <li>종이팩</li>
      <li>전구</li>
      <li>스티로폼</li>
      <li>휴지</li>
      <li>헌 옷</li>
      <li>배터리</li>
      <li>캔</li>
      <li>페트병</li>
      <li>비닐봉지</li>
    </ol>
  </section>

<hr class="border-t border-gray-300 my-12" />
  <!-- 커뮤니티 이동 버튼 -->
  <div class="text-center">
  	<div class="my-8 text-lg">
  		쓰레기, 생활 스타일, 당신만의 꿀팁 등<br />
  		함께 공유하는 공간
  	</div>
    <a href="../article/list" class="btn btn-outline btn-success text-lg">에코커뮤니티로 이동</a>
  </div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>