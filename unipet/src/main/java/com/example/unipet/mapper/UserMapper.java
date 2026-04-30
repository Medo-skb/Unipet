package com.example.unipet.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.User;

@Mapper
public interface UserMapper {

	int checkUser(HashMap<String, Object> map);

	int insertUser(HashMap<String, Object> map);

	int insertBizUser(HashMap<String, Object> map);

	User selectUser(HashMap<String, Object> map);

	User selectStoreUser(HashMap<String, Object> map);
	//사용자 아이디찾기
	User findId(HashMap<String, Object> map);
	//사업자 아이디찾기
	User findBizId(HashMap<String, Object> map);
	User checkUserForReset(HashMap<String, Object> map);

	int resetPwd(HashMap<String, Object> map);

	User selectSocialUser(HashMap<String, Object> map);

	int insertSocialUser(HashMap<String, Object> map);

	// UserMapper.java
	int updatePhone(HashMap<String, Object> map);

	int insertPhoneVerify(HashMap<String, Object> map);

	HashMap<String, Object> selectLatestPhoneVerify(HashMap<String, Object> map);

	int updatePhoneVerified(HashMap<String, Object> map);

	// 매장번호 조회
	int selectStoreNoByUserId(HashMap<String, Object> map);

	// 사업자등록증 파일 저장
	int insertStoreFile(HashMap<String, Object> map);
	// 매장 정보 저장
	int insertStore(HashMap<String, Object> map);
	
	// 휴대폰번호 조회
	int checkPhone(HashMap<String, Object> map);

	// 비밀번호 변경용 사용자 조회
	int selectUserCheckCount(HashMap<String, Object> map);
}