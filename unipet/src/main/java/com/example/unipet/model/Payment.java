package com.example.unipet.model;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Payment {
	// 1. 예약 기본 정보
    int rsvNo;
    String rsvDate;  // 시작 시간
    String endDate;  // 종료 시간
    String request;         // 요청 사항
    String rsvStatus;       // 예약 상황

    // 2. 상점 정보 (STORE 테이블 Join 결과)
    String storeName;       // 업체명

    // 3. 메뉴 정보 (STORE_MENU 테이블 Join 결과)
    String menuName;		// 메뉴 이름
    int menuPrice; 			// 메뉴 가격
    String mStatus;			// 판매 상황

    // 4. 사용자 정보 (USERS 테이블 Join 결과) - 포트원 전송 및 확인용
    String userName; 		// 이름
    String phone;    		// 전화번호

    // 5. 계산 데이터
    int deposit;    // 예약금
    int balance;    // 잔액
}
