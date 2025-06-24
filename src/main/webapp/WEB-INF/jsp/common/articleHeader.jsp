<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  <!-- 필수 스크립트 & 스타일 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
  <link rel="stylesheet" href="/resource/common.css" />
  <meta charset="UTF-8">
  <title>${pageTitle}</title>
  <link rel="shortcut icon" href="/resource/imgs/favicon.ico" />
</head>
<body class="bg-gray-50 min-h-screen">

  <div class="bg-[#06874e] text-white">
    <div class="container mx-auto flex justify-between items-center h-24">
      <!-- 로고 -->
      <a href="/"><img src="/resource/logo.png" class="h-18" /></a>
      <!-- 메뉴 -->
      <ul class="flex space-x-10 text-xl font-medium">
        <li><a href="/usr/article/list" class="hover:text-green-200 font-semibold">커뮤니티</a></li>
        <c:if test="${req.getLoginedMember().getId() == 0 }">
	        <li><a href="/usr/member/join" class="hover:text-green-200 font-semibold">회원가입</a></li>
	        <li><a href="/usr/member/login" class="hover:text-green-200 font-semibold">로그인</a></li>
        </c:if>
        <c:if test="${req.getLoginedMember().getId() != 0 && req.getLoginedMember().authLevel != 0 }">
	        <li><a href="/usr/member/checkPw" class="hover:text-green-200 font-semibold">마이페이지</a></li>
	        <li><a href="/usr/member/logout" class="hover:text-green-200 font-semibold">로그아웃</a></li>
        </c:if>
        <c:if test="${req.getLoginedMember().getId() != 0 && req.getLoginedMember().authLevel == 0 }">
	        <li><a href="/admin/member/info" class="hover:text-green-200 font-semibold">관리자페이지</a></li>
	        <li><a href="/usr/member/logout" class="hover:text-green-200 font-semibold">로그아웃</a></li>
        </c:if>
      </ul>
    </div>
  </div>