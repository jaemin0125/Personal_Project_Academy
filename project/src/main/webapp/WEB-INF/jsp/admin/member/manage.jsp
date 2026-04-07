<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="관리자 페이지" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<script>
	function goInfo(){
		location.href = "/admin/member/info";	
	}
	
	function openModifyModal(id){
		$.ajax({
			url : '/admin/member/getMemberById',
			type : 'GET',
			data : {
				id : id
			},
			success : function(data) {
				document.getElementById('modify_modal').showModal();
				$("#m-regDate").val(data.regDate);
				$("#m-loginId").val(data.loginId);
				$("#m-name").val(data.name);
				$("#m-email").val(data.email);
				$("#m-address").val(data.address);
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		});
	}
</script>

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
                	<form id="filterForm" method="get">
	                    <select name="authLevel" onchange="this.form.submit();" class="select select-bordered select-sm">
		                        <option value="-1" <c:if test="${authLevel == -1 }"> selected </c:if>>전체 보기</option>
		                        <option value="0"  <c:if test="${authLevel == 0 }"> selected </c:if>>관리자</option> 
		                        <option value="1"  <c:if test="${authLevel == 1 }"> selected </c:if>>일반회원</option>
	                    </select>
                    </form>
                </div>
            </div>

            <div class="overflow-x-auto min-h-[400px]">
                <table class="table table-zebra w-full">
                    <thead>
                        <tr>
                            <th class="bg-base-200 text-center w-16">번호</th>
                            <th class="bg-base-200">아이디</th>
                            <th class="bg-base-200">이름</th>
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
                                    <button
                                       class="btn btn-sm btn-ghost text-info hover:bg-info/10" onclick="openModifyModal(${member.id});"> 📝 수정 </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

			<dialog id="modify_modal" class="modal">
			<div class="modal-box w-11/22 max-w-2xl">
				<h3 class="font-bold text-lg mb-4">회원 상세 정보 및 수정</h3>

				<form action="/admin/member/doModify" method="POST">
					<input type="hidden" name="id" id="m-id">

					<div class="grid grid-cols-2 gap-4">
						<div class="form-control">
							<label class="label">가입일</label> <input type="text"
								id="m-regDate" class="input input-bordered bg-gray-100" readonly>
						</div>
						<div class="form-control">
							<label class="label">아이디</label> <input type="text"
								id="m-loginId" class="input input-bordered bg-gray-100" readonly>
						</div>
						<div class="form-control col-span-2">
							<label class="label">이름</label> <input type="text" name="name"
								id="m-name" class="input input-bordered">
						</div>
						<div class="form-control col-span-2">
							<label class="label">이메일</label> <input type="email" name="email"
								id="m-email" class="input input-bordered">
						</div>
						<div class="form-control col-span-2">
							<label class="label">주소</label> <input type="text" name="address"
								id="m-address" class="input input-bordered">
						</div>
						<div class="form-control">
							<label class="label">권한</label> <select name="authLevel"
								id="m-authLevel" class="select select-bordered">
								<option value="1">일반사용자</option>
								<option value="0">관리자</option>
							</select>
						</div>
					</div>

					<div class="modal-action">
						<button type="submit" class="btn btn-primary">수정 저장</button>
						<button type="button" class="btn" onclick="modify_modal.close()">취소</button>
					</div>
				</form>
			</div>
			</dialog>

			<div class="relative flex justify-center items-center mt-6 pt-6 border-t">
                
                <div class="join shadow-sm border">
                    <c:set var="queryString" value="?authLevel=${authLevel }"/>
                    <c:if test="${begin > 1}">
                        <a href="${queryString }&cPage=${begin - 1}" class="join-item btn btn-sm">
                            <i class="fa-solid fa-angles-left"></i>
                        </a>
                        <a href="${queryString }&cPage=1" class="join-item btn btn-sm">
                            <i class="fa-solid fa-angle-left"></i>
                        </a>
                    </c:if>
                    
                    <c:forEach var="i" begin="${begin}" end="${end}">
                        <a href="${queryString }&cPage=${i}"
                           class="join-item btn btn-sm ${cPage == i ? 'btn-active btn-primary' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${end < totalPagesCnt}">
                        <a href="${queryString }&cPage=${end + 1}" class="join-item btn btn-sm">
                            <i class="fa-solid fa-angle-right"></i>
                        </a>
                    </c:if>

                    <c:if test="${cPage < totalPagesCnt}">
                        <a href="${queryString }&cPage=${totalPagesCnt}" class="join-item btn btn-sm">
                            <i class="fa-solid fa-angles-right"></i>
                        </a>
                    </c:if>
                </div>

                <div class="absolute right-0 flex flex-col items-end gap-2">
                    <button onclick="goInfo();" class="btn btn-outline btn-sm gap-2">
                        <span class="text-xs">←</span> 목록으로 돌아가기
                    </button>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>