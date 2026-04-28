package com.example.unipet.model;

import lombok.Data;

@Data
public class Product {

	// ===== 상품 =====
	int productNo;
	Integer storeNo;
	String productName;
	String brand;
	int productPrice;
	int stockQty;
	int aSubNo;
	int iSubNo;
	String productStatus;
	String cdate;

	// ===== 동물 카테고리 =====
	int aMainNo;
	String aMainType;
	String aSubType;

	// ===== 상품 카테고리 =====
	int iMainNo;
	String iMainType;
	String iSubType;

	// ===== 상품 이미지 / 파일 =====
	int fileNo;
	String filePath;
	String fileName;
	String originName;
	long fileSize;
	String fileExt;
	String fileUrl;
	String img;

	// ===== 리뷰 =====
	int reviewNo;
	String userId;
	String userName;
	int rating;
	String contents;
	String reviewContents;
	String reviewCdate;
	double avgRating;
	int reviewCount;

	// ===== QNA =====
	int qnaNo;
	String qnaTitle;
	String qnaContents;
	String qnaAnswer;
	String qnaStatus;
	String privateYn;
	String qnaCdate;
	String updateTime;

	// ===== 장바구니 =====
	int cartNo;
	int qty;
	int cartQty;
	int totalPrice;

}