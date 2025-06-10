package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.demo.dto.WasteGuide;

@Mapper
public interface UploadDao {

	
	@Select("""
			SELECT *
				FROM wasteGuide
				ORDER BY reg_date DESC
				LIMIT 10
			""")
	List<WasteGuide> getAddedObject();

	
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
			    FROM searchLog
			    WHERE search_time >= DATE_SUB(NOW(), INTERVAL 7 DAY)
			    GROUP BY ko_label
			    ORDER BY COUNT(id) DESC
			    LIMIT 10;
			""")
	List<WasteGuide> getKeywordList();
}