package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WasteGuide {
	private int id;
	private String label;
	private String ko_label;
	private String category;
	private String guide;
	private String wasteType;
	private String thumbnail;
	private String regDate;

	public String getForPrintGuide() {
	    return this.guide.replaceAll("\\.\\s+", ".<br />");
	}

}
