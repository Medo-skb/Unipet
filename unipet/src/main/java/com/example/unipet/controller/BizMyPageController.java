package com.example.unipet.controller;

import java.util.HashMap;

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
	public String updateBizStoreInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
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
	
	// 사업자 내정보 수정
	@RequestMapping(value = "/biz/user/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateBizUser(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = bizMyPageService.editBizUser(map);

		return new Gson().toJson(resultMap);
	}

}
