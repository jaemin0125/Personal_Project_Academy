<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="에코 커뮤니티" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<div class="container mx-auto flex mt-6 px-4">
	<aside class="w-1/5 bg-green-100 p-4 rounded-xl h-fit">
		<h2 class="font-semibold text-lg mb-4">카테고리</h2>
		<ul class="space-y-2">
			<li><a href="/usr/article/list?boardId=1"
				class="block hover:text-green-800">공지사항</a></li>
			<li><a href="/usr/article/list?boardId=2"
				class="block hover:text-green-800">팁/정보</a></li>
			<li><a href="/usr/article/list?boardId=3"
				class="block hover:text-green-800">질의응답</a></li>
		</ul>
	</aside>

	<div class="w-4/5 ml-6 ">
		<div
			class="flex justify-between items-center border-b border-gray-300 mb-4 text-gray-700 font-semibold text-lg">

			<div class="flex space-x-6">
				<a href="/usr/article/list?boardId=1"
					class="pb-2 ${board.getId() == 1 ? 'border-b-2 border-green-600' : ''}">공지사항</a>
				<a href="/usr/article/list?boardId=2"
					class="pb-2 ${board.getId() == 2 ? 'border-b-2 border-green-600' : ''}">팁/정보</a>
				<a href="/usr/article/list?boardId=3"
					class="pb-2 ${board.getId() == 3 ? 'border-b-2 border-green-600' : ''}">질의응답</a>
			</div>

			<form method="get"
				class="flex items-center space-x-2 bg-green-50 px-3 py-2 mb-4 rounded-lg shadow-sm">
				<input type="hidden" name="boardId" value="${board.getId() }" /> <select
					name="searchType"
					class="border border-green-400 text-sm px-2 py-1 rounded-md focus:outline-none focus:ring-2 focus:ring-green-300">
					<option value="title"
						<c:if test="${searchType == 'title'}">selected</c:if>>제목</option>
					<option value="content"
						<c:if test="${searchType == 'content'}">selected</c:if>>내용</option>
					<option value="title,content"
						<c:if test="${searchType == 'title,content'}">selected</c:if>>제목+내용</option>
				</select> <input type="search" name="searchKeyword" value="${searchKeyword}"
					placeholder="검색어 입력" maxlength="25"
					class="border border-green-400 text-sm px-3 py-1 rounded-md focus:outline-none focus:ring-2 focus:ring-green-300" />
				<button type="submit"
					class="bg-green-500 text-white px-3 py-1 text-sm rounded-md hover:bg-green-600 transition">검색</button>
			</form>
		</div>
		<div class="space-y-4">
			<c:forEach var="article" items="${articles}">
				<div class="p-4 bg-white shadow rounded hover:bg-gray-100 transition">
					<h3 class="font-bold text-xl">
						<a href="/usr/article/detail?id=${article.getId() }">
							${article.title} </a>
					</h3>
					<p class="text-gray-600 line-clamp-2">${article.getContent() }</p>
					<div class="text-sm text-gray-500 mt-2">작성자:
						${article.getWriterName() } | 작성일 : ${article.getRegDate().substring(2,10) } | 조회수: ${article.getViews() } | 좋아요:
						${article.getLikePoint() }</div>
				</div>
			</c:forEach>
		</div>
		<div class="text-right mt-4">
			<c:if test="${req.getLoginedMember().id != 0}">
				<c:choose>
					<c:when test="${req.getLoginedMember().authLevel == 0}">
						<a href="write"
							class="px-4 py-2 bg-green-500 text-white text-sm rounded-xl hover:bg-green-600 transition">글쓰기</a>
					</c:when>
					<c:otherwise>
						<c:if test="${board.getId() != 1}">
							<a href="write"
								class="px-4 py-2 bg-green-500 text-white text-sm rounded-xl hover:bg-green-600 transition">글쓰기</a>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:if>
		</div>
		<div class="flex justify-center mb-8 mt-4">
			<div class="flex items-center space-x-1">
				<c:set var="queryString"
					value="?boardId=${board.getId() }&searchType=${searchType }&searchKeyword=${searchKeyword }" />

				<c:if test="${begin != 1}">
					<a class="btn btn-sm px-3 py-1 border rounded hover:bg-[#06874e] hover:text-white" href="${queryString }&cPage=1"><i class="fa-solid fa-angles-left"></i></a>
					<a class="btn btn-sm px-3 py-1 border rounded hover:bg-[#06874e] hover:text-white" href="${queryString }&cPage=${begin - 1 }"><i class="fa-solid fa-caret-left"></i></a>
				</c:if>

				<c:forEach begin="${begin }" end="${end }" var="i">
					<a href="${queryString }&cPage=${i }" class="px-3 py-1 border rounded ${cPage == i ? 'bg-[#06874e] text-white font-bold' : 'hover:bg-[#06874e] hover:text-white'}">${i} </a>
				</c:forEach>

				<c:if test="${end != totalPagesCnt }">
					<a class="btn btn-sm px-3 py-1 border rounded hover:bg-[#06874e] hover:text-white" href="${queryString }&cPage=${end + 1 }"><i class="fa-solid fa-caret-right"></i></a>
					<a class="btn btn-sm px-3 py-1 border rounded hover:bg-[#06874e] hover:text-white" href="${queryString }&cPage=${totalPagesCnt }"> <i class="fa-solid fa-angles-right"></i></a>
				</c:if>
			</div>
		</div>
	</div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>