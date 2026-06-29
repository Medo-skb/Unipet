package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Store;
import com.example.unipet.model.User;

@Mapper
public interface UserMapper {

	int checkUser(HashMap<String, Object> map);

	int checkBiznum(HashMap<String, Object> map);

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

	// 다른 일반 사용자 휴대폰 점유 해제
	int clearUserPhoneOwner(HashMap<String, Object> map);

	int insertPhoneVerify(HashMap<String, Object> map);

	HashMap<String, Object> selectLatestPhoneVerify(HashMap<String, Object> map);

	int updatePhoneVerified(HashMap<String, Object> map);
	
	// 휴대폰번호 조회
	int checkPhone(HashMap<String, Object> map);

	// 비밀번호 변경용 사용자 조회
	int selectUserCheckCount(HashMap<String, Object> map);

	int updateSms(HashMap<String, Object> map);

	// 외부업체 검색
	List<Store> selectExternalStoreList(HashMap<String, Object> map);

	// 선택한 업체가 신청 가능한 상태인지 확인
	int selectAvailableStoreCount(HashMap<String, Object> map);

	// 같은 업체에 진행 중인 신청이 있는지 확인
	int selectPendingSubmitCountByStore(HashMap<String, Object> map);

	// 같은 사업자 계정에 진행 중인 신청이 있는지 확인
	int selectPendingSubmitCountByUser(HashMap<String, Object> map);

	// 사업자등록증 파일 저장
	int insertStoreFile(HashMap<String, Object> map);

	// 사업자 업체 신청 내역 저장
	int insertStoreSubmit(HashMap<String, Object> map);

	// 신청한 업체 상태를 검토 대기 상태로 변경
	int updateStoreStatusToPending(HashMap<String, Object> map);

}
