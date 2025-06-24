
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="로그인" />
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<script>
	const loginFormChk = function (form) {
		form.loginId.value = form.loginId.value.trim();
		form.loginPw.value = form.loginPw.value.trim();

		if (form.loginId.value.length == 0) {
			alert('아이디는 필수 입력 정보입니다');
			form.loginId.focus();
			return false;
		}

		if (form.loginPw.value.length == 0) {
			alert('비밀번호는 필수 입력 정보입니다');
			form.loginPw.focus();
			return false;
		}

		return true;
	}
</script>

<section class="min-h-screen bg-green-50 flex items-center justify-center">
	<div class="bg-white shadow-xl rounded-2xl p-10 w-full max-w-md">
		<h2 class="text-2xl font-semibold text-center text-green-800 mb-6">로그인</h2>
		
		<form action="doLogin" method="post" onsubmit="return loginFormChk(this);">
			<div class="space-y-4">
				<label class="input input-bordered flex items-center gap-2">
					<svg class="w-4 h-4 opacity-50" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A3.001 3.001 0 008 21h8a3 3 0 002.879-3.196A5.002 5.002 0 0018 13V9a6 6 0 10-12 0v4a5.002 5.002 0 00-.879 4.804z" />
					</svg>
					<input type="text" name="loginId" placeholder="아이디" class="grow" />
				</label>

				<label class="input input-bordered flex items-center gap-2">
					<svg class="w-4 h-4 opacity-50" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM18 11c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM6 11c1.105 0 2-.895 2-2S7.105 7 6 7 4 7.895 4 9s.895 2 2 2zM6 13c-1.105 0-2 .895-2 2s.895 2 2 2 2-.895 2-2-.895-2-2-2zm6 0c-1.105 0-2 .895-2 2s.895 2 2 2 2-.895 2-2-.895-2-2-2zm6 0c-1.105 0-2 .895-2 2s.895 2 2 2 2-.895 2-2-.895-2-2-2z" />
					</svg>
					<input type="password" name="loginPw" placeholder="비밀번호" class="grow" />
				</label>

				<div class="flex justify-center mt-6">
					<button class="btn btn-success btn-wide">로그인</button>
				</div>
			</div>
		</form>

		<div class="text-center mt-4">
			<button class="btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>