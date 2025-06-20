<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="ERROR ${statusCode }" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>


<section
	class="flex items-center justify-center min-h-screen bg-gray-100">
	<div class="bg-white p-10 rounded-2xl shadow-lg max-w-lg text-center">
				<p class="text-gray-600 mb-6">
				 <strong class="text-2xl">AI 분석 서버가 응답하지 않습니다.</strong> <br />
				 <strong class="text-xl">잠시 후 다시 시도해주세요.</strong> 
				</p>
		<a href="/" class="btn btn-primary">홈으로 돌아가기</a>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>