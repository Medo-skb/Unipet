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
	String sUserPwd;
	String ceoName;
	
	// 예약 건수 조회
	Integer todayReservationCount;
	Integer weekReservationCount;
	Integer completeReservationCount;
	Integer reserveCount;
	String rsvDate;
	
	// 예약 목록
	String rsvNo;
	String userName;
	String phone;
	String rsvTime;
	String rsvDateTime;
	String rsvStatus;
	String rsvStatusName;
	String request;

	// PET
	String petName;
	String species;
	String breed;
	String birthdate;
	String gender;
	
	// 리뷰 요약
	Integer totalReviewCount;
	Double avgRating;
	Double recentReviewRating;
	
	// 리뷰 목록
	Integer reviewNo;
	String nickname;
	Integer rating;
	String rContents;
	String reviewDate;
	String isReported;
}
