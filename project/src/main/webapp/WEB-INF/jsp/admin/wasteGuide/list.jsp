<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="분리배출 정보 관리" />
<%@ include file="/WEB-INF/jsp/common/articleHeader.jsp"%>

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
      url: "/admin/wasteGuide/uploadImage",
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
  
  function getLabels(category) {
	  
	  $.ajax({
			url : '/admin/wasteGuide/getCategoryLabels',
			type : 'GET',
			data : {category : category},
			success : function(data) {
				
				$("#selectedLabel").empty().append(`<option value="" hidden selected>라벨을 선택하세요</option>`);
				
				data.forEach(function(item){
					$("#selectedLabel").append(
					 `<option value="\${item.label}">\${item.ko_label}</option>`
					);
				});
				$("#selectedLabel").prop("disabled", false);
				
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		});
	  
  }
  
  function showDetail(label){
	  $.ajax({
			url : '/admin/wasteGuide/getWasteGuide',
			type : 'GET',
			data : {label : label},
			success : function(data) {
				console.log(data);
				$("#wasteId").val("\${data.id}");
				$("#label").val("\${data.label}");
				$("#ko_label").val("\${data.ko_label}");
				$("#category").val("\${data.category}");
				$("#wasteType").val("\${data.wasteType}");
				$("#guide").val("\${data.guide}");
				$("#hiddenWasteId").val("\${data.id}");
						
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		});
  }
</script>

<section class="mt-10 flex">
	<div
		class="container mx-auto max-w-8xl bg-base-100 p-8 rounded-2xl shadow-md">
		<h1 class="text-3xl font-bold mb-6 text-center">♻️ 분리배출 정보 관리</h1>

		<div class="bg-base-100 border rounded-xl p-8 mb-4">
			<h2 class="text-xl font-semibold mb-6 flex justify-center items-center gap-2">
				<span class="text-blue-600 text-lg">🆕</span> 학습 정보 추가
			</h2>

			<div class="flex justify-center">
				<form action="doAddWaste" method="get"
					class="w-full max-w-2xl space-y-4">

					<!-- YOLO 라벨 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold">YOLO 라벨(영문)</label> 
						<input type="text" name="label" class="input input-bordered col-span-9" placeholder="예: paperbox" required />
					</div>

					<!-- 한글 명칭 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold">한글 명칭</label> 
						<input type="text" name="ko_label" class="input input-bordered col-span-9" placeholder="예: 종이 박스" required />
					</div>

					<!-- 카테고리 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold whitespace-nowrap">카테고리</label>
						<input type="text" name="category" class="input input-bordered col-span-9" placeholder="예: 종이" required />
					</div>

					<!-- 가이드 -->
					<div class="grid grid-cols-12 items-start gap-2 flex items-center">
						<label class="col-span-3 text-right font-semibold mt-10">분리배출 가이드</label>
						<textarea name="guide" rows="4" class="textarea textarea-bordered col-span-9" placeholder="예: 테이프, 스티커 등 이물질 제거 후 접어서 배출하세요." required></textarea>
					</div>
					
					<!-- 타입 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold whitespace-nowrap">타입</label>
						<select name="wasteType" class="select select-bordered col-span-9" required>
							<option value="" class=" text-gray-400" disabled selected hidden>타입을 선택하세요</option>
							<option value="일반">일반</option>	
							<option value="대형">대형</option>
							<option value="특수">특수</option>
						</select>
					</div>
					
					<!-- thumbnail -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold whitespace-nowrap">썸네일 이미지</label>
						<div class="col-span-6">
							<input type="file" id="uploadFileInput" class="file-input file-input-bordered w-full mb-1" accept="image/*" onchange="uploadImage()"/>
							<img id="thumbnailPreview" src="" class="mt-4 w-40 h-auto hidden border rounded" /> 
							<input type="hidden" name="thumbnail" id="thumbnailInput" required /> <!-- 이미지 업로드 하면 hidden 클래스 삭제 -->
						</div>
					</div>
					
					<!-- 버튼 -->
					<div class="relative mt-6 min-h-[48px]">
						<div class="absolute left-1/2 -translate-x-1/2">
							<button type="submit" class="btn btn-primary w-40">정보 추가</button>
						</div>
						<div class="absolute right-18">
							<button type="button" onclick="history.back();" class="btn btn-outline">← 뒤로가기</button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<div class="border rounded-xl p-6">
			<h2 class="text-lg font-semibold mb-4">📋 등록된 쓰레기 목록</h2>
			
			
			
			
			<!-- 해당 부분이 폐기물 정보 수정,삭제 UI 간소화 로직. -->
			<form action="doModifyWaste" method="get">
			<select id="selectedCategory" class="select select-bordered col-span-9 w-50" onchange="getLabels(this.value);" required>
				<option hidden selected>카테고리를 선택하세요</option>
				<c:forEach var="category" items="${categories }">
					<option>${category.category }</option>
				</c:forEach>
			</select>
			</form>
			
			<select id="selectedLabel" class="select select-bordered col-span-9 w-50" disabled required onchange="showDetail(this.value);">
			</select>
			
			
			
			
			<table class="table w-full">
				<tbody>
						<tr>
							<td class="w-full">
								<form id="" action="doModifyWaste" method="get"
									class="flex items-center gap-2 w-full">
									<input id="wasteId" type="hidden" name="wasteId"value="" /> 
									<input id="label" type="text" name="label" class="input input-bordered input-sm !w-24 shrink-0" value="" required /> 
									<input id="ko_label" type="text" name="ko_label" class="input input-bordered input-sm !w-30 shrink-0" value="" required /> 
									<input id="category" type="text" name="category" class="input input-bordered input-sm !w-20 shrink-0"value="" required />
									<input id="wasteType" type="text" name="wasteType" class="input input-bordered input-sm !w-20 shrink-0"value="" required />
									<input id="guide" type="text" name="guide" class="input input-bordered input-sm flex-grow" value="" required />
									<button type="submit" class="btn btn-sm btn-success ml-2 shrink-0">수정</button>
								</form>
							</td>
							<td class="align-middle">
								<form action="doDeleteWaste" method="get"
									class="flex items-center justify-center"
									onsubmit="return confirm('정말 삭제하시겠습니까?');">
									<input id="hiddenWasteId" type="hidden" name="hiddenWasteId"
										value="" />
									<button type="submit" class="btn btn-sm btn-error">삭제</button>
								</form>
							</td>
						</tr>
				</tbody>
			</table>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>