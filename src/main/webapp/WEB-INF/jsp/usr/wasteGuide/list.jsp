<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="분리배출 정보 관리" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

<section class="mt-10 flex">
	<div
		class="container mx-auto max-w-8xl bg-base-100 p-8 rounded-2xl shadow-md">
		<h1 class="text-3xl font-bold mb-6 text-center">♻️ 분리배출 정보 관리</h1>

		<div class="bg-base-100 border rounded-xl p-8 mb-10">
			<h2
				class="text-xl font-semibold mb-6 flex justify-center items-center gap-2">
				<span class="text-blue-600 text-lg">🆕</span> 쓰레기 정보 추가
			</h2>

			<!-- 가운데 정렬 -->
			<div class="flex justify-center">
				<form action="doAddWaste" method="get"
					class="w-full max-w-2xl space-y-4">

					<!-- YOLO 라벨 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold">YOLO 라벨
							(영문)</label> <input type="text" name="label"
							class="input input-bordered col-span-9" placeholder="예: papercup"
							required />
					</div>

					<!-- 한글 명칭 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold">한글 명칭</label> <input
							type="text" name="ko_label"
							class="input input-bordered col-span-9" placeholder="예: 종이컵"
							required />
					</div>

					<!-- 카테고리 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label
							class="col-span-3 text-right font-semibold whitespace-nowrap">카테고리
							(영문) </label> <input type="text" name="category"
							class="input input-bordered col-span-9" placeholder="예: paper"
							required />
					</div>

					<!-- 가이드 -->
					<div class="grid grid-cols-12 items-start gap-2 flex items-center">
						<label class="col-span-3 text-right font-semibold mt-10">분리배출
							가이드</label>
						<textarea name="guide" rows="4"
							class="textarea textarea-bordered col-span-9"
							placeholder="예: 내용물을 비우고 압착한 후 배출하세요." required></textarea>
					</div>
					<div class="grid grid-cols-12 items-center gap-2">
			            <label class="col-span-3 text-right font-semibold whitespace-nowrap">썸네일 이미지</label>
			            <div class="col-span-9">
			              <input type="file" id="uploadFileInput" class="file-input file-input-bordered w-full" accept="image/*" />
			              <button type="button" onclick="uploadImage()" class="btn btn-sm btn-outline">📤 이미지 업로드</button>
			              <img id="thumbnailPreview" src="" class="mt-4 w-40 h-auto hidden border rounded" />
			              <input type="hidden" name="thumbnail" id="thumbnailInput" required />
			            </div>
			          </div>

					<!-- 버튼 -->
					<div class="flex justify-center pt-4">
						<button type="submit" class="btn btn-primary w-40">정보 추가</button>
					</div>
				</form>
			</div>
		</div>



		<!-- 게시판 목록 + 수정/삭제 -->
		<div class="border rounded-xl p-6">
			<h2 class="text-lg font-semibold mb-4">📋 등록된 쓰레기 목록</h2>

			<table class="table w-full">
				<tbody>
					<c:forEach var="wasteGuide" items="${wasteGuides}">
						<tr>
							<td class="align-top">${wasteGuide.getId()}</td>
							<td class="w-full">
								<form action="doModifyWaste" method="get"
									class="flex items-center gap-2 w-full">
									<input type="hidden" name="wasteId"value="${wasteGuide.getId()}" /> 
									<input type="text" name="label" class="input input-bordered input-sm !w-24 shrink-0" value="${wasteGuide.getLabel()}" required /> 
									<input type="text" name="ko_label" class="input input-bordered input-sm !w-30 shrink-0" value="${wasteGuide.getKo_label()}" required /> 
									<input type="text" name="category" class="input input-bordered input-sm !w-20 shrink-0"value="${wasteGuide.getCategory()}" required />
									<input type="text" name="guide" class="input input-bordered input-sm flex-grow" value="${wasteGuide.getGuide()}" required />
									<button type="submit" class="btn btn-sm btn-success ml-2 shrink-0">수정</button>
								</form>
							</td>
							<td class="align-middle">
								<form action="doDeleteWaste" method="get"
									class="flex items-center justify-center"
									onsubmit="return confirm('정말 삭제하시겠습니까?');">
									<input type="hidden" name="wasteId"
										value="${wasteGuide.getId()}" />
									<button type="submit" class="btn btn-sm btn-error">삭제</button>
								</form>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</section>

<script>
  function uploadImage() {
    const file = $("#uploadFileInput")[0].files[0];

    if (!file) {
      alert("업로드할 파일을 선택하세요");
      return;
    }

    const formData = new FormData();
    formData.append("file", file);

    $.ajax({
      url: "/usr/wasteGuide/uploadImage",
      type: "POST",
      data: formData,
      contentType: false,
      processData: false,
      success: function(data) {
        if (data.success) {
          const url = data.url;
          $("#thumbnailPreview").attr("src", url).removeClass("hidden");
          $("#thumbnailInput").val(url);
          alert("이미지 업로드 성공!");
        } else {
          alert("업로드 실패");
        }
      },
      error: function(err) {
        console.error(err);
        alert("오류 발생");
      }
    });
  }
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
