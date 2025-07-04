package com.example.demo.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CustomErrorController implements ErrorController {

	@RequestMapping("/error")
	public String handleError(HttpServletRequest request, Model model) {
		Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");

		if (statusCode != null) {
			model.addAttribute("statusCode", statusCode);
			return "usr/error/badRequest";
		}

		return "usr/error/badRequest";
	}
}
