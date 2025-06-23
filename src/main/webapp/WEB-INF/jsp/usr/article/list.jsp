<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="에코 커뮤니티" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<div class="container mx-auto mt-6 px-4 flex flex-col md:flex-row gap-4">
	<!-- ✅ 사이드바: 모바일에서는 숨김 -->
	<aside class="hidden md:block md:w-1/5 bg-green-100 p-4 rounded-xl h-fit">
		<h2 class="font-semibold text-lg pb-4">카테고리</h2>
		<ul class="space-y-2">
			<c:forEach var="boards" items="${boards }">
				<li>
					<a href="/usr/article/list?boardId=${boards.getId() }"
					   class="block hover:text-green-800">${boards.getName() }</a>
				</li>
			</c:forEach>
		</ul>
	</aside>

	<div class="w-full md:w-4/5">
		<div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-4 border-b border-gray-300 pb-2 text-gray-700 font-semibold text-lg gap-2">
			<div class="flex flex-wrap gap-4">
				<c:forEach var="boards" items="${boards }">
					<a href="/usr/article/list?boardId=${boards.getId() }"
					   class="pb-1 ${board.getId() == boards.getId() ? 'border-b-2 border-green-600' : ''}">
						${boards.getName()}
					</a>
				</c:forEach>
			</div>

			<form method="get"
				  class="flex flex-col sm:flex-row sm:items-center gap-2 bg-green-50 px-1.5 py-1.5 rounded-lg shadow-sm w-full sm:w-auto">
				<input type="hidden" name="boardId" value="${board.getId() }" />
				<select name="searchType"
						class="border border-green-400 text-sm px-2 py-1 rounded-md focus:outline-none focus:ring-2 focus:ring-green-300">
					<option value="title" <c:if test="${searchType == 'title'}">selected</c:if>>제목</option>
					<option value="content" <c:if test="${searchType == 'content'}">selected</c:if>>내용</option>
					<option value="title,content" <c:if test="${searchType == 'title,content'}">selected</c:if>>제목+내용</option>
				</select>
				<input type="search" name="searchKeyword" value="${searchKeyword}" placeholder="검색어 입력" maxlength="25"
					   class="border border-green-400 text-sm px-2 py-1 rounded-md focus:outline-none focus:ring-2 focus:ring-green-300 w-full sm:w-60" />
				<button type="submit"
						class="bg-green-500 text-white px-3 py-1 text-sm rounded-md hover:bg-green-600 transition">
					검색
				</button>
			</form>
		</div>

		<!-- 게시글 목록 -->
		<div class="space-y-4">
			<c:forEach var="article" items="${articles}">
				<div class="p-4 bg-white shadow rounded hover:bg-gray-100 transition">
					<h3 class="font-bold text-xl">
						<a href="/usr/article/detail?id=${article.getId() }">${article.title}</a>
					</h3>
					<p class="text-gray-600 line-clamp-2">${article.getContent() }</p>
					<div class="text-sm text-gray-500 mt-2">
						작성자: ${article.getWriterName()} | 작성일: ${article.getRegDate().substring(2,10)} |
						조회수: ${article.getViews()} | 좋아요: ${article.getLikePoint()}
					</div>
				</div>
			</c:forEach>
		</div>

		<!-- 글쓰기 버튼 -->
		<div class="text-right mt-4">
			<c:if test="${req.getLoginedMember().id != 0}">
				<c:choose>
					<c:when test="${req.getLoginedMember().authLevel == 0}">
						<a href="write?boardId=${board.getId() }"
						   class="px-4 py-2 bg-green-500 text-white text-sm rounded-xl hover:bg-green-600 transition">글쓰기</a>
					</c:when>
					<c:otherwise>
						<c:if test="${board.getId() != 1}">
							<a href="write?boardId=${board.getId() }"
							   class="px-4 py-2 bg-green-500 text-white text-sm rounded-xl hover:bg-green-600 transition">글쓰기</a>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:if>
		</div>

		<!-- 페이지네이션 -->
		<div class="flex justify-center mb-8 mt-4">
			<div class="flex items-center space-x-1 flex-wrap">
				<c:set var="queryString" value="?boardId=${board.getId()}&searchType=${searchType}&searchKeyword=${searchKeyword}" />

				<c:if test="${begin != 1}">
					<a class="btn btn-sm px-3 py-1 border rounded hover:bg-[#06874e] hover:text-white" href="${queryString}&cPage=1">
						<i class="fa-solid fa-angles-left"></i>
					</a>
					<a class="btn btn-sm px-3 py-1 border rounded hover:bg-[#06874e] hover:text-white" href="${queryString}&cPage=${begin - 1}">
						<i class="fa-solid fa-caret-left"></i>
					</a>
				</c:if>

				<c:forEach begin="${begin}" end="${end}" var="i">
					<a href="${queryString}&cPage=${i}"
					   class="px-3 py-1 border rounded ${cPage == i ? 'bg-[#06874e] text-white font-bold' : 'hover:bg-[#06874e] hover:text-white'}">${i}</a>
				</c:forEach>

				<c:if test="${end != totalPagesCnt}">
					<a class="btn btn-sm px-3 py-1 border rounded hover:bg-[#06874e] hover:text-white" href="${queryString}&cPage=${end + 1}">
						<i class="fa-solid fa-caret-right"></i>
					</a>
					<a class="btn btn-sm px-3 py-1 border rounded hover:bg-[#06874e] hover:text-white" href="${queryString}&cPage=${totalPagesCnt}">
						<i class="fa-solid fa-angles-right"></i>
					</a>
				</c:if>
			</div>
		</div>
	</div>
</div>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>