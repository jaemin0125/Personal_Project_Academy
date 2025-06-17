package com.example.demo.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.dto.Req;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class NeedAuthLevelInterceptor implements HandlerInterceptor {
	
	private Req req;
	
	public NeedAuthLevelInterceptor(Req req) {
		this.req = req;
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		if (req.getLoginedMember().getAuthLevel() != 0) {
			req.jsPrintReplace("권한이 없습니다", "/");
			return false;
		}
		
		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
	
}