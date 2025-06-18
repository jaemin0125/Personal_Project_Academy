package com.example.demo.service;

import org.springframework.stereotype.Service;

import com.example.demo.dao.MemberDao;
import com.example.demo.dto.Member;

@Service
public class MemberService {

	private MemberDao memberDao;
	
	public MemberService(MemberDao memberDao) {
		this.memberDao = memberDao;
	}

	public void joinMember(String loginId, String loginPw, String name, String email, String address) {
		this.memberDao.joinMember(loginId, loginPw, name, email, address);
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

}