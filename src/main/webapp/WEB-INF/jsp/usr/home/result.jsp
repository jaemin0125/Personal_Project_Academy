<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  

<c:set var="pageTitle" value="분조장" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp" %>

<c:if test="${wasteGuide != null }">
	<div class="max-w-3xl mt-4 mx-auto p-8 bg-white rounded-2xl shadow-lg">
		<div class="text-center mb-8">
			<h2 class="text-2xl font-bold mb-2">
				쓰레기 종류: <span class="text-green-600">${wasteGuide.ko_label}</span>
			</h2>
			<div class="text-gray-500 text-sm">정확한 분리배출 방법을 확인하세요</div>
		</div>

		<!-- 이미지 -->
		<div class="flex justify-center mb-6">
			<img src="${wasteGuide.thumbnail}"
				class="w-72 h-auto rounded-lg shadow" alt="${wasteGuide.ko_label}" />
		</div>

		<!-- 분리배출 가이드 -->
		<div class="bg-green-50 border-l-4 border-green-400 p-6 rounded-lg text-left text-gray-800 mb-8">
			<span class="font-semibold text-green-700">분리배출 방법:</span>
			<div class="mt-2 text-lg font-medium">${wasteGuide.getForPrintGuide() }</div>
		</div>

		<!-- 오류신고 버튼 -->
		<div class="text-right">
			<a href="/usr/article/write?boardId=4" class="btn btn-sm btn-error">🚨
				오류 신고</a>
		</div>
	</div>

</c:if>
<c:if test="${wasteGuide == null }">
	<div
		class="bg-red-50 border-l-4 border-red-400 p-6 rounded-xl shadow-md text-red-800 max-w-xl mx-auto mt-20 text-center animate-fade-in">
		<h2 class="text-2xl font-bold mb-2">😢 아직 학습되지 않은 쓰레기입니다</h2>
		<div class="text-md mb-4">
			현재 업로드한 쓰레기는 <strong>AI가 아직 분류하지 못했어요.</strong><br /> <span
				class="text-red-600 font-semibold">여러분의 도움</span>으로 더 똑똑한 분리수거 AI가 될
			수 있습니다.
		</div>
		<a href="/usr/article/write?boardId=4"
			class="inline-block mt-4 px-6 py-2 bg-red-400 text-white font-semibold rounded-full hover:bg-red-500 transition duration-200">
			🔧 오류 신고하고 AI 학습 돕기 </a>
		<div class="mt-2">
			* 업로드했던 사진을 <span class="text-red-600 font-semibold">꼭</span> 첨부해
			주세요!!
		</div>
	</div>
</c:if>


<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>