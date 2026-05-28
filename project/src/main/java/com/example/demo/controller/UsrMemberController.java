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
	public ResultData<Map<String, Object>> VerifyPhoneNum(String phoneNum, String authPin)
			throws IOException, InterruptedException {

		String regExp = "^010[0-9]{7,8}$";

		if (phoneNum == null || !phoneNum.trim().matches(regExp)) {
			return ResultData.from("F-1", "올바른 전화번호의 형식이 아닙니다");
		}

		Map<String, Object> map = Util.VerifyPhoneNum(phoneNum, authPin);
		Boolean exists = (Boolean) map.get("exists");

		if (!exists) {
			return ResultData.from("F-2", "인증에 실패하였습니다");
		}

		int idCnt = this.memberService.phoneNumDupChk(phoneNum);

		if (idCnt == 0) {
			return ResultData.from("S-1", "인증이 완료되었습니다"); // 중복된 회원 정보가 없으니 join form에서는 Success의 의미.
		} else if (idCnt == 1) {
			return ResultData.from("F-3", "이미 가입된 휴대폰 번호입니다"); // 이미 가입된 정보가 있으니 Fail의 의미
		}

		return ResultData.from("F-4", "잘못된 접근입니다");
	}

	@GetMapping("/usr/member/findLoginInfo")
	@ResponseBody
	public ResultData<Map<String, Object>> FindLoginInfo(String phoneNum, String authPin,
			@RequestParam(defaultValue = "") String loginId, String info) throws IOException, InterruptedException {
		String regExp = "^010[0-9]{7,8}$";

		if (phoneNum == null || !phoneNum.trim().matches(regExp)) {
			return ResultData.from("F-1", "올바른 전화번호의 형식이 아닙니다");
		}

		Map<String, Object> map = Util.VerifyPhoneNum(phoneNum, authPin);

		Boolean exists = (Boolean) map.get("exists");

		/* 휴대폰 인증 성공 시 이미 가입된 번호인지 중복 검증 */
		if (!exists) {
			return ResultData.from("F-2", "인증에 실패하였습니다");
		}

		Map<String, Object> rsData = new HashMap<>();

		if (info.equals("id")) {
			int idCnt = this.memberService.phoneNumDupChk(phoneNum);

			if (idCnt == 0) {
				// 아이디 없을 떄
				return ResultData.from("F-3", "입력하신 정보의 회원이 존재하지 않습니다");
			} else if (idCnt == 1) {
				rsData.put("loginId", this.memberService.getMemberByPhoneNumber(phoneNum));
				return ResultData.from("S-1", "인증 성공 및 아이디 찾음", rsData);
			}
		}

		if (info.equals("pw")) {
			if (loginId.trim().length() == 0) {
				return ResultData.from("F-1", "올바른 ID의 형식이 아닙니다");
			}

			int infoCnt = this.memberService.getIdCntByInfo(phoneNum, loginId);

			if (infoCnt == 0) {
				// 인증한 phoneNum과 loginId 정보가 일치하지 않을 때j
				return ResultData.from("F-3", "회원 정보와 인증된 휴대폰 번호가 일치하지 않습니다");
			} else if (infoCnt == 1) {
				return ResultData.from("S-2", "인증 성공 비밀번호 재설정");
			}
		}

		return ResultData.from("F-4", "잘못된 접근입니다");
	}
	
	@PostMapping("/usr/member/verifyDormantAuth")
	@ResponseBody
	public ResultData<Map<String,Object>> verifyDormantAuth(String phoneNum, String authPin, String loginId) throws IOException, InterruptedException{
		
		String regExp = "^010[0-9]{7,8}$";

		if (phoneNum == null || !phoneNum.trim().matches(regExp)) {
			return ResultData.from("F-1", "올바른 전화번호의 형식이 아닙니다");
		} else if (loginId.trim().length() == 0) {
			return ResultData.from("F-1", "올바른 ID의 형식이 아닙니다");
		}
		
		Map<String, Object> map = Util.VerifyPhoneNum(phoneNum, authPin);
		
		Boolean exists = (Boolean) map.get("exists");
		
		if(!exists) {
			return ResultData.from("F-2", "인증에 실패하였습니다");
		}
		
		Member member = this.memberService.getMemberByLoginId(loginId);
		
		if(member == null || !member.getPhoneNumber().equals(phoneNum)) {
			return ResultData.from("F-3", "회원 정보와 인증된 휴대폰 번호가 일치하지 않습니다");
		}
		
		if(exists) {
			this.memberService.doReleaseDormantStatus(member.getId());
			return ResultData.from("S-1", "휴면 계정 보호가 완전히 해제되었습니다. 다시 로그인해 주세요!");
		}
		
		return ResultData.from("F-4", "잘못된 접근입니다");
	}

	@GetMapping("/usr/member/login")
	public String login() {
		return "usr/member/login";
	}

	@PostMapping("/usr/member/doLogin")
	@ResponseBody
	public ResultData<Map<String, Object>> doLogin(String loginId, String loginPw) {

		Member member = this.memberService.getMemberByLoginId(loginId);
		
		if (member == null) {
			return ResultData.from("F-1", String.format("[ %s ] 은(는) 존재하지 않는 회원입니다", loginId));
		} 
		
		
		Map<String, Object> rs = new HashMap<>();
		
		rs.put("loginId", member.getLoginId());
		rs.put("phoneNumber", member.getPhoneNumber());
		/*
		 * if (member == null) { return
		 * Util.jsReplace(String.format("[ %s ] 은(는) 존재하지 않는 회원입니다", loginId), "login");
		 * }
		 * 
		 * if (member.getLoginPw().equals(Util.encryptSHA256(loginPw)) == false) {
		 * return Util.jsReplace("비밀번호가 일치하지 않습니다", "login"); }
		 * 
		 * if (member.getStatus() == 1) { return
		 * Util.jsReplace("차단된 회원입니다 관리자에게 문의하세요.", "/"); 추가적으로 휴면, 탈퇴대기 관련 로직을 추가하여
		 * else if 문 추가 예정. } else if (member.getStatus() == 2) { return
		 * Util.jsReplace("휴면 상태의 계정입니다.", "/"); }
		 */
		
		 if (member.getLoginPw().equals(Util.encryptSHA256(loginPw)) == false) {
			return ResultData.from("F-2", "비밀번호가 일치하지 않습니다");
		} else if (member.getStatus() == 1) {
			return ResultData.from("F-3", "차단된 회원입니다 관리자에게 문의하세요");
		} else if (member.getStatus() == 2) {
			return ResultData.from("F-4", "장기 미접속으로 인해 현재 휴면 전환된 계정입니다. \n휴면 상태를 해제하시겠습니까?", rs);
		}

		this.req.login(new LoginedMember(member.getId(), member.getAuthLevel(), member.getStatus()));
		this.memberService.updateLoginDate(member.getId());

		/*
		 * return Util.jsReplace(String.format("[ %s ] 님 환영합니다", member.getLoginId()),
		 * "/usr/home/main");
		 */
		return ResultData.from("S-1",String.format("[ %s ] 님 환영합니다", member.getLoginId()));
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

		if (loginId.length() != 0 && newPassword.matches(regExp)) {
			this.memberService.doResetPassword(loginId, phoneNum, Util.encryptSHA256(newPassword));
			return ResultData.from("S-1", "정상적으로 비밀번호가 변경되었습니다");
		}
		return ResultData.from("F-1", "오류 발생");
	}

}