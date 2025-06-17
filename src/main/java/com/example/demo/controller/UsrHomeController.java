package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.dto.Member;
import com.example.demo.dto.Req;
import com.example.demo.dto.StickerPrice;
import com.example.demo.dto.WasteGuide;
import com.example.demo.service.MemberService;
import com.example.demo.service.WasteGuideService;

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
	public String getResultPage(String label, Model model) {

		WasteGuide wasteGuide = wasteGuideService.getWasteGuide(label);

		if (wasteGuide != null) {
			wasteGuideService.searchCnt(wasteGuide.getLabel(), wasteGuide.getKo_label(), wasteGuide.getCategory());
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

	
	@GetMapping("/")
	public String showRoot() {
		return "redirect:/usr/home/main";
	}
	
}