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

    // STORE_USER
    String sUserId;
    String uStatus;

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
    String cdate;
}