<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  

<c:set var="pageTitle" value="분조장" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp" %>

<c:if test="${wasteGuide != null }"> 
	<div class="p-6 bg-white rounded-xl shadow-md text-center">
		<div class="pb-6 text-2xl">
			쓰레기 종류: <strong>${wasteGuide.getKo_label() }</strong>
		</div>
		<div class="pb-6">
			<img src="${wasteGuide.thumbnail}" class="w-64 mx-auto rounded-lg mb-4" />
		</div>
		<div class="text-xl">
			분리배출 방법: <strong>${wasteGuide.getGuide() }</strong>
		</div>
		<div class="pt-6 pr-10 text-right">
			<div class="btn btn-sm">
				<a href="/usr/article/write?boardId=4">오류신고</a>
			</div>
		</div>
	</div>
</c:if>
<c:if test="${wasteGuide == null }"> 
  <div class="bg-red-50 border-l-4 border-red-400 p-6 rounded-xl shadow-md text-red-800 max-w-xl mx-auto mt-10 text-center animate-fade-in">
    <h2 class="text-2xl font-bold mb-2">😢 아직 학습되지 않은 쓰레기입니다</h2>
    <div class="text-md mb-4">
      현재 업로드한 쓰레기는 <strong>AI가 아직 분류하지 못했어요.</strong><br/>
      <span class="text-red-600 font-semibold">여러분의 도움</span>으로 더 똑똑한 분리수거 AI가 될 수 있습니다.
    </div>
    <a href="/usr/article/write?boardId=4"
      class="inline-block mt-4 px-6 py-2 bg-red-400 text-white font-semibold rounded-full hover:bg-red-500 transition duration-200">
      🔧 오류 신고하고 AI 학습 돕기
    </a>
  </div>
</c:if>


<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>