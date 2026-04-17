package com.example.unipet.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.User;

@Mapper
public interface UserMapper {

    // 아이디 중복 체크
    int checkUser(HashMap<String, Object> map);

    // 일반 회원가입
    int insertUser(HashMap<String, Object> map);

    // 사업자 회원가입 - users 테이블 저장
    int insertBizUser(HashMap<String, Object> map);

    // 사업자 회원가입 - biz_info 테이블 저장
    int insertBizInfo(HashMap<String, Object> map);

    // 로그인 시 사용자 조회
    User selectUser(HashMap<String, Object> map);

    // 이름 + 휴대폰번호로 아이디 찾기
    User findId(HashMap<String, Object> map);

    // 아이디 + 휴대폰번호로 비밀번호 재설정 대상 확인
    User checkUserForReset(HashMap<String, Object> map);

    // 비밀번호 재설정
    int resetPwd(HashMap<String, Object> map);
}