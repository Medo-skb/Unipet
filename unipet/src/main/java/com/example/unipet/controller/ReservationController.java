package com.example.unipet.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.ReservationService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ReservationController {
	
	@Autowired
	ReservationService reservationService;
	
	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/reservation/search.do") 
	public String search(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/reservation/search";
	}

	@RequestMapping(value = "/reservation/search.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String search(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap = 서비스객체.함수(map);
		
		resultMap = reservationService.getStoreList(map);

		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping("/reservation/store-detail.do")
	public String detail(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/reservation/storeDetail";
	}
	
	@RequestMapping(value = "/reservation/store-detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    // 1. 가게 정보 (Map 형태) 담기
	    HashMap<String, Object> storeInfo = reservationService.getStoreInfo(map);
	    resultMap.put("info", storeInfo.get("info"));

	    // 2. 메뉴 목록 (List 형태) 담기
	    HashMap<String, Object> menuList = reservationService.getStoreMenuList(map);
	    resultMap.put("menuList", menuList.get("list"));
	    
	    HashMap<String, Object> imgList = reservationService.getStoreImgList(map);
	    resultMap.put("imgList", imgList.get("list"));

	    // Gson으로 변환하면 { "info": {...}, "menuList": [...] } 구조가 됩니다.
	    return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping("/reservation/store-reservation.do")
	public String reservation(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/reservation/reservation";
	}
	
	@RequestMapping(value = "/reservation/store-reservation.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rsv(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap = 서비스객체.함수(map);
		
		resultMap = reservationService.getStoreSlotList(map);
		
//		HashMap<String, Object> petList = reservationService.getPetList(map);
//	    resultMap.put("petList", petList.get("list"));

		return new Gson().toJson(resultMap); 
	}
	
}
