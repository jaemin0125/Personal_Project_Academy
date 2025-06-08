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
	    private String category;
	    private String guide;
	    private String thumbnail;
	    private String regDate;
	}
