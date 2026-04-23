package com.example.unipet.model;

import lombok.Data;

@Data
public class Order {
	
	int ordNo;
    String userId;
    String ordAddr;
    String ordMemo;
    int totalPrice;
    String ordDate;
    String ordStatus;
    int disPrice;
    
    int productNo;
    String productName;
    String filePath;
    String fileName;
    int unitPrice;
    int ordQty;
    
    int rsvNo;
    String rsvDate;
    String rsvStartTime;
    String rsvEndTime;
    String storeName;   /* 매장명 */
    String menuName;    /* 예약 메뉴명 */
    int menuPrice;
    String request;     /* 요청사항 */

}
