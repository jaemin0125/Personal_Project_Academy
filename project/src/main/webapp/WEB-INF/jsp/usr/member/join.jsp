<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="회원 가입" />
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

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

		if (form.email.value.length < 8) {
			alert('올바른 이메일 형식이 아닙니다')
			form.email.focus();
			return false;
		}

		if (form.address.value.length == 0) {
			alert('주소는 필수 입력 정보입니다')
			form.address.focus();
			return false;
		}

		if (form.isPhoneCertified.value == "false") {
			alert('휴대폰 인증이 필요합니다')
			form.certifyPhone.focus();
			return false;
		}

		console.log(form.isPhoneCertified.value);

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
			oncomplete : function(data) {
				let region = data.sido;
				if (data.sigungu && data.sigungu.trim() !== '') {
					region += ' ' + data.sigungu;
				}

				$('#address').val(region);

			}
		}).open();
	}

	function openAuthModal() {

		const phoneNum = $('#cellphoneNum').val().trim();
		const regExp = /^010[0-9]{7,8}$/;

		if (phoneNum.length == 0) {
			alert('휴대폰 번호를 입력하세요');
			$('#cellphoneNum').focus();
			return;
		}
		if (!regExp.test(phoneNum)) {
			alert('올바른 휴대폰 번호 형식이 아닙니다');
			$('#cellphoneNum').focus();
			return;
		}

		document.getElementById('auth_modal').showModal();

		$('#cellphoneNum').prop('readonly', true);

		$.ajax({
			url : '/usr/member/getAuthPin',
			type : 'GET',
			dataType : 'text',
			success : function(data) {

				$("#authPin").html(data);

			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		})

	}

	function verifyAuth() {

		const phoneNum = $('#cellphoneNum').val();
		const authPin = $('#authPin').html();
		const authMsg = $('#authMsg');

		$.ajax({
			url : '/usr/member/verifyPhoneNum',
			type : 'GET',
			data : {
				phoneNum : phoneNum,
				authPin : authPin
			},
			dataType : 'json',
			success : function(data) {

				if (data.exists == true && !data.isDupPhoneNum) {
					authMsg.removeClass('text-red-500');
					authMsg.addClass('text-success');
					authMsg.html("인증이 완료되었습니다");
					$('#isPhoneCertified').val("true");
					$('#certifyButton').prop("disabled", true);
					window.auth_modal.close();
				}
				
				else if (data.exists == true && data.isDupPhoneNum) {
					alert('이미 가입된 휴대폰 번호입니다. 로그인 페이지로 이동합니다');
					location.href = "/usr/member/login";
				} 
				
				else if (data.exists == false) {
					authMsg.removeClass('text-success');
					authMsg.addClass('text-red-500');
					authMsg.html("인증에 실패하였습니다");

					$('#cellphoneNum').prop('readonly', false);
					window.auth_modal.close();
				}
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		})
	}

	function closeModal() {
		document.getElementById('auth_modal').close();
		$('#cellphoneNum').prop('readonly', false);
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
				<div class="flex gap-2 items-center">
					<label class="input input-bordered flex items-center gap-2 grow">
						<input type="text" id="cellphoneNum" name="phoneNum"
						placeholder="휴대폰 번호 (- 없이 입력)" class="grow" />
					</label>
					<button type="button" onclick="openAuthModal()"
						id="certifyButton" class="btn btn-outline btn-sm" name="certifyPhone">인증하기</button>
				</div>
				<input type="hidden" id="isPhoneCertified" name="isPhoneCertified"
					value="false" />
				<div id="authMsg" class="mt-1 text-sm text-center h-4 text-success"></div>

				<div class="flex justify-center mt-6">
					<button class="btn btn-success btn-wide">회원가입</button>
				</div>
			</div>
		</form>

		<dialog id="auth_modal" class="modal">
		<div class="modal-box text-center">
			<h3 class="font-bold text-lg">휴대폰 소유 확인</h3>
			<p class="py-4 text-sm text-gray-500">아래 안내된 번호로 인증 번호를 전송해 주세요.</p>

			<div class="bg-base-200 p-6 rounded-lg my-4 space-y-3">
				<div>
					<span class="text-xs text-gray-400">보낼 곳(옥토모 대표번호)</span>
					<p id="octomoNum" class="text-xl font-bold text-primary">1666-3538</p>
				</div>
				<hr class="border-base-300">
				<div>
					<span class="text-xs text-gray-400">메시지 내용(인증번호)</span>
					<p id="authPin"
						class="text-3xl font-black tracking-widest text-secondary">----</p>
				</div>
			</div>

			<p class="text-xs text-error mb-4">※ 문자를 보낸 후 아래 확인 버튼을 눌러주세요.</p>

			<div class="modal-action justify-center">
				<button type="button" onclick="verifyAuth()"
					class="btn btn-success btn-wide">인증 완료 확인</button>
				<button type="button" onclick="closeModal();" class="btn btn-ghost">닫기</button>
			</div>
		</div>
		</dialog>

		<div class="text-center mt-4">
			<button class="btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
		</div>
	</div>
</section>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>