package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.Req;
import com.example.demo.service.ArticleService;
import com.example.demo.service.BoardService;
import com.example.demo.util.Util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UsrArticleController {

	private ArticleService articleService;
	private BoardService boardService;
	private Req req;

	public UsrArticleController(ArticleService articleService, BoardService boardService, Req req) {
		this.articleService = articleService;
		this.boardService = boardService;
		this.req = req;
	}

	@GetMapping("/usr/article/write")
	public String write() {
		return "usr/article/write";
	}

	@PostMapping("/usr/article/doWrite")
	@ResponseBody
	public String doWrite(String title, String content, int boardId) {

		this.articleService.writeArticle(title, content, this.req.getLoginedMember().getId(), boardId);

		int id = this.articleService.getLastArticleId();

		return Util.jsReplace("게시글 작성!", String.format("detail?id=%d", id));
	}

	@GetMapping("/usr/article/list")
	public String list(Model model, @RequestParam(defaultValue = "1") int boardId, @RequestParam(defaultValue = "1") int cPage,
			@RequestParam(defaultValue = "title") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword) {

		int articlesInPage = 10;
		int limitFrom = (cPage - 1) * articlesInPage;

		int articlesCnt = this.articleService.getArticlesCnt(boardId, searchType, searchKeyword);

		int totalPagesCnt = (int) Math.ceil(articlesCnt / (double) articlesInPage);

		int begin = ((cPage - 1) / 10) * 10 + 1;
		int end = (((cPage - 1) / 10) + 1) * 10;

		if (end > totalPagesCnt) {
			end = totalPagesCnt;
		}

		Board board = this.boardService.getBoard(boardId);
		List<Article> articles = this.articleService.getArticles(boardId, articlesInPage, limitFrom, searchType,
				searchKeyword);
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("cPage", cPage);
		model.addAttribute("begin", begin);
		model.addAttribute("end", end);
		model.addAttribute("totalPagesCnt", totalPagesCnt);
		model.addAttribute("articlesCnt", articlesCnt);
		model.addAttribute("articles", articles);
		model.addAttribute("board", board);

		return "usr/article/list";
	}

	@GetMapping("/usr/article/detail")
	public Object detail(HttpServletRequest request, HttpServletResponse response, Model model, int id) {

		Cookie[] cookies = request.getCookies();
		boolean isViewed = false;
		
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("viewedArticle_" + id)) {
					isViewed = true;
					break;
				}
			}
		}
		
		if (!isViewed) {
			this.articleService.increaseViews(id);
			Cookie cookie = new Cookie("viewedArticle_" + id, "true");
			cookie.setMaxAge(60 * 30);
			response.addCookie(cookie);
		}
		
		Article article = this.articleService.getArticleById(id);
		
		model.addAttribute("article", article);

		return "usr/article/detail";
	}

	@GetMapping("/usr/article/modify")
	public String modify(Model model, int id) {

		Article article = this.articleService.getArticleById(id);

		model.addAttribute("article", article);

		return "usr/article/modify";
	}

	@PostMapping("/usr/article/doModify")
	@ResponseBody
	public String doModify(int id, String title, String content) {

		this.articleService.modifyArticle(id, title, content);

		return Util.jsReplace(String.format("%d번 게시물을 수정했습니다", id), String.format("detail?id=%d", id));
	}

	@GetMapping("/usr/article/delete")
	@ResponseBody
	public String delete(int id, int boardId) {

		this.articleService.deleteArticle(id);

		return Util.jsReplace(String.format("%d번 게시글이 삭제되었습니다", id), String.format("list?boardId=%d", boardId));
	}
}