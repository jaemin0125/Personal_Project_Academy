package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.LikePoint;
import com.example.demo.dto.Req;
import com.example.demo.dto.ResultData;
import com.example.demo.service.LikePointService;

@Controller
public class UsrLikePointController {

	private LikePointService likePointService;
	private Req req;

	public UsrLikePointController(LikePointService likePointService, Req req) {
		this.likePointService = likePointService;
		this.req = req;
	}

	@PostMapping("/usr/likePoint/clickLikePoint")
	@ResponseBody
	public String clickLikePoint(String relTypeCode, int relId, boolean likePointBtn) {
		
		if (likePointBtn) {
			this.likePointService.deleteLikePoint(this.req.getLoginedMember().getId(), relTypeCode, relId);
			return "좋아요 취소";
		}
		
		this.likePointService.insertLikePoint(this.req.getLoginedMember().getId(), relTypeCode, relId);
		return "좋아요 추가";
	}
	
	@GetMapping("/usr/likePoint/getLikePoint")
	@ResponseBody
	public ResultData<Integer> getLikePoint(String relTypeCode, int relId) {
		
		LikePoint likePoint = this.likePointService.getLikePoint(this.req.getLoginedMember().getId(), relTypeCode, relId);
		int likePointCnt = this.likePointService.getLikePointCnt(relTypeCode, relId);
		
		if (likePoint == null) {
			return ResultData.from("F-1", "좋아요 정보 조회 실패", likePointCnt);
		}
		
		return ResultData.from("S-1", "좋아요 정보 조회 성공", likePointCnt);
	}

}