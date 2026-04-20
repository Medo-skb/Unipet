package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestTemplate;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.DefaultMapper;
import com.example.unipet.mapper.PaymentMapper;
import com.example.unipet.model.Payment;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PaymentService {

	@Autowired 
	PaymentMapper paymentMapper;
	
	@Value("${portone.api.secret}")
    private String apiSecret;
	
	@Value("${portone.channel.billing}")
    private String billingChannelKey;
	
	private final RestTemplate restTemplate = new RestTemplate();
	
	// 조회 -> get, 수정 -> edit, 삽입 -> add, 삭제 -> remove
	// ex) 학생목록 : getStudentList, 학생수정 -> editStudent
	
	public HashMap<String, Object> getPayment(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Payment info = paymentMapper.selectRsvPayment(map);
			
			int totalPrice = info.getMenuPrice();
			int deposit = (int) (totalPrice * 0.1);
			int balance = totalPrice - deposit;
			
			resultMap.put("info", info);
			resultMap.put("deposit", deposit);
	        resultMap.put("balance", balance);
	        
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getUser(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Payment info = paymentMapper.selectUser(map);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> addPayment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        String payStatus = (String) map.get("payStatus");
	        String payFlg = (String) map.get("payFlg");

	        if ("PAY".equals(payStatus)) {
	            // 1. 서비스 유형별 상태 업데이트 및 처리
	            if ("SUB".equals(payFlg)) {

	            } else if ("RSV".equals(payFlg)) {
	                paymentMapper.updateRsvStatus(map);
	            } else if ("SHOP".equals(payFlg)) {	
//	                paymentMapper.updateShopOrderStatus(map)'';
	            }
	            
	            // 2. 최종 결제 내역 저장
	            paymentMapper.insertPayment(map);
	            resultMap.put("result", "success");
	            resultMap.put("message", "결제 및 서비스 등록이 완료되었습니다.");
	        } else {
	            // 결제 실패 시 내역만 저장 (실패 로그용)
	            paymentMapper.insertPayment(map);
	            resultMap.put("result", "fail");
	            resultMap.put("message", "결제에 실패하였습니다.");
	        }
	    } catch (Exception e) {
	        System.out.println("결제 처리 중 에러 발생: " + e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", "서버 오류가 발생했습니다.");
	        
	        // 트랜잭션 롤백을 위해 예외를 던집니다. (빌링키만 저장되고 결제 안되는 상황 방지)
	        throw new RuntimeException("Payment processing failed: " + e.getMessage()); 
	    }
	    return resultMap;
    }
	
	public int getSubStatus(String userId) {
        return paymentMapper.selectSubStatus(userId);
    }
	
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> getBillingKey(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        Payment userInfo = paymentMapper.selectUser(map);
	        if (userInfo == null) {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "유저 정보를 찾을 수 없습니다.");
	            return resultMap;
	        }

	        // [수정 1] 카드 번호에서 하이픈(-) 제거
	        String cleanCardNumber = ((String) map.get("cardNumber")).replaceAll("-", "");

	        Map<String, String> credential = new HashMap<>();
	        credential.put("number", ((String) map.get("cardNumber")).replaceAll("-", "")); // 하이픈 제거 필수
	        credential.put("expiryYear", (String) map.get("expiryYear"));
	        credential.put("expiryMonth", (String) map.get("expiryMonth"));
	        credential.put("birthOrBusinessRegistrationNumber", (String) map.get("birth"));
	        credential.put("passwordTwoDigits", (String) map.get("pwd2Digit"));

	        // [수정 2] customer.name을 객체로 변경 (가장 중요)
	        Map<String, String> customerName = new HashMap<>();
	        customerName.put("full", userInfo.getUserName());

	        // [수정 3] 전화번호에서도 혹시 모를 하이픈 제거
	        String cleanPhone = userInfo.getPhone() != null ? userInfo.getPhone().replaceAll("-", "") : "";

	        Map<String, Object> customer = new HashMap<>();
	        customer.put("id", (String) map.get("userId"));
	        customer.put("name", Map.of("full", userInfo.getUserName())); // String이 아니라 반드시 Map.of!!
	        customer.put("email", userInfo.getEmail());
	        customer.put("phoneNumber", userInfo.getPhone().replaceAll("-", "")); // 하이픈 제거 필수
	        
	        Map<String, Object> billingReq = new HashMap<>();
	        billingReq.put("channelKey", billingChannelKey); 
	        billingReq.put("customer", customer); 
	        billingReq.put("method", Map.of("card", Map.of("credential", credential)));

	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.APPLICATION_JSON);
	        headers.set("Authorization", "PortOne " + apiSecret);

	        // [STEP 1] 포트원 빌링키 발급 API 호출
	        String billingRes = restTemplate.postForObject("https://api.portone.io/billing-keys", new HttpEntity<>(billingReq, headers), String.class);
	        JsonObject billingObj = JsonParser.parseString(billingRes).getAsJsonObject();

	        if (billingObj.has("billingKey")) {
	            String issuedBillingKey = billingObj.get("billingKey").getAsString();
	            
	            // [STEP 2] 우리 DB에 빌링키 저장 (payment_method)
	            map.put("issuedBillingKey", issuedBillingKey);
	            map.put("pmName", "등록카드"); 
	            paymentMapper.insertPaymentMethod(map); 

	            // [STEP 3] 유저 구독 상태 확인 (int 타입 대응)
	            // 0 이면 'N'(미구독), 1 이상이면 'Y'(구독 중)
	            int subStatus = paymentMapper.selectSubStatus((String) map.get("userId"));
	            
	            // [STEP 4] 구독 중이 아니면(0 == 'N') 즉시 결제 진행
	            if (subStatus == 0) {
	                log.info("미구독 유저 -> 즉시 결제 진행: {}", map.get("userId"));
	                
	                String paymentId = "ORD-" + System.currentTimeMillis();
	                
	                Map<String, Object> payBody = new HashMap<>();
	                payBody.put("billingKey", issuedBillingKey);
	                payBody.put("orderName", "UNIPET 프리미엄 정기구독");
	                // totalprice가 Object일 수 있으므로 안전하게 형변환
	                payBody.put("amount", Map.of("total", Integer.parseInt(String.valueOf(map.get("totalprice")))));
	                payBody.put("currency", "KRW");
	                payBody.put("channelKey", billingChannelKey);

	                // [STEP 5] 포트원 빌링키 결제 API 호출
	                String payRes = restTemplate.postForObject(
	                    "https://api.portone.io/payments/" + paymentId + "/billing-key", 
	                    new HttpEntity<>(payBody, headers), 
	                    String.class
	                );
	                
	                JsonObject payObj = JsonParser.parseString(payRes).getAsJsonObject();
	                
	                // [STEP 6] 결제 성공 시 payment_master 저장
	                if (payObj.has("payment")) {
	                    map.put("paymentId", paymentId);
	                    map.put("payStatus", "PAY");
	                    map.put("payFlg", "SUB");
	                    
	                    paymentMapper.insertPayment(map);
	                    
	                    resultMap.put("result", "success");
	                    resultMap.put("message", "구독 시작 및 첫 달 결제가 완료되었습니다.");
	                } else {
	                    resultMap.put("result", "fail");
	                    resultMap.put("message", "빌링키는 등록되었으나 첫 결제에 실패했습니다.");
	                }
	            } else {
	                // 이미 구독 중인 경우 (subStatus > 0)
	                resultMap.put("result", "success");
	                resultMap.put("message", "결제 수단 변경이 완료되었습니다.");
	            }
	        } else {
	            resultMap.put("result", "fail");
	            resultMap.put("message", "카드 정보를 다시 확인해주세요.");
	        }
	    } catch (Exception e) {
	        log.error("정기결제 프로세스 에러: {}", e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", "서버 통신 중 오류가 발생했습니다.");
	    }
	    return resultMap;
	}
}
	
