package com.example.unipet.model;

import lombok.Data;

@Data
public class User {

    private String userId;
    private String pwd;
    private String userName;
    private String nickname;

    private String role;
    private String phone;
    private String email;

    private String userAddr;     // 🔥 추가
    private String fullAddr;     // 🔥 추가
    private String zipcode;      // 🔥 추가
    private String userStatus;   // 🔥 추가
    private String cdate;        // 🔥 추가

    private String bizName;
    private String bizNo;
    private String bizStatus;
    private String bizFileName;
    private String bizFilePath;

    // 사업자 로그인용
    private String storeUserId;
    private String storeUserPwd;
    private String ceoName;

    // 소셜 구분용
    private String socialType;
    private String socialId;
}