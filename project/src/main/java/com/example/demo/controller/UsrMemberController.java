package com.example.demo.controller;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.LoginedMember;
import com.example.demo.dto.Member;
import com.example.demo.dto.Req;
import com.example.demo.dto.ResultData;
import com.example.demo.service.MemberService;
import com.example.demo.util.Util;
import com.fasterxml.jackson.databind.ObjectMapper;

import ch.qos.logback.core.recovery.ResilientSyslogOutputStream;
import lombok.Builder.Default;

@Controller
public class UsrMemberController {

	private MemberService memberService;
	private Req req;
	private static SecureRandom secureRandom = new SecureRandom();

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
	public String doJoin(String loginId, String loginPw, String name, String email, String address, String phoneNum) {

		this.memberService.joinMember(loginId, Util.encryptSHA256(loginPw), name, email, address, phoneNum);

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

	@GetMapping("/usr/member/getAuthPin")
	@ResponseBody
	public String getAuthPin() {

		StringBuilder pin = new StringBuilder();

		for (int i = 0; i < 4; i++) {
			pin.append(secureRandom.nextInt(10));
		}

		return pin.toString();
	}

	@GetMapping("/usr/member/verifyPhoneNum")
	@ResponseBody
	public Object VerifyPhoneNum(String phoneNum, String authPin) throws IOException, InterruptedException {
		String regExp = "^010[0-9]{7,8}$";
		Map<String, Object> map = Util.VerifyPhoneNum(phoneNum, authPin);
		Boolean exists = (Boolean) map.get("exists");
		Boolean isDupPhoneNum = false;
		
		Map<String, Object> rs = new HashMap<>();
		
		if(!phoneNum.matches(regExp)) {
			rs.put("exists", false);
			return rs;
		}
		

		/* 휴대폰 인증 성공 시 이미 가입된 번호인지 중복 검증 */
		if (exists) {
			int idCount = this.memberService.phoneNumDupChk(phoneNum);

			if (idCount == 1) {
				isDupPhoneNum = true;
			}
		}

		rs.put("exists", exists);
		rs.put("isDupPhoneNum", isDupPhoneNum);

		return rs;
	}
	
	@GetMapping("/usr/member/findLoginInfo")
	@ResponseBody
	public Object FindLoginInfo(String phoneNum, String authPin, @RequestParam(defaultValue = "") String loginId, String mode) throws IOException, InterruptedException {
		
		Map<String, Object> map = Util.VerifyPhoneNum(phoneNum, authPin);

		Boolean exists = true /*(Boolean) map.get("exists")*/;
		Boolean isDupPhoneNum = false;
		String findLoginId = null;
		Boolean isInfoMatching = false;

		Map<String, Object> rs = new HashMap<>();
		/* 휴대폰 인증 성공 시 이미 가입된 번호인지 중복 검증 */
		
		if(mode.equals("id")) {
			if (exists) {
				int idCount = this.memberService.phoneNumDupChk(phoneNum);

				if (idCount == 1) {
					isDupPhoneNum = true;
				}
			}

			if (isDupPhoneNum) {
				findLoginId = this.memberService.getMemberByPhoneNumber(phoneNum);
			}

			if (findLoginId != null) {
				rs.put("loginId", findLoginId);
			}
		}
		
		if(mode.equals("pw")) {
			if(exists && loginId.length() != 0) {
				//여기에 phoneNum와, loginId가 매칭되는지 확인
				int countId = this.memberService.getIdCntByInfo(phoneNum, loginId);
				
				if(countId == 1) {
					isInfoMatching = true;
				}
			}
		}

		rs.put("exists", exists);
		rs.put("isInfoMatching", isInfoMatching);
		return rs;
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

		if (member.getStatus() == 1) {
			return Util.jsReplace("차단된 회원입니다 관리자에게 문의하세요.", "/");
		} /* 추가적으로 휴면, 탈퇴대기 관련 로직을 추가하여 else if 문 추가 예정. */

		this.req.login(new LoginedMember(member.getId(), member.getAuthLevel(), member.getStatus()));
		this.memberService.updateLoginDate(member.getId());

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
		model.addAttribute("loginedMember", loginedMember);

		if (!Util.encryptSHA256(loginPw).equals(loginedMember.getLoginPw())) {
			model.addAttribute("msg", "비밀번호가 일치하지 않습니다");
			return "usr/member/checkPw";
		} else if (req.getLoginedMember().getAuthLevel() == 0) {
			return "usr/member/info";
		}

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
			this.memberService.doModifyMember(loginedMember.getLoginId(), name, email, address,
					Util.encryptSHA256(loginPw));
		} else if (loginPw.length() == 0) {
			this.memberService.modfiyWithOutPw(loginedMember.getLoginId(), name, email, address);
		}

		this.req.logout();

		return Util.jsReplace("회원정보가 수정되었습니다 변경된 정보로 다시 로그인하세요", "/");
	}
	
	@PostMapping("/usr/member/resetPassword")
	@ResponseBody
	public ResultData doResetPassword(String loginId, String phoneNum, String newPassword) {
		
		String regExp = "^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=\\.\\-])(?=.*[0-9]).{8,16}$";	
		
		if(loginId.length() != 0 && newPassword.matches(regExp)) {
			this.memberService.doResetPassword(loginId, phoneNum, Util.encryptSHA256(newPassword));
			return ResultData.from("S-1", "정상적으로 비밀번호가 변경되었습니다");
		}
		return ResultData.from("F-1", "오류 발생");
	}

}