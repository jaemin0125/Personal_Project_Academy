<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  

<c:set var="pageTitle" value="분조장" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp" %>

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


<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>