package com.example.unipet.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.example.unipet.dao.UserMypageService;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserMypageController {

	@Autowired
	private UserMypageService userMypageService;

	// 로그인 체크 공통 함수
	private boolean checkLogin(HttpSession session, HttpServletResponse response) throws IOException {
		if (session.getAttribute("sessionId") == null) {
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().write(
				"<script>" +
				"alert('로그인 후 이용해주세요.');" +
				"location.href='/user/login.do';" +
				"</script>"
			);
			return false;
		}
		return true;
	}

	// 마이페이지 홈 화면 이동
	@GetMapping("/user/mypage.do")
	public String mypage(HttpSession session, HttpServletResponse response) throws IOException {
		if (!checkLogin(session, response)) return null;
		return "user/Mypage/dashboard";
	}

	// 구독관리 화면 이동
	@GetMapping("/user/mypage/subscription.do")
	public String subscriptionPage(HttpSession session, HttpServletResponse response) throws IOException {
		if (!checkLogin(session, response)) return null;
		return "user/Mypage/subscription";
	}

	// 커뮤니티 화면 이동
	@GetMapping("/user/mypage/community.do")
	public String communityPage(HttpSession session, HttpServletResponse response) throws IOException {
		if (!checkLogin(session, response)) return null;
		return "user/Mypage/community";
	}


	// 주문내역 화면 이동
	@GetMapping("/user/mypage/order-list.do")
	public String orderListPage(HttpSession session, HttpServletResponse response) throws IOException {
	    if (!checkLogin(session, response)) return null;
	    return "user/Mypage/orderList";
	}

	

	// 예약내역 화면 이동
	@GetMapping("/user/mypage/reserve-list.do")
	public String reserveListPage(HttpSession session, HttpServletResponse response) throws IOException {
		if (!checkLogin(session, response)) return null;
		return "user/Mypage/reserveList";
	}

	// 반려동물 관리 화면 이동
	@GetMapping("/user/mypage/pet-edit.do")
	public String petEditPage(HttpSession session, HttpServletResponse response) throws IOException {
		if (!checkLogin(session, response)) return null;
		return "user/Mypage/petEdit";
	}

	// 반려동물 건강관리 화면 이동
	@GetMapping("/user/mypage/pet-health.do")
	public String petHealthPage(HttpSession session, HttpServletResponse response) throws IOException {
		if (!checkLogin(session, response)) return null;
		return "user/Mypage/petHealth";
	}

	// 포인트 화면 이동
	@GetMapping("/user/mypage/point-info.do")
	public String pointInfoPage(HttpSession session, HttpServletResponse response) throws IOException {
		if (!checkLogin(session, response)) return null;
		return "user/Mypage/pointInfo";
	}

	// 쿠폰 화면 이동
	@GetMapping("/user/mypage/coupon-info.do")
	public String couponInfoPage(HttpSession session, HttpServletResponse response) throws IOException {
		if (!checkLogin(session, response)) return null;
		return "user/Mypage/couponInfo";
	}

	// 마이페이지 기본 정보 조회
	@PostMapping("/user/mypage.dox")
	@ResponseBody
	public HashMap<String, Object> getMypage(HttpSession session) {

		HashMap<String, Object> result = new HashMap<>();
		Object sessionId = session.getAttribute("sessionId");

		if (sessionId == null) {
			result.put("result", "loginRequired");
			return result;
		}

		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", sessionId);

		result = userMypageService.getMypageData(map);
		result.put("result", "success");

		return result;
	}

	// 회원정보 수정
	@PostMapping("/user/update-user.dox")
	@ResponseBody
	public HashMap<String, Object> updateUser(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.updateUserInfo(map);
	}

	// 현재 비밀번호 확인
	@PostMapping("/user/check-password.dox")
	@ResponseBody
	public HashMap<String, Object> checkPassword(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.checkPassword(map);
	}

	// 비밀번호 변경
	@PostMapping("/user/change-pwd.dox")
	@ResponseBody
	public HashMap<String, Object> changePwd(@RequestParam HashMap<String, Object> map, HttpSession session) {
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

	// 반려동물 추가
	@PostMapping("/user/add-pet.dox")
	@ResponseBody
	public HashMap<String, Object> addPet(@RequestParam HashMap<String, Object> map, HttpSession session) {
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

		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> map = new HashMap<>();

		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			result.put("result", "loginRequired");
			result.put("message", "로그인 필요");
			return result;
		}

		map.put("userId", userId);
		map.put("petNo", petNo);

		userMypageService.changeMainPet(map);

		result.put("result", "success");
		return result;
	}

	// 최근 예약 목록 조회
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

	// 주문 목록 조회
	@PostMapping("/user/order-list.dox")
	@ResponseBody
	public HashMap<String, Object> getOrderList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getOrderList(map);
	}

	// 몸무게 목록 조회
	@PostMapping("/user/weight-list.dox")
	@ResponseBody
	public HashMap<String, Object> getWeightList(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getWeightList(map);
	}

	// 몸무게 기록 추가
	@PostMapping("/user/add-weight.dox")
	@ResponseBody
	public HashMap<String, Object> addWeight(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addWeight(map);
	}

	// 건강 기록 목록 조회
	@PostMapping("/user/health-list.dox")
	@ResponseBody
	public HashMap<String, Object> getHealthList(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getHealthList(map);
	}

	// 건강 기록 추가
	@PostMapping("/user/add-health.dox")
	@ResponseBody
	public HashMap<String, Object> addHealth(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addHealth(map);
	}

	// 접종 기록 목록 조회
	@PostMapping("/user/vaccine-list.dox")
	@ResponseBody
	public HashMap<String, Object> getVaccineList(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getVaccineList(map);
	}

	// 접종 기록 추가
	@PostMapping("/user/add-vaccine.dox")
	@ResponseBody
	public HashMap<String, Object> addVaccine(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addVaccine(map);
	}

	// 접종 기록 삭제
	@PostMapping("/user/delete-vaccine.dox")
	@ResponseBody
	public HashMap<String, Object> deleteVaccine(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.deleteVaccine(map);
	}

	// 작성 가능한 리뷰 목록 조회
	@PostMapping("/user/review/writable-list.dox")
	@ResponseBody
	public HashMap<String, Object> getWritableReviewList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getWritableReviewList(map);
	}

	// 내가 작성한 리뷰 목록 조회
	@PostMapping("/user/review/my-list.dox")
	@ResponseBody
	public HashMap<String, Object> getMyReviewList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getMyReviewList(map);
	}

	// 리뷰 등록
	@PostMapping("/user/review/add.dox")
	@ResponseBody
	public HashMap<String, Object> addReview(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addReview(map);
	}

	// 리뷰 수정
	@PostMapping("/user/review/edit.dox")
	@ResponseBody
	public HashMap<String, Object> editReview(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.editReview(map);
	}

	// 리뷰 삭제
	@PostMapping("/user/review/delete.dox")
	@ResponseBody
	public HashMap<String, Object> deleteReview(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.removeReview(map);
	}

	// 구독 정보 조회
	@PostMapping("/user/subscription-info.dox")
	@ResponseBody
	public HashMap<String, Object> getSubscriptionInfo(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getSubscriptionInfo(map);
	}

	// 자동결제 변경
	@PostMapping("/user/update-auto-pay.dox")
	@ResponseBody
	public HashMap<String, Object> updateAutoPay(@RequestParam HashMap<String, Object> map, HttpSession session) {

		HashMap<String, Object> result = new HashMap<>();

		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			result.put("result", "loginRequired");
			result.put("message", "로그인 후 이용해주세요.");
			return result;
		}

		map.put("userId", userId);

		return userMypageService.updateAutoPay(map);
	}

	// 내가 쓴 게시글 목록 조회
	@PostMapping("/user/community-post-list.dox")
	@ResponseBody
	public HashMap<String, Object> getMyPostList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getMyPostList(map);
	}

	// 내가 쓴 댓글 목록 조회
	@PostMapping("/user/community-comment-list.dox")
	@ResponseBody
	public HashMap<String, Object> getMyCommentList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getMyCommentList(map);
	}

	// 구독 해지
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

	// 구독 결제내역 조회
	@PostMapping("/user/subscription-pay-list.dox")
	@ResponseBody
	public HashMap<String, Object> subscriptionPayList(HttpSession session) {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> map = new HashMap<>();

		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			result.put("result", "loginRequired");
			result.put("message", "로그인 후 이용해주세요.");
			return result;
		}

		map.put("userId", userId);

		return userMypageService.getSubscriptionPayList(map);
	}

	// 현재 포인트 조회
	@PostMapping("/user/point-info.dox")
	@ResponseBody
	public HashMap<String, Object> getPointInfo(HttpSession session) {
		HashMap<String, Object> result = new HashMap<>();
		Object sessionId = session.getAttribute("sessionId");

		if (sessionId == null) {
			result.put("result", "fail");
			result.put("message", "로그인이 필요합니다.");
			result.put("info", new HashMap<String, Object>());
			return result;
		}

		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", sessionId);

		return userMypageService.getPointInfo(map);
	}

	// 포인트 사용내역 조회
	@PostMapping("/user/point-use-list.dox")
	@ResponseBody
	public HashMap<String, Object> getPointUseList(HttpSession session) {

		HashMap<String, Object> result = new HashMap<>();
		Object sessionId = session.getAttribute("sessionId");

		if (sessionId == null) {
			result.put("result", "fail");
			result.put("pointUseList", new ArrayList<>());
			return result;
		}

		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", sessionId);

		return userMypageService.getPointUseList(map);
	}

	// 쿠폰 목록 조회
	@PostMapping("/user/coupon-list.dox")
	@ResponseBody
	public HashMap<String, Object> getCouponList(HttpSession session) {

		HashMap<String, Object> result = new HashMap<>();
		Object sessionId = session.getAttribute("sessionId");

		if (sessionId == null) {
			result.put("result", "fail");
			result.put("couponList", new java.util.ArrayList<>());
			return result;
		}

		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", sessionId);

		result.put("couponList", userMypageService.getCouponList(map));
		result.put("result", "success");

		return result;
	}

	// 환불 완료 후 주문/배송 상태 변경
	@PostMapping("/user/update-order-refund.dox")
	@ResponseBody
	public HashMap<String, Object> updateOrderRefund(@RequestParam HashMap<String, Object> map, HttpSession session) {

		Object sessionId = session.getAttribute("sessionId");

		if (sessionId == null) {
			HashMap<String, Object> result = new HashMap<>();
			result.put("result", "loginRequired");
			result.put("message", "로그인 후 이용해주세요.");
			return result;
		}

		map.put("userId", sessionId);

		return userMypageService.updateOrderRefund(map);
	}

}