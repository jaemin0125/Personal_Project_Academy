<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="게시판 관리" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<script>
	function showBoardDetail(boardId) {
		if (boardId) {
			$("#modifyBoardContainer").removeClass("hidden");
			$("#boardId").val(boardId);
			$("#hiddenBoardId").val(boardId);
		}
		
		$.ajax({
			url : '/admin/board/doGetBoardName',
			type : 'GET',
			data : {
				boardId : boardId
			},
			success : function(data) {
				
				$("#boardName").val(data);
			
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		});

	}
	

	function confirmBoardDelete() {
		if (confirm("정보를 삭제하시겠습니까?")) {
			$("#doDeleteBoard").submit();
		}

	}

	
	function cancelMoidfy() {
		$("#modifyBoardContainer").addClass("hidden");
		$("#selectedBoard").val("게시판을 선택하세요");

	}
</script>



<section class="mt-10">
	<div
		class="container mx-auto max-w-3xl bg-base-100 p-6 rounded-2xl shadow-md">
		<h1 class="text-2xl font-bold mb-6 text-center">📂 게시판 관리</h1>

		<!-- 게시판 등록 -->
		<form action="doAddBoard" method="get"
			class="mb-10 border rounded-xl p-6">
			<h2 class="text-lg font-semibold mb-4">🆕 게시판 추가</h2>
			<div class="form-control mb-4 flex items-center">
				<label class="label font-semibold mr-2">게시판 이름</label> <input
					type="text" name="boardName" class="input input-bordered w-full"
					placeholder="예: 공지사항" required />
				<button type="submit" class="btn btn-sm btn-primary ml-6">게시판
					추가</button>
			</div>
		</form>

		<!-- 게시판 목록 + 수정/삭제 -->
		<%-- <div class="border rounded-xl p-6">
			<h2 class="text-lg font-semibold mb-4">📋 게시판 목록</h2>

			<table class="table w-full">
				<tbody>
					<c:forEach var="board" items="${boards}">
						<tr>
							<td>${board.id }</td>
							<td>
								<form action="doModifyBoard" method="get" class="flex items-center space-x-2">
									<input type="hidden" name="boardId" value="${board.id }" />
									<input type="text" name="boardName" class="input input-bordered input-sm w-40" value="${board.name }" required />
									<button type="submit" class="btn btn-sm ml-12 btn-success">수정</button>
								</form>
							</td>
							<td>
								<form action="doDeleteBoard" method="get"
									onsubmit="return confirm('정말 삭제하시겠습니까?');">
									<input type="hidden" name="boardId" value="${board.id }" />
									<button type="submit" class="btn btn-sm btn-error">삭제</button>
								</form>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div> --%>
		<div class="border rounded-2xl p-8 bg-base-100 shadow-sm">
			<h2 class="text-2xl font-bold mb-8 flex items-center gap-2">
				<span class="text-primary">📋</span> 게시판 목록 수정
			</h2>

			<div
				class="flex flex-wrap gap-6 mb-10 p-6 bg-base-200 rounded-2xl items-end">
				<div class="form-control w-fit">
					<label class="label"> <span class="label-text font-bold">1.
							게시판 선택</span>
					</label> <select id="selectedBoard" class="select select-bordered mt-2"
						onchange="showBoardDetail(this.value);" required>
						<option hidden selected>게시판을 선택하세요</option>
						<c:forEach var="board" items="${boards}">
							<option value="${board.id}">${board.name}</option>
						</c:forEach>
					</select>
				</div>

				<div class="text-sm text-gray-500 mb-3">* 항목을 선택하면 아래에 수정 양식이 나타납니다.</div>
			</div>

			<div id="modifyBoardContainer" class="hidden animate-fadeIn">
				<div class="divider text-gray-400 text-sm">EDIT BOARD SETTINGS</div>

				<div
					class="bg-white border-2 border-primary/10 rounded-3xl p-8 mt-6 shadow-lg">
					<form action="doModifyBoard" method="get" class="space-y-6">
						<input id="boardId" type="hidden" name="boardId" value="" />

						<div class="form-control w-full">
							<label class="label"> <span
								class="label-text font-semibold text-lg">게시판 이름</span>
							</label> 
							<input id="boardName" type="text" name="boardName" class="input input-bordered mt-2 w-full max-w-lg focus:input-primary" placeholder="수정할 게시판 이름을 입력하세요" value="" required />
						</div>

						<div class="flex justify-between items-center pt-8 border-t border-gray-100">
							<button type="button" onclick="confirmBoardDelete();" class="btn btn-error btn-outline gap-2">
							<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                       			<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    		</svg>
								게시판 삭제
							</button>

							<div class="flex gap-3">
								<button type="button" onclick="cancelMoidfy();"
									class="btn btn-ghost">취소</button>
								<button type="submit"
									class="btn btn-primary px-10 shadow-md shadow-primary/20">저장하기</button>
							</div>
						</div>
					</form>

					<form id="doDeleteBoard" action="doDeleteBoard" method="get"> <!-- 삭제 confirm 후 submit 되는 form -->
						<input id="hiddenBoardId" type="hidden" name="boardId" value="" />
					</form>
				</div>
			</div>

			<div class="text-right mt-6">
				<button onclick="history.back();" class="btn btn-outline btn-sm">←
					목록으로 돌아가기</button>
			</div>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>