package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Default;
import com.example.unipet.model.Payment;

@Mapper
public interface PaymentMapper {
	
	// 한개 리턴 -> selectXXX
	public Payment selectRsvPayment(HashMap<String, Object> map);
	
	public Payment selectUser(HashMap<String, Object> map);

	// 삽입 -> insertXXX (결제 내역 추가)
	public int insertPayment(HashMap<String, Object> map);

	// 수정 -> updateXXX (예약 상태 변경)
	public int updateRsvStatus(HashMap<String, Object> map);
	
	public Integer selectMethod(HashMap<String, Object> map);
	
	public void updateAllDefaultN(HashMap<String, Object> map);
	
	public void updateDefault(HashMap<String, Object> map);
	
	public void insertPaymentMethod(HashMap<String, Object> map);
	
	public void insertSub(HashMap<String, Object> map);
	
}
