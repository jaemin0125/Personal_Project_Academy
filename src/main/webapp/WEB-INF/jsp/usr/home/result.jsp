<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  

<c:set var="pageTitle" value="분조장" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp" %>

	<div class="p-6 bg-white rounded-xl shadow-md text-center">
  <h2 class="text-xl font-semibold mb-4">분석 결과</h2>
  <p>쓰레기 종류: <strong>${label}</strong></p>
  <p>분리배출 방법: <strong>${wasteGuide}</strong></p>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>