package com.example.unipet.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.User;

@Mapper
public interface UserMapper {

    // 일반 로그인
    User selectUser(HashMap<String, Object> map);

    // userId 단건 조회
    User selectUserById(HashMap<String, Object> map);

    // 사업자 로그인
    User selectStoreUser(HashMap<String, Object> map);

    // 아이디 중복 체크
    int checkUser(HashMap<String, Object> map);

    // 일반 회원가입
    int insertUser(HashMap<String, Object> map);

    // 사업자 회원가입
    int insertBizUser(HashMap<String, Object> map);

    // 소셜 회원 조회
    User selectSocialUser(HashMap<String, Object> map);

    // 소셜 회원 가입
    int insertSocialUser(HashMap<String, Object> map);
}