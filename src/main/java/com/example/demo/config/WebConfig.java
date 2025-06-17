package com.example.demo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.interceptor.NeedAuthLevelInterceptor;
import com.example.demo.interceptor.NeedLoginInterceptor;
import com.example.demo.interceptor.NeedLogoutInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	private BeforeActionInterceptor beforeActionInterceptor;
	private NeedLoginInterceptor needLoginInterceptor;
	private NeedLogoutInterceptor needLogoutInterceptor;
	private NeedAuthLevelInterceptor needAuthLevelInterceptor;

	public WebConfig(BeforeActionInterceptor beforeActionInterceptor, NeedLoginInterceptor needLoginActionInterceptor,NeedLogoutInterceptor needLogoutInterceptor, NeedAuthLevelInterceptor needAuthLevelInterceptor) {
		this.beforeActionInterceptor = beforeActionInterceptor;
		this.needLoginInterceptor = needLoginActionInterceptor;
		this.needLogoutInterceptor = needLogoutInterceptor;
		this.needAuthLevelInterceptor = needAuthLevelInterceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(beforeActionInterceptor).addPathPatterns("/**").excludePathPatterns("/resource/**");

		registry.addInterceptor(needLoginInterceptor).addPathPatterns("/usr/article/write")
				.addPathPatterns("/usr/article/doWrite").addPathPatterns("/usr/article/modify")
				.addPathPatterns("/usr/article/doModify").addPathPatterns("/usr/article/delete")
				.addPathPatterns("/usr/member/logout").addPathPatterns("/usr/article/uploadImage")
				.addPathPatterns("/usr/likePoint/clickLikePoint").addPathPatterns("/usr/member/doModify")
				.addPathPatterns("/usr/member/checkPw").addPathPatterns("/usr/member/info")
				.addPathPatterns("/usr/reply/doWrite").addPathPatterns("/usr/reply/delete")
				.addPathPatterns("/usr/reply/modify").addPathPatterns("/admin/board/list")
				.addPathPatterns("/admin/board/doAddBoard").addPathPatterns("/admin/board/doModifyBoard")
				.addPathPatterns("/admin/board/doDeleteBoard").addPathPatterns("/admin/member/info")
				.addPathPatterns("/admin/wasteGuide/uploadImage").addPathPatterns("/admin/wasteGuide/list")
				.addPathPatterns("/admin/wasteGuide/doAddWaste").addPathPatterns("/admin/wasteGuide/doModifyWaste")
				.addPathPatterns("/admin/wasteGuide/doDeleteWaste");
		
		registry.addInterceptor(needAuthLevelInterceptor).addPathPatterns("/admin/board/list")
				.addPathPatterns("/admin/board/doAddBoard").addPathPatterns("/admin/board/doModifyBoard")
				.addPathPatterns("/admin/board/doDeleteBoard").addPathPatterns("/admin/member/info")
				.addPathPatterns("/admin/wasteGuide/uploadImage").addPathPatterns("/admin/wasteGuide/list")
				.addPathPatterns("/admin/wasteGuide/doAddWaste").addPathPatterns("/admin/wasteGuide/doModifyWaste")
				.addPathPatterns("/admin/wasteGuide/doDeleteWaste");

		registry.addInterceptor(needLogoutInterceptor).addPathPatterns("/usr/member/join")
				.addPathPatterns("/usr/member/login").addPathPatterns("/usr/member/doLogin");

		
	}

}