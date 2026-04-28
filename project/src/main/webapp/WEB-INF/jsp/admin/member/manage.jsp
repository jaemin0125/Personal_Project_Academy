<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="관리자 페이지" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<script>
	function goInfo(){
		location.href = "/admin/member/info";	
	}
	
	function openModifyModal(id){
		
		const loginedId = "${req.loginedMember.id}";
				
		$.ajax({
			url : '/admin/member/getMemberById',
			type : 'GET',
			data : {
				id : id
			},
			success : function(data) {
				document.getElementById('modify_modal').showModal();
				$("#m-id").val(id)
				$("#m-authLevel").val(data.authLevel);
				$("#m-status").val(data.status);
				
				$("#m-regDate").text(data.regDate);
				$("#m-loginId").text(data.loginId);
				$("#m-name").text(data.name);
				$("#m-email").text(data.email);
				$("#m-address").text(data.address);
				
				if(loginedId == id){
					$('#m-status').prop("disabled", true);
				} else {
					$('#m-status').prop("disabled", false);
				}
				
				if(data.updateDate){
					$("#m-updateDate").text(data.updateDate);
				}
				
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

			<dialog id="modify_modal" class="modal modal-bottom sm:modal-middle">
			<div
				class="modal-box w-11/12 max-w-2xl border border-base-300 shadow-2xl p-0 overflow-hidden">
				<div
					class="bg-slate-50 px-6 py-4 border-b flex items-center justify-between">
					<div>
						<h3 class="font-bold text-xl text-slate-800">회원 관리 및 권한 설정</h3>
						<p class="text-xs text-slate-500 mt-1">회원의 개인정보를 확인하고 관리 권한을
							조정합니다.</p>
					</div>
					<button type="button" class="btn btn-sm btn-circle btn-ghost"
						onclick="modify_modal.close()">✕</button>
				</div>

				<form action="/admin/member/doModify" method="POST"
					class="p-6 space-y-6">
					<input type="hidden" name="id" id="m-id">

					<section>
						<div class="flex items-center gap-2 mb-3">
							<span
								class="badge badge-sm badge-outline badge-primary font-bold px-3 py-2">회원
								정보</span>
						</div>
						<div
							class="grid grid-cols-1 md:grid-cols-2 gap-4 bg-base-100 border rounded-xl p-4 shadow-sm">
							<div class="form-control">
								<label class="label"><span
									class="label-text font-medium text-slate-500">아이디</span></label>
								<div id="m-loginId"
									class="px-1 font-bold text-slate-700 uppercase tracking-tight">
									-</div>
							</div>
							<div class="form-control">
								<label class="label"><span
									class="label-text font-medium text-slate-500">이름</span></label>
								<div id="m-name" class="px-1 text-slate-700 font-semibold">
									-</div>
							</div>
							<div class="form-control">
								<label class="label"><span
									class="label-text font-medium text-slate-500">이메일</span></label>
								<div id="m-email" class="px-1 text-slate-700">-</div>
							</div>
							<div class="form-control">
								<label class="label"><span
									class="label-text font-medium text-slate-500">주소</span></label>
								<div id="m-address" class="px-1 text-slate-700 truncate"
									title="상세 주소">-</div>
							</div>
						</div>
					</section>

					<section
						class="bg-primary/5 rounded-2xl p-5 border border-primary/10">
						<div class="flex items-center gap-2 mb-4">
							<span
								class="badge badge-sm badge-primary font-bold px-3 py-2 text-white">관리
								설정</span>
						</div>

						<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
							<div class="form-control">
								<label class="label"> <span
									class="label-text font-bold text-slate-700">접근 권한 등급</span>
								</label> <select name="authLevel" id="m-authLevel"
									class="select select-bordered select-primary w-full bg-white font-semibold">
									<option value="1">일반사용자 (Level 1)</option>
									<option value="0">관리자 (Level 0)</option>
								</select>
							</div>

							<div class="form-control">
								<label class="label"> <span
									class="label-text font-bold text-slate-700">계정 상태</span>
								</label> 
								<select name="status" id="m-status"
									class="select select-bordered w-full bg-white">
									<option value="0">정상 (Active)</option>
									<option value="1">차단 (Banned)</option>
									<option value="2" disabled>휴면 (Dormant) - 시스템 전용</option>
								</select>
							</div>
						</div>
					</section>

					<div
						class="flex justify-between items-center px-2 py-1 text-[11px] text-slate-400 border-t pt-4">
						<div class="flex gap-4">
							<span>가입일: <b id="m-regDate"
								class="font-normal text-slate-500">-</b></span> <span>최종 수정: <b
								id="m-updateDate" class="font-normal text-slate-500">-</b></span>
						</div>
						<div class="italic text-primary/60 font-medium">Administrator
							Access Only</div>
					</div>

					<div class="flex justify-end gap-3 pt-2">
						<button type="button" class="btn btn-ghost btn-sm h-10 px-6"
							onclick="modify_modal.close()">취소</button>
						<button type="submit"
							class="btn btn-primary btn-sm h-10 px-8 shadow-md">권한 설정
							저장</button>
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