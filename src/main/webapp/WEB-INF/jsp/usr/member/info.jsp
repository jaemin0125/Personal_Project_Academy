<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="마이페이지" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>

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

function validateForm(form) {
    if (form.loginPw.value !== form.loginPwChk.value) {
      alert('비밀번호가 일치하지 않습니다.');
      return false;
    }
    return true;
  }

</script>

<div class="flex justify-center mt-10">
	<div class="w-full max-w-xl bg-white rounded-2xl shadow-lg p-8">
		<h2 class="text-2xl font-bold mb-6 border-b pb-2 text-center">🧑‍💻
			회원 정보 수정</h2>

		<form action="/usr/member/doModify" method="post"
			onsubmit="return validateForm(this)">

			<div class="form-control mb-4">
				<div class="flex items-center">
					<label class="w-38 font-semibold text-right pr-2">이름</label> <input
						type="text" name="name" value="${loginedMember.getName() }"
						class="input input-bordered w-full" required />
				</div>
			</div>

			<div class="form-control mb-4">
				<div class="flex items-center">
					<label class="w-38 font-semibold text-right pr-2">이메일</label> <input
						type="email" name="email" value="${loginedMember.getEmail() }"
						class="input input-bordered w-full" />
				</div>
			</div>

			<div class="form-control mb-4">
				<div class="flex items-center">
					<label class="w-38 font-semibold text-right pr-2">주소</label>
					<div class="flex items-center grow gap-2">
						<input type="text" id="address" name="address" readonly
							class="input input-bordered w-full"
							value="${loginedMember.getAddress() }" />
						<button type="button" onclick="postCode()"
							class="btn btn-outline btn-sm">검색</button>
					</div>
				</div>
			</div>

			<div class="form-control mb-4">
				<div class="flex items-center">
					<label class="w-38 font-semibold text-right pr-2">새 비밀번호</label> <input
						type="password" name="loginPw" class="input input-bordered w-full"
						placeholder="변경하지 않으려면 비워두세요" />
				</div>
			</div>

			<div class="form-control mb-6">
				<div class="flex items-center">
					<label class="w-38 font-semibold text-right pr-2">새 비밀번호 확인</label>
					<input type="password" name="loginPwChk"
						class="input input-bordered w-full" />
				</div>
			</div>

			<div class="text-center">
				<button class="btn btn-primary w-40 px-10">저장</button>
			</div>
			<div>
				<button type="button" onclick="location.href='/'" class="btn btn-outline btn-success btn-sm">← 뒤로가기</button>
			</div>
		</form>
	</div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>