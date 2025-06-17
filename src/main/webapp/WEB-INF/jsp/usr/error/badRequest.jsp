<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="ERROR ${statusCode }" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>


<section
	class="flex items-center justify-center min-h-screen bg-gray-100">
	<div class="bg-white p-10 rounded-2xl shadow-lg max-w-lg text-center">
		<h1 class="text-5xl font-bold text-red-500 mb-4">${statusCode}</h1>

		<c:choose>
			<c:when test="${statusCode == 400}">
				<h2 class="text-2xl font-semibold mb-2">잘못된 요청입니다</h2>
				<p class="text-gray-600 mb-6">
					요청이 잘못되었거나 서버에서 이해할 수 없는 요청이었습니다.<br> 입력값을 다시 확인해주세요.
				</p>
			</c:when>
			<c:when test="${statusCode == 401}">
				<h2 class="text-2xl font-semibold mb-2">인증이 필요합니다</h2>
				<p class="text-gray-600 mb-6">
					이 페이지를 보려면 로그인해야 합니다.<br> 로그인 후 다시 시도해주세요.
				</p>
			</c:when>
			<c:when test="${statusCode == 403}">
				<h2 class="text-2xl font-semibold mb-2">접근이 거부되었습니다</h2>
				<p class="text-gray-600 mb-6">
					이 페이지에 접근할 권한이 없습니다.<br> 관리자에게 문의하세요.
				</p>
			</c:when>
			<c:when test="${statusCode == 404}">
				<h2 class="text-2xl font-semibold mb-2">페이지를 찾을 수 없습니다</h2>
				<p class="text-gray-600 mb-6">
					존재하지 않는 페이지입니다.<br> URL을 다시 확인해주세요.
				</p>
			</c:when>
			<c:when test="${statusCode == 500}">
				<h2 class="text-2xl font-semibold mb-2">서버 오류입니다</h2>
				<p class="text-gray-600 mb-6">
					서버 내부에서 문제가 발생했습니다.<br> 잠시 후 다시 시도해주세요.
				</p>
			</c:when>
			<c:otherwise>
				<h2 class="text-2xl font-semibold mb-2">알 수 없는 오류</h2>
				<p class="text-gray-600 mb-6">
					에러 코드: ${statusCode} <br> 예기치 못한 오류가 발생했습니다.
				</p>
			</c:otherwise>
		</c:choose>

		<a href="/" class="btn btn-primary">홈으로 돌아가기</a>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>