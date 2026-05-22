
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="로그인" />
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<script>
const findInfoState = {
	info : null,
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
	
	function getFirstHtml(info){
		if(info == "id"){
			return `<div class="modal-box text-center">
						<h3 class="font-bold text-lg">아이디 찾기</h3>
						<p class="py-4 text-sm text-gray-500">가입 시 등록한 휴대폰 번호를 입력해주세요.</p>
						<div class="flex flex-col gap-3">
							<input type="text" id="findId_phoneNum" placeholder="휴대폰 번호 (- 없이)"
								class="input input-bordered w-full" />
							<button type="button" onclick="findLoginId();"
								class="btn btn-success w-full">아이디 확인</button>
						</div>
						<div id="findId_result" class="mt-4 text-sm font-medium h-6"></div>
						<div class="modal-action">
							<form method="dialog">
								<button class="btn btn-ghost">닫기</button>
							</form>
						</div>
					</div>`;
		} else if(info == "pw"){
			return `<div class="modal-box text-center">
						<h3 class="font-bold text-lg">비밀번호 찾기</h3>
						<p class="py-4 text-sm text-gray-500">아이디와 등록된 휴대폰 번호를 입력해주세요.</p>
						<div class="flex flex-col gap-3">
							<input type="text" id="findPw_loginId" placeholder="아이디"
								class="input input-bordered w-full" /> <input type="text"
								id="findPw_phoneNum" placeholder="휴대폰 번호 (- 없이)"
								class="input input-bordered w-full" />
							<button type="button" onclick="getAuthPin_pw();" class="btn btn-success	 w-full">본인 인증
								후 비밀번호 재설정</button>
						</div>
						<div class="modal-action">
							<form method="dialog">
								<button class="btn btn-ghost">닫기</button>
							</form>
						</div>
					</div>`;
		}
		
	}
	
	
	
	function openFindIdModal(){
		document.getElementById('findId_modal').showModal();
		$('#findId_modal').html(getFirstHtml("id"));
	}
	
	
	function findLoginId (){
		
		const regExp = /^010[0-9]{7,8}$/;
		const phoneNum = $('#findId_phoneNum').val().trim();
		
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
		
		findInfoState.phoneNum = phoneNum;
		
		$('#findId_phoneNum').prop('readonly', true);
		
		$.ajax({
			url : '/usr/member/getAuthPin',
			type : 'GET',
			dataType : 'text',
			success : function(data) {
					findInfoState.authPin = data; //Pin번호 전역 상태에 저장.
				
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
									<button type="button" onclick="verifyAuth('id')"
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
	
	function verifyAuth(info) {

		$.ajax({
			url : '/usr/member/findLoginInfo',
			type : 'GET',
			data : {
				phoneNum : findInfoState.phoneNum,
				authPin : findInfoState.authPin,
				loginId : findInfoState.loginId,
				mode : info
			},
			dataType : 'json',
			success : function(data) {

				if(data.fail){
					alert(data.rsMsg);
					
					if(data.rsCode === "F-2" || data.rsCode === "F-4" ){ //F-2 = 인증 실패 코드 (공통) , F-4 = 잘못된 접근 코드
						return location.href = "/usr/member/login";
					} 
					else if (data.rsCode === "F-3") { //F-3 = 회원 정보 미존재 코드 (공통)
						return location.href = "/usr/member/join";
					}
					
					return; //F-1 = 입력값 유효성 오류 코드 (공통) F-1일 떄는 모달 유지를 위해 redirection X 
				}
				
				
				if (data.rsCode === "S-1"){ //S-1 = id찾기 성공 코드
					findInfoState.loginId = data.rsData.loginId;
					
					$('#findId_modal').html(
							`<div id="find-id-result" class="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
							    <div class="p-8">
							        <div class="text-center mb-8">
							            <div class="inline-flex items-center justify-center w-20 h-20 bg-green-50 text-green-500 rounded-full mb-4 ring-8 ring-green-50/50">
							                <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
							                </svg>
							            </div>
							            <h2 class="text-2xl font-black text-gray-800 tracking-tight">아이디 찾기 성공</h2>
							            <p class="text-gray-400 mt-2 text-sm font-medium">회원님의 소중한 계정 정보를 찾았습니다.</p>
							        </div>
							
							        <div class="bg-gray-50 rounded-2xl p-10 text-center border border-dashed border-gray-200 my-6 relative">
							            <p class="text-[10px] text-gray-400 uppercase tracking-[0.3em] mb-3 font-bold">Registered Account</p>
							            
							            <div class="flex items-center justify-center gap-2">
							                <span id="display-login-id" class="text-4xl font-mono font-black text-green-600 tracking-tighter">
							                   \${findInfoState.loginId}
							                </span>
							            </div>
							            
							            <div class="absolute bottom-0 left-1/2 -translate-x-1/2 w-12 h-1 bg-green-500 rounded-full translate-y-1/2"></div>
							        </div>
							
							        <div class="flex flex-col gap-3 mt-10">
							            <a href="/usr/member/login" 
							               class="btn btn-success btn-lg w-full text-white font-bold shadow-lg shadow-green-200 border-none transition-all hover:scale-[1.02] active:scale-95">
							                로그인하기
							            </a>
							            
							            <div class="relative py-4">
							                <div class="absolute inset-0 flex items-center"><div class="w-full border-t border-gray-100"></div></div>
							                <div class="relative flex justify-center text-xs uppercase"><span class="bg-white px-3 text-gray-300 tracking-widest">Additional Option</span></div>
							           </div>
							            
							            <button onclick="findPw_modal();" 
							               class="btn btn-ghost btn-sm w-full text-gray-400 hover:text-green-600 hover:bg-green-50 font-medium">
							                비밀번호가 기억나지 않으시나요?
							            </button>
							        </div>
							    </div>
							    
							    <div class="bg-gray-50 px-8 py-4 border-t border-gray-100 text-center">
							        <p class="text-[10px] text-gray-400 font-medium">보안을 위해 비밀번호는 주기적으로 변경해 주세요.</p>
							    </div>
							</div>`);	
					
					findInfoState.info = null;
					findInfoState.phoneNum = null;
					findInfoState.authPin = null;
					findInfoState.loginId = null;
					
				} else if (data.rsCode === "S-2") { //S-2 = pw 재설정 허용 코드
				    $('#findPw_modal').html(`
				        <div id="reset-pw-form" class="modal-box p-0 bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden w-11/12 max-w-md">
				            <div class="p-8">
				                <div class="text-center mb-8">
				                    <div class="inline-flex items-center justify-center w-20 h-20 bg-blue-50 text-blue-500 rounded-full mb-4 ring-8 ring-blue-50/50">
				                        <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
				                        </svg>
				                    </div>
				                    <h2 class="text-2xl font-black text-gray-800 tracking-tight">비밀번호 재설정</h2>
				                    <p class="text-gray-400 mt-2 text-sm font-medium">안전한 사용을 위해 새 비밀번호를 입력해주세요.</p>
				                </div>

				                <div class="space-y-4">
				                    <div class="form-control">
				                        <label class="label">
				                            <span class="label-text font-bold text-gray-600">새 비밀번호</span>
				                        </label>
				                        <input type="password" id="newPassword" placeholder="8~16자 영문, 숫자 조합" 
				                               class="input input-bordered w-full focus:input-primary transition-all rounded-xl bg-gray-50 border-gray-200" />
				                    </div>

				                    <div class="form-control">
				                        <label class="label">
				                            <span class="label-text font-bold text-gray-600">비밀번호 확인</span>
				                        </label>
				                        <input type="password" id="newPasswordConfirm" placeholder="다시 한번 입력해주세요" 
				                               class="input input-bordered w-full focus:input-primary transition-all rounded-xl bg-gray-50 border-gray-200" />
				                        <label class="label">
				                            <span id="pw-match-msg" class="label-text-alt text-error hidden block w-full break-all">비밀번호가 일치하지 않습니다.</span>
				                        </label>
				                    </div>

				                    <div class="flex flex-col gap-3 mt-6">
				                        <button onclick="submitNewPassword();" 
				                                class="btn btn-primary btn-lg w-full text-white font-bold shadow-lg shadow-blue-200 border-none transition-all hover:scale-[1.02] active:scale-95">
				                            비밀번호 변경하기
				                        </button>
				                        
				                        <button onclick="location.reload();" 
				                                class="btn btn-ghost btn-sm w-full text-gray-400 font-medium">
				                            취소
				                        </button>
				                    </div>
				                </div>
				            </div>
				            
				            <div class="bg-gray-50 px-8 py-4 border-t border-gray-100 text-center">
				                <p class="text-[10px] text-gray-400 font-medium text-left italic">
				                    * 다른 사이트에서 사용하지 않는 안전한 비밀번호를 권장합니다.
				                </p>
				            </div>
				        </div>
				    `);
				}
				
				
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		})
	}
	
	function submitNewPassword(){
		const regExp = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=\.-])(?=.*[0-9]).{8,16}$/;
		const newPassword = $('#newPassword').val().trim();
		const newPasswordConfirm = $('#newPasswordConfirm').val().trim();
		
		if(newPassword.length == 0){
			alert('비밀번호를 입력하세요');
			$('#newPassword').focus();	
			return;
		} else if (newPasswordConfirm.length == 0){
			alert('비밀번호를 다시 입력하세요');
			$('#newPasswordConfirm').focus();
			return;
		}
		
		if(!regExp.test(newPassword)){
			alert('올바른 비밀번호 형식이 아닙니다');
			$('#newPassword').focus();
			
			return;
		}
		
		if(newPassword != newPasswordConfirm){
			$('#pw-match-msg').removeClass("hidden");
			$('#newPasswordConfirm').focus();
			
			return;
		}
		
		if(newPassword == newPasswordConfirm){
			$('#pw-match-msg').addClass("hidden");
		}
		
		console.log(findInfoState);
		
		$.ajax({
			url : '/usr/member/resetPassword',
			type : 'POST',
			data : {
				loginId : findInfoState.loginId,
				phoneNum : findInfoState.phoneNum,
				newPassword : newPassword,
			},
			dataType : 'json',
			success : function(data) {
				if(data.success){
					alert(data.rsMsg);
					return location.href = "/";
				} else{
					alert(data.rsMsg);
					return location.href = "/usr/member/login";
				}
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		})
		
		findInfoState.info = null;
		findInfoState.phoneNum = null;
		findInfoState.authPin = null;
		findInfoState.loginId = null;
		
	}
	
	function findPw_modal(){
		document.getElementById('findId_modal').close();
		
		$('#findPw_modal').html(getFirstHtml("pw"));
		document.getElementById('findPw_modal').showModal();
	}
	
	function getAuthPin_pw(){
		
		const regExp = /^010[0-9]{7,8}$/;
		const phoneNum = $('#findPw_phoneNum').val().trim();
		const loginId = $('#findPw_loginId').val().trim();
		
		if(loginId.length == 0){
			alert('ID를 입력하세요');
			$('#findPw_loginId').focus();
			
			return;
		}
		if(phoneNum.length == 0){
			alert('휴대폰 번호를 입력하세요');
			$('#findPw_phoneNum').focus();
			
			return;
		}
		if(!regExp.test(phoneNum)){
			alert('올바른 휴대폰 번호 형식이 아닙니다');
			$('#findPw_phoneNum').focus();
			
			return;
		}
		
		
		findInfoState.phoneNum = phoneNum;
		findInfoState.loginId = loginId;
		
		$.ajax({
			url : '/usr/member/getAuthPin',
			type : 'GET',
			dataType : 'text',
			success : function(data) {
					 findInfoState.authPin = data; //Pin번호 전역 상태에 저장.
				
					$('#findPw_modal').html(
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
									<button type="button" onclick="verifyAuth('pw')"
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

			<button type="button" onclick="findPw_modal();"
				class="hover:text-green-600 transition-colors bg-transparent border-none p-0 cursor-pointer ">
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
			class="btn btn-success w-full">아이디 확인</button>
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
		<button type="button" onclick="getAuthPin_pw();"
			class="btn btn-success	 w-full">본인 인증 후 비밀번호 재설정</button>
	</div>
	<div class="modal-action">
		<form method="dialog">
			<button class="btn btn-ghost">닫기</button>
		</form>
	</div>
</div>
</dialog>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>