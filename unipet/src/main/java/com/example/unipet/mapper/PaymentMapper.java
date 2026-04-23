package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Coupon;
import com.example.unipet.model.Default;
import com.example.unipet.model.Order;
import com.example.unipet.model.Payment;

@Mapper
public interface PaymentMapper {
	
	// 예약 한개 리턴
	public Payment selectRsvPayment(HashMap<String, Object> map);
	
	// 유저 한개 리턴
	public Payment selectUser(HashMap<String, Object> map);

	// 오늘자 구독 갱신자 여럿 리턴
	public List<HashMap<String, Object>> selectTodaySub();
	
	// 결제할 상품 목록
	public List<HashMap<String, Object>> selectProductList(HashMap<String, Object> map);
	
	// 쿠폰 내역 검색
	public List<Coupon> selectCoupon(HashMap<String, Object> map);
	
	// 오더 마스터 검색
    public Order selectOrderMaster(HashMap<String, Object> map);
    
    // 오더 디테일 검색
    public List<Order> selectOrderDetail(HashMap<String, Object> map);
    
    // 예약 내역 검색
    public Order selectReservation(HashMap<String, Object> map);
	
	// 포인트 내역 검색
	public int selectUserPoint(HashMap<String, Object> map);
	
	// 결제 내역 추가
	public int insertPayment(HashMap<String, Object> map);

	// 예약 상태 변경
	public int updateRsvStatus(HashMap<String, Object> map);
	
	// 구독 상태 검색
	public int selectSubStatus(String userId);
	
	// 빌링키 등록 및 업데이트
	public int insertPaymentMethod(HashMap<String, Object> map);
	
	// 구독 내역 추가
	public int insertSub(HashMap<String, Object> map);
	
	// 구독 내역 업데이트
	public int updateSub(HashMap<String, Object> map);
	
	// 포인트 내역 추가
	public int insertPoint(HashMap<String, Object> map);
	
	// 주문서 내역 추가
	public int insertOrder(HashMap<String, Object> map);

	// 주문서 내역 추가
	public int insertOrderDetail(HashMap<String, Object> map);
	
	// 쿠폰 사용 내역 업데이트
	public int updateCouponStatus(HashMap<String, Object> map);

	// 포인트 업데이트
	public int updatePoint(HashMap<String, Object> map);
	
	// 장바구니에서 삭제
	public int deleteCart(HashMap<String, Object> map);
	
	// 재고 수량 업데이트
	public int updateStock(HashMap<String, Object> map);
	
}
