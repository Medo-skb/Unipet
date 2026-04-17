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
	public String rsv(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/payment/pay-rsv";
	}
	
	@RequestMapping("/payment/sub.do") 
	public String sub(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/payment/sub";
	}
	
	// ajax가 호출하는 주소
	@RequestMapping(value = "/payment/rsv.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rsv(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = paymentService.getPayment(map);
 
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/payment/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String savePayment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        // 서비스 내부에서 insertPayment와 updateRsvStatus를 순차적으로 실행
        // map에는 payStatus('PAY' 또는 'FAL')가 포함되어 있어야 함
        HashMap<String, Object> resultMap = paymentService.addPayment(map);
        
        return new Gson().toJson(resultMap); 
    }
	
	@RequestMapping(value = "/payment/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String userInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = paymentService.getUser(map);
        
        return new Gson().toJson(resultMap); 
    }

}
