<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="분조장" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<c:if test="${loginedMember != null && loginedMember.id != 0}">
	<div
		class="fixed top-32 left-4 w-64 bg-white shadow-lg rounded-xl border border-gray-200 p-4 z-50 hidden lg:block">
		<h3 class="text-green-700 font-bold mb-2 text-lg">⭐ 즐겨찾기한 항목</h3>
		<ul id="likedList" class="space-y-2 text-sm text-gray-800">
		</ul>
	</div>
</c:if>

<!-- Swiper CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

<div class="content px-4 md:px-12 py-12 space-y-20">
	<section class="relative text-center">
		<div class="absolute right-0 top-0 mr-20 z-10 flex flex-col items-end  hidden lg:block">
			<div class="flex gap-2 bg-green-50 px-1.5 py-1.5 rounded-lg shadow-sm max-w-md">
				<input type="search" id="searchKeyword" placeholder="검색어로 찾아보기" maxlength="15" class="border border-green-400 text-sm px-3 py-1 rounded-md focus:outline-none focus:ring-2 focus:ring-green-300 w-full sm:w-60" />
				<button type="button" id="searchBtn" class="bg-green-500 text-white px-3 py-1 text-sm rounded-md hover:bg-green-600 transition">검색</button>
			</div>
			<div class="h-5 mt-1 text-sm text-red-500">
				<p id="searchError"></p>
			</div>
		</div>

		<div class="mb-10">
			<div class="text-3xl font-bold text-green-700 mb-3">♻️ 분리수거 나만 헷갈리는 거 아니죠?</div>
			<div class="text-lg text-gray-700">
				사진만 업로드하세요! <span class="text-green-600 font-semibold">AI가 분석</span>해서<br />
				분리배출 방법은 물론,<br /> <span class="text-green-700 font-semibold">대형폐기물은
					내 거주지 기준</span>으로 스티커 비용까지 정확히 안내해드려요.
			</div>
		</div>

		<div class="flex items-center justify-center">
			<form action="/usr/image/analyze" method="post"
				enctype="multipart/form-data">
				<input type="file" id="realUpload" name="file" accept="image/*" class="hidden" onchange="this.form.submit()" />
				<div class="w-80 h-80 border-4 border-dashed border-[#58c43a] flex items-center justify-center bg-white rounded-lg cursor-pointer hover:bg-green-100 transition" onclick="$('#realUpload').click();">
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
		<div class="text-2xl font-bold mb-4">AI가 최근 학습한 쓰레기</div>
		<div class="relative w-full max-w-7xl mx-auto h-[18rem]">
			<div class="swiper h-full">
				<div class="swiper-wrapper h-full">
					<c:forEach var="wasteGuide" items="${wasteGuide}">
						<div class="swiper-slide h-full flex flex-col items-center px-2">
							<div class="w-full h-[14rem]">
								<a href="/usr/home/result?label=${wasteGuide.label}"> <img
									src="${wasteGuide.thumbnail}"
									class="w-full h-full object-cover rounded-lg shadow hover:shadow-xl" />
								</a>
							</div>
							<div class="mt-2 text-sm text-gray-800 text-center font-medium">
								${wasteGuide.ko_label}</div>
						</div>
					</c:forEach>
				</div>
			</div>

			<!-- 버튼 -->
			<div class="swiper-button-prev absolute top-1/2 -translate-y-1/2 left-2 !text-green-500 z-10"></div>
			<div class="swiper-button-next absolute top-1/2 -translate-y-1/2 right-2 !text-green-500 z-10"></div>
		</div>

		<div class="swiper-pagination-wrapper flex justify-center">
			<div class="swiper-pagination !static"></div>
		</div>

	</section>

	<hr class="border-t border-gray-300 my-12" />

	<!-- 주간 검색어 TOP 10 -->
	<section class="text-center">
		<div class="text-2xl font-bold mb-8">주간 검색어 TOP 10</div>
		<ol class="list-decimal list-inside text-left max-w-md mx-auto text-lg space-y-3">
			<c:forEach var="searchKeyword" items="${searchKeyword}">
				<li class="hover:text-[#06874e]">
					<a href="/usr/home/result?label=${searchKeyword.getLabel()}">${searchKeyword.getKo_label()}</a>
				</li>
			</c:forEach>
		</ol>
	</section>
</div>

<script>
$(function () {
	  LikedWasteList();
	  
	  $('#searchBtn').on('click', function () {
	    handleSearch();
	  });

	  $('#searchKeyword').on('keypress', function (e) {
	    if (e.key == "Enter") {
	      handleSearch();
	    }
	  });
	});

	function handleSearch() {
	  const error = $('#searchError');
	  const keyword = $('#searchKeyword').val().trim();
	  
	  error.text('');

	  if (keyword === '') {
	    error.text('검색어를 입력해주세요.');
	    return;
	  }

	  $.ajax({
	    url: '/usr/home/checkLabelExists',
	    method: 'GET',
	    data: { ko_label: keyword 
	    	
  	},
	    dataType: 'text',
	    success: function (response) {
	      if (response && response.trim() !== '') {
	        location.href = '/usr/home/result?label=' + response;
	      } else {
	        error.text(`'\${keyword}'에 대한 검색 결과가 없습니다.`);
	      }
	    },
	    error: function () {
	      error.text('서버 오류가 발생했습니다. 다시 시도해주세요.');
	    }
	  });
	}

	function LikedWasteList() {
		  $.ajax({
		    url: '/usr/likePoint/getLikedLabels',
		    type: 'GET',
		    data: {
		      relTypeCode: 'waste'
		    },
		    dataType: 'json',
		    success: function(data) {
		      if (!data || data.length === 0) {
		        $('#likedList').html('<li class="text-gray-400">즐겨찾기한 항목이 없습니다</li>');
		        return;
		      }

		      let html = '';
		      data.forEach(function(item) {
		        html += `
		          <li>
		            <a href="/usr/home/result?label=\${item.label}" class="block hover:text-green-600 hover:underline">
		              \${item.ko_label}
		            </a>
		          </li>
		        `;
		      });

		      $('#likedList').html(html);
		    },
		    error: function(xhr, status, error) {
		      console.error("즐겨찾기한 항목 로딩 실패:", error);
		      $('#likedList').html('<li class="text-red-400">불러오기 실패</li>');
		    }
		  });
		}

	

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