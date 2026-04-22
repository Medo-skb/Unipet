package com.example.unipet.model;

import lombok.Data;

@Data
public class Coupon {

    int ucpNo;          // 유저 쿠폰 보유 번호
    int couponNo;     
    String couponName; 
    int deduceprice;    // 할인 금액
    String expDate;     // 만료일
	
}
