package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminMemberController {
	
	@GetMapping("/admin/member/info")
	public String goRootPage() {

		return "admin/member/info";
	}
	
}