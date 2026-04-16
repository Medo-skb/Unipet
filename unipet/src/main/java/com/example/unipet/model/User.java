package com.example.unipet.model;

import lombok.Data;

@Data
public class User {

    // 기본 회원 정보
    private String userId;
    private String pwd;
    private String userName;
    private String role;        // USER / BIZ

    // 사업자 관련
    private String bizName;     // 업체명
    private String bizNo;       // 사업자번호
    private String bizStatus;   // WAIT / APPROVED

    // 파일 관련
    private String bizFileName;
    private String bizFilePath;

}