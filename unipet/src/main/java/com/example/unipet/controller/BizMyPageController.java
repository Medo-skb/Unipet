package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.BizMyPageService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class BizMyPageController {
	
	@Autowired
	BizMyPageService bizMyPageService;
	
	// 사업자 마이페이지 메인
	@RequestMapping("/biz/MyPage.do") 
	public String bizMyPage(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/bizMyPage/bizMyPageMain";
	}
	
	// 사업자 업체 수정
	@RequestMapping("/biz/storeEdit.do") 
	public String storeEdit(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/bizMyPage/storeEdit";
	}
	
	// 사업자 내정보 수정
	@RequestMapping("/biz/myInfo.do") 
	public String myInfo(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/bizMyPage/myInfo";
	}
	
	// 사업자 예약 현황
	@RequestMapping("/biz/reservation.do") 
	public String reservation(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/bizMyPage/reservation";
	}
	
	// 사업자 리뷰 관리
	@RequestMapping("/biz/review.do") 
	public String review(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/bizMyPage/review";
	}
	
	// 사업자 매출 현황
	@RequestMapping("/biz/sales.do") 
	public String sales(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
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

}
