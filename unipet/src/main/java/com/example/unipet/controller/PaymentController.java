package com.example.unipet.controller;

import java.io.PrintWriter;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.PaymentService;
import com.google.gson.Gson;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class PaymentController {
	
	@Autowired
	PaymentService paymentService; 
	
	@RequestMapping("/payment/pay-rsv.do") 
	public String rsv(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/payment/pay-rsv";
	}
	
	@RequestMapping("/payment/sub.do") 
	public String sub(HttpServletRequest request, HttpServletResponse response, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		HttpSession session = request.getSession();
//	    String userId = (String) session.getAttribute("userId");
		String userId = "test_user01";
		request.setAttribute("totalprice", map.get("totalprice"));
	    if (userId == null) {
	        return "redirect:/login.do"; // 로그인 안 했으면 로그인부터!
	    }
	    int isSubscribed = paymentService.getSubStatus(userId); 
	    
	    if (isSubscribed > 0) {
	        // 인코딩 설정 (한글 깨짐 방지)
	        response.setContentType("text/html; charset=UTF-8");
	        PrintWriter out = response.getWriter();
	        
	        // 자바스크립트 직접 실행
	        out.println("<script>");
	        out.println("alert('이미 프리미엄 멤버십을 이용 중입니다.');");
	        out.println("location.href='/main.do';");
	        out.println("</script>");
	        
	        out.flush();
	        return null; 
	    }
		
		return "/payment/sub";
	}
	
	@RequestMapping("/payment/pay-sub.do") 
	public String paySub(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		request.setAttribute("totalprice", map.get("totalprice"));
		return "/payment/pay-sub";
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
	
	@RequestMapping(value = "/payment/billing.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String billing(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = paymentService.getBillingKey(map);
        
        return new Gson().toJson(resultMap); 
    }

}
