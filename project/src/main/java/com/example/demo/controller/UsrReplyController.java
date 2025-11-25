package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Reply;
import com.example.demo.dto.Req;
import com.example.demo.service.ReplyService;

@Controller
public class UsrReplyController {

	private ReplyService replyService;
	private Req req;

	public UsrReplyController(ReplyService replyService, Req req) {
		this.replyService = replyService;
		this.req = req;
	}

	@PostMapping("/usr/reply/doWrite")
	@ResponseBody
	public int doWrite(String relTypeCode, int relId, String content) {
		
		this.replyService.writeReply(req.getLoginedMember().getId(), relTypeCode, relId, content);
		
		return this.replyService.getLastInsertReplyId();
	}
	
	@GetMapping("/usr/reply/getReply")
	@ResponseBody
	public Reply getReply(int id) {
		return this.replyService.getReplyById(id);
	}
	
	@GetMapping("/usr/reply/list")
	@ResponseBody
	public List<Reply> list(String relTypeCode, int relId) {
		return this.replyService.getReplies(relTypeCode, relId);
	}
	
	@PostMapping("/usr/reply/delete")
	@ResponseBody
	public boolean delete(int id) {
		
		Reply reply = this.replyService.getReplyById(id);
		
		if(reply.getMemberId() != req.getLoginedMember().getId() && req.getLoginedMember().getAuthLevel() != 0) {
			return false;
		}
		
		this.replyService.deleteReply(id);
		return true;
	}
	
	@PostMapping("/usr/reply/modify")
	@ResponseBody
	public boolean modify(int id, String content) {
		
		Reply reply = this.replyService.getReplyById(id);
		
		if(reply.getMemberId() != req.getLoginedMember().getId()) {
			return false;
		}
		
		this.replyService.modifyReply(id, content);
		return true;
	}
}