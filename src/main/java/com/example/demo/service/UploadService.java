package com.example.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.UploadDao;
import com.example.demo.dto.WasteGuide;

@Service
public class UploadService {
	private UploadDao uploadDao;
	
	public UploadService(UploadDao uploadDao) {
		this.uploadDao = uploadDao;
	}
	
	public List<WasteGuide> getAddedObject() {
		return this.uploadDao.getAddedObject();
	}

	public WasteGuide getWasteGuide(String resultLabel) {
		return this.uploadDao.getWasteGuide(resultLabel);
	}

	public void searchCnt(String ko_label, String category) {
		this.uploadDao.searchCnt(ko_label, category);
	}

	public List<String> getKeywordList() {
		return this.uploadDao.getKeywordList();
	}

}	