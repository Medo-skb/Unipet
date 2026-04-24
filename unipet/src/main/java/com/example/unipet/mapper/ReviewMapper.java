package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Default;
import com.example.unipet.model.Order;
import com.example.unipet.model.Reservation;
import com.example.unipet.model.Review;

@Mapper
public interface ReviewMapper {
	
	// 여러개 리턴 -> selectXXXList
	public List<Default> selectDefaultList(HashMap<String, Object> map);
	
	// 한개 리턴 -> selectXXX
	public Default selectDefault(HashMap<String, Object> map);
	// 주문 상세 정보 조회
	public Order selectOrderInfo(HashMap<String, Object> map);
	// 예약 상세 정보 조회
	public Reservation selectRsvInfo(HashMap<String, Object> map);
	
	// 삭제 
	public int deleteDefault(HashMap<String, Object> map);
	
	// 수정
	public int updateDefault(HashMap<String, Object> map);
	
	// 삽입 
	public int insertDefault(HashMap<String, Object> map);
	// 예약 서비스 리뷰 삽입
	public int insertReviewRsv(HashMap<String, Object> map);
	// 상품 주문 리뷰 삽입
	public int insertReviewPrd(HashMap<String, Object> map);
	// 상품 주문 및 예약 서비스 리뷰 파일 삽입
	public int insertReviewFile(HashMap<String, Object> map);
	
}
