package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dto.Req;
import com.example.demo.dto.WasteGuide;
import com.example.demo.service.WasteGuideService;
import com.example.demo.util.Util;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class AdminWasteGuideController {

	private WasteGuideService wasteGuideService;
	private Req req;

	public AdminWasteGuideController(WasteGuideService wasteGuideService, Req req) {
		this.wasteGuideService = wasteGuideService;
		this.req = req;
	}

	@PostMapping("/admin/wasteGuide/uploadImage")
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestParam("file") MultipartFile file, HttpServletRequest request)
			throws IOException {
		
		String contentType = file.getContentType();
		
		if (contentType == null || !contentType.startsWith("image/")) {
			throw new IllegalArgumentException("지원하지 않는 확장자입니다");
		}

		String uploadDir = request.getServletContext().getRealPath("/static/resource/imgs/");
		File dir = new File(uploadDir);
		if (!dir.exists())
			dir.mkdirs();

		String uuid = UUID.randomUUID().toString();
		String fileName = uuid + "_" + file.getOriginalFilename();

		File savedFile = new File(uploadDir, fileName);
		file.transferTo(savedFile);

		Map<String, Object> response = new HashMap<>();
		response.put("success", true);
		response.put("url", "/static/resource/imgs/" + fileName);
		return response;
	}

	@GetMapping("/admin/wasteGuide/list")
	public String getWasteList(Model model) {

		if (req.getLoginedMember().getAuthLevel() != 0) {
			return "usr/error/badRequest";
		}

		List<WasteGuide> wasteGuides = this.wasteGuideService.getTotalGuide();
		List<WasteGuide> categories = this.wasteGuideService.getCategories();
		

		model.addAttribute("wasteGuides", wasteGuides);
		model.addAttribute("categories", categories);

		return "admin/wasteGuide/list";
	}
	
	@GetMapping("/admin/wasteGuide/getCategoryLabels") // 등록된 분리배출 가이드 중 선택된 것으로 가져오는 비동기용 메서드.
	@ResponseBody
		public List<WasteGuide> getCategoryLabels(String category) {
		
		List<WasteGuide> categoryLabels = this.wasteGuideService.getCategoryLabels(category);
		
		// 그러면 일단 카테고리는 list.jsp 열릴때 카테고리만 중복 제거에서 가져오고, 카테고리가 선택된 뒤에 이 컨트롤러 메서드를 쓴다?????
		return categoryLabels;
		}
	
	@GetMapping("/admin/wasteGuide/getWasteGuide")
	@ResponseBody
	public List<WasteGuide> getWasteGuide(String label) {
		
		List<WasteGuide> wasteGuide = this.wasteGuideService.getWasteGuideDetail(label);
		
		System.out.println(wasteGuide);
		return wasteGuide;
	}
	
	
	

	@GetMapping("/admin/wasteGuide/doAddWaste")
	@ResponseBody
	public String doAddWaste(String label, String ko_label, String category, String guide, String wasteType, String thumbnail) {

		this.wasteGuideService.doAddWaste(label, ko_label, category, guide, wasteType, thumbnail);

		return Util.jsReplace("정보 추가 완료!", "/admin/wasteGuide/list");
	}

	@GetMapping("/admin/wasteGuide/doModifyWaste")
	@ResponseBody
	public String doModifyWaste(int wasteId, String label, String ko_label, String category, String guide,
			String wasteType) {

		this.wasteGuideService.doModifyWaste(wasteId, label, ko_label, category, guide, wasteType);

		return Util.jsReplace("정보 수정 완료!", "/admin/wasteGuide/list");
	}

	@GetMapping("/admin/wasteGuide/doDeleteWaste")
	@ResponseBody
	public String delete(int wasteId, HttpServletRequest request) {

		WasteGuide oldWasteGuide = this.wasteGuideService.getWasteGuideById(wasteId);
		String oldThumbnail = oldWasteGuide.getThumbnail();

		String realPath = request.getServletContext().getRealPath(oldThumbnail);
		File oldFile = new File(realPath);

		if (oldFile.exists()) {
			oldFile.delete();
		}

		this.wasteGuideService.doDeleteWaste(wasteId);
		this.wasteGuideService.doDeleteSearchKeyword(oldWasteGuide.getLabel());

		return Util.jsReplace(String.format("%d번 정보가 삭제되었습니다", wasteId), "/admin/wasteGuide/list");
	}
}