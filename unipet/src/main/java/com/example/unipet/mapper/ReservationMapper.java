package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Reservation;
//import com.example.unipet.model.Review;
import com.example.unipet.model.Store;

@Mapper
public interface ReservationMapper {
	
	// 여러개 리턴 -> selectXXXList
	// 전체 업체 조회
	public List<Store> selectStoreList(HashMap<String, Object> map);
	// 업체 진료/서비스 조회
	public List<Store> selectStoreMenuList(HashMap<String, Object> map);
	// 업체 이미지 조회
	public List<Store> selectStoreImgList(HashMap<String, Object> map);
	// 업체 리뷰 조회
	public List<Store> selectStoreReviewList(HashMap<String, Object> map);
	// 업체 예약 슬롯 조회
	public List<Store> selectStoreSlotList(HashMap<String, Object> map);
	// 예약 서비스 완료 시간 지남 조회
	public List<Reservation> selectExpiredReservations(HashMap<String, Object> map);
	
	// 한개 리턴 -> selectXXX
	// 업체 상세 정보 조회
	public Store selectStoreInfo(HashMap<String, Object> map);
	// 예약 가능 여부 확인
	public int checkSlotAvailability(Object slotNo);
	// 업체 정책 조회
	public Store selectStorePolicy(HashMap<String, Object> map);
	// 업체 리뷰 통계 조회
	HashMap<String, Object> selectStoreReviewSummary(HashMap<String, Object> map);
	
	
	// 삭제 
	public int deleteDefault(HashMap<String, Object> map);
	
	// 수정
	public int updateDefault(HashMap<String, Object> map);
	// 예약 상태 변경 (WAI -> COM 등)
	public int updateRsvStatus(HashMap<String, Object> map);
	// 예약 상태 변경 (CNF -> CAN)
	public int updateRsvStatusCancel(HashMap<String, Object> map);
	// 슬롯 인원수 증가 및 상태 관리
	public int updateRsvSlot(HashMap<String, Object> map);
	// 슬롯 인원수 감소
	public int updateRsvSlotCancel(HashMap<String, Object> map);
	// 슬롯 상태 업데이트
	public int updateSlotStatus(HashMap<String, Object> map);
	// 예약 마감 시간이 지난 슬롯 일괄 'N'처리
	public int updateExpiredSlots();
	// 예약 서비스 완료 시간 지남 FIN 처리
	public int updateRsvStatusToFin(HashMap<String, Object> map);
	
	
	// 삽입 
	public int insertDefault(HashMap<String, Object> map);
	// 예약 기본 정보 삽입
	public int insertReservation(HashMap<String, Object> map);
	// 로그 기록 삽입
	public int insertRsvLog(HashMap<String, Object> map);
	
	
}
