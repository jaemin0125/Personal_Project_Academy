<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="관리자 페이지" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<section class="mt-10 mb-10">
    <div class="container mx-auto max-w-6xl bg-base-100 p-6 rounded-2xl shadow-md">
        <h1 class="text-2xl font-bold mb-6 text-center text-primary">👤 회원 정보 관리</h1>

        <div class="border rounded-2xl p-8 bg-base-100 shadow-sm">
            <div class="flex justify-between items-end mb-6">
                <div>
                    <h2 class="text-xl font-bold flex items-center gap-2">
                        <span class="text-secondary">📋</span> 회원 목록
                    </h2>
                    <p class="text-xs opacity-60 mt-1">전체 회원을 조회하고 정보를 수정할 수 있습니다.</p>
                </div>

                <div class="flex gap-2">
                    <select class="select select-bordered select-sm">
                        <option disabled selected>권한 필터</option>
                        <option>전체</option>
                        <option>관리자</option>
                        <option>일반회원</option>
                    </select>
                </div>
            </div>

            <div class="overflow-x-auto min-h-[400px]">
                <table class="table table-zebra w-full">
                    <thead>
                        <tr>
                            <th class="bg-base-200 text-center w-16">번호</th>
                            <th class="bg-base-200">아이디</th>
                            <th class="bg-base-200">이름</th>
                            <th class="bg-base-200">이메일</th>
                            <th class="bg-base-200 text-center">권한</th>
                            <th class="bg-base-200 text-center">가입일</th>
                            <th class="bg-base-200 text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="member" items="${members}">
                            <tr class="hover">
                                <td class="text-center opacity-70">${member.id}</td>
                                <td class="font-bold">${member.loginId}</td>
                                <td>${member.name}</td>
                                <td class="text-sm">${member.email}</td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${member.authLevel == 0}">
                                            <div class="badge badge-primary badge-outline gap-1">👑 관리자</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="badge badge-ghost gap-1">👤 일반</div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center text-xs opacity-60">${member.regDate}</td>
                                <td class="text-center">
                                    <a href="/admin/member/modify?id=${member.id}"
                                       class="btn btn-sm btn-ghost text-info hover:bg-info/10"> 📝 수정 </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="relative flex justify-center items-center mt-6 pt-6 border-t">
                
                <div class="join shadow-sm border">
                    <c:if test="${begin > 1}">
                        <a href="?cPage=${begin - 1}" class="join-item btn btn-sm">
                            <i class="fa-solid fa-angles-left"></i>
                        </a>
                    </c:if>
                    
                    <c:if test="${cPage > 1}">
                        <a href="?cPage=1" class="join-item btn btn-sm">
                            <i class="fa-solid fa-angle-left"></i>
                        </a>
                    </c:if>
                    
                    <c:forEach var="i" begin="${begin}" end="${end}">
                        <a href="?cPage=${i}"
                           class="join-item btn btn-sm ${cPage == i ? 'btn-active btn-primary' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${end < totalPagesCnt}">
                        <a href="?cPage=${end + 1}" class="join-item btn btn-sm">
                            <i class="fa-solid fa-angle-right"></i>
                        </a>
                    </c:if>

                    <c:if test="${cPage < totalPagesCnt}">
                        <a href="?cPage=${totalPagesCnt}" class="join-item btn btn-sm">
                            <i class="fa-solid fa-angles-right"></i>
                        </a>
                    </c:if>
                </div>

                <div class="absolute right-0 flex flex-col items-end gap-2">
                    <button onclick="history.back();" class="btn btn-outline btn-sm gap-2">
                        <span class="text-xs">←</span> 목록으로 돌아가기
                    </button>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>