package com.example.unipet.controller;

import java.util.HashMap; 

import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.beans.factory.annotation.Value;     
import org.springframework.stereotype.Controller;              
import org.springframework.ui.Model;                           
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RequestMethod;   
import org.springframework.web.bind.annotation.RequestParam;   
import org.springframework.web.bind.annotation.ResponseBody;   

import com.example.unipet.dao.ReservationService;              
import com.google.gson.Gson;                                   

import jakarta.servlet.http.HttpServletRequest;                

@Controller
public class ReservationController {
	
	@Autowired
	ReservationService reservationService;
	
	@Value("${kakao.maps.apikey}")
	private String kakaoApiKey;
	
	@RequestMapping("/reservation/search.do") 
	public String search(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		
		model.addAttribute("kakaoApiKey", kakaoApiKey);
		
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
		model.addAttribute("kakaoApiKey", kakaoApiKey);
		return "/reservation/storeDetail";
	}
	
	@RequestMapping(value = "/reservation/store-detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    HashMap<String, Object> storeInfo = reservationService.getStoreInfo(map);
	    resultMap.put("info", storeInfo.get("info"));

	    HashMap<String, Object> menuList = reservationService.getStoreMenuList(map);
	    resultMap.put("menuList", menuList.get("list"));
	    
	    HashMap<String, Object> imgList = reservationService.getStoreImgList(map);
	    resultMap.put("imgList", imgList.get("list"));
	    
	    HashMap<String, Object> reviewList = reservationService.getStoreReviewList(map);
	    resultMap.put("reviewList", reviewList.get("list"));
	    
	    HashMap<String, Object> reviewSummary = reservationService.getStoreReviewSummary(map);
	    resultMap.put("reviewCount", reviewSummary.get("count"));
	    resultMap.put("reviewAvg", reviewSummary.get("avg"));
	    resultMap.put("reviewSummaryText", reviewSummary.get("summaryText"));

	    return new Gson().toJson(resultMap); 
	}
	
	// 리뷰 수정
	@RequestMapping(value = "/reservation/review-update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    
	    try {
	        reservationService.updateReview(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }
	    
	    return new Gson().toJson(resultMap); 
	}

	// 리뷰 삭제
	@RequestMapping(value = "/reservation/review-remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    
	    try {
	        reservationService.removeReview(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", e.getMessage());
	    }
	    
	    return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping("/reservation/book.do")
	public String book(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("map", map);
		return "/reservation/book";
	}
	
	@RequestMapping(value = "/reservation/book.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String book(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
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
	
	@RequestMapping("/reservation/confirm.do")
	public String confirm(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
		
		return "/reservation/confirm";
	}
	
	@RequestMapping("/reservation/add-rsv.dox")
	@ResponseBody
	public String addRsv(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    
	    resultMap = reservationService.addReservation(map);
	    
	    return new Gson().toJson(resultMap);
	}
	
	// 결제 완료를 가정하고 completeReserviation 호출을 위한 임시 매서드
//	@GetMapping("/test/complete")
//	@ResponseBody
//	public HashMap<String, Object> testComplete(
//	        @RequestParam("rsvNo") int rsvNo,
//	        @RequestParam("slotNo") int slotNo) {
//	    
//	    HashMap<String, Object> map = new HashMap<>();
//	    map.put("rsvNo", rsvNo);
//	    map.put("slotNo", slotNo);
//	    map.put("userId", "test_user01"); // 로그 기록을 위한 임의 ID
//
//	    try {
//	        return reservationService.completeReservation(map);
//	    } catch (Exception e) {
//	        HashMap<String, Object> error = new HashMap<>();
//	        error.put("result", "error");
//	        error.put("message", e.getMessage());
//	        return error;
//	    }
//	}
	
//	@RequestMapping("/reservation/success.do")
//	public String rSuccess(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
//		
//		request.setAttribute("map", map);
//		
//		return "/reservation/success";
//	}
	
	
	// 결제 완료 후 취소 시,
	
	@RequestMapping(value = "/reservation/cancel.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rCancel(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        reservationService.removeRsv(map);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }
	    return new Gson().toJson(resultMap);
	}

	
}
