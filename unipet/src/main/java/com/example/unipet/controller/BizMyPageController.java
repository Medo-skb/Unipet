package com.example.unipet.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.dao.BizMyPageService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class BizMyPageController {
	
	@Autowired
	BizMyPageService bizMyPageService;
	
	// 사업자 마이페이지 메인
	@RequestMapping("/biz/MyPage.do") 
	public String bizMyPage(HttpServletRequest request, HttpSession session, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		
	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        return "redirect:/user/login.do";
	    }
		
		return "/bizMyPage/bizMyPageMain";
	}
	
	// 사업자 업체 수정
	@RequestMapping("/biz/storeEdit.do") 
	public String storeEdit(HttpServletRequest request, HttpSession session, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
	    
	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        return "redirect:/user/login.do";
	    }
	    
	    return "/bizMyPage/storeEdit";
	}
	
	// 사업자 예약 현황
	@RequestMapping("/biz/reservation.do") 
	public String reservation(HttpServletRequest request, HttpSession session, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		
	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        return "redirect:/user/login.do";
	    }
		
		return "/bizMyPage/reservation";
	}
	
	// 사업자 리뷰 관리
	@RequestMapping("/biz/review.do") 
	public String review(HttpServletRequest request, HttpSession session, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		
	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        return "redirect:/user/login.do";
	    }
		
		return "/bizMyPage/review";
	}
	
	// 사업자 매출 현황
	@RequestMapping("/biz/sales.do") 
	public String sales(HttpServletRequest request, HttpSession session, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		
	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        return "redirect:/user/login.do";
	    }
		
		return "/bizMyPage/sales";
	}
	
	// 오늘의 일정
	@RequestMapping(value = "/getTodayScheduleList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getTodayScheduleList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");

		if (sessionId == null || !"BIZ".equals(sessionRole)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("sUserId", sessionId);

		resultMap = bizMyPageService.getTodayScheduleList(map);

		return new Gson().toJson(resultMap);
	}
	
	// 메뉴 예약 분포
	@RequestMapping(value = "/getMenuChartList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMenuChartList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");

		if (sessionId == null || !"BIZ".equals(sessionRole)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("sUserId", sessionId);

		resultMap = bizMyPageService.getMenuChartList(map);

		return new Gson().toJson(resultMap);
	}
	
	// 하루 예약 건수 차트
	@RequestMapping(value = "/getDailyReservationChartList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getDailyReservationChartList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");

		if (sessionId == null || !"BIZ".equals(sessionRole)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("sUserId", sessionId);

		resultMap = bizMyPageService.getDailyReservationChartList(map);

		return new Gson().toJson(resultMap);
	}
	
	// 승인된 업체 조회
	@RequestMapping(value = "/getApprovedStore.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getApprovedStore(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "로그인이 필요합니다.");
	        return new Gson().toJson(resultMap);
	    }

	    map.put("sUserId", sessionId);

	    resultMap = bizMyPageService.getApprovedStore(map);

	    return new Gson().toJson(resultMap);
	}
	
	// 사업자 회원 탈퇴
	@RequestMapping(value = "/biz/withdrawRequest.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String withdrawRequest(@RequestParam HashMap<String, Object> map, HttpSession session) {

	    String sessionId = (String) session.getAttribute("sessionId");
	    map.put("sUserId", sessionId);

	    Map<String, Object> result = bizMyPageService.withdrawRequest(map);

	    if ((boolean) result.get("success")) {
	        session.invalidate();
	    }

	    return new Gson().toJson(result);
	}
	
	// 업체 이미지 리스트
	@RequestMapping(value = "/getBizImgList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBizImgList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bizMyPageService.getBizImgList(map);
 
		return new Gson().toJson(resultMap); 
	}
	
	// 업체 소개 리스트
	@RequestMapping(value = "/getBizStoreList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBizMyPageList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bizMyPageService.getBizStoreList(map);
 
		return new Gson().toJson(resultMap); 
	}
	
	// 업체 메뉴 리스트
	@RequestMapping(value = "/getBizStoreMenuList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBizStoreMenuList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bizMyPageService.getBizStoreMenuList(map);
 
		return new Gson().toJson(resultMap); 
	}
	
	// 사업자 이미지 업로드
	@PostMapping("/biz/store/image/upload.dox")
	@ResponseBody
	public HashMap<String, Object> uploadStoreImage(
	        @RequestParam("file") MultipartFile file,
	        @RequestParam("storeNo") int storeNo,
	        @RequestParam("sUserId") String sUserId,
	        HttpServletRequest request) throws Exception {

	    HashMap<String, Object> resultMap = new HashMap<>();

	    if (file == null || file.isEmpty()) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "업로드할 파일이 없습니다.");
	        return resultMap;
	    }

	    String contentType = file.getContentType();
	    if (contentType == null || !contentType.startsWith("image/")) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "이미지 파일만 업로드할 수 있습니다.");
	        return resultMap;
	    }

	    bizMyPageService.addStoreImage(file, storeNo, sUserId, request);

	    resultMap.put("result", "success");
	    return resultMap;
	}
	
	// 사업자 이미지 삭제
	@PostMapping("/biz/store/image/delete.dox")
	@ResponseBody
	public HashMap<String, Object> deleteStoreImage(
	        @RequestParam("fileNo") int fileNo,
	        HttpServletRequest request) {

	    return bizMyPageService.removeStoreImage(fileNo, request);
	}
	
	// 대표 이미지
	@PostMapping("/biz/store/image/main.dox")
	@ResponseBody
	public HashMap<String, Object> updateStoreMainImage(@RequestParam("fileNo") int fileNo) {
		return bizMyPageService.editStoreMainImage(fileNo);
	}
	
	// 업체 설정 수정
	@RequestMapping(value = "/biz/store/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateBizStoreInfo(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");

		if (sessionId == null || !"BIZ".equals(sessionRole)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("sUserId", sessionId);

		resultMap = bizMyPageService.editBizStoreInfo(map);

		return new Gson().toJson(resultMap);
	}
	
	// 업체 메뉴 수정
	@RequestMapping(value = "/biz/store/menu/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editBizStoreMenu(@RequestBody HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bizMyPageService.editBizStoreMenu(map);

		return new Gson().toJson(resultMap);
	}
	
	// 사업자 내정보 조회
	@RequestMapping(value = "/getBizUserInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBizUserInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bizMyPageService.getBizUserInfo(map);

		return new Gson().toJson(resultMap);
	}
	
	// 아이디 중복 확인
	@RequestMapping(value = "/checkBizUserId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkBizUserId(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bizMyPageService.getBizUserId(map);

		return new Gson().toJson(resultMap);
	}
	
	// 내 정보 수정
	@RequestMapping(value = "/biz/user/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateBizUser(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    // 로그인 체크
	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "로그인이 필요합니다.");
	        return new Gson().toJson(resultMap);
	    }

	    // 기존 아이디는 세션값으로 고정
	    map.put("originUserId", sessionId);

	    resultMap = bizMyPageService.editBizUser(map);

	    // 아이디 변경 성공 시 세션도 같이 변경
	    if ("success".equals(resultMap.get("result"))) {
	        String newUserId = String.valueOf(map.get("sUserId"));
	        session.setAttribute("sessionId", newUserId);
	    }

	    return new Gson().toJson(resultMap);
	}
	
	// 예약 요약
	@RequestMapping(value = "/getReservationSummary.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReservationSummary(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");

		if (sessionId == null || !"BIZ".equals(sessionRole)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("sUserId", sessionId);

		resultMap = bizMyPageService.getReservationSummary(map);

		return new Gson().toJson(resultMap);
	}
	
	// 예약 목록
	@RequestMapping(value = "/getReservationList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReservationList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");

		if (sessionId == null || !"BIZ".equals(sessionRole)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("sUserId", sessionId);

		resultMap = bizMyPageService.getReservationList(map);

		return new Gson().toJson(resultMap);
	}
	
	// 리뷰 요약
	@RequestMapping(value = "/getReviewSummary.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewSummary(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");

		if (sessionId == null || !"BIZ".equals(sessionRole)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("sUserId", sessionId);

		resultMap = bizMyPageService.getReviewSummary(map);

		return new Gson().toJson(resultMap);
	}
	
	// 리뷰 목록
	@RequestMapping(value = "/getReviewList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");

		if (sessionId == null || !"BIZ".equals(sessionRole)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("sUserId", sessionId);

		resultMap = bizMyPageService.getReviewList(map);

		return new Gson().toJson(resultMap);
	}
	
	// 리뷰 메뉴 목록
	@RequestMapping(value = "/getReviewMenuList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReviewMenuList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "로그인이 필요합니다.");
	        return new Gson().toJson(resultMap);
	    }

	    map.put("sUserId", sessionId);

	    resultMap = bizMyPageService.getReviewMenuList(map);

	    return new Gson().toJson(resultMap);
	}
	
	// 리뷰 신고
	@RequestMapping(value = "/reportReview.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reportReview(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    String sessionId = (String) session.getAttribute("sessionId");
	    String sessionRole = (String) session.getAttribute("sessionRole");

	    if (sessionId == null || !"BIZ".equals(sessionRole)) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "로그인이 필요합니다.");
	        return new Gson().toJson(resultMap);
	    }

	    map.put("reporterId", sessionId);

	    resultMap = bizMyPageService.addReviewReport(map);

	    return new Gson().toJson(resultMap);
	}

}