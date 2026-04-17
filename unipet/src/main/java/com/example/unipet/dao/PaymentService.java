package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.DefaultMapper;
import com.example.unipet.mapper.PaymentMapper;
import com.example.unipet.model.Payment;

@Service
public class PaymentService {

	@Autowired 
	PaymentMapper paymentMapper;
	
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
            
            if ("PAY".equals(payStatus)) {
                // 구독인 경우, 수단과 구독 정보를 먼저 생성해서 PK를 확보함
                if (map.get("subNo") != null && !"0".equals(String.valueOf(map.get("subNo")))) {
                    this.addSubscription(map); // 여기서 methodNo, subNo가 map에 채워짐
                } 
                
                // 확보된 subNo 등이 포함된 상태로 마스터 이력 삽입
                paymentMapper.insertPayment(map);

                // 다른 서비스(예약, 쇼핑몰) 상태 업데이트
                if (map.get("rsvNo") != null && !"0".equals(String.valueOf(map.get("rsvNo")))) {
                    paymentMapper.updateRsvStatus(map);
                } else if (map.get("ordNo") != null && !"0".equals(String.valueOf(map.get("ordNo")))) {
                    // paymentMapper.updateShopOrderStatus(map);
                }

                resultMap.put("message", "결제가 완료되었습니다.");
            } else {
                resultMap.put("message", "결제에 실패하여 내역만 저장되었습니다.");
            }
            
            resultMap.put("result", "success");
            
        } catch (Exception e) {
            // 예외 발생 시 콘솔 출력 및 실패 응답 구성
            System.out.println("결제 저장 에러: " + e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", Message.MSG_SERVER_ERR);
            
            // 트랜잭션 롤백을 위해 런타임 예외를 명시적으로 던져주는 것이 좋음
            throw new RuntimeException(e); 
        }
        return resultMap;
    }
	
	public void addSubscription(HashMap<String, Object> map) {
		Integer existingMethodNo = paymentMapper.selectMethod(map);
		
		paymentMapper.updateAllDefaultN(map);
		
		if (existingMethodNo != null) {
	        // [기존 빌링키인 경우] -> UPDATE
	        // 1) 조회된 PK를 map에 담아 구독 정보 저장 시 활용함
	        map.put("methodNo", existingMethodNo);
	        
	        // 2) 새로 넣는 게 아니라, 기존 데이터의 상태를 'Y'로 갱신 (이미 있는 데이터 재활용)
	        paymentMapper.updateDefault(map); 
	    } else {
	        // [신규 빌링키인 경우] -> INSERT
	        // 1) 테이블에 새로운 행을 추가함 (IS_DEFAULT='Y'로 삽입)
	        // 2) useGeneratedKeys 설정으로 인해 생성된 PK가 map의 'methodNo'에 담김
	        paymentMapper.insertPaymentMethod(map); 
	    }
		
		// 3. 위에서 결정된(기존 PK 혹은 신규 PK) methodNo를 사용하여 구독 생성
	    paymentMapper.insertSub(map);
	  
	}
	
}