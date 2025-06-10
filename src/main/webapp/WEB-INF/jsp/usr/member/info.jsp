<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="마이페이지" />

<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>



<div class="container mx-auto max-w-2xl mt-10 p-6 bg-white rounded-2xl shadow-lg">
  <h2 class="text-2xl font-bold mb-6 border-b pb-2">🧑‍💻 회원 정보 수정</h2>

  <form action="/usr/member/doModify" method="post" onsubmit="return validateForm(this)" class="text-center">
    
    <div class="form-control mb-4">
      <label class="label font-semibold">이름</label>
      <input type="text" name="name" value="${loginedMember.getName() }" class="input input-bordered w-full" required />
    </div>

    <div class="form-control mb-4">
      <label class="label font-semibold">이메일</label>
      <input type="email" name="email" value="${loginedMember.getEmail() }" class="input input-bordered w-full" />
    </div>
    <div class="form-control mb-4">
      <label class="label font-semibold">주소</label>
      <input type="text" name="address" value="${loginedMember.getAddress() }" class="input input-bordered w-full" />
    </div>
	
    <div class="form-control mb-4">
      <label class="label font-semibold">새 비밀번호</label>
      <input type="password" name="loginPw" class="input input-bordered w-full" placeholder="변경하지 않으려면 비워두세요"/>
    </div>
    <div class="form-control mb-6">
      <label class="label font-semibold">새 비밀번호 확인</label>
      <input type="password" name="loginPwChk" class="input input-bordered w-full"/>
    </div>

    <div class="text-center">
      <button class="btn btn-primary px-10">저장</button>
    </div>
  </form>
</div>

<script>
  function validateForm(form) {
    if (form.loginPw.value !== form.loginPwChk.value) {
      alert('비밀번호가 일치하지 않습니다.');
      return false;
    }
    return true;
  }
</script>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>