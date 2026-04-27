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

	@Autowired
	private UserMypageService userMypageService;

	@GetMapping("/user/mypage.do")
	public String mypage() {
		return "user/UserMypage";
	}

	@PostMapping("/user/mypage.dox")
	@ResponseBody
	public HashMap<String, Object> getMypage(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getMypageData(map);
	}

	@PostMapping("/user/update-user.dox")
	@ResponseBody
	public HashMap<String, Object> updateUser(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.updateUserInfo(map);
	}

	@PostMapping("/user/check-password.dox")
	@ResponseBody
	public HashMap<String, Object> checkPassword(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.checkPassword(map);
	}

	@PostMapping("/user/change-pwd.dox")
	@ResponseBody
	public HashMap<String, Object> changePwd(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.changePassword(map);
	}

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

	@PostMapping("/user/pet-list.dox")
	@ResponseBody
	public HashMap<String, Object> getPetList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getPetList(map);
	}

	@PostMapping("/user/add-pet.dox")
	@ResponseBody
	public HashMap<String, Object> addPet(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addPet(map);
	}

	@PostMapping("/user/update-pet.dox")
	@ResponseBody
	public HashMap<String, Object> updatePet(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.updatePet(map);
	}

	@PostMapping("/user/delete-pet.dox")
	@ResponseBody
	public HashMap<String, Object> deletePet(@RequestParam("petNo") int petNo, HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		map.put("petNo", petNo);
		return userMypageService.deletePet(map);
	}

	@PostMapping("/user/change-main-pet.dox")
	@ResponseBody
	public HashMap<String, Object> changeMainPet(@RequestParam("petNo") int petNo, HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		map.put("petNo", petNo);
		return userMypageService.changeMainPet(map);
	}

	@PostMapping("/user/reservation-list.dox")
	@ResponseBody
	public HashMap<String, Object> getReservationList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getReservationList(map);
	}

	@PostMapping("/user/reservation-all-list.dox")
	@ResponseBody
	public HashMap<String, Object> getReservationAllList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getReservationAllList(map);
	}

	@PostMapping("/user/order-list.dox")
	@ResponseBody
	public HashMap<String, Object> getOrderList(HttpSession session) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getOrderList(map);
	}

	@PostMapping("/user/weight-list.dox")
	@ResponseBody
	public HashMap<String, Object> getWeightList(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getWeightList(map);
	}

	@PostMapping("/user/add-weight.dox")
	@ResponseBody
	public HashMap<String, Object> addWeight(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.addWeight(map);
	}

	@PostMapping("/user/health-list.dox")
	@ResponseBody
	public HashMap<String, Object> getHealthList(@RequestParam HashMap<String, Object> map, HttpSession session) {
		map.put("userId", session.getAttribute("sessionId"));
		return userMypageService.getHealthList(map);
	}

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
		System.out.println("포인트 사용내역 sessionId = " + sessionId);

		if (sessionId == null) {
			result.put("result", "fail");
			result.put("message", "로그인이 필요합니다.");
			result.put("list", java.util.Collections.emptyList());
			return result;
		}

		HashMap<String, Object> map = new HashMap<>();
		map.put("userId", sessionId);

		return userMypageService.getPointUseList(map);
	}
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
}