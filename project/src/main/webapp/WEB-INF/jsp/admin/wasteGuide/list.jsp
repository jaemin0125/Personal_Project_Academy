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
			url : "/admin/wasteGuide/uploadImage",
			type : "POST",
			data : formData,
			contentType : false,
			processData : false,
			success : function(data) {
				if (data.success) {
					const url = data.url;
					$("#thumbnailPreview").attr("src", url).removeClass(
							"hidden");
					$("#thumbnailInput").val(url);
					alert("이미지 업로드 성공!");
				} else {
					alert("업로드 실패");
				}
			},
			error : function(err) {
				console.error(err);
				alert("오류 발생");
			}
		});
	}

	function getLabels(category) {

				
				$.ajax({
					url : '/admin/wasteGuide/getCategoryLabels',
					type : 'GET',
					data : {
						category : category
					},
					success : function(data) {

						$("#selectedLabel").empty().append(`<option value="" hidden selected>라벨을 선택하세요</option>`);

						data.forEach(function(item) {$("#selectedLabel").append(`<option value="\${item.label}">\${item.ko_label}</option>`);
								});
						$("#selectedLabel").prop("disabled", false);

					},
					error : function(xhr, status, error) {
						console.log(error);
					}
				});

	}

	function showDetail(label) {
		$.ajax({
			url : '/admin/wasteGuide/getWasteGuide',
			type : 'GET',
			data : {
				label : label
			},
			success : function(data) {
				const item = data[0];

				if (item) {
					$("#wasteId").val(item.id);
					$("#label").val(item.label);
					$("#ko_label").val(item.ko_label);
					$("#category").val(item.category);
					$("#wasteType").val(item.wasteType);
					$("#guide").val(item.guide);
					$("#hiddenWasteId").val(item.id);
					$("#modifyContainer").removeClass("hidden");

					document.getElementById('modifyContainer').scrollIntoView({
						behavior : 'smooth'
					});

				}
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		});
	}

	function confirmDelete() {
		if (confirm("정보를 삭제하시겠습니까?")) {
			$("#deleteForm").submit();
		}
	}
	
	function cancelModify(){
		$("#modifyContainer").addClass("hidden");
		$("#selectedLabel").prop("disabled", true).empty().append(`<option selected disabled>카테고리를 먼저 선택하세요</option>`);
		$("#selectedCategory").val("카테고리를 선택하세요");
		
	}
</script>

<section class="mt-10 flex">
	<div
		class="container mx-auto max-w-8xl bg-base-100 p-8 rounded-2xl shadow-md">
		<h1 class="text-3xl font-bold mb-6 text-center">♻️ 분리배출 정보 관리</h1>

		<div class="bg-base-100 border rounded-xl p-8 mb-4">
			<h2
				class="text-xl font-semibold mb-6 flex justify-center items-center gap-2">
				<span class="text-blue-600 text-lg">🆕</span> 학습 정보 추가
			</h2>

			<div class="flex justify-center">
				<form action="doAddWaste" method="get"
					class="w-full max-w-2xl space-y-4">

					<!-- YOLO 라벨 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold">영문 명칭</label> <input
							type="text" name="label" class="input input-bordered col-span-9"
							placeholder="예: paperbox" required />
					</div>

					<!-- 한글 명칭 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label class="col-span-3 text-right font-semibold">한글 명칭</label> <input
							type="text" name="ko_label"
							class="input input-bordered col-span-9" placeholder="예: 종이 박스"
							required />
					</div>

					<!-- 카테고리 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label
							class="col-span-3 text-right font-semibold whitespace-nowrap">카테고리</label>
						<input type="text" name="category"
							class="input input-bordered col-span-9" placeholder="예: 종이"
							required />
					</div>

					<!-- 가이드 -->
					<div class="grid grid-cols-12 items-start gap-2 flex items-center">
						<label class="col-span-3 text-right font-semibold mt-10">분리배출
							가이드</label>
						<textarea name="guide" rows="4"
							class="textarea textarea-bordered col-span-9"
							placeholder="예: 테이프, 스티커 등 이물질 제거 후 접어서 배출하세요." required></textarea>
					</div>

					<!-- 타입 -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label
							class="col-span-3 text-right font-semibold whitespace-nowrap">타입</label>
						<select name="wasteType" class="select select-bordered col-span-9"
							required>
							<option value="" class=" text-gray-400" disabled selected hidden>타입을
								선택하세요</option>
							<option value="일반">일반</option>
							<option value="대형">대형</option>
							<option value="특수">특수</option>
						</select>
					</div>

					<!-- thumbnail -->
					<div class="grid grid-cols-12 items-center gap-2">
						<label
							class="col-span-3 text-right font-semibold whitespace-nowrap">썸네일
							이미지</label>
						<div class="col-span-6">
							<input type="file" id="uploadFileInput"
								class="file-input file-input-bordered w-full mb-1"
								accept="image/*" onchange="uploadImage()" /> <img
								id="thumbnailPreview" src=""
								class="mt-4 w-40 h-auto hidden border rounded" /> <input
								type="hidden" name="thumbnail" id="thumbnailInput" required />
							<!-- 이미지 업로드 하면 hidden 클래스 삭제 -->
						</div>
					</div>

					<!-- 버튼 -->
					<div class="relative mt-6 min-h-[48px]">
						<div class="absolute left-1/2 -translate-x-1/2">
							<button type="submit" class="btn btn-primary w-40">정보 추가</button>
						</div>
						<div class="absolute right-18">
							<button type="button" onclick="history.back();"
								class="btn btn-outline">← 뒤로가기</button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<div class="border rounded-2xl p-8 bg-base-100 shadow-sm">
			<h2 class="text-2xl font-bold mb-8 flex items-center gap-2">
				<span class="text-primary">📋</span> 등록된 정보 수정 및 삭제
			</h2>

			<div
				class="flex flex-wrap gap-4 mb-10 p-6 bg-base-200 rounded-2xl items-end">
				<div class="form-control w-full max-w-xs">
					<label class="label"><span class="label-text font-bold">1.
							카테고리 선택</span></label> <select id="selectedCategory"
						class="select select-bordered w-full mt-2"
						onchange="getLabels(this.value);" required>
						<option hidden selected>카테고리를 선택하세요</option>
						<c:forEach var="category" items="${categories}">
							<option>${category.category}</option>
						</c:forEach>
					</select>
				</div>

				<div class="form-control w-full max-w-xs">
					<label class="label"><span class="label-text font-bold">2.
							상세 항목 선택</span></label> <select id="selectedLabel"
						class="select select-bordered w-full mt-2" disabled required
						onchange="showDetail(this.value);">
						<option selected disabled>카테고리를 먼저 선택하세요</option>
					</select>
				</div>

				<div class="text-sm text-gray-500 mb-3 ml-auto">* 항목을 선택하면 아래에
					수정 양식이 나타납니다.</div>
			</div>

			<div id="modifyContainer" class="hidden animate-fadeIn">
				<div class="divider text-gray-400 text-sm">EDIT INFORMATION</div>

				<div
					class="bg-white border-2 border-primary/10 rounded-3xl p-8 mt-6 shadow-lg">
					<form action="doModifyWaste" method="get" class="space-y-6">
						<input id="wasteId" type="hidden" name="wasteId" value="" />

						<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
							<div class="form-control">
								<label class="label"><span
									class="label-text font-semibold">영문 명칭</span></label> <input id="label"
									type="text" name="label" class="input input-bordered mt-1"
									value="" required />
							</div>

							<div class="form-control">
								<label class="label"><span
									class="label-text font-semibold">한글 명칭</span></label> <input
									id="ko_label" type="text" name="ko_label"
									class="input input-bordered mt-1" value="" required />
							</div>

							<div class="form-control">
								<label class="label"><span
									class="label-text font-semibold">카테고리</span></label> <input
									id="category" type="text" name="category"
									class="input input-bordered mt-1" value="" required />
							</div>

							<div class="form-control">
								<label class="label"><span
									class="label-text font-semibold">배출 타입</span></label> <select
									id="wasteType" name="wasteType"
									class="select select-bordered mt-1" required>
									<option value="일반">일반</option>
									<option value="대형">대형</option>
									<option value="특수">특수</option>
								</select>
							</div>
						</div>

						<div class="form-control">
							<label class="label"><span
								class="label-text font-semibold">분리배출 가이드</span></label>
							<textarea id="guide" name="guide"
								class="textarea textarea-bordered h-32 w-full leading-relaxed mt-1"
								required></textarea>
						</div>

						<div
							class="flex justify-between items-center pt-6 border-t border-gray-100">
							<button type="button" onclick="confirmDelete();"
								class="btn btn-error btn-outline gap-2">
								<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5"
									fill="none" viewBox="0 0 24 24" stroke="currentColor">
									<path stroke-linecap="round" stroke-linejoin="round"
										stroke-width="2"
										d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
								정보 삭제
							</button>

							<div class="flex gap-2">
								<button type="button" onclick="cancelModify();"
									class="btn btn-ghost">취소</button>
								<button type="submit"
									class="btn btn-primary px-10 shadow-md shadow-primary/20">저장하기</button>
							</div>
						</div>
					</form>

					<form id="deleteForm" action="doDeleteWaste" method="get">
						<input id="hiddenWasteId" type="hidden" name="wasteId" value="" />
					</form>
				</div>
			</div>
		</div>
	</div>
</section>

<style>
@
keyframes fadeIn {from { opacity:0;
	transform: translateY(10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.animate-fadeIn {
	animation: fadeIn 0.4s ease-out;
}
</style>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>