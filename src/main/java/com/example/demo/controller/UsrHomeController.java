package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.dto.Req;
import com.example.demo.dto.WasteGuide;
import com.example.demo.service.UploadService;

@Controller
public class UsrHomeController {
	private UploadService uploadService;
	private Req req;

	public UsrHomeController(UploadService uploadService, Req req) {
		this.uploadService = uploadService;
		this.req = req;
	}
	@GetMapping("/usr/home/main")
	public String showMain(Model model) {
		
		List<WasteGuide> wasteGuide = uploadService.getAddedObject();
		
		model.addAttribute("wasteGuide", wasteGuide);
		
		return "usr/home/main";
	}
	
	@GetMapping("/")
	public String showRoot() {
		return "redirect:/usr/home/main";
	}
	
}