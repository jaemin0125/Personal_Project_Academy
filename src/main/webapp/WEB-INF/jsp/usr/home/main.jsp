<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="분조장" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<!-- Swiper CDN -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

<div class="content px-4 md:px-12 py-12 space-y-20">
	<!-- 업로드 박스 -->
	<section class="text-center">
		<div class="mb-10 text-center relative">
			<div class="text-3xl font-bold text-green-700 mb-3">♻️ 분리수거 나만
				헷갈리는 거 아니죠?</div>
			<div class="text-lg text-gray-700">
				사진만 업로드하세요! <span class="text-green-600 font-semibold">AI가 분석</span>해서<br>
				분리배출 방법은 물론,<br> <span class="text-green-700 font-semibold">대형폐기물은
					내 거주지 기준</span>으로 스티커 비용까지 정확히 안내해드려요.
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

	<!-- 최근 학습한 쓰레기 슬라이더 -->
	<section class="text-center">
		<div class="text-2xl font-bold mb-8">AI가 최근 학습한 쓰레기</div>

		<div class="relative">
			<div class="swiper w-full max-w-7xl mx-auto !pt-6">
				<div class="swiper-wrapper">
					<c:forEach var="wasteGuide" items="${wasteGuide}">
						<div class="swiper-slide flex flex-col items-center px-2">
							<div class="relative w-full h-[15rem] sm:h-[16rem]">
								<a href="/usr/home/result?label=${wasteGuide.getLabel()}"> <img
									src="${wasteGuide.getThumbnail()}"
									class="w-full h-full object-cover rounded-lg shadow hover:scale-105 transition duration-300" />
								</a>
							</div>
							<div
								class="mt-2 sm:mt-4 text-base sm:text-lg font-medium text-gray-800 text-center min-h-[2.5rem]">
								${wasteGuide.getKo_label()}</div>
						</div>
					</c:forEach>
				</div>

				<!-- 슬라이드 네비게이션 버튼 -->
				<div
					class="swiper-button-prev absolute top-1/2 -translate-y-1/2 
					left-2 sm:-left-4 md:-left-6 lg:-left-8 
					!text-green-500 z-10 !pt-6"></div>
				<div
					class="swiper-button-next absolute top-1/2 -translate-y-1/2 
					right-2 sm:-right-4 md:-right-6 lg:-right-8 
					!text-green-500 z-10 !pt-6"></div>
			</div>

			<!-- 페이지네이션 -->
			<div class="flex justify-center mt-10">
				<div class="swiper-pagination static"></div>
			</div>
		</div>
	</section>

	<hr class="border-t border-gray-300 my-12" />

	<!-- 주간 검색어 TOP 10 -->
	<section class="text-center">
		<div class="text-2xl font-bold mb-8">주간 검색어 TOP 10</div>
		<ol
			class="list-decimal list-inside text-left max-w-md mx-auto text-lg space-y-3">
			<c:forEach var="searchKeyword" items="${searchKeyword}">
				<li class="hover:text-[#06874e]"><a
					href="/usr/home/result?label=${searchKeyword.getLabel()}">${searchKeyword.getKo_label()}</a>
				</li>
			</c:forEach>
		</ol>
	</section>
</div>

<!-- Swiper 초기화 -->
<script>
	const swiper = new Swiper('.swiper', {
		loop : true,
		spaceBetween : 12,
		pagination : {
			el : '.swiper-pagination',
			clickable : true,
		},
		autoplay : {
			delay : 5000,
			disableOnInteraction : false,
		},
		navigation : {
			nextEl : '.swiper-button-next',
			prevEl : '.swiper-button-prev',
		},
		simulateTouch : true,
		breakpoints : {
			0 : {
				slidesPerView : 1.3
			},
			480 : {
				slidesPerView : 2
			},
			640 : {
				slidesPerView : 3
			},
			768 : {
				slidesPerView : 4
			},
			1024 : {
				slidesPerView : 5
			},
		}
	});
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
