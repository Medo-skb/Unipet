package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.UserMypageService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserMypageController {

	// Service 호출용
	@Autowired
	private UserMypageService userMypageService;

	// 마이페이지 화면 이동
	@GetMapping("/user/mypage.do")
	public String mypage() {
		// /WEB-INF/user/UserMypage.jsp 로 이동
		return "user/UserMypage";
	}

	// 마이페이지 기본 사용자 정보 조회
	@PostMapping("/user/mypage.dox")
	@ResponseBody
	public HashMap<String, Object> getMypage(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();

		// 로그인 성공 시 세션에 저장된 sessionId를 userId로 사용
		map.put("userId", session.getAttribute("sessionId"));

		// Service로 넘겨서 사용자 정보 조회
		return userMypageService.getMypageData(map);
	}

	// 사용자 정보 수정
	@PostMapping("/user/update-user.dox")
	@ResponseBody
	public HashMap<String, Object> updateUser(@RequestParam HashMap<String, Object> map, HttpSession session) {
		// 로그인한 사용자 기준으로 수정해야 하므로 userId를 세션에서 넣음
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.updateUserInfo(map);
	}

	// 현재 비밀번호 확인
	@PostMapping("/user/check-password.dox")
	@ResponseBody
	public HashMap<String, Object> checkPassword(@RequestParam HashMap<String, Object> map, HttpSession session) {
		// 로그인 사용자 기준
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.checkPassword(map);
	}

	// 비밀번호 변경
	@PostMapping("/user/change-pwd.dox")
	@ResponseBody
	public HashMap<String, Object> changePwd(@RequestParam HashMap<String, Object> map, HttpSession session) {
		// 로그인 사용자 기준
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.changePassword(map);
	}

	// 회원 탈퇴
	@PostMapping("/user/delete-user.dox")
	@ResponseBody
	public HashMap<String, Object> deleteUser(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));

		HashMap<String, Object> result = userMypageService.deleteUser(map);

		// 탈퇴 성공 시 세션 제거
		if ("success".equals(result.get("result"))) {
			session.invalidate();
		}

		return result;
	}

	// 반려동물 목록 조회
	@PostMapping("/user/pet-list.dox")
	@ResponseBody
	public HashMap<String, Object> getPetList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.getPetList(map);
	}

	// 반려동물 등록
	@PostMapping("/user/add-pet.dox")
	@ResponseBody
	public HashMap<String, Object> addPet(@RequestParam HashMap<String, Object> map, HttpSession session) {
		// 어떤 사용자의 반려동물인지 연결하기 위해 userId 추가
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.addPet(map);
	}

	// 반려동물 수정
	@PostMapping("/user/update-pet.dox")
	@ResponseBody
	public HashMap<String, Object> updatePet(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.updatePet(map);
	}

	// 반려동물 삭제
	@PostMapping("/user/delete-pet.dox")
	@ResponseBody
	public HashMap<String, Object> deletePet(@RequestParam("petNo") int petNo, HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		map.put("petNo", petNo);

		return userMypageService.deletePet(map);
	}

	// 대표 반려동물 변경
	@PostMapping("/user/change-main-pet.dox")
	@ResponseBody
	public HashMap<String, Object> changeMainPet(@RequestParam("petNo") int petNo, HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		map.put("petNo", petNo);

		return userMypageService.changeMainPet(map);
	}

	// 예약 목록 조회
	@PostMapping("/user/reservation-list.dox")
	@ResponseBody
	public HashMap<String, Object> getReservationList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.getReservationList(map);
	}

	// 전체 예약 목록 조회
	@PostMapping("/user/reservation-all-list.dox")
	@ResponseBody
	public HashMap<String, Object> getReservationAllList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.getReservationAllList(map);
	}

	// 주문내역 조회
	@PostMapping("/user/order-list.dox")
	@ResponseBody
	public HashMap<String, Object> getOrderList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();

		// 로그인한 사용자 아이디를 조회 조건으로 전달
		map.put("userId", session.getAttribute("sessionId"));

		return userMypageService.getOrderList(map);
	}

	// 몸무게목록조회
	@PostMapping("/user/weight-list.dox")
	@ResponseBody
	public HashMap<String, Object> getWeightList(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getWeightList(map);
	}

	// 몸무게등록
	@PostMapping("/user/add-weight.dox")
	@ResponseBody
	public HashMap<String, Object> addWeight(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addWeight(map);
	}

	// 건강기록조회
	@PostMapping("/user/health-list.dox")
	@ResponseBody
	public HashMap<String, Object> getHealthList(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getHealthList(map);
	}

	// 건강기록등록
	@PostMapping("/user/add-health.dox")
	@ResponseBody
	public HashMap<String, Object> addHealth(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addHealth(map);
	}

	@PostMapping("/user/vaccine-list.dox")
	@ResponseBody
	public HashMap<String, Object> getVaccineList(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getVaccineList(map);
	}

	@PostMapping("/user/add-vaccine.dox")
	@ResponseBody
	public HashMap<String, Object> addVaccine(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addVaccine(map);
	}

	@PostMapping("/user/delete-vaccine.dox")
	@ResponseBody
	public HashMap<String, Object> deleteVaccine(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.deleteVaccine(map);
	}

	@PostMapping("/user/review/writable-list.dox")
	@ResponseBody
	public HashMap<String, Object> getWritableReviewList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getWritableReviewList(map);
	}

	@PostMapping("/user/review/my-list.dox")
	@ResponseBody
	public HashMap<String, Object> getMyReviewList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getMyReviewList(map);
	}

	@PostMapping("/user/review/add.dox")
	@ResponseBody
	public HashMap<String, Object> addReview(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addReview(map);
	}

	@PostMapping("/user/review/edit.dox")
	@ResponseBody
	public HashMap<String, Object> editReview(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.editReview(map);
	}

	@PostMapping("/user/review/delete.dox")
	@ResponseBody
	public HashMap<String, Object> deleteReview(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.removeReview(map);
	}

	// =====================
	// 구독 정보 조회
	// =====================
	@PostMapping("/user/subscription-info.dox")
	@ResponseBody
	public HashMap<String, Object> getSubscriptionInfo(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getSubscriptionInfo(map);
	}

	@PostMapping("/user/community-post-list.dox")
	@ResponseBody
	public HashMap<String, Object> getMyPostList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getMyPostList(map);
	}

	@PostMapping("/user/community-comment-list.dox")
	@ResponseBody
	public HashMap<String, Object> getMyCommentList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getMyCommentList(map);
	}
	@PostMapping("/user/cancel-subscription.dox")
	@ResponseBody
	public HashMap<String, Object> cancelSubscription(HttpSession session) {
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("userId", session.getAttribute("sessionId"));

	    int cnt = userMypageService.cancelSubscription(map);

	    HashMap<String, Object> result = new HashMap<>();
	    result.put("result", cnt > 0 ? "success" : "fail");

	    return result;
	}
	// 포인트 관련 API 추가

	// 현재 보유 포인트 조회
	@PostMapping("/user/point-info.dox")
	@ResponseBody
	public HashMap<String, Object> getPointInfo(HttpSession session) {

	    // 결과 반환용 객체
	    HashMap<String, Object> map = new HashMap<>();

	    // 로그인한 사용자 ID 가져오기
	    map.put("userId", session.getAttribute("sessionId"));

	    // 서비스 호출 → 포인트 정보 조회
	    return userMypageService.getPointInfo(map);
	}


	// 포인트 사용내역 조회
	@PostMapping("/user/point-use-list.dox")
	@ResponseBody
	public HashMap<String, Object> getPointUseList(HttpSession session) {

	    HashMap<String, Object> map = new HashMap<>();

	    // 로그인 사용자 ID
	    map.put("userId", session.getAttribute("sessionId"));

	    // 서비스 호출 → 사용내역 리스트 조회
	    return userMypageService.getPointUseList(map);
	}
	

}