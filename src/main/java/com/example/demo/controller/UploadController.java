package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.FilenameUtils;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dto.Req;
import com.example.demo.dto.StickerPrice;
import com.example.demo.dto.WasteGuide;
import com.example.demo.service.UploadService;
import com.example.demo.util.Util;

import jakarta.servlet.http.HttpServletRequest;


@Controller
public class UploadController {
	
	private UploadService uploadService;
	private Req req;
	
	public UploadController(UploadService uploadService, Req req) {
		this.uploadService = uploadService;
		this.req = req;
	}
	
	@PostMapping("/usr/image/analyze")
	public String analyzeImage(@RequestParam("file") MultipartFile file, Model model) throws IOException {
	    
	    String contentType = file.getContentType(); // file의 컨텐츠 타입을 contentType이란 변수에 저장한다 모든 image파일의 MIMETYPE은 image/로 시작
	    
	    if (contentType == null || !contentType.startsWith("image/")) { // MIMETYPE이 null이거나 image파일 이 아닌경우에 코드의 흐름을 제어하는 조건문
	        return Util.jsReplace("이미지 파일만 업로드할 수 있습니다.", "/");
	    }

	    // 1. 임시 파일로 저장
	    File tempFile = File.createTempFile("upload-", file.getOriginalFilename()); //jsp에서 사용자가 업로드 한 사진을 임시파일을 생성하여 디렉토리 중 한곳에 저장한다
	    file.transferTo(tempFile); 
	    

	    // 2. Flask로 파일 보내기
	    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>(); 
	    body.add("image", new FileSystemResource(tempFile)); //body변수에 image라는 key로 실제로 임시파일(이미지파일)을 저장

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.MULTIPART_FORM_DATA); //HTTP의 요청 MediaType을 MULTIPART_FORM_DATA 로 지정

	    HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers); //실제로 Http요청에 body와 headers 변수를 담는다

	    String flaskUrl = "http://localhost:5000/analyze"; // flask url

	    RestTemplate restTemplate = new RestTemplate(); // Http요청을 보내기 위한 Spring 클라이언트 객체 
	    ResponseEntity<Map> response = restTemplate.postForEntity(flaskUrl, requestEntity, Map.class); //flaskurl에 요청이 담긴 requestEntity 변수를 post요청으로 보내고 , 리턴은 Map타입으로 받겠다

	    // 3. Flask에서 온 JSON 응답 처리
	    Map<String, Object> result = response.getBody(); // result라는 변수에 json객체 배열을 담는다
	    
	    List<Map<String, Object>> results = (List<Map<String, Object>>) result.get("results"); // results라는 Json객체 타입의 List 변수에 Json배열에서 results라는 key로 꺼내온 Json객체를 담는다  

	    
	    String resultLabel = null;
	    if (results != null && !results.isEmpty()) {  
	        Map<String, Object> topResult = results.get(0); 
	        resultLabel = (String) topResult.get("label");
	    }

	    model.addAttribute("label", resultLabel);
	    
	    WasteGuide wasteGuide = this.uploadService.getWasteGuide(resultLabel);

		if (wasteGuide == null) {
			model.addAttribute("wasteGuide", null);
			return "usr/home/result";
		} else if (wasteGuide != null) {
			this.uploadService.searchCnt(wasteGuide.getLabel(), wasteGuide.getKo_label(), wasteGuide.getCategory());
		}
	    
	    List<StickerPrice> stickerPrice = uploadService.getStickerPrice(resultLabel, this.req.getLoginedMember().getAddress());
	    
	    List<WasteGuide> relatedList = uploadService.getRandomRelated(wasteGuide.getCategory(), wasteGuide.getLabel());
	    
	    model.addAttribute("wasteGuide", wasteGuide);
	    model.addAttribute("stickerPrice", stickerPrice);
	    model.addAttribute("relatedList", relatedList);

	    return "usr/home/result";
	}

    
    @GetMapping("/usr/home/result")
    public String getResultPage(String label, Model model) {
    	
    	    WasteGuide wasteGuide = uploadService.getWasteGuide(label);
    	    

    	    if (wasteGuide != null) {
    	        uploadService.searchCnt(wasteGuide.getLabel(), wasteGuide.getKo_label(), wasteGuide.getCategory());
    	    }
    	    
    		List<StickerPrice> stickerPrice = uploadService.getStickerPrice(label, this.req.getLoginedMember().getAddress());
    		List<WasteGuide> relatedList = uploadService.getRandomRelated(wasteGuide.getCategory(), wasteGuide.getLabel());
    		
    	    model.addAttribute("wasteGuide", wasteGuide);
    	    model.addAttribute("stickerPrice", stickerPrice);
    	    model.addAttribute("relatedList", relatedList);

        return "usr/home/result";
    }
    
    
	@PostMapping("/usr/wasteGuide/uploadImage")
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestParam("file") MultipartFile file, HttpServletRequest request) throws IOException {
		
		String ext = FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase();
		if (!List.of("jpg", "jpeg", "png", "gif").contains(ext)) {
		    throw new IllegalArgumentException("지원하지 않는 확장자입니다");
		}
		
	    String uploadDir = request.getServletContext().getRealPath("/resource/upload/");
	    File dir = new File(uploadDir);
	    if (!dir.exists()) dir.mkdirs();

	    String uuid = UUID.randomUUID().toString();
	    String fileName = uuid + "_" + file.getOriginalFilename();
	    
	    
	    File savedFile = new File(uploadDir, fileName);
	    file.transferTo(savedFile);

	    Map<String, Object> response = new HashMap<>();
	    response.put("success", true);
	    response.put("url", "/resource/upload/" + fileName);
	    return response;
	}
	
	@GetMapping("/usr/wasteGuide/list")
	public String getWasteList(Model model) {
		
		List<WasteGuide> wasteGuides = this.uploadService.getTotalGuide();
		
		model.addAttribute("wasteGuides", wasteGuides);
		
		return "usr/wasteGuide/list";
	}
	
	@GetMapping("/usr/wasteGuide/doAddWaste")
	@ResponseBody
	public String doAddWaste(String label, String ko_label, String category, String guide, String wasteType, String thumbnail) {
		
		this.uploadService.doAddWaste(label, ko_label, category, guide, wasteType, thumbnail);
		
		return Util.jsReplace("정보 추가 완료!", "/usr/wasteGuide/list");
	}
	
	@GetMapping("/usr/wasteGuide/doModifyWaste")
	@ResponseBody
	public String doModifyWaste(int wasteId, String label, String ko_label, String category, String guide, String wasteType) {
		
		this.uploadService.doModifyWaste(wasteId, label, ko_label, category, guide, wasteType);
		
		return Util.jsReplace("정보 수정 완료!", "/usr/wasteGuide/list");
	}
	
	@GetMapping("/usr/wasteGuide/doDeleteWaste")
	@ResponseBody
	public String delete(int wasteId, HttpServletRequest request) {
		
		WasteGuide oldWasteGuide = this.uploadService.getWasteGuideById(wasteId);
		String oldThumbnail = oldWasteGuide.getThumbnail();
		
		String realPath = request.getServletContext().getRealPath(oldThumbnail);
		File oldFile = new File(realPath);
		
		if(oldFile.exists()) {
			oldFile.delete();
		}
		
		this.uploadService.doDeleteWaste(wasteId);
		this.uploadService.doDeleteSearchKeyword(oldWasteGuide.getLabel());

		return Util.jsReplace(String.format("%d번 정보가 삭제되었습니다", wasteId), "/usr/wasteGuide/list");
	}
	
}