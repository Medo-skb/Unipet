package com.example.unipet.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
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

		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/reservation/pet-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String petList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap = 서비스객체.함수(map);
		
		resultMap = reservationService.getPetList(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/reservation/store-menu.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sMenu(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = reservationService.getStoreMenuList(map);
	    
	    return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/reservation/store-policy.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sPolicy(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = reservationService.getStorePolicy(map);
	    
	    return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping("/reservation/rsv-confirm.do")
	public String confirm(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
		return "/reservation/rsv-confirm";
	}
	
	@RequestMapping("/reservation/add-reservation.dox")
	@ResponseBody
	public String addReservation(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    
	    // 1. 서비스 호출 (reservation INSERT + rsv_log INSERT)
	    // 앞서 Service에서 useGeneratedKeys 설정을 했으므로 map에 rsvNo가 담겨 돌아옵니다.
	    resultMap = reservationService.addReservation(map);
	    
	    return new Gson().toJson(resultMap);
	}
	
	// 결제 완료를 가정하고 completeReserviation 호출을 위한 임시 매서드
	@GetMapping("/test/complete")
	@ResponseBody
	public HashMap<String, Object> testComplete(
	        @RequestParam("rsvNo") int rsvNo,
	        @RequestParam("slotNo") int slotNo) {
	    
	    HashMap<String, Object> map = new HashMap<>();
	    map.put("rsvNo", rsvNo);
	    map.put("slotNo", slotNo);
	    map.put("userId", "test_user01"); // 로그 기록을 위한 임의 ID

	    try {
	        // 서비스의 completeReservation 호출
	        return reservationService.completeReservation(map);
	    } catch (Exception e) {
	        HashMap<String, Object> error = new HashMap<>();
	        error.put("result", "error");
	        error.put("message", e.getMessage());
	        return error;
	    }
	}
	
	@RequestMapping("/reservation/rsv-success.do")
	public String rSuccess(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
		
		request.setAttribute("map", map);
		
		return "/reservation/rsv-success";
	}
	
	@RequestMapping(value = "/reservation/rsv-info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = reservationService.getRsvInfo(map);
	    
	    return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/reservation/rsv-cancel.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rCancel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        // 서비스 단에서 트랜잭션 처리
	        reservationService.removeRsv(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }
	    return new Gson().toJson(resultMap);
	}
	
	
	
}
