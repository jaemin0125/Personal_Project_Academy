package com.example.demo.service;

import org.springframework.stereotype.Service;

import com.example.demo.dao.LikePointDao;
import com.example.demo.dto.LikePoint;

@Service
public class LikePointService {

	private LikePointDao likePointDao;
	
	public LikePointService(LikePointDao likePointDao) {
		this.likePointDao = likePointDao;
	}

	public void insertLikePoint(int id, String relTypeCode, int relId) {
		this.likePointDao.insertLikePoint(id, relTypeCode, relId);
	}

	public LikePoint getLikePoint(int id, String relTypeCode, int relId) {
		return this.likePointDao.getLikePoint(id, relTypeCode, relId);
	}

	public int getLikePointCnt(String relTypeCode, int relId) {
		return this.likePointDao.getLikePointCnt(relTypeCode, relId);
	}

	public void deleteLikePoint(int id, String relTypeCode, int relId) {
		this.likePointDao.deleteLikePoint(id, relTypeCode, relId);
	}
}