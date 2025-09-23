<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="회원 가입" />
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
	let validLoginId = null;

	const joinFormChk = function(form) {
		form.loginId.value = form.loginId.value.trim();
		form.loginPw.value = form.loginPw.value.trim();
		form.loginPwChk.value = form.loginPwChk.value.trim();
		form.name.value = form.name.value.trim();

		if (form.loginId.value.length == 0) {
			alert('아이디는 필수 입력 정보입니다');
			form.loginId.focus();
			return false;
		}

		if (form.loginId.value != validLoginId) {
			alert('[ ' + form.loginId.value + ' ] 은(는) 사용할 수 없는 아이디입니다.');
			form.loginId.focus();
			return false;
		}

		if (form.loginPw.value.length == 0) {
			alert('비밀번호는 필수 입력 정보입니다');
			form.loginPw.focus();
			return false;
		}

		if (form.loginPw.value != form.loginPwChk.value) {
			alert('비밀번호가 일치하지 않습니다');
			form.loginPw.focus();
			return false;
		}

		if (form.name.value.length == 0) {
			alert('이름은 필수 입력 정보입니다');
			form.name.focus();
			return false;
		}
		
		if (form.email.value.length == 0) {
			alert('이메일은 필수 입력 정보입니다');
			form.email.focus();
			return false;
		}
		
		if (form.email.value.length < 8){
			alert('올바른 이메일 형식이 아닙니다')
			form.email.focus();
			return false;
		}
		
		if (form.address.value.length == 0) {
			alert('주소는 필수 입력 정보입니다')
			form.address.focus();
			return false;
		}

		return true;
	}

	const loginIdDupChk = function(el) {
		el.value = el.value.trim();

		let loginIdDupChkMsg = $('#loginIdDupChkMsg');

		if (el.value.length == 0) {
			loginIdDupChkMsg.removeClass('text-green-500');
			loginIdDupChkMsg.addClass('text-red-500');
			loginIdDupChkMsg.html('아이디는 필수 입력 정보입니다');
			return;
		}

		$.ajax({
			url : '/usr/member/loginIdDupChk',
			type : 'GET',
			data : {
				loginId : el.value
			},
			dataType : 'json',
			success : function(data) {
				if (data.success) {
					loginIdDupChkMsg.removeClass('text-red-500');
					loginIdDupChkMsg.addClass('text-green-500');
					loginIdDupChkMsg.html(`\${data.rsMsg}`);
					validLoginId = el.value;
				} else {
					loginIdDupChkMsg.removeClass('text-green-500');
					loginIdDupChkMsg.addClass('text-red-500');
					loginIdDupChkMsg.html(`\${data.rsMsg}`);
					validLoginId = null;
				}
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		})

	}

	function postCode() {
		new daum.Postcode({
			oncomplete: function(data) {
				let region = data.sido;
				if (data.sigungu && data.sigungu.trim() !== '') {
					region += ' ' + data.sigungu;
				}

				$('#address').val(region);

			}
		}).open();
	}

</script>

<section
	class="min-h-screen bg-green-50 flex items-center justify-center">
	<div class="bg-white shadow-xl rounded-2xl p-10 w-full max-w-md">
		<h2 class="text-2xl font-semibold text-center text-green-800 mb-6">회원가입</h2>

		<form action="doJoin" method="post"
			onsubmit="return joinFormChk(this);">
			<div class="space-y-4">

				<div>
					<label class="input input-bordered flex items-center gap-2">
						<input type="text" name="loginId" placeholder="아이디" class="grow"
						onblur="loginIdDupChk(this);" />
					</label>
					<div id="loginIdDupChkMsg" class="mt-1 text-sm text-center h-4"></div>
				</div>

				<label class="input input-bordered flex items-center gap-2">
					<input type="password" name="loginPw" placeholder="비밀번호"
					class="grow" />
				</label> <label class="input input-bordered flex items-center gap-2">
					<input type="password" name="loginPwChk" placeholder="비밀번호 확인"
					class="grow" />
				</label> <label class="input input-bordered flex items-center gap-2">
					<input type="text" name="name" placeholder="이름" class="grow" />
				</label> <label class="input input-bordered flex items-center gap-2">
					<input type="email" name="email" placeholder="이메일" class="grow" />
				</label>
				<div class="flex gap-2 items-center">
					<input type="text" id="address" name="address"
						placeholder="주소를 입력하세요" readonly class="input input-bordered grow" />
					<button type="button" onclick="postCode()"
						class="btn btn-outline btn-sm">검색</button>
				</div>
				
				<div class="flex justify-center mt-6">
					<button class="btn btn-success btn-wide">회원가입</button>
				</div>
			</div>
		</form>

		<div class="text-center mt-4">
			<button class="btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
		</div>
	</div>
</section>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>