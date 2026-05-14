package com.example.unipet.model;

import lombok.Data;

@Data
public class User {
    private String userId;
    private String pwd;
    private String userName;
    private String nickname;
    private String phone;
    private String email;
    private String userAddr;
    private String fullAddr;
    private String zipcode;
    private String socialType;
    private String userStatus;
    private String storeStatus;
}