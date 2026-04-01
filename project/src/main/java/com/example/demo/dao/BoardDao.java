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
				WHERE sort_id = #{sortId} 
			""")
	Board getBoardBySortId(int sortId);
	
	
	@Insert("""
			INSERT INTO board
				SET name = #{boardName}
					, sort_id = (SELECT IFNULL(MAX(sort_id), 0) + 1 FROM board AS B); 
			""") 
	void doAddBoard(String boardName);

	@Select("""
			SELECT *
				FROM board
				ORDER BY sort_id;
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

	@Select("""
			SELECT * 	
				FROM board
				WHERE id = #{boardId}
			""")
	Board doGetBoardInfo(int boardId);

	@Update("""
			UPDATE board
				SET sort_id = #{newSortId}
				WHERE id = #{boardId}
			""")
	void doUpdateSort(int boardId, int newSortId);
}