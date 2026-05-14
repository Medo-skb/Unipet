package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMypageMapper {

	HashMap<String, Object> selectUserInfo(HashMap<String, Object> map);

	int updateUserInfo(HashMap<String, Object> map);

	HashMap<String, Object> checkPassword(HashMap<String, Object> map);

	int changePassword(HashMap<String, Object> map);

	int deleteUser(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectPetList(HashMap<String, Object> map);

	int insertPet(HashMap<String, Object> map);

	int updatePet(HashMap<String, Object> map);

	int deletePet(HashMap<String, Object> map);

	int resetMainPet(HashMap<String, Object> map);

	int changeMainPet(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectReservationList(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectReservationAllList(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectOrderList(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectWeightList(HashMap<String, Object> map);

	int insertWeight(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectHealthList(HashMap<String, Object> map);

	int insertHealth(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectVaccineList(HashMap<String, Object> map);

	int insertVaccine(HashMap<String, Object> map);

	int deleteVaccine(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectWritableReviewList(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectMyReviewList(HashMap<String, Object> map);

	int insertReview(HashMap<String, Object> map);

	int updateReview(HashMap<String, Object> map);

	int deleteReview(HashMap<String, Object> map);

	HashMap<String, Object> selectSubscriptionInfo(HashMap<String, Object> map);
	
	List<HashMap<String, Object>> selectSubscriptionPayList(HashMap<String, Object> map);
	int updateAutoPay(HashMap<String, Object> map);
	int cancelSubscription(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectMyPostList(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectMyCommentList(HashMap<String, Object> map);

	// 현재 포인트 조회
	HashMap<String, Object> selectPointInfo(HashMap<String, Object> map);

	// 포인트 사용내역 조회
	List<HashMap<String, Object>> selectPointUseList(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectCouponList(HashMap<String, Object> map);
	// 주문 취소
	int updateOrderRefund(HashMap<String, Object> map);
	
}