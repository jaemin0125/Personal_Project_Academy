package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
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
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.util.Util;

@Controller
public class UsrUploadController {
	
	@PostMapping("/usr/image/analyze")
	public String analyzeImage(@RequestParam("file") MultipartFile file, Model model) throws IOException {
	    
	    String contentType = file.getContentType(); // file의 컨텐츠 타입을 contentType이란 변수에 저장한다 모든 image파일의 MIMETYPE은 image/로 시작
	    
	    if (!contentType.startsWith("image/")) { // MIMETYPE이 null이거나 image파일 이 아닌경우에 코드의 흐름을 제어하는 조건문
	        return "redirect:/";
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
	    
	    Map<String, Object> result = null;
	    
	    try {
	        ResponseEntity<Map> response = restTemplate.postForEntity(flaskUrl, requestEntity, Map.class);
	        result = response.getBody();
	    } catch (RestClientException e) {
	        return "usr/error/flaskError"; // → 에러용 JSP 페이지로 이동
	    }
	    
	    // 3. Flask에서 온 JSON 응답 처리
	    
	    List<Map<String, Object>> results = (List<Map<String, Object>>) result.get("results"); // results라는 Json객체 타입의 List 변수에 Json배열에서 results라는 key로 꺼내온 Json객체를 담는다  

	    String resultLabel = null;
	    if (results != null && !results.isEmpty()) {  
	        Map<String, Object> topResult = results.get(0); 
	        resultLabel = (String) topResult.get("label");
	    }

		return String.format("redirect:/usr/home/result?label=%s", resultLabel);
	}
	
}