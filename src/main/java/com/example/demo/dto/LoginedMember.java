package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LoginedMember {
	private int id;
	private int authLevel;
	private String loginedMemberId;
	private String loginedMemberPw;
	private String name;
	private String email;
	private String address;
}