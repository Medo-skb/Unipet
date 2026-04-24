package com.example.unipet.model;

import lombok.Data;

@Data
public class Order {
	
	public int ordNo;
	public String userId;
	public String ordAddr;
	public String ordMemo;
	public int totalPrice;
	public String ordDate;
	public String ordStatus;
	public int disPrice;
    
	public int productNo;
	public String productName;
	public String filePath;
	public String fileName;
	public int unitPrice;
	public int ordQty;
    
	public int rsvNo;
	public String rsvDate;
	public String rsvStartTime;
	public String rsvEndTime;
	public String storeName;   /* 매장명 */
	public String menuName;    /* 예약 메뉴명 */
	public int menuPrice;
	public String request;     /* 요청사항 */
    
	public String deliStatus;

}