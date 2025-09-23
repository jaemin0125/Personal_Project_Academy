package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Member;
import com.example.demo.dto.Req;
import com.example.demo.dto.StickerPrice;
import com.example.demo.dto.WasteGuide;
import com.example.demo.service.MemberService;
import com.example.demo.service.WasteGuideService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UsrHomeController {
	private WasteGuideService wasteGuideService;
	private MemberService memberService;
	private Req req;

	public UsrHomeController(WasteGuideService wasteGuideService, MemberService memberService, Req req) {
		this.wasteGuideService = wasteGuideService;
		this.memberService = memberService;
		this.req = req;
	}
	@GetMapping("/usr/home/main")
	public String showMain(Model model) {
		
		List<WasteGuide> wasteGuide = wasteGuideService.getAddedObject();
		
		List<WasteGuide> searchKeyword = wasteGuideService.getKeywordList(); //최근 검색어 TOP 10
		
		model.addAttribute("wasteGuide", wasteGuide);
		model.addAttribute("searchKeyword", searchKeyword);
		
		return "usr/home/main";
	}

	@GetMapping("/usr/home/result")
	public String getResultPage(HttpServletRequest request, HttpServletResponse response, String label, Model model) {

		WasteGuide wasteGuide = wasteGuideService.getWasteGuide(label);

		if (wasteGuide == null) {
			model.addAttribute("wasteGuide", null);
			return "usr/home/result";
		}
		
		Cookie[] cookies = request.getCookies();
		boolean isViewed = false;

		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("viewedResult_" + wasteGuide.getId())) {
					isViewed = true;
					break;
				}
			}
		}
		
		if (wasteGuide != null && !isViewed) {
			this.wasteGuideService.searchCnt(wasteGuide.getLabel(), wasteGuide.getKo_label(), wasteGuide.getCategory());
			Cookie cookie = new Cookie("viewedResult_" + wasteGuide.getId(), "true");
			cookie.setMaxAge(60 * 30);
			response.addCookie(cookie);
		}
		
		if(req.getLoginedMember().getId() != 0) {
			Member loginedMember = memberService.getLoginedMemberById(req.getLoginedMember().getId());
			List<StickerPrice> stickerPrice = wasteGuideService.getStickerPrice(label, loginedMember.getAddress());
			model.addAttribute("stickerPrice", stickerPrice);
			model.addAttribute("loginedMember", loginedMember);
		}
		
		List<WasteGuide> relatedList = wasteGuideService.getRandomRelated(wasteGuide.getCategory(),
				wasteGuide.getLabel());

		model.addAttribute("wasteGuide", wasteGuide);
		model.addAttribute("relatedList", relatedList);
		return "usr/home/result";
	}
	
	@GetMapping("/usr/home/checkLabelExists")
	@ResponseBody
	public String checkLabelExist(String ko_label) {
		
		return this.wasteGuideService.checkLabelExist(ko_label);
	}
	
	@GetMapping("/")
	public String showRoot() {
		return "redirect:/usr/home/main";
	}
	
}