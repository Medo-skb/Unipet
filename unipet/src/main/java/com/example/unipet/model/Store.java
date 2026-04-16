package com.example.unipet.model;

import lombok.Data;

@Data
public class Store {
	private String storeName;
	private String sCategory;
	private String isOpen;
	private String sAddr;
	private String sFullAddr;
	private String storeType;
	private double lat;
	private double lng;
}
