package com.example.unipet.model;

import lombok.Data;

@Data
public class StoreRecommend {
    private int storeNo;
    private String storeName;
    private String addr;
    private String subTitle;
    private String contents;
    private String menuNames;
    private Integer minPrice;
    private Double avgRating;
    private int reviewCount;
    private String reviewContents;
    private String sStatus;

}