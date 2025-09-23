<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="게시글 작성" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<c:set var="pageTitle" value="글쓰기" />
<c:set var="selectedBoardId" value="${boardId != null ? boardId : 1}" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/toastUiEditorLib.jsp" %>

<section class="mt-10">
  <div class="container mx-auto max-w-2xl bg-base-100 p-8 rounded-2xl shadow-md">
    <form action="doWrite" method="post" onsubmit="return submitForm(this);">
      <input type="hidden" name="content" />
      <input type="hidden" name="thumbnail" id="thumbnail"/>

      <div class="form-control mb-6">
        <label class="label font-semibold">게시판 선택</label>
		<div class="flex space-x-4">
		  <c:forEach var="board" items="${boards}">
		    <c:if test="${req.getLoginedMember().authLevel == 0 || board.id != 1}">
		      <label class="label cursor-pointer">
		        <input type="radio" name="boardId" value="${board.getId() }"
		               class="radio radio-sm radio-success"
		               ${selectedBoardId == board.getId() ? 'checked' : ''}/>
		        <span class="ml-2">${board.name}</span>
		      </label>
		    </c:if>
		  </c:forEach>
		</div>
      </div>

      <div class="form-control mb-6">
        <label class="label font-semibold" for="title">제목</label>
        <input type="text" name="title" id="title" class="input input-bordered w-full" placeholder="제목을 입력하세요" required />
      </div>

      <div class="form-control mb-6">
        <label class="label font-semibold mb-2">내용</label>
        <div id="toast-ui-editor"></div>
      </div>

      <div class="flex justify-center items-center mt-8 relative">
        <button type="submit" class="btn btn-success btn-wide">저장</button>
        <button type="button" onclick="history.back();" class="btn btn-outline btn-sm absolute right-0">뒤로가기</button>
      </div>
    </form>
  </div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>