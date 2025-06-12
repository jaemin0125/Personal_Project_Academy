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

</script>

<c:if test="${req.getLoginedMember().authLevel !=0 }">
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
							type="password" name="loginPw"
							class="input input-bordered w-full" placeholder="변경하지 않으려면 비워두세요" />
					</div>
				</div>

				<div class="form-control mb-6">
					<div class="flex items-center">
						<label class="w-38 font-semibold text-right pr-2">새 비밀번호
							확인</label> <input type="password" name="loginPwChk"
							class="input input-bordered w-full" />
					</div>
				</div>

				<div class="text-center">
					<button class="btn btn-primary px-10">저장</button>
				</div>
			</form>
		</div>
	</div>

</c:if>

<c:if test="${req.getLoginedMember().authLevel == 0}">
	<section class="mt-10 container mx-auto max-w-4xl p-6">
		<h1 class="text-3xl font-bold text-center mb-10">🛠️ 관리자 전용 페이지</h1>

		<div class="grid grid-cols-1 md:grid-cols-2 gap-6">

			<!-- 분리배출 정보 관리 -->
			<div class="card bg-base-100 shadow-xl">
				<div class="card-body items-center text-center">
					<h2 class="card-title">♻️ 분리배출 정보 관리</h2>
					<p class="text-sm text-gray-500">AI 분류 라벨에 따른 분리수거 가이드를 관리합니다.</p>
					<div class="card-actions mt-4">
						<a href="/usr/wasteGuide/list" class="btn btn-primary">이동하기</a>
					</div>
				</div>
			</div>

			<!-- 게시판 정보 관리 -->
			<div class="card bg-base-100 shadow-xl">
				<div class="card-body items-center text-center">
					<h2 class="card-title">📋 게시판 정보 관리</h2>
					<p class="text-sm text-gray-500">공지사항, 질문 등 게시판 구조를 수정합니다.</p>
					<div class="card-actions mt-4">
						<a href="/usr/board/list" class="btn btn-primary">이동하기</a>
					</div>
				</div>
			</div>

		</div>
	</section>
</c:if>


<script>
  function validateForm(form) {
    if (form.loginPw.value !== form.loginPwChk.value) {
      alert('비밀번호가 일치하지 않습니다.');
      return false;
    }
    return true;
  }
</script>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>