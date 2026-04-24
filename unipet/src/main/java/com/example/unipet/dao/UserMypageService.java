package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.UserMypageMapper;

@Service
public class UserMypageService {

	@Autowired
	private UserMypageMapper userMypageMapper;

	// 마이페이지 기본정보 조회
	public HashMap<String, Object> getMypageData(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		HashMap<String, Object> userInfo = userMypageMapper.selectUserInfo(map);

		result.put("result", userInfo != null ? "success" : "fail");
		result.put("userInfo", userInfo);
		result.put("message", userInfo != null ? "조회 성공" : "사용자 정보가 없습니다.");

		return result;
	}

	// 회원정보 수정
	public HashMap<String, Object> updateUserInfo(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.updateUserInfo(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "회원정보가 저장되었습니다." : "회원정보 저장 실패");

		return result;
	}

	// 현재 비밀번호 확인
	public HashMap<String, Object> checkPassword(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		HashMap<String, Object> check = userMypageMapper.checkPassword(map);

		result.put("result", check != null ? "success" : "fail");
		result.put("message", check != null ? "비밀번호 확인 완료" : "현재 비밀번호가 일치하지 않습니다.");

		return result;
	}

	// 비밀번호 변경
	public HashMap<String, Object> changePassword(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.changePassword(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "비밀번호가 변경되었습니다." : "비밀번호 변경 실패");

		return result;
	}

	// 회원 탈퇴
	public HashMap<String, Object> deleteUser(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.deleteUser(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "회원 탈퇴가 완료되었습니다." : "회원 탈퇴 실패");

		return result;
	}

	// 반려동물 목록 조회
	public HashMap<String, Object> getPetList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> petList = userMypageMapper.selectPetList(map);

		result.put("result", "success");
		result.put("petList", petList);
		result.put("message", "반려동물 목록 조회 완료");

		return result;
	}

	// 반려동물 등록
	public HashMap<String, Object> addPet(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.insertPet(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "반려동물이 등록되었습니다." : "반려동물 등록 실패");

		return result;
	}

	// 반려동물 수정
	public HashMap<String, Object> updatePet(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.updatePet(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "반려동물 정보가 수정되었습니다." : "반려동물 수정 실패");

		return result;
	}

	// 반려동물 삭제
	public HashMap<String, Object> deletePet(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.deletePet(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "반려동물 정보가 삭제되었습니다." : "반려동물 삭제 실패");

		return result;
	}

	// 대표 반려동물 변경
	public HashMap<String, Object> changeMainPet(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		userMypageMapper.resetMainPet(map);
		int cnt = userMypageMapper.changeMainPet(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "대표 프로필이 변경되었습니다." : "대표 프로필 변경 실패");

		return result;
	}

	// 최근 예약 목록
	public HashMap<String, Object> getReservationList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> reservationList = userMypageMapper.selectReservationList(map);

		result.put("result", "success");
		result.put("reservationList", reservationList);
		result.put("message", "예약 목록 조회 완료");

		return result;
	}

	// 전체 예약 목록
	public HashMap<String, Object> getReservationAllList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> reservationList = userMypageMapper.selectReservationAllList(map);

		result.put("result", "success");
		result.put("reservationList", reservationList);
		result.put("message", "전체 예약 목록 조회 완료");

		return result;
	}

	// 주문내역 조회
	public HashMap<String, Object> getOrderList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> orderList = userMypageMapper.selectOrderList(map);

		result.put("result", "success");
		result.put("orderList", orderList);
		result.put("message", "주문 목록 조회 완료");

		return result;
	}

	public HashMap<String, Object> getWeightList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> weightList = userMypageMapper.selectWeightList(map);

		result.put("result", "success");
		result.put("weightList", weightList);
		result.put("message", "몸무게 목록 조회 완료");

		return result;
	}

	public HashMap<String, Object> addWeight(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.insertWeight(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "몸무게가 저장되었습니다." : "몸무게 저장 실패");

		return result;
	}

	public HashMap<String, Object> getHealthList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> healthList = userMypageMapper.selectHealthList(map);

		result.put("result", "success");
		result.put("healthList", healthList);
		result.put("message", "건강기록 목록 조회 완료");

		return result;
	}

	public HashMap<String, Object> addHealth(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.insertHealth(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "건강기록이 저장되었습니다." : "건강기록 저장 실패");

		return result;
	}

	public HashMap<String, Object> getVaccineList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> vaccineList = userMypageMapper.selectVaccineList(map);

		result.put("result", "success");
		result.put("vaccineList", vaccineList);
		result.put("message", "백신 목록 조회 완료");

		return result;
	}

	public HashMap<String, Object> addVaccine(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.insertVaccine(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "백신 기록이 저장되었습니다." : "백신 기록 저장 실패");

		return result;
	}

	public HashMap<String, Object> deleteVaccine(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.deleteVaccine(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "백신 기록이 삭제되었습니다." : "백신 기록 삭제 실패");

		return result;
	}

	public HashMap<String, Object> getWritableReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> list = userMypageMapper.selectWritableReviewList(map);

		result.put("result", "success");
		result.put("writableReviewList", list);
		result.put("message", "작성 가능한 리뷰 목록 조회 완료");

		return result;
	}

	public HashMap<String, Object> getMyReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> list = userMypageMapper.selectMyReviewList(map);

		result.put("result", "success");
		result.put("myReviewList", list);
		result.put("message", "내 리뷰 목록 조회 완료");

		return result;
	}

	public HashMap<String, Object> addReview(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.insertReview(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "리뷰가 등록되었습니다." : "리뷰 등록 실패");

		return result;
	}

	public HashMap<String, Object> editReview(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.updateReview(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "리뷰가 수정되었습니다." : "리뷰 수정 실패");

		return result;
	}

	public HashMap<String, Object> removeReview(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		int cnt = userMypageMapper.deleteReview(map);

		result.put("result", cnt > 0 ? "success" : "fail");
		result.put("message", cnt > 0 ? "리뷰가 삭제되었습니다." : "리뷰 삭제 실패");

		return result;
	}

	// =====================
	// 구독 정보
	// =====================
	public HashMap<String, Object> getSubscriptionInfo(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		HashMap<String, Object> info = userMypageMapper.selectSubscriptionInfo(map);
		if (info == null) {
			info = new HashMap<>();
		}

		result.put("result", "success");
		result.put("subscriptionInfo", info);

		return result;
	}

	public HashMap<String, Object> getMyPostList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> list = userMypageMapper.selectMyPostList(map);

		result.put("result", "success");
		result.put("postList", list);

		return result;
	}

	public HashMap<String, Object> getMyCommentList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		List<HashMap<String, Object>> list = userMypageMapper.selectMyCommentList(map);

		result.put("result", "success");
		result.put("commentList", list);

		return result;
	}

	public int cancelSubscription(HashMap<String, Object> map) {
		return userMypageMapper.cancelSubscription(map);
	}

	// =====================
	// 포인트 조회
	// =====================
	public HashMap<String, Object> getPointInfo(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		HashMap<String, Object> info = userMypageMapper.selectPointInfo(map);

		if (info == null) {
			info = new HashMap<>();
			info.put("point", 0);
		}

		result.put("result", "success");
		result.put("info", info);

		return result;
	}

	// =====================
	// 포인트 사용내역 조회
	// =====================
	public HashMap<String, Object> getPointUseList(HashMap<String, Object> map) {
	    HashMap<String, Object> result = new HashMap<>();

	    List<HashMap<String, Object>> list = userMypageMapper.selectPointUseList(map);

	    result.put("result", "success");
	    result.put("list", list);

	    return result;
	}
}