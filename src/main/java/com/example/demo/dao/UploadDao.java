package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.demo.dto.StickerPrice;
import com.example.demo.dto.WasteGuide;

@Mapper
public interface UploadDao {

	
	@Select("""
			SELECT *
				FROM wasteGuide
				WHERE label = #{resultLabel}
			""")
	WasteGuide getWasteGuide(String resultLabel);

	
	@Insert("""
			INSERT INTO searchLog
				SET label = #{label}
					, ko_label = #{ko_label}
					, category = #{category}
			""")
	void searchCnt(String label, String ko_label, String category);

	@Select("""
			SELECT *
				FROM stickerPrice
				WHERE label = #{label}
				AND region = #{region}
				ORDER BY price;
			""")
	List<StickerPrice> getStickerPrice(String label, String region);

	@Select("""
			SELECT * 
				FROM wasteGuide
				WHERE category = #{category}
				AND label != #{label}
				ORDER BY RAND()
				LIMIT 4
			""")
	List<WasteGuide> getRandomRelate(String category, String label);
}