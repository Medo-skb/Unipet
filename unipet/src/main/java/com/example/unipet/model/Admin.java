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
	String biznum;
	String isOpen;
	String accName;
	String accNo;
	String accHolder;

	// STORE_USER
	String sUserId;
	String ceoName;
	String bizFileName;
	String uStatus;

	// STORE_SUBMIT
	String submitStatus;

	// STORE_FILE / PRODUCT_FILE / 공통 파일
	String filePath;
	String fileName;
	String originName;
	Long fileSize;
	String fileExt;
	String isProof;
	String isMain;
	String isDetail;
	
	// 리뷰 신고 관련
	int reportNo; 
	Integer reviewNo;         
	String userId;      
	String reporterId;   
	String repStatus;   
	String rContents;
	String reportReason;
	int reportCount;
	
    String reviewType;

    // 상품
    String productName;
    String brand;
    Integer productPrice;
    Integer stockQty;
    String productStatus;
    Integer aMainNo;
    Integer aSubNo;
    Integer iMainNo;
    Integer iSubNo;
    String aMainType;
    String aSubType;
    String iMainType;
    String iSubType;
    

    // 상품 리뷰용
    Integer ordNo; 

    // 예약 리뷰용
    Integer rsvNo;
    
    // 커뮤니티 신고 관련
    int targetNo;
    int boardNo;
    String reportedUserId;
    String contents;
    String title;
    String createTime;
	    
    // QNA
    int qnaNo;
    int productNo;
    String qnaTitle;
    String qContents;
    String isSecret;
    String ansStatus;
    String aContents;

    // 통합 문의 관리용
    String qnaCategory;
    String qnaCategoryName;
    String unaType;

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
    int repCount;
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
    String caution;
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

    // ORDER_DETAIL
    Integer productKindCount;
    Integer ordQty;
    Integer unitPrice;
    Integer productTotalPrice;

    // RESERVATION
    String rsvDate;
    String rsvStartTime;
    String rsvEndTime;
    Integer petNoObj;
    Integer menuNo;
    String menuName;
    String rsvStatus;
    int totalReservationCount;
    int activeReservationCount;
    int cancelReservationCount;
    
    // REVIEW
    String rating;
    String avgRating;

    // 커뮤니티
    int commentNo;
    String cContent;
    String udate;

    // 신고 상세
    String reportType;
    String targetTitle;
    String targetContent;
    
    // 사업자 회원조회 집계
    int accReportCount;
    int rejReportCount;

    // STORE_MENU
    Integer menuPrice;
    String menuStatus;

    // STORE_POLICY
    Integer slot;
    Integer capacity;
    String openTime;
    String closeTime;
    String breakStart;
    String breakEnd;

    // STORE_DETAIL
    String subTitle;
    String sContents;
}