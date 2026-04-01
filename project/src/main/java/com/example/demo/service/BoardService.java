package com.example.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.BoardDao;
import com.example.demo.dto.Board;

@Service
public class BoardService {

	private BoardDao boardDao;
	
	public BoardService(BoardDao boardDao) {
		this.boardDao = boardDao;
	}

	public Board getBoardBySortId(int boardId) {
		return this.boardDao.getBoardBySortId(boardId);
	}

	public void doAddBoard(String boardName) {
		this.boardDao.doAddBoard(boardName);
	}

	public List<Board> getBoards() {
		return this.boardDao.getBoards();
	}

	public void doModfiyBoard(int boardId, String boardName) {
		this.boardDao.doModifyBoard(boardId, boardName);
	}

	public void doDeleteBoard(int boardId) {
		this.boardDao.doDeleteBoard(boardId);
	}

	public Board doGetBoardInfo(int boardId) {
		return this.boardDao.doGetBoardInfo(boardId);
	}

	public void doUpdateSort(int boardId, int newSortId) {
		this.boardDao.doUpdateSort(boardId, newSortId);
	}

}