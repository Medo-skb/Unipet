package com.example.unipet.model;

import lombok.Data;

@Data
public class Admin {
	
	// ADMIN
	String adminId;
	String adminPwd;
	String adminName;
	
	// STORE
	int storeNo;
	String storeName;
	String sCategory;
	String sAddr;
	String sFullAddr;
	String sStatus;
	String lat;
	String lng;

	// STORE_USER
	String sUserId;
	String ceoName;
	String bizFileName;
	String uStatus;

	// STORE_SUBMIT
	String submitStatus;

    // STORE_FILE / 공통 파일
    String filePath;
    String fileName;
    String originName;

    // 리뷰 신고 관련
    int reportNo; 
    int reviewNo;         
    String userId;      
    String reporterId;   
    String repStatus;   
    String rContents;
    String reportReason;

    String reviewType;

    // 상품 리뷰용
    String productName; 
    Integer ordNo; 

    // 예약 리뷰용
    Integer rsvNo;
    
    // 커뮤니티 신고 관련
    int targetNo;
    int boardNo;
    String reportedUserId;
    String contents;
    String title;
	    
    // QNA
    int qnaNo;
    int productNo;
    String qnaTitle;
    String qContents;
    String isSecret;
    String ansStatus;
    String aContents;

    // 유저 정보
    String userName;
    String nickname;
    String email;
    String phone;
    String userAddr;
    String fullAddr;
    String zipcode;
    String socialtype;
    String userStatus;
    String cdate;

    // 관리자 회원조회 집계
    int reportCount;
    int petCount;
    int pointTotal;
    int couponCount;
    int orderCount;
    int reservationCount;
    int reviewCount;
    int communityCount;
    String subscriptionYn;

    // PET
    int petNo;
    String petName;
    String species;
    String breed;
    String birthdate;
    String gender;

    // SUBSCRIPTION
    String sDate;
    String eDate;
    String nDate;
    Integer subPrice;
    String subStatus;

    // USER_POINT
    int pointNo;
    Integer pointAmount;

    // USER_COUPON
    int ucpNo;
    String couponName;
    String cpStatus;
    String useDate;
    String expDate;

    // ORDERS
    Integer couponNo;
    Integer disPrice;
    Integer totalPrice;
    String ordStatus;
    String ordAddr;
    String deliStatus;
    String ordDate;

    // RESERVATION
    String rsvDate;
    String rsvStartTime;
    String rsvEndTime;
    Integer petNoObj;
    Integer menuNo;
    String menuName;
    String rsvStatus;

    // REVIEW
    String rating;

    // 커뮤니티
    int commentNo;
    String cContent;
    String udate;

    // 신고 상세
    String reportType;
    String targetTitle;
    String targetContent;
}