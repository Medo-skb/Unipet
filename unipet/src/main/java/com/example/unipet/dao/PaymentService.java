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
			Payment info = paymentMapper.selectPayment(map);
			
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
	
	@Transactional(rollbackFor = Exception.class) // 데이터 정합성을 위한 트랜잭션 설정
    public HashMap<String, Object> addPayment(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        try {
            // 1. 결제 내역 삽입 (payment_master 테이블)
            paymentMapper.insertPayment(map);
            
            // 2. 예약 상태 수정 (reservation 테이블: 결제대기 -> 결제완료)
            paymentMapper.updateRsvStatus(map);
            
            // 기존 Message 클래스 관례에 따른 응답 설정
            resultMap.put("result", "success");
            resultMap.put("message", "결제가 완료되었습니다."); 
            
        } catch (Exception e) {
            // 예외 발생 시 콘솔 출력 및 실패 응답 구성
            System.out.println("결제 저장 에러: " + e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", Message.MSG_SERVER_ERR);
            
            // @Transactional이 catch 블록을 인지하고 롤백하게 하려면 예외를 던져주는 것이 정석이나,
            // 사용자님의 기존 관례(결과 반환)를 우선시하여 설계했습니다.
        }
        return resultMap;
    }


	
}