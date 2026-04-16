package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.DefaultService;
import com.example.unipet.dao.PaymentService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class PaymentController {
	
	@Autowired
	PaymentService paymentService; 
	
	@RequestMapping("/payment/pay-rsv.do") 
	public String copy(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/payment/pay-rsv";
	}
	
	// ajax가 호출하는 주소
	@RequestMapping(value = "/payment/rsv.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String copy(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.getPayment(map);
 
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/payment/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String savePayment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    // 1. 서비스 호출을 통해 DB 저장 및 예약 상태 업데이트 수행
	    HashMap<String, Object> resultMap = paymentService.addPayment(map);
	    
	    // 2. 최종 결과를 JSON 문자열로 변환하여 반환
	    return new Gson().toJson(resultMap); 
	}
	

}
