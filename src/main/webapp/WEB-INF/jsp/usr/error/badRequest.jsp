<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<section class="flex items-center justify-center min-h-screen bg-gray-100">
  <div class="bg-white p-10 rounded-2xl shadow-lg max-w-lg text-center">
    <h1 class="text-5xl font-bold text-red-500 mb-4">400</h1>
    <h2 class="text-2xl font-semibold mb-2">잘못된 요청입니다</h2>
    <p class="text-gray-600 mb-6">
      요청이 잘못되었거나 서버에서 이해할 수 없는 요청이었습니다.<br>
      입력값을 다시 확인해주세요.
    </p>
    <a href="/" class="btn btn-primary">홈으로 돌아가기</a>
  </div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
