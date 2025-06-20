package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.StickerPrice;
import com.example.demo.dto.WasteGuide;

@Mapper
public interface WasteGuideDao {

	
	@Select("""
			SELECT *
				FROM wasteGuide
				ORDER BY updateDate DESC
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


	@Select("""
			SELECT *
				FROM wasteGuide
			""")
	List<WasteGuide> getTotalGuide();

	@Insert("""
			INSERT INTO wasteGuide
				SET label = #{label}
					, ko_label = #{ko_label}
					, category = #{category}
					, guide = #{guide}
					, wasteType = #{wasteType}
					, thumbnail = #{thumbnail}
					, updateDate = NOW()
			""")
	void doAddWaste(String label, String ko_label, String category, String guide, String wasteType, String thumbnail);

	@Update("""
			UPDATE wasteGuide
				SET label = #{label}
					, ko_label = #{ko_label}
					, category = #{category}
					, guide = #{guide} 
					, wasteType = #{wasteType}
					, updateDate = NOW()
					WHERE id = #{wasteId}
			""")
	void doModifyWaste(int wasteId, String label, String ko_label, String category, String guide, String wasteType);

	
	@Select("""
			SELECT *
				FROM wasteGuide
				WHERE id = #{wasteId}
			""")
	WasteGuide getWasteGuideById(int wasteId);

	@Delete("""
			DELETE
				FROM wasteGuide
				WHERE id = #{wasteId}
			""")
	void doDeleteWaste(int wasteId);

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
	List<WasteGuide> getRandeomRelate(String category, String label);

	@Delete("""
			DELETE FROM searchLog
				WHERE label = #{label}
			""")
	void doDeleteSearchKeyword(String label);
	
	@Select("""
		    <script>
		        SELECT *
		        FROM wasteGuide
		        WHERE id IN 
		        <foreach item="id" collection="relIds" open="(" separator="," close=")">
		            #{id}
		        </foreach>
		    </script>
		""")
		List<WasteGuide> getWasteGuideListByrelIds(@Param("relIds") List<Integer> relIds);

	@Select("""
			SELECT label
				FROM wasteGuide
				WHERE ko_label LIKE CONCAT('%', #{ko_label}, '%')
				LIMIT 1
			""")
	String checkLabelExist(String ko_label);
}