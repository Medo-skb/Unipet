package com.example.unipet.model;

import lombok.Data;

@Data
public class AiRecommend {
    private String userId;        
    private String recServices;   
    private String recProducts;   
    private String createdAt;     
    private String updatedAt;     
}
