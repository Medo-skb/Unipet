package com.example.unipet.controller;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
		model.addAttribute("rsvNo", map.get("rsvNo"));		
		return "/payment/pay-rsv";
	}
	
	@RequestMapping("/payment/pay-shop.do") 
	public String shop(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("sessionId");

		return "/payment/pay-shop";
	}
	
	@RequestMapping("/payment/sub.do") 
	public String sub(HttpServletRequest request, HttpServletResponse response, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		HttpSession session = request.getSession();
	    String userId = (String) session.getAttribute("sessionId");
		request.setAttribute("totalprice", map.get("totalprice"));
		
		response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
	    if (userId == null) {
	    	out.println("<script>");
	        out.println("alert('로그인이 필요한 서비스입니다.');");
	        out.println("location.href='/user/login.do';");
	        out.println("</script>");
	        
	        out.flush();
	        return null; 
	    }
	    
	    int isSubscribed = paymentService.getSubStatus(userId); 
	    
	    if (isSubscribed > 0) {
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

	@GetMapping("/payment/toss-success.do")
	public String tossSuccess(@RequestParam String customerKey, @RequestParam String authKey) {
		// 1. 빌링키 발급 및 DB 저장 (HashMap으로 결과를 받습니다)
	    HashMap<String, Object> billingResult = paymentService.getBillingKey(customerKey, authKey);
	    
	    // 결과 바구니가 비어있지 않다면 성공!
	    if (billingResult != null && billingResult.get("billingKey") != null) {
	        
	        // 2. HashMap에서 필요한 정보를 직접 꺼냅니다.
	        String savedBillingKey = (String) billingResult.get("billingKey");
	        Integer methodNo = Integer.parseInt(String.valueOf(billingResult.get("methodNo")));
	        
	        System.out.println("✅ 빌링키 발급 성공! 카드번호(methodNo): " + methodNo);

	        // 3. 꺼낸 정보(savedBillingKey, methodNo)를 들고 실제 결제를 진행합니다.
	        HashMap<String, Object> payResult = paymentService.executeBilling(
	            savedBillingKey, 
	            customerKey, 
	            1000, 
	            "유니펫 프리미엄 구독",
	            methodNo,
	            "N"
	        );

	        // 4. 최종 결과 확인
	        if ("success".equals(payResult.get("result"))) {
	            System.out.println("구독 및 결제 성공");
	            return "redirect:/main.do"; 
	        } else {
	            System.out.println("결제 승인 실패");
	            return "redirect:/payment/sub.do"; 
	        }
	        
	    } else {
	        System.out.println("결제 수단 등록 실패");
	        return "redirect:/payment/sub.do"; 
	    }
	}
	
	@RequestMapping("/payment/pay-success.do")
	public String paymentSuccessPage(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {
	    // 2. 파라미터로 받은 orderNo(또는 rsvNo)를 request에 담기 (Attribute 세팅)
	    request.setAttribute("ordNo", map.get("ordNo"));
	    request.setAttribute("rsvNo", map.get("rsvNo"));
	    
	    return "payment/pay-success";
	}
	
	@RequestMapping("/payment/refund-shop.do")
	public String refund(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {
	    // 2. 파라미터로 받은 orderNo(또는 rsvNo)를 request에 담기 (Attribute 세팅)
	    request.setAttribute("ordNo", map.get("ordNo"));
	    
	    return "payment/refund-shop";
	}
	
	@RequestMapping("/payment/refund-rsv.do")
    public String refundReservation(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {
        // 예약 번호(rsvNo)를 넘겨받아 페이지에 전달
        request.setAttribute("rsvNo", map.get("rsvNo"));
        return "payment/refund-rsv";
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
	
	@PostMapping(value = "/payment/add.dox", consumes = MediaType.APPLICATION_JSON_VALUE, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public HashMap<String, Object> savePaymentJson(@RequestBody HashMap<String, Object> map) throws Exception {

	    return paymentService.addPayment(map); 
	}
	
	@RequestMapping(value = "/payment/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String userInfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = paymentService.getUser(map);
        
        return new Gson().toJson(resultMap); 
    }
	
	@PostMapping(value = "/payment/orderList.dox") // RequestMapping보다 명확한 PostMapping 권장
	@ResponseBody
	public HashMap<String, Object> getOrderList(
	    HttpSession session, 
	    @RequestBody HashMap<String, Object> map // ★ @RequestParam -> @RequestBody로 변경
	) throws Exception {

	    HashMap<String, Object> resultMap = paymentService.getCartList(map);

	    // 스프링 부트에서는 그냥 Map을 리턴하면 자동으로 JSON으로 변환해주므로 Gson이 필요 없습니다.
	    return resultMap;
	}
	
	@RequestMapping(value = "/payment/getBenefit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBenefit(Model model, HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
	    String userId = (String) session.getAttribute("sessionId");
	    map.put("userId", userId);
	    
	    HashMap<String, Object> resultMap = paymentService.getBenefit(map);
	    return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/payment/getOrder.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getOrder(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        resultMap = paymentService.getOrder(map); 
        return new Gson().toJson(resultMap); 
    }
	@RequestMapping(value = "/payment/getRsv.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRsv(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = paymentService.getRsv(map); 
		return new Gson().toJson(resultMap); 
	}
	
    @RequestMapping(value = "/payment/productRefund.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String productRefund(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();     
        resultMap = paymentService.refundPayment(map);
        

        return new Gson().toJson(resultMap); 
    }
    
    @RequestMapping(value = "/payment/rsvRefund.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String reservationRefund(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();     
        // 예약 전용 서비스 함수 호출
        resultMap = paymentService.refundReservation(map);
        return new Gson().toJson(resultMap); 
    }
    
    @RequestMapping(value = "/payment/getRsvDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getReservationDetail(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        
        resultMap = paymentService.getRsvDetail(map);
        
        return new Gson().toJson(resultMap); 
    }
	
}
