package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.LoginedMember;
import com.example.demo.dto.Member;
import com.example.demo.dto.Req;
import com.example.demo.dto.ResultData;
import com.example.demo.service.MemberService;
import com.example.demo.util.Util;

@Controller
public class UsrMemberController {
	
	private MemberService memberService;
	private Req req;
	
	public UsrMemberController(MemberService memberService, Req req) {
		this.memberService = memberService;
		this.req = req;
	}
	
	@GetMapping("/usr/member/join")
	public String join() {
		return "usr/member/join";
	}
	
	@PostMapping("/usr/member/doJoin")
	@ResponseBody
	public String doJoin(String loginId, String loginPw, String name, String email, String address) {
		
		this.memberService.joinMember(loginId, Util.encryptSHA256(loginPw), name, email, address);
		
		return Util.jsReplace(String.format("[ %s ] 님의 가입이 완료되었습니다", name), "/usr/home/main");
	}
	
	@GetMapping("/usr/member/loginIdDupChk")
	@ResponseBody
	public ResultData loginIdDupChk(String loginId) {
		
		Member member = this.memberService.getMemberByLoginId(loginId);
		
		if (member != null) {
			return ResultData.from("F-1", String.format("[ %s ] 은(는) 이미 사용중인 아이디입니다", loginId));
		}
		
		return ResultData.from("S-1", String.format("[ %s ] 은(는) 사용가능한 아이디입니다", loginId));
	}
	
	@GetMapping("/usr/member/login")
	public String login() {
		return "usr/member/login";
	}
	
	@PostMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw) {
		
		Member member = this.memberService.getMemberByLoginId(loginId);
		
		if (member == null) {
			return Util.jsReplace(String.format("[ %s ] 은(는) 존재하지 않는 회원입니다", loginId), "login");
		}
		
		if (member.getLoginPw().equals(Util.encryptSHA256(loginPw)) == false) {
			return Util.jsReplace("비밀번호가 일치하지 않습니다", "login");
		}
		this.req.login(new LoginedMember(member.getId(), member.getAuthLevel()));
		
		return Util.jsReplace(String.format("[ %s ] 님 환영합니다", member.getLoginId()), "/usr/home/main");
	}
	
	@GetMapping("/usr/member/logout")
	@ResponseBody
	public String logout() {
		
		this.req.logout();
		
		return Util.jsReplace("정상적으로 로그아웃 되었습니다", "/usr/home/main");
	}
	
	@GetMapping("/usr/member/getLoginId")
	@ResponseBody
	public String getLoginId() {
		return this.memberService.getLoginId(this.req.getLoginedMember().getId());
	}
	
	
	@PostMapping("/usr/member/info")
	public String memberInfo(Model model, String loginPw) {
		
		Member loginedMember = this.memberService.getLoginedMemberById(this.req.getLoginedMember().getId());
		
		
		if(!Util.encryptSHA256(loginPw).equals(loginedMember.getLoginPw())) {
			model.addAttribute("msg", "비밀번호가 일치하지 않습니다");
			return "usr/member/checkPw";
		} /*else if (req.getLoginedMember().getAuthLevel() == 0) {
			return "usr/member/info";
			}*/
		
		model.addAttribute("loginedMember", loginedMember);
		
		return "usr/member/info";
	}
	
	@GetMapping("/usr/member/checkPw")
	public String checkPw(String loginPw) {
		
		return "usr/member/checkPw";
	}
	
	@PostMapping("/usr/member/doModify")
	@ResponseBody
	public String doModifyMember(String name, String email, String address, String loginPw) {
		
		Member loginedMember = this.memberService.getLoginedMemberById(this.req.getLoginedMember().getId());
		
		if (loginPw.length() != 0) {
			this.memberService.doModifyMember(loginedMember.getLoginId(), name, email, address, Util.encryptSHA256(loginPw));
		} else if(loginPw.length() == 0) {
			this.memberService.modfiyWithOutPw(loginedMember.getLoginId(), name, email, address);
		}
		
		this.req.logout();
		
		return Util.jsReplace("회원정보가 수정되었습니다 변경된 정보로 다시 로그인하세요", "/");
	}
	
	
}