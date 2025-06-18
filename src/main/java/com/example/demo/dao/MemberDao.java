package com.example.demo.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.Member;

@Mapper
public interface MemberDao {

	@Insert("""
			INSERT INTO `member`
			    SET regDate = NOW()
			        , updateDate = NOW()
			        , loginId = #{loginId}
			        , loginPw = #{loginPw}
			        , `name` = #{name}
			        , email = #{email}
			        , address = #{address}
			""")
	void joinMember(String loginId, String loginPw, String name, String email, String address);

	@Select("""
			SELECT *
				FROM `member`
				WHERE loginId = #{loginId}
			""")
	Member getMemberByLoginId(String loginId);

	@Update("""
			UPDATE `member`
				SET name = #{name}
					, email = #{email}
					, address = #{address}
					, loginPw = #{loginPw}
					WHERE loginId = #{loginedMemberId}
			""")
	void doModifyMember(String loginedMemberId, String name, String email, String address, String loginPw);
	
	@Select("""
			SELECT loginId
				FROM `member`
				WHERE id = #{id}
			""")
	String getLoginId(int id);
	
	@Update("""
			UPDATE `member`
				SET name = #{name}
					, email = #{email}
					, address = #{address}
					WHERE loginId = #{loginedMemberId}
			""")
	void modifyWithOutPw(String loginedMemberId, String name, String email, String address);

	
	@Select("""
			SELECT *
				FROM `member`
				WHERE id = #{id}
			""")
	Member getLoginedMemberById(int id);
	
}