package com.example.unipet.dao;

import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.PaymentMapper;
import com.example.unipet.model.Coupon;
import com.example.unipet.model.Order;
import com.example.unipet.model.Payment;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PaymentService {

	@Autowired 
	PaymentMapper paymentMapper;
	
	@Value("${toss.secret.key}")
    private String secretKey;
	
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
	            	if (!"Y".equals(map.get("isBatch"))) {
	                    paymentMapper.insertSub(map);
	                }	
	            } else if ("RSV".equals(payFlg)) {
	                paymentMapper.updateRsvStatus(map);
	            } else if ("SHOP".equals(payFlg)) {	
	            	
	            	// --- [Step 1] 포인트 처리 ---
	                Object val = map.get("usedPoint");
	                int usedPoint = (val != null) ? Integer.parseInt(val.toString()) : 0;
	                
	                if (usedPoint > 0) {
	                    paymentMapper.insertPoint(map); // insertPoint에서 pointNo 자동 생성/주입
	                } 

	                // --- [Step 2] 쿠폰 처리 ---
	                Object ucpNoObj = map.get("ucpNo");
	                if (ucpNoObj != null && !"".equals(ucpNoObj.toString())) {

	                    // orders 테이블의 COUPON_NO 컬럼에 넣기 위해 ucpNo를 대입
	                    map.put("couponNo", ucpNoObj); 
	                }

	                // --- [Step 3] 주문 마스터(orders) 생성 ---
	                // 주소 합치기
	                String fullAddr = map.get("userAddr") + " " + map.get("fullAddr");
	                map.put("ordAddr", fullAddr);
	                
	                // ORDERS에 INSERT (map에 ordNo 자동 주입)
	                paymentMapper.insertOrder(map);
	                resultMap.put("ordNo", map.get("ordNo"));
	                
	                // 포인트 업데이트
	                if (usedPoint > 0) {
	                    paymentMapper.updatePoint(map);
	                }
	                
	                // 쿠폰 업데이트
	                if (ucpNoObj != null && !"".equals(ucpNoObj.toString())) {
	                    paymentMapper.updateCouponStatus(map);
	                }

	                // --- [Step 4] 주문 상세(order_detail) 생성 ---
	                int generatedOrdNo = Integer.parseInt(String.valueOf(map.get("ordNo")));
	                String userId = (String) map.get("userId");

	                List<HashMap<String, Object>> orderList = (List<HashMap<String, Object>>) map.get("orderList");

	                for (HashMap<String, Object> item : orderList) {
	                    item.put("ordNo", generatedOrdNo); // 확보한 주문번호 연결
	                    item.put("userId", userId);
	                    paymentMapper.insertOrderDetail(item);
	                    int stockResult = paymentMapper.updateStock(item);
	                    if (stockResult == 0) {
	                        // 재고가 부족하여 업데이트가 안 된 경우, 강제로 예외를 발생시켜 전체 롤백
	                        throw new RuntimeException("상품번호 [" + item.get("productNo") + "]의 재고가 부족하여 결제를 진행할 수 없습니다.");
	                    }
	                    paymentMapper.deleteCart(item);
	                }
	                
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
	
	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        try {
            // 1. 매퍼 호출 (전달받은 map을 그대로 쿼리에 던짐)
            List<HashMap<String, Object>> list = paymentMapper.selectProductList(map);
            
            // 2. 결과 담기
            resultMap.put("list", list);
            resultMap.put("result", "success");
            
        } catch (Exception e) {
            // 에러 발생 시 로그 찍고 실패 리턴
            log.error("❌ 상품 목록 조회 중 에러: {}", e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", "데이터를 가져오는 중 오류가 발생했습니다.");
        }
        
        return resultMap;
    }
	
	public HashMap<String, Object> getBenefit(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    
	    try {
	        // 1. DB에서 쿠폰 리스트 조회
	        List<Coupon> couponList = paymentMapper.selectCoupon(map);
	        int userPoint = paymentMapper.selectUserPoint(map);
	        
	        String userId = (String) map.get("userId");
	        int subCount = paymentMapper.selectSubStatus(userId);
	        
	        // 2. 화면에 던져줄 데이터 세팅
	        resultMap.put("couponList", couponList);
	        resultMap.put("point", userPoint);
	        resultMap.put("isPremium", subCount > 0);
	        
	        resultMap.put("result", "success");
	         resultMap.put("message", Message.MSG_ADD); 
	        
	    } catch (Exception e) {
	        // 4. 에러 처리 (디폴트 템플릿 스타일 그대로 적용)
	        System.out.println(e.getMessage());
	        
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR); // 상수 클래스 사용!
	    }
	    
	    return resultMap;
	}

	
	public int getSubStatus(String userId) {
        return paymentMapper.selectSubStatus(userId);
    }
	
	@Transactional(rollbackFor = Exception.class)
    public HashMap<String, Object> getBillingKey(String customerKey, String authKey) {
        try {
            // 1. 시크릿 키 Base64 인코딩 (Basic Auth 규격, 콜론 필수)
            String encodedKey = Base64.getEncoder().encodeToString((secretKey + ":").getBytes());

            // 2. HTTP 헤더 및 바디 설정
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Basic " + encodedKey);
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> body = Map.of("customerKey", customerKey);
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(body, headers);

            // 3. 토스 API 호출
            String url = "https://api.tosspayments.com/v1/billing/authorizations/" + authKey;
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                Map<String, Object> resBody = response.getBody();
                String billingKey = (String) resBody.get("billingKey");
                
                // 카드사 이름 추출
                Map<String, Object> card = (Map<String, Object>) resBody.get("card");
                String company = (String) card.get("company");

                // 4. DB 저장 파라미터 조립 (payment_method 테이블 구조에 맞춤)
                HashMap<String, Object> param = new HashMap<>();
                param.put("userId", customerKey);
                param.put("pmName", company + "카드");
                param.put("billingKey", billingKey);
                
                // MyBatis 쿼리 실행
                paymentMapper.insertPaymentMethod(param);
                
                log.info("빌링키 발급 및 DB 저장 성공! 유저ID: {}, 카드: {}", customerKey, company);
                return param;
            }
        } catch (Exception e) {
            log.error("토스 빌링키 교환 중 에러 발생: {}", e.getMessage());
        }
        return null;
    }
	
	public HashMap<String, Object> executeBilling(String billingKey, String customerKey, int amount, String orderName, 
												  Integer methodNo, String isBatch) {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        try {
            // 1. 시크릿 키 인코딩 (Basic Auth)
            String encodedKey = Base64.getEncoder().encodeToString((secretKey + ":").getBytes());

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Basic " + encodedKey);
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 2. 고유한 주문번호 생성 (절대 중복되면 안 됨! 예: order_20260421_랜덤문자열)
            String orderId = "order_" + System.currentTimeMillis();

            // 3. 결제 요청 데이터 조립
            Map<String, Object> body = new HashMap<>();
            body.put("customerKey", customerKey);
            body.put("amount", amount);       // 결제할 금액 (예: 1000)
            body.put("orderId", orderId);     // 주문번호
            body.put("orderName", orderName); // 주문명 (예: "유니펫 베이직 구독")

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

            // 4. 토스 '빌링키 결제 실행 API' 호출
            // 주의: 아까 발급받을 때랑 URL이 다릅니다! URL 맨 끝에 발급받은 billingKey가 들어갑니다.
            String url = "https://api.tosspayments.com/v1/billing/" + billingKey;
            
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                // 결제 완전 성공!
            	HashMap<String, Object> resBody = (HashMap<String, Object>) response.getBody();
            	String paymentKey = (String) resBody.get("paymentKey");

            	log.info("결제 성공! 승인번호: {}", paymentKey);
                
            	HashMap<String, Object> map = new HashMap<String, Object>();
                // 1. addPayment() 내부의 if문을 타기 위한 제어 플래그
                map.put("payFlg", "SUB");       // 정기구독 결제
                map.put("payStatus", "PAY");    // 결제 성공
                map.put("isBatch", isBatch);
                
                // 2. insertSub 쿼리에 필요한 데이터
                
                map.put("userId", customerKey);
                map.put("totalprice", amount);  // 토스에 결제 요청했던 그 금액
                map.put("methodNo", methodNo);      // [주의] 결제수단 번호 (아래 설명 참고)

                // 3. insertPayment 쿼리에 필요한 추가 데이터
                map.put("payType", "card");     // 결제수단 종류
                map.put("ordName", orderName);  // "유니펫 베이직 구독" 등
                map.put("tid", paymentKey);     // 취소할 때 필요한 토스 고유 승인번호

                // 조립된 바구니를 들고 addPayment로 던집니다!
                // (addPayment -> insertSub 실행 -> SUB_NO 획득 -> insertPayment 실행)
                return this.addPayment(map);
            }
        } catch (Exception e) {
            log.error("빌링키 결제 실행 중 에러 발생: {}", e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", "결제 승인에 실패했습니다.");
        }
        
        return resultMap;
    }
	
	@Transactional(rollbackFor = Exception.class)
	public void executeAutoBilling(HashMap<String, Object> target) {
		log.info("📢 MyBatis에서 넘어온 원본 데이터: {}", target);
	    String billingKey = (String) target.get("BILLINGKEY");
	    String userId = (String) target.get("USER_ID");
	    int amount = Integer.parseInt(String.valueOf(target.get("SUB_PRICE")));
	    Integer methodNo = Integer.parseInt(String.valueOf(target.get("METHOD_NO")));
	    Integer subNo = Integer.parseInt(String.valueOf(target.get("SUB_NO")));

	    // [수정] 마지막 파라미터로 "Y"를 보냅니다. (이게 isBatch 값이 됩니다.)
	    HashMap<String, Object> payResult = this.executeBilling(billingKey, userId, amount, "유니펫 정기구독 갱신", methodNo, "Y");

	    if ("success".equals(payResult.get("result"))) {
	        // 결제 영수증(payment_master)은 addPayment가 알아서 넣었으니,
	        // 여기서는 기존 구독(subscription) 날짜만 업데이트합니다.
	        HashMap<String, Object> map = new HashMap<>();
	        map.put("subNo", subNo);
	        paymentMapper.updateSub(map);
	        
	        log.info("정기 갱신 완료: 유저 {}, 구독번호 {}", userId, subNo);
	    }
	}
	
	public List<HashMap<String, Object>> getTodayBillingList() {
	    // 매퍼 호출 (전달할 파라미터 없음)
	    return paymentMapper.selectTodaySub();
	}
	
	public HashMap<String, Object> getOrder(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {

	        Order info = paymentMapper.selectOrderMaster(map);
	        List<Order> list = paymentMapper.selectOrderDetail(map);
	        
	        // 3. 결과 맵에 담기 (Vue에서는 이전과 동일하게 사용 가능)
	        resultMap.put("info", info);
	        resultMap.put("list", list);
	        
	        resultMap.put("result", "success");
	        resultMap.put("message", "주문 내역 로드 성공");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", "서버 오류 발생");
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> getRsv(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {

	        Order info = paymentMapper.selectReservation(map);
	        
	        // 3. 결과 맵에 담기 (Vue에서는 이전과 동일하게 사용 가능)
	        resultMap.put("info", info);
	        
	        resultMap.put("result", "success");
	        resultMap.put("message", "주문 내역 로드 성공");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", "서버 오류 발생");
	    }
	    return resultMap;
	}
}	
	
