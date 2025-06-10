<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<div class="container mx-auto max-w-md mt-24 p-8 bg-white rounded-xl shadow-md text-center">
  <h2 class="text-xl font-bold mb-6">🔒 본인 확인</h2>
  
  <form action="/usr/member/info" method="post">
    <div class="form-control mb-4">
      <label class="label">현재 비밀번호</label>
      <input type="password" name="loginPw" class="input input-bordered w-full" required />
    </div>
    <button class="btn btn-primary w-full">확인</button>
  </form>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>