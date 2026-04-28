package com.example.demo.dao;

import java.util.List;

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
				SET updateDate = NOW()
					,name = #{name}
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
				SET updateDate = NOW()
					, name = #{name}
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

	@Select("""
			<script>
				SELECT COUNT(id)
					FROM `member`
					<if test="authLevel != -1">
						WHERE authLevel = #{authLevel}
					</if>
			</script>
			""")
	int getMembersCnt(int authLevel);

	@Select("""
			<script>
				SELECT id
						, SUBSTR(regDate, 1, 10) regDate
						, SUBSTR(updateDate, 1, 10) updateDate
						, loginId
						, name
						, email
						, address
						, authLevel
				    FROM `member`
				    <if test="authLevel != -1">
				    	WHERE authLevel = #{authLevel}
				    </if>
					ORDER BY id DESC
					LIMIT #{limitFrom}, #{membersInPage}
			</script>
			""")
	List<Member> getMemberList(int membersInPage, int limitFrom, int authLevel);

	@Select("""
			SELECT SUBSTR(regDate, 1, 10) regDate
					, SUBSTR(updateDate, 1, 10) updateDate
					, loginId
					, name
					, email
					, address
					, status
					, authLevel
					FROM `member`
					WHERE id = #{id}
			""")
	Member getMemberById(int id);

	@Update("""
			UPDATE `member`
				SET updateDate = NOW()
					 ,authLevel = #{authLevel}
					 , status = #{status}
				WHERE id = #{id}
			""")
	void doModifyMemberInfo(int id, int authLevel, int status);

	@Update("""
			UPDATE `member`
				SET lastLoginDate = NOW()
				WHERE id = #{id};
			""")
	void updateLoginDate(int id);

}