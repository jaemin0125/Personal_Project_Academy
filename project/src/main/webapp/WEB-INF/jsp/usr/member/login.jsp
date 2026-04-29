
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="로그인" />
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
const findIdState = {
	phoneNum : null,
	authPin : null,
	loginId : null
}

	const loginFormChk = function(form) {
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

	function historyBack() {
		location.href = "/";
	}
	
	function getFirstHtml(){
		return `<div class="modal-box text-center">
					<h3 class="font-bold text-lg">아이디 찾기</h3>
					<p class="py-4 text-sm text-gray-500">가입 시 등록한 휴대폰 번호를 입력해주세요.</p>
					<div class="flex flex-col gap-3">
						<input type="text" id="findId_phoneNum" placeholder="휴대폰 번호 (- 없이)"
							class="input input-bordered w-full" />
						<button type="button" onclick="findLoginId();"
							class="btn btn-primary w-full">아이디 확인</button>
					</div>
					<div id="findId_result" class="mt-4 text-sm font-medium h-6"></div>
					<div class="modal-action">
						<form method="dialog">
							<button class="btn btn-ghost">닫기</button>
						</form>
					</div>
				</div>`;
	}
	
	
	
	
	function openFindIdModal(){
		document.getElementById('findId_modal').showModal();
		$('#findId_modal').html(getFirstHtml());
	}
	
	
	
	
	function findLoginId (){
		
		const regExp = /^010[0-9]{7,8}$/;
		const phoneNum = $('#findId_phoneNum').val();
		
		if(phoneNum.length == 0){
			alert('휴대폰 번호를 입력하세요');
			$('#findId_phoneNum').focus();
			
			return;
		}
		if(!regExp.test(phoneNum)){
			alert('올바른 휴대폰 번호 형식이 아닙니다');
			$('#findId_phoneNum').focus();
			
			return;
		} 
		
		findIdState.phoneNum = phoneNum;
		
		$('#findId_phoneNum').prop('readonly', true);
		
		$.ajax({
			url : '/usr/member/getAuthPin',
			type : 'GET',
			dataType : 'text',
			success : function(data) {
					findIdState.authPin = data; //Pin번호 전역 상태에 저장.
				
					$('#findId_modal').html(
							`<div class="modal-box text-center">
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
											class="text-3xl font-black tracking-widest text-secondary">\${data}</p>
									</div>
								</div>
					
								<p class="text-xs text-error mb-4">※ 문자를 보낸 후 아래 확인 버튼을 눌러주세요.</p>
					
								<div class="modal-action justify-center">
									<button type="button" onclick="verifyAuth()"
										class="btn btn-success btn-wide">인증 완료 확인</button>
									<form method="dialog">
										<button class="btn btn-ghost">닫기</button>
									</form>
								</div>
							</div>`
							)

			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		})
		
	}
	
	function verifyAuth() {

		$.ajax({
			url : '/usr/member/findLoginInfo',
			type : 'GET',
			data : {
				phoneNum : findIdState.phoneNum,
				authPin : findIdState.authPin
			},
			dataType : 'json',
			success : function(data) {
				if(!data.exists){
					alert('인증에 실패하였습니다');
					return;
				}
				
				if(!data.loginId){
					alert('입력하신 정보의 회원이 존재하지 않습니다');
					location.href = "/usr/member/join";
				}
				//loginId 안내 후 findIdState 의 상태는 다시 null로 초기화해줘야함!!!!!
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		})
	}

</script>

<section
	class="min-h-screen bg-green-50 flex items-center justify-center p-4">
	<div class="bg-white shadow-xl rounded-2xl p-8 md:p-10 w-full max-w-md">
		<h2 class="text-2xl font-bold text-center text-green-800 mb-8">로그인</h2>

		<form action="doLogin" method="post"
			onsubmit="return loginFormChk(this);" class="w-full">
			<div class="space-y-5">
				<div class="form-control w-full">
					<label class="input input-bordered flex items-center gap-3 w-full">
						<svg class="w-4 h-4 opacity-60 shrink-0"
							xmlns="http://www.w3.org/2000/svg" fill="currentColor"
							viewBox="0 0 16 16">
                            <path
								d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z" />
                        </svg> <input type="text" name="loginId"
						placeholder="아이디" class="grow w-full" />
					</label>
				</div>

				<div class="form-control w-full">
					<label class="input input-bordered flex items-center gap-3 w-full">
						<svg class="w-4 h-4 opacity-60 shrink-0"
							xmlns="http://www.w3.org/2000/svg" fill="currentColor"
							viewBox="0 0 16 16">
                            <path
								d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z" />
                        </svg> <input type="password" name="loginPw"
						placeholder="비밀번호" class="grow w-full" />
					</label>
				</div>

				<div class="pt-2">
					<button
						class="btn btn-success w-full text-white font-bold tracking-wide">로그인</button>
				</div>
			</div>
		</form>

		<div
			class="flex justify-center items-center gap-3 mt-8 text-xs sm:text-sm text-gray-400">
			<button type="button" onclick="openFindIdModal();"
				class="hover:text-green-600 transition-colors bg-transparent border-none p-0 cursor-pointer">
				아이디 찾기</button>

			<span class="w-px h-3 bg-gray-200"></span>

			<button type="button" onclick="findPw_modal.showModal();"
				class="hover:text-green-600 transition-colors bg-transparent border-none p-0 cursor-pointer">
				비밀번호 찾기</button>

			<span class="w-px h-3 bg-gray-200"></span> <a href="/usr/member/join"
				class="hover:text-green-600 font-medium transition-colors"> 회원가입
			</a>
		</div>

		<div class="mt-8 flex justify-center">
			<button
				class="btn btn-ghost btn-sm text-gray-400 hover:bg-transparent hover:text-gray-600"
				onclick="historyBack();">← 돌아가기</button>
		</div>
	</div>
</section>

<dialog id="findId_modal" class="modal">
	<div class="modal-box text-center">
		<h3 class="font-bold text-lg">아이디 찾기</h3>
		<p class="py-4 text-sm text-gray-500">가입 시 등록한 휴대폰 번호를 입력해주세요.</p>
		<div class="flex flex-col gap-3">
			<input type="text" id="findId_phoneNum" placeholder="휴대폰 번호 (- 없이)"
				class="input input-bordered w-full" />
			<button type="button" onclick="findLoginId();"
				class="btn btn-primary w-full">아이디 확인</button>
		</div>
		<div id="findId_result" class="mt-4 text-sm font-medium h-6"></div>
		<div class="modal-action">
			<form method="dialog">
				<button class="btn btn-ghost">닫기</button>
			</form>
		</div>
	</div>
</dialog>

<dialog id="findPw_modal" class="modal">
	<div class="modal-box text-center">
		<h3 class="font-bold text-lg">비밀번호 찾기</h3>
		<p class="py-4 text-sm text-gray-500">아이디와 등록된 휴대폰 번호를 입력해주세요.</p>
		<div class="flex flex-col gap-3">
			<input type="text" id="findPw_loginId" placeholder="아이디"
				class="input input-bordered w-full" /> <input type="text"
				id="findPw_phoneNum" placeholder="휴대폰 번호 (- 없이)"
				class="input input-bordered w-full" />
			<button type="button" class="btn btn-secondary w-full">본인 인증
				후 비밀번호 재설정</button>
		</div>
		<div class="modal-action">
			<form method="dialog">
				<button class="btn btn-ghost">닫기</button>
			</form>
		</div>
	</div>
</dialog>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>