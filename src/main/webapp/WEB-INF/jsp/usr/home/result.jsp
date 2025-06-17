<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  

<c:set var="pageTitle" value="분조장" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp" %>

<c:if test="${wasteGuide != null }">
	<div class="max-w-4xl mt-4 mx-auto p-8 bg-white rounded-2xl shadow-lg">
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
			<span class="font-semibold text-green-700">📦 분리배출 방법:</span>
			<div class="mt-2 text-lg font-medium">${wasteGuide.getForPrintGuide() }</div>
		</div>

		<c:if test="${loginedMember != null && loginedMember.getId() != 0}">
			<c:if test="${wasteGuide.getWasteType() == '대형' }">
				<div
					class="bg-yellow-50 border-l-4 border-yellow-400 p-6 rounded-lg text-gray-800">
					<h3 class="text-lg font-semibold text-yellow-700 mb-3">🏠
						${loginedMember.getAddress() } 기준 폐기물 스티커 가격</h3>

					<!-- 표 테이블 스타일 -->
					<div class="overflow-x-auto">
						<table class="w-full table-auto border-collapse text-sm">
							<thead>
								<tr class="bg-yellow-100 text-yellow-800 font-semibold">
									<th class="px-4 py-2 border border-yellow-300">세부항목</th>
									<th class="px-4 py-2 border border-yellow-300">단위</th>
									<th class="px-4 py-2 border border-yellow-300">가격</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="stickerPrice" items="${stickerPrice}">
									<tr class="hover:bg-yellow-50">
										<td class="px-4 py-2 border border-yellow-200">${stickerPrice.getSubType()}</td>
										<td class="px-4 py-2 border border-yellow-200">${stickerPrice.getUnit()}</td>
										<td class="px-4 py-2 border border-yellow-200 font-medium">${stickerPrice.getPrice()}원</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</c:if>
		</c:if>

		<!-- 오류신고 버튼 -->
		<div class="flex justify-between mt-6">
			<button type="button" onclick="history.back();" class="btn btn-outline btn-success btn-sm">← 뒤로가기</button>
			<a href="/usr/article/write?boardId=4" class="btn btn-sm btn-error">🚨오류
				신고</a>
		</div>
	</div>
	<hr class="border-t border-gray-300 my-12" />
	<c:if test="${not empty relatedList}">
		<div class="pb-6">
			<h3 class="text-xl text-center font-semibold text-green-700 mb-4">헷갈릴 수 있는 다른 항목도 있어요 👀</h3>
			<div class="gap-1 flex w-full justify-center">
				<c:forEach var="item" items="${relatedList}">
					<a href="/usr/home/result?label=${item.label}"
						class="block text-center hover:shadow-lg w-1/5 p-4 bg-white rounded-xl border border-gray-200 transition hover:-translate-y-1 hover:scale-[1.02] duration-200 ml-4">
						<img src="${item.thumbnail}" alt="${item.ko_label}"
						class="w-24 h-24 mx-auto object-contain mb-2">
						<span class="text-sm text-gray-700 font-medium">${item.ko_label}</span>
					</a>
				</c:forEach>
			</div>
		</div>
	</c:if>
</c:if>

<c:if test="${wasteGuide == null }">
	<div class="bg-red-50 border-l-4 border-red-400 p-6 rounded-xl shadow-md text-red-800 max-w-xl mx-auto mt-20 text-center animate-fade-in">
		<h2 class="text-2xl font-bold mb-2">😢 분류에 실패했어요</h2>
		<div class="text-md mb-4 leading-relaxed">
			업로드한 이미지를 <strong>AI가 분류하지 못했어요.</strong><br />
			아직 학습되지 않았거나, <span class="text-red-600 font-semibold">사진이 불분명할 수 있어요.</span>
		</div>

		<!-- ✔ 사용자 행동 유도 -->
		<div class="text-gray-700 mb-4">
			🔁 <strong>다른 각도나 배경으로 다시 촬영</strong>해 보시겠어요?<br />
			🔙 또는 <strong><a href="javascript:history.back()" class="text-blue-600 hover:underline">뒤로가기</a></strong> 후 다시 시도해 보세요!
		</div>

		<!-- 오류 신고 유도 -->
		<a href="/usr/article/write?boardId=4"
			class="inline-block mt-4 px-6 py-2 bg-red-400 text-white font-semibold rounded-full hover:bg-red-500 transition duration-200">
			🔧 오류 신고하고 AI 학습 돕기
		</a>
		<div class="mt-2">
			* 업로드했던 사진을 
			<span class="text-red-600 font-semibold">꼭</span>
			첨부해주세요!!
		</div>
	</div>
</c:if>




<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>