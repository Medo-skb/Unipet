package com.example.unipet.model;

import java.util.List;

import lombok.Data;

@Data
public class Main {
	
    // 메인 섹션 리스트
    // =========================

    // 최근 예약이 많은 업체
    private List<Main> popularStoreList;

    // 사람들이 많이 찜한 상품(인기상품)
    private List<Main> popularProductList;

    // 최근 본 상품 기반 추천
    private List<Main> recentProductList;

    // 최근 본 업체 기반 추천
    private List<Main> recentStoreList;

    // 예약 기반 상품 추천 (WAI / CNF / FIN)
    private List<Main> reservationProductList;

    // 예약 카테고리 기반 업체 추천 (CAN)
    private List<Main> reservationStoreList;

    // WISH 기반 추천
    private List<Main> wishProductList;

    // =========================
    // 업체 정보
    // =========================
    private int storeNo;
    private String storeName;
    private String sCategory;
    private String sAddr;
    private String sCategoryName;
    private String popularMenuName;

    // =========================
    // 상품 정보
    // =========================
    private int productNo;
    private String productName;
    private int productPrice;
    private int iSubNo;

    // =========================
    // 추천 문구
    // =========================
    private String recommendReason;
}