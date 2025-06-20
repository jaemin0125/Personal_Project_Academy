package com.example.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.WasteGuideDao;
import com.example.demo.dto.StickerPrice;
import com.example.demo.dto.WasteGuide;

@Service
public class WasteGuideService {
	private WasteGuideDao wasteGuideDao;
	
	public WasteGuideService(WasteGuideDao wasteGuideDao) {
		this.wasteGuideDao = wasteGuideDao;
	}
	
	public List<WasteGuide> getAddedObject() {
		return this.wasteGuideDao.getAddedObject();
	}

	public WasteGuide getWasteGuide(String resultLabel) {
		return this.wasteGuideDao.getWasteGuide(resultLabel);
	}

	public void searchCnt(String label, String ko_label, String category) {
		this.wasteGuideDao.searchCnt(label, ko_label, category);
	}

	public List<WasteGuide> getKeywordList() {
		return this.wasteGuideDao.getKeywordList();
	}

	public List<WasteGuide> getTotalGuide() {
		return this.wasteGuideDao.getTotalGuide();
	}

	public void doAddWaste(String label, String ko_label, String category, String guide, String wasteType, String thumbnail) {
		this.wasteGuideDao.doAddWaste(label, ko_label, category, guide, wasteType, thumbnail);
	}

	public void doModifyWaste(int wasteId, String label, String ko_label, String category, String guide, String wasteType) {
		this.wasteGuideDao.doModifyWaste(wasteId, label, ko_label, category, guide, wasteType);
		
	}

	public WasteGuide getWasteGuideById(int wasteId) {
		return this.wasteGuideDao.getWasteGuideById(wasteId);
	}

	public void doDeleteWaste(int wasteId) {
		this.wasteGuideDao.doDeleteWaste(wasteId);
	}

	public List<StickerPrice> getStickerPrice(String label, String region) {
		return this.wasteGuideDao.getStickerPrice(label, region);
	}

	public List<WasteGuide> getRandomRelated(String category, String label) {
		return this.wasteGuideDao.getRandeomRelate(category, label);
	}

	public void doDeleteSearchKeyword(String label) {
		this.wasteGuideDao.doDeleteSearchKeyword(label);
	}

	public List<WasteGuide> getWasteGuideListByrelIds(List<Integer> relIds) {
		return this.wasteGuideDao.getWasteGuideListByrelIds(relIds);
	}

	public String checkLabelExist(String ko_label) {
		return this.wasteGuideDao.checkLabelExist(ko_label);
	}

}	