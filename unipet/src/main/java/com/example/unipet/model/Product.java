package com.example.unipet.model;

import lombok.Data;

@Data
public class Product {

	// ===== 상품 =====
	int PRODUCT_NO;
	int STORE_NO;
	String PRODUCT_NAME;
	String BRAND;
	int PRODUCT_PRICE;
	int STOCK_QTY;
	int A_SUB_NO;
	int I_SUB_NO;
	String PRODUCT_STATUS;
	String CDATE;

	// ===== 카테고리 =====
	String A_MAIN_TYPE;
	String A_SUB_TYPE;
	String I_MAIN_TYPE;
	String I_SUB_TYPE;

	// ===== 검색 =====
	String SORT_TYPE;
	String KEYWORD;

	// ===== QNA =====
	int QNA_NO;
	String QNA_TITLE;
	String Q_CONTENTS;
	String A_CONTENTS;
	String ANS_STATUS;
	String IS_SECRET;
	String ADATE;

	// ===== 장바구니 =====
	String USER_ID;
	int QTY;
	int CART_NO;

	// ===== 주문 =====
	int ORD_NO;

	// ===== 이미지 =====
	String FILE_PATH;
	String FILE_NAME;
}