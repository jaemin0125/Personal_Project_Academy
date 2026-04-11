package com.example.demo.controller;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Member;
import com.example.demo.dto.Req;
import com.example.demo.service.MemberService;
import com.example.demo.util.Util;

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
	public String manageMember(Model model, @RequestParam(defaultValue = "1") int cPage, @RequestParam(defaultValue = "-1") int authLevel) {

		/*
		 * if (!req.isAdmin()) { return "usr/error/badRequest"; }
		 */
		
		int membersInPage = 10;
		int limitFrom = (cPage - 1) * membersInPage;

		int membersCnt = this.memberService.getMembersCnt(authLevel);
		
		int totalPagesCnt = (int) Math.ceil(membersCnt / (double) membersInPage);

		int begin = ((cPage - 1) / 10) * 10 + 1;
		int end = (((cPage - 1) / 10) + 1) * 10;

		if (end > totalPagesCnt) {
			end = totalPagesCnt;
		}
		
		List<Member> members = this.memberService.getMembersList(membersInPage, limitFrom, authLevel);
		
		
		model.addAttribute("members", members);
		model.addAttribute("authLevel", authLevel);
		model.addAttribute("cPage", cPage);
		model.addAttribute("begin", begin);
		model.addAttribute("end", end);
		model.addAttribute("totalPagesCnt", totalPagesCnt);
		model.addAttribute("articlesCnt", membersCnt);

		return "admin/member/manage";
	}
	
	@PostMapping("/admin/member/doModify")
	@ResponseBody
	public String doModifyMember(int id, int authLevel, int status) {
		
		this.memberService.doModifyMemberInfo(id, authLevel, status);
		
		return Util.jsReplace("회원 정보가 수정되었습니다.", "/admin/member/manage");
	}
	
	@GetMapping("/admin/member/getMemberById")
	@ResponseBody
	public Member getMemberById(int id) {
		
		return this.memberService.getMemberById(id);
	}

}