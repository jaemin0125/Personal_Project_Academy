package com.example.demo.dao;

import java.util.List;

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
			SELECT guide
				FROM wasteGuide
				WHERE label = #{label}
			""")
	String getWasteGuide(String label);
}