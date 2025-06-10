package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Board;
import com.example.demo.dto.Req;
import com.example.demo.service.BoardService;
import com.example.demo.util.Util;


@Controller
public class UsrBoardController {
	private BoardService boardService;
	private Req req;

	public UsrBoardController(BoardService boardService, Req req) {
		this.boardService = boardService;
		this.req = req;
	}
	
	@GetMapping("/usr/board/modify")
	public String modifyBoard(Model model) {
		
		if(req.getLoginedMember().getId() == 0 || req.getLoginedMember().getAuthLevel() !=0) {
			return "redirect:/usr/home/main";
		}
		
		List<Board> boards = this.boardService.getBoards();
		
		model.addAttribute("boards", boards);   
		
		return "usr/board/modify";
	}
	
	@GetMapping("/usr/board/doAddBoard")
	@ResponseBody
	public String doAddBoard(String boardName) {
		
		if(req.getLoginedMember().getId() == 0 || req.getLoginedMember().getAuthLevel() !=0) {
			return Util.jsReplace("관리자만 접근 가능합니다", "/");
		}
		
		this.boardService.doAddBoard(boardName);
		
		return Util.jsReplace("게시판 생성 완료", "/usr/article/list");
	}
	
	@GetMapping("/usr/board/doModifyBoard")
	@ResponseBody
	public String doModify(int boardId, String boardName) {
		
		if(req.getLoginedMember().getId() == 0 || req.getLoginedMember().getAuthLevel() !=0) {
			return Util.jsReplace("관리자만 접근 가능합니다", "/");
		}
		
		this.boardService.doModfiyBoard(boardId, boardName);
		
		return Util.jsReplace("게시판 수정 완료", "/usr/article/list");
	}
	
	@GetMapping("/usr/board/doDeleteBoard")
	@ResponseBody
	public String doDelete(int boardId) {
		
		if(req.getLoginedMember().getId() == 0 || req.getLoginedMember().getAuthLevel() !=0) {
			return Util.jsReplace("관리자만 접근 가능합니다", "/");
		}
		
		this.boardService.doDeleteBoard(boardId);
		
		return Util.jsReplace("게시판 삭제 완료", null);
	}
	
}