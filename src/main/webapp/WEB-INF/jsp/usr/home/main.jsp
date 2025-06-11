<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="분조장" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

<div class="content px-4 md:px-12 py-12 space-y-20">
	<!-- 업로드 박스 -->
	<section class="text-center">
		<div class="mb-10 text-center relative">
			<div class="text-3xl font-bold text-green-700 mb-3">♻️ 분리수거 나만 헷갈리는 거 아니죠?</div>
			<div class="text-lg text-gray-700">
				사진만 업로드하세요! <span class="text-green-600 font-semibold">AI가 분석</span>하고<br>
				<span class="underline underline-offset-4">우리 동네 배출 기준</span>까지 정확하게알려드려요.
			</div>
		</div>
		<div class="flex items-center justify-center">
			<form action="/usr/image/analyze" method="post"
				enctype="multipart/form-data">
				<input type="file" id="realUpload" name="file" accept="image/*"
					class="hidden" onchange="this.form.submit()" />
				<div
					class="w-80 h-80 border-4 border-dashed border-[#58c43a] flex items-center justify-center bg-white rounded-lg cursor-pointer hover:bg-green-100 transition"
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

	<section class="text-center">
		<div class="text-2xl font-bold mb-8">AI가 최근 학습한 쓰레기</div>

		<!-- ✅ 전체 swiper + 버튼 래핑 (relative 기준) -->
		<div class="relative">
			<!-- ✅ 슬라이더 영역 -->
			<div class="swiper w-full max-w-7xl mx-auto">
				<div class="swiper-wrapper">
					<c:forEach var="wasteGuide" items="${wasteGuide}">
						<div class="swiper-slide flex flex-col items-center">
							<div class="relative w-60 h-60">
								<a href="/usr/home/result?label=${wasteGuide.getLabel() }"><img
									src="${wasteGuide.getThumbnail() }"
									class="w-full h-full object-cover rounded-lg" /></a>
							</div>
							<div class="mt-4 text-lg">${wasteGuide.getKo_label() }</div>
						</div>
					</c:forEach>
				</div>

				<!-- ✅ 이미지 기준 중앙 버튼 -->
				<div
					class="swiper-button-prev absolute top-1/2 -translate-y-1/2 !text-green-500"></div>
				<div
					class="swiper-button-next absolute top-1/2 -translate-y-1/2 !text-green-500"></div>
			</div>

			<!-- ✅ 페이지네이션은 완전히 아래! -->
			<div class="flex justify-center mt-10">
				<div class="swiper-pagination static"></div>
			</div>
		</div>
	</section>

	<hr class="border-t border-gray-300 my-12" />
	<!-- 오늘의 검색 TOP 10 -->
	<section class="text-center">
		<div class="text-2xl font-bold mb-8">주간 검색어 TOP 10</div>
		<ol
			class="list-decimal list-inside text-left max-w-md mx-auto text-lg space-y-3">
			<c:forEach var="searchKeyword" items="${searchKeyword }">
				<li class="hover:text-[#06874e]"><a
					href="/usr/home/result?label=${searchKeyword.getLabel() }">${searchKeyword.getKo_label() }</a>
				</li>
			</c:forEach>
		</ol>
	</section>
</div>

<script>
const swiper = new Swiper('.swiper', {
	  loop: true,
	  slidesPerView: 5,
	  spaceBetween: 20,
	  pagination: {
	    el: '.swiper-pagination',
	    clickable: true,
	  },
	  autoplay: {
	    delay: 5000,
	    disableOnInteraction: false,
	  },
	  navigation: {
	    nextEl: '.swiper-button-next',
	    prevEl: '.swiper-button-prev',
	  },
	  simulateTouch: false,
	});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>