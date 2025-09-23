package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class StickerPrice {
	private int id;
	private String label;
	private String subType;
	private String region;
	private int price;
	private String unit;

}
