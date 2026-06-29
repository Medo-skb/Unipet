package com.example.unipet.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.dao.ReviewService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ReviewController {
	
	@Autowired
	ReviewService reviewService;
	
	@RequestMapping("/user/mypage/rsv-review.do")
	public String rReview(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
		
		request.setAttribute("map", map);
		
		return "user/rsv-review";
	}
	
	@RequestMapping(value = "/reservation/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = reviewService.getRsvInfo(map);
	    return new Gson().toJson(resultMap); 
	}
	

	
	@RequestMapping("/user/mypage/add-review-rsv.dox")
	@ResponseBody
	public HashMap<String, Object> addReviewRsv(
	        @RequestParam HashMap<String, Object> map, 
	        @RequestParam(value = "files", required = false) List<MultipartFile> files) throws Exception {
	    
	    
	    return reviewService.addReviewRsv(map, files);
	}
	
	@RequestMapping("/user/mypage/prd-review.do")
	public String pReview(HttpServletRequest request, Model model,  @RequestParam HashMap<String, Object> map) throws Exception{
		
		request.setAttribute("map", map);
		
		return "/user/prd-review";
	}
	
	@RequestMapping(value = "/order/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String oInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = reviewService.getOrderInfo(map);
	    
	    return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping("/user/mypage/add-review-prd.dox")
	@ResponseBody
	public HashMap<String, Object> addReviewPrd(
	        @RequestParam HashMap<String, Object> map, 
	        @RequestParam(value = "files", required = false) List<MultipartFile> files) throws Exception {
	    
	    
	    return reviewService.addReviewPrd(map, files);
	}
	
	// 초기 리뷰 AI 요약 생성
	@RequestMapping(value = "/admin/review/summary/init.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public HashMap<String, Object> addInitialReviewSummary(@RequestParam HashMap<String, Object> map) throws Exception {
		return reviewService.addInitialReviewSummary(map);
	}

}
