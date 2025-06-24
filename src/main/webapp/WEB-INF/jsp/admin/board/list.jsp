<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="게시판 관리" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<section class="mt-10">
	<div class="container mx-auto max-w-3xl bg-base-100 p-6 rounded-2xl shadow-md">
		<h1 class="text-2xl font-bold mb-6 text-center">📂 게시판 관리</h1>

		<!-- 게시판 등록 -->
		<form action="doAddBoard" method="get"
			class="mb-10 border rounded-xl p-6">
			<h2 class="text-lg font-semibold mb-4">🆕 게시판 추가</h2>
			<div class="form-control mb-4 flex items-center">
				<label class="label font-semibold mr-2">게시판 이름</label> 
				<input type="text" name="boardName" class="input input-bordered w-full" placeholder="예: 공지사항" required />
				<button type="submit" class="btn btn-sm btn-primary ml-6">게시판 추가</button>
			</div>
		</form>

		<!-- 게시판 목록 + 수정/삭제 -->
		<div class="border rounded-xl p-6">
			<h2 class="text-lg font-semibold mb-4">📋 게시판 목록</h2>

			<table class="table w-full">
				<tbody>
					<c:forEach var="board" items="${boards}">
						<tr>
							<td>${board.getId() }</td>
							<td>
								<form action="doModifyBoard" method="get" class="flex items-center space-x-2">
									<input type="hidden" name="boardId" value="${board.getId() }" />
									<input type="text" name="boardName" class="input input-bordered input-sm w-40" value="${board.getName() }" required />
									<button type="submit" class="btn btn-sm ml-12 btn-success">수정</button>
								</form>
							</td>
							<td>
								<form action="doDeleteBoard" method="get"
									onsubmit="return confirm('정말 삭제하시겠습니까?');">
									<input type="hidden" name="boardId" value="${board.getId() }" />
									<button type="submit" class="btn btn-sm btn-error">삭제</button>
								</form>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<div class="text-right">
			<button onclick="history.back();" class="btn btn-outline btn-sm mt-6">← 뒤로가기</button>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>