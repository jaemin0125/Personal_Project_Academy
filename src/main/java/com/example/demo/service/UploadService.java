package com.example.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.UploadDao;
import com.example.demo.dto.StickerPrice;
import com.example.demo.dto.WasteGuide;

@Service
public class UploadService {
	private UploadDao uploadDao;

	public UploadService(UploadDao uploadDao) {
		this.uploadDao = uploadDao;
	}
	
	public WasteGuide getWasteGuide(String resultLabel) { 
		return this.uploadDao.getWasteGuide(resultLabel);
	}

	public void searchCnt(String label, String ko_label, String category) {  
		this.uploadDao.searchCnt(label, ko_label, category);
	}

	public List<StickerPrice> getStickerPrice(String label, String region) {  
		return this.uploadDao.getStickerPrice(label, region);
	}

	public List<WasteGuide> getRandomRelated(String category, String label) { 
		return this.uploadDao.getRandomRelate(category, label);
	}

}	