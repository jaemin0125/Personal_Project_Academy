<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="게시글 작성" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<c:set var="pageTitle" value="글쓰기" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/toastUiEditorLib.jsp" %>

<section class="mt-10">
  <div class="container mx-auto max-w-2xl bg-base-100 p-8 rounded-2xl shadow-md">
    <form action="doWrite" method="post" onsubmit="return submitForm(this);">
      <input type="hidden" name="content" />

      <div class="form-control mb-6">
        <label class="label font-semibold">게시판 선택</label>
        <div class="flex space-x-4">
          <c:if test="${req.getLoginedMember().getAuthLevel() == 0 }">
            <label class="label cursor-pointer">
              <input type="radio" name="boardId" value="1" class="radio radio-sm radio-success" />
              <span class="ml-2">공지사항</span>
            </label>
          </c:if>
          <label class="label cursor-pointer">
            <input type="radio" name="boardId" value="2" class="radio radio-sm radio-success" checked />
            <span class="ml-2">팁/정보</span>
          </label>
          <label class="label cursor-pointer">
            <input type="radio" name="boardId" value="3" class="radio radio-sm radio-success" />
            <span class="ml-2">질의응답</span>
          </label>
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

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>