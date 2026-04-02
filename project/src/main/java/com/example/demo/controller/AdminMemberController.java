package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.Article;
import com.example.demo.dto.Member;
import com.example.demo.dto.Req;
import com.example.demo.service.MemberService;

@Controller
public class AdminMemberController {

	private MemberService memberService;
	private Req req;

	public AdminMemberController(MemberService memberService, Req req) {
		this.memberService = memberService;
		this.req = req;
	}

	@GetMapping("/admin/member/info")
	public String goRootPage() {

		/*
		 * if (!req.isAdmin()) { return "usr/error/badRequest"; }
		 */
		return "admin/member/info";
	}

	@GetMapping("/admin/member/manage")
	public String modifyMember(Model model, @RequestParam(defaultValue = "1") int cPage) {

		/*
		 * if (!req.isAdmin()) { return "usr/error/badRequest"; }
		 */

		
		int membersInPage = 10;
		int limitFrom = (cPage - 1) * membersInPage;

		int membersCnt = this.memberService.getMembersCnt();
		
		int totalPagesCnt = (int) Math.ceil(membersCnt / (double) membersInPage);

		int begin = ((cPage - 1) / 10) * 10 + 1;
		int end = (((cPage - 1) / 10) + 1) * 10;

		if (end > totalPagesCnt) {
			end = totalPagesCnt;
		}
		
		List<Member> members = this.memberService.getMembersList(membersInPage, limitFrom);
		

		model.addAttribute("members", members);
		model.addAttribute("cPage", cPage);
		model.addAttribute("begin", begin);
		model.addAttribute("end", end);
		model.addAttribute("totalPagesCnt", totalPagesCnt);
		model.addAttribute("articlesCnt", membersCnt);

		return "admin/member/manage";
	}

}