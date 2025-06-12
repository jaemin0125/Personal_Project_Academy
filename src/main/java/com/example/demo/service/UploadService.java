package com.example.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.UploadDao;
import com.example.demo.dto.Article;
import com.example.demo.dto.StickerPrice;
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

	public void searchCnt(String label, String ko_label, String category) {
		this.uploadDao.searchCnt(label, ko_label, category);
	}

	public List<WasteGuide> getKeywordList() {
		return this.uploadDao.getKeywordList();
	}

	public List<WasteGuide> getTotalGuide() {
		return this.uploadDao.getTotalGuide();
	}

	public void doAddWaste(String label, String ko_label, String category, String guide, String wasteType, String thumbnail) {
		this.uploadDao.doAddWaste(label, ko_label, category, guide, wasteType, thumbnail);
	}

	public void doModifyWaste(int wasteId, String label, String ko_label, String category, String guide, String wasteType) {
		this.uploadDao.doModifyWaste(wasteId, label, ko_label, category, guide, wasteType);
		
	}

	public WasteGuide getWasteGuideById(int wasteId) {
		return this.uploadDao.getWasteGuideById(wasteId);
	}

	public void doDeleteWaste(int wasteId) {
		this.uploadDao.doDeleteWaste(wasteId);
	}

	public List<StickerPrice> getStickerPrice(String label, String region) {
		return this.uploadDao.getStickerPrice(label, region);
	}

	public List<WasteGuide> getRandomRelated(String category, String label) {
		return this.uploadDao.getRandeomRelate(category, label);
	}

	public void doDeleteSearchKeyword(String label) {
		this.uploadDao.doDeleteSearchKeyword(label);
	}

}	