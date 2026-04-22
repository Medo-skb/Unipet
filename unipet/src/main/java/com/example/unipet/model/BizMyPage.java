package com.example.unipet.model;

import lombok.Data;

@Data
public class BizMyPage {
	
	// STORE
	int storeNo;
	String storeName;
	String sCategory;
	String biznum;
	String isOpen;
	String accName;
	String accNo;
	String accHolder;
	String sAddr;
	String sFullAddr;
	
	// DETAIL
	String subTitle;
	String sContents;

	// POLICY
	Integer slot;
	Integer capacity;
	Integer cutoff;
	String openTime;
	String closeTime;
	String breakStart;
	String breakEnd;
	String offDay;
	String refundPolicy;

	// STORE_FILE
	int fileNo;
	String filePath;
	String fileName;
	String originName;
	String isMain;
	Long fileSize;
	String fileExt;

	// STORE_MENU
	int menuNo;
	String menuName;
	String menuInfo;
	Integer menuPrice;
	Integer reqTime;
	String mStatus;
	String mStatusName;
	String menuCategory;
	
	// STORE_USER
	String sUserId;
	String ceoName;
}
