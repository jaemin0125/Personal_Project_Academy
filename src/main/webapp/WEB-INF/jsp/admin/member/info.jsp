<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="관리자 페이지" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<section class="mt-10 container mx-auto max-w-4xl p-6">
	<h1 class="text-3xl font-bold text-center mb-10">🛠️ 관리자 전용 페이지</h1>

	<div class="grid grid-cols-1 md:grid-cols-2 gap-6">

		<!-- 분리배출 정보 관리 -->
		<div class="card bg-base-100 shadow-xl">
			<div class="card-body items-center text-center">
				<h2 class="card-title">♻️ 분리배출 정보 관리</h2>
				<p class="text-sm text-gray-500">AI 분류 라벨에 따른 분리수거 가이드를 관리합니다.</p>
				<div class="card-actions mt-4">
					<a href="/admin/wasteGuide/list" class="btn btn-primary">이동하기</a>
				</div>
			</div>
		</div>

		<!-- 게시판 정보 관리 -->
		<div class="card bg-base-100 shadow-xl">
			<div class="card-body items-center text-center">
				<h2 class="card-title">📋 게시판 정보 관리</h2>
				<p class="text-sm text-gray-500">공지사항, 질문 등 게시판 구조를 수정합니다.</p>
				<div class="card-actions mt-4">
					<a href="/admin/board/list" class="btn btn-primary">이동하기</a>
				</div>
			</div>
		</div>
		<div class="card bg-base-100 shadow-xl">
			<div class="card-body items-center text-center">
				<h2 class="card-title">🧑‍ 관리자 정보 수정</h2>
				<p class="text-sm text-gray-500">개인정보를 수정합니다</p>
				<div class="card-actions mt-4">
					<a href="/usr/member/checkPw" class="btn btn-primary">이동하기</a>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>