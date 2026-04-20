package com.example.unipet.model;

import lombok.Data;

@Data
public class Main {

    // 업체 정보
    int storeNo;
    String storeName;
    String sCategory;
    String sAddr;
    String sCategoryName;
    String popularMenuName;
    String menuName1;
    Integer menuPrice1;
    
    // 상품 정보
	int productNo;
	String productName;
	int productPrice;
	int iSubNo;
	String iSubType;
	int aMainNo;
	String aMainType;
	String brand;
	String aSubType;
	double rating;
	int reviewCount;
	
	
	// 커뮤니티
	int boardNo;
	String title;
	String bContent;
	int bMainNo;
	
	// 사진
	String filePath;
	String fileName;
	
	
}