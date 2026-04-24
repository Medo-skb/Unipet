package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.BizMyPage;

@Mapper
public interface BizMyPageMapper {
	// 오늘의 일정
	public List<BizMyPage> selectTodayScheduleList(HashMap<String, Object> map);
	
	// 메뉴 예약 분포
	public List<BizMyPage> selectMenuChartList(HashMap<String, Object> map);
	
	// 하루 예약 건수 차트
	public List<BizMyPage> selectDailyReservationChartList(HashMap<String, Object> map);
	
	// 승인된 업체 조회
	public BizMyPage selectApprovedStore(HashMap<String, Object> map);
	
	// 폐업 불가 예약 개수 조회
	public int selectCloseBlockedReservationCount(HashMap<String, Object> map);
	
	// 사업자 회원 탈퇴
	int selectStoreCountByUserId(Map<String, Object> map);
	int selectClosedStoreCount(Map<String, Object> map);
	int deleteStoreByUserId(Map<String, Object> map);
	int updateWithdrawRequestStatus(Map<String, Object> map);
	
	// 업체 이미지 리스트
	public List<BizMyPage> selectBizImgList(HashMap<String, Object> map);
	
	// 업체 소개 리스트
	public List<BizMyPage> selectBizStoreList(HashMap<String, Object> map);
	
	// 업체 메뉴 리스트
	public List<BizMyPage> selectBizStoreMenuList(HashMap<String, Object> map);

	// 이미지 개수 조회
	public int selectStoreImageCount(int storeNo);

	// 이미지 등록
	public void insertStoreImage(BizMyPage item);
	
	// 이미지 1건 조회 (파일 경로 얻기용)
	public BizMyPage selectStoreImage(int fileNo);

	// 이미지 삭제
	public void deleteStoreImage(int fileNo);
	
	// 선택한 이미지의 업체번호 조회
	public BizMyPage selectStoreImageInfo(int fileNo);

	// 해당 업체 이미지 전체 대표 해제
	public void updateStoreImageMainReset(int storeNo);

	// 선택한 이미지 대표 설정
	public void updateStoreImageMain(int fileNo);
	
	// 업체 기본정보 수정
	public void updateBizStore(HashMap<String, Object> map);

	// 업체 상세정보 수정
	public void updateBizStoreDetail(HashMap<String, Object> map);

	// 업체 정책 수정
	public void updateBizStorePolicy(HashMap<String, Object> map);
	
	// 업체 메뉴 수정
	public void updateBizStoreMenu(HashMap<String, Object> map);
	
	// 사업자 내 정보 조회
	public BizMyPage selectBizUserInfo(HashMap<String, Object> map);
	
	// 사업자 아이디 중복 확인
	public int checkBizUserId(HashMap<String, Object> map);

	// 사업자 내 정보 수정
	public void updateBizUser(HashMap<String, Object> map);
	
	// 예약 요약
	public BizMyPage selectReservationSummary(HashMap<String, Object> map);
	
	// 예약 목록
	public List<BizMyPage> selectReservationList(HashMap<String, Object> map);
	
	// 리뷰 요약
	public BizMyPage selectReviewSummary(HashMap<String, Object> map);
	
	// 리뷰 목록
	public List<BizMyPage> selectReviewList(HashMap<String, Object> map);
	
	// 리뷰 메뉴 목록
	public List<BizMyPage> selectReviewMenuList(HashMap<String, Object> map);
	
	// 리뷰 신고 등록
	public void insertReviewReport(HashMap<String, Object> map);
	
	
}