package com.example.demo.dao;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.demo.dto.LikePoint;

@Mapper
public interface LikePointDao {

	@Insert("""
			INSERT INTO likePoint
				SET memberId = #{id}
					, relTypeCode = #{relTypeCode}
					, relId = #{relId}
			""")
	void insertLikePoint(int id, String relTypeCode, int relId);

	@Select("""
			SELECT *
				FROM likePoint
				WHERE memberId = #{id}
				AND relTypeCode = #{relTypeCode}
				AND relId = #{relId}
			""")
	LikePoint getLikePoint(int id, String relTypeCode, int relId);

	@Select("""
			SELECT COUNT(*)
				FROM likePoint
				WHERE relTypeCode = #{relTypeCode}
				AND relId = #{relId}
			""")
	int getLikePointCnt(String relTypeCode, int relId);

	@Delete("""
			DELETE FROM likePoint
				WHERE memberId = #{id}
				AND relTypeCode = #{relTypeCode}
				AND relId = #{relId}
			""")
	void deleteLikePoint(int id, String relTypeCode, int relId);
}