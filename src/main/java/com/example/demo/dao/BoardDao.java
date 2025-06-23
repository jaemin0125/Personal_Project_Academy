package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.Board;

@Mapper
public interface BoardDao {
	
	@Select("""
			SELECT *
				FROM board
				WHERE id = #{boardId} 
			""")
	Board getBoard(int boardId);
	
	
	@Insert("""
			INSERT INTO board
				SET name = #{boardName}
			""") 
	void doAddBoard(String boardName);

	@Select("""
			SELECT *
				FROM board
			""")
	List<Board> getBoards();

	@Update("""
			UPDATE board
				SET name = #{boardName}
				WHERE id = #{boardId}
			""")
	void doModifyBoard(int boardId, String boardName);

	@Delete("""
			DELETE FROM board
				WHERE id = #{boardId}
			""")
	void doDeleteBoard(int boardId);
}