package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.util.Map;

import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.service.UploadService;

@Controller
public class UploadController {
	
	private UploadService uploadService;
	
	public UploadController(UploadService uploadService) {
		this.uploadService = uploadService;
	}
	
    @PostMapping("/usr/image/analyze")
    public String analyzeImage(@RequestParam("file") MultipartFile file, Model model) throws IOException {
        // 1. 임시 파일로 저장
        File tempFile = File.createTempFile("upload-", file.getOriginalFilename());
        file.transferTo(tempFile);

        // 2. Flask로 파일 보내기
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("image", new FileSystemResource(tempFile));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        String flaskUrl = "http://localhost:5000/analyze";

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<Map> response = restTemplate.postForEntity(flaskUrl, requestEntity, Map.class);
        
        

        // 3. Flask에서 온 JSON 응답 처리
        Map<String, Object> result = response.getBody();
        model.addAttribute("label", result.get("label"));
        
        String label = (String) result.get("label");
        
        String wasteGuide = this.uploadService.getWasteGuide(label);
        
        model.addAttribute("wasteGuide", wasteGuide);
        

        return "usr/home/result"; // 이 JSP가 결과를 보여주는 화면
    }

}
