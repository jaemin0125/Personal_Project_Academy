<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<div class="container mx-auto max-w-md mt-24 pr-4 pt-4 pl-4 pb-2 bg-white rounded-xl shadow-md text-center">
  <h2 class="text-xl font-bold mb-4">🔒 본인 확인</h2>
  
  <form action="/usr/member/info" method="post">
    <div class="form-control mb-4">
      <label class="label mb-2">현재 비밀번호</label>
      <input type="password" name="loginPw" class="input input-bordered w-full" required />
      <div class="mt-2 text-red-400">${msg }</div>
    </div>
    <button class="btn btn-primary w-40">확인</button>
    <div class="mt-2 mb-2 text-center">
   		<button type="button" onclick="history.back();" class="btn btn-outline btn-sm">← 뒤로가기</button>
    </div>
  </form>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>