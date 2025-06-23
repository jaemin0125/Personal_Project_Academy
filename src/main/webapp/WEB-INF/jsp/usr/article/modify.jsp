<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="게시글 수정" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/common/toastUiEditorLib.jsp"%>

<section class="mt-10">
	<div
		class="container mx-auto max-w-2xl bg-base-100 p-8 rounded-2xl shadow-md">
		<form action="doModify" method="post"
			onsubmit="return submitForm(this);">
			<input type="hidden" name="id" value="${article.getId()}" /> 
			<input type="hidden" name="content" />
			<input type="hidden" name="thumbnail" id="thumbnail" />

			<!-- 게시글 메타 정보 -->
			<div class="flex justify-between text-sm mb-6">
				<div>
					<span class="font-semibold">번호:</span> ${article.getId()}
				</div>
				<div>
					<span class="font-semibold">작성일:</span>
					${article.getRegDate().substring(2, 16)}
				</div>
				<div>
					<span class="font-semibold">수정일:</span>
					${article.getUpdateDate().substring(2, 16)}
				</div>
			</div>

			<!-- 제목 입력 -->
			<div class="form-control mb-6">
				<label class="label font-semibold" for="title">제목</label> <input
					type="text" name="title" id="title"
					class="input input-bordered w-full" value="${article.getTitle()}"
					required />
			</div>

			<!-- 내용 입력 -->
			<div class="form-control mb-6">
				<label class="label font-semibold mb-2">내용</label>
				<div id="toast-ui-editor"
					class="w-full min-w-0 overflow-hidden border rounded-md">
					<div>${article.getContent() }</div>
				</div>
			</div>

			<!-- 버튼 -->
			<div class="flex justify-center items-center pl-8 mt-8 relative">
				<button type="submit" class="btn btn-success btn-wide">수정</button>
				<button type="button" onclick="history.back();"
					class="btn btn-outline btn-sm absolute right-0">뒤로가기</button>
			</div>
		</form>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>