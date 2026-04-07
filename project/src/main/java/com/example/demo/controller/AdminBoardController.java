package com.example.demo.controller;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Board;
import com.example.demo.service.BoardService;
import com.example.demo.util.Util;

@Controller
public class AdminBoardController {
	private BoardService boardService;

	public AdminBoardController(BoardService boardService) {
		this.boardService = boardService;
	}
	
	@GetMapping("/admin/board/list")
	public String modifyBoard(Model model) {
		
		List<Board> boards = this.boardService.getBoards();
		
		model.addAttribute("boards", boards);   
		
		return "admin/board/list";
	}
	
	@GetMapping("/admin/board/doAddBoard")
	@ResponseBody
	public String doAddBoard(String boardName) {
		
		this.boardService.doAddBoard(boardName);
		
		return Util.jsReplace("게시판 생성 완료", "/admin/board/list");
	}
	
	@GetMapping("/admin/board/doModifyBoard")
	@ResponseBody
	public String doModify(int boardId, String boardName) {
		
		this.boardService.doModfiyBoard(boardId, boardName);
		
		return Util.jsReplace("게시판 수정 완료", "/admin/board/list");
	}
	
	@GetMapping("/admin/board/doDeleteBoard")
	@ResponseBody
	public String doDelete(int boardId) {
		
		this.boardService.doDeleteBoard(boardId);
		
		return Util.jsReplace("게시판 삭제 완료", "/admin/board/list");
	}
	
	@GetMapping("/admin/board/doGetBoardInfo")
	@ResponseBody
	public Board doGetBoardName(int boardId) {
		
		Board boardInfo = this.boardService.doGetBoardInfo(boardId);
		
		return boardInfo;
	}
	
	@GetMapping("/admin/board/doUpdateSort")
	@ResponseBody
	public String doUpdateOrder(@RequestParam("ids") List<Integer> ids) {
		
		
		for(int i = 0; i < ids.size() ; i++) {
			int boardId = ids.get(i);
			int newSortId = i + 1;
			
			this.boardService.doUpdateSort(boardId, newSortId);
		}
		
		return Util.jsReplace("게시판 순서가 변경되었습니다.", "/admin/board/list");
	}
	
}