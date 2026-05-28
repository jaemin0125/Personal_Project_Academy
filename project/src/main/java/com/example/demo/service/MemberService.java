package com.example.demo.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.example.demo.dao.MemberDao;
import com.example.demo.dto.Member;

@Service
public class MemberService {

	private MemberDao memberDao;
	
	public MemberService(MemberDao memberDao) {
		this.memberDao = memberDao;
	}
	
	@Scheduled(cron = "0 0 4 * * *")
	public void checkAndConvertDormantMembers() {
		LocalDateTime oneYearAgo = LocalDateTime.now().minusYears(1);
		
		this.memberDao.checkAndConvertDormantMembers(oneYearAgo);
	}

	public void joinMember(String loginId, String loginPw, String name, String email, String address, String phoneNum) {
		this.memberDao.joinMember(loginId, loginPw, name, email, address, phoneNum);
	}

	public Member getMemberByLoginId(String loginId) {
		return this.memberDao.getMemberByLoginId(loginId);
	}
	
	public String getLoginId(int id) {
		return this.memberDao.getLoginId(id);
	}

	public void doModifyMember(String loginedMemberId, String name, String email, String address, String loginPw) {
		this.memberDao.doModifyMember(loginedMemberId, name, email,address, loginPw);
	}

	public void modfiyWithOutPw(String loginedMemberId, String name, String email, String address) {
		this.memberDao.modifyWithOutPw(loginedMemberId, name, email,address);
	}

	public Member getLoginedMemberById(int id) {
		return this.memberDao.getLoginedMemberById(id);
	}

	public int getMembersCnt(int authLevel) {
		return this.memberDao.getMembersCnt(authLevel);
	}

	public List<Member> getMembersList(int membersInPage, int limitFrom, int authLevel) {
		return this.memberDao.getMemberList(membersInPage, limitFrom, authLevel);
	}

	public Member getMemberById(int id) {
		return this.memberDao.getMemberById(id);
	}

	public void doModifyMemberInfo(int id, int authLevel, int status) {
		this.memberDao.doModifyMemberInfo(id, authLevel, status);
	}

	public void updateLoginDate(int id) {
		this.memberDao.updateLoginDate(id);
	}

	public int phoneNumDupChk(String phoneNum) {
		return this.memberDao.phoneNumDupChk(phoneNum);
	}

	public String getMemberByPhoneNumber(String phoneNum) {
		return this.memberDao.getMemberByPhoneNumber(phoneNum);
	}

	public int getIdCntByInfo(String phoneNum, String loginId) {
		return this.memberDao.getIdCntByInfo(phoneNum, loginId);
	}

	public void doResetPassword(String loginId, String phoneNum, String newPassword) {
		this.memberDao.doResetPassword(loginId, phoneNum, newPassword);
	}

	public void doReleaseDormantStatus(int id) {
		this.memberDao.doReleaseDormantStatus(id);
	}

}