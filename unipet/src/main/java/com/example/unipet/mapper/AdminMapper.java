package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Admin;

@Mapper
public interface AdminMapper {
	
	// 관리자 로그인
	public Admin selectAdminLogin(HashMap<String, Object> map);
	
	// 쇼핑몰 문의 미답변 목록
	List<Admin> selectQnaAnswerList(HashMap<String, Object> map);

	// 쇼핑몰 문의 답변 등록
	int updateQnaAnswer(HashMap<String, Object> map);
	
	// 쇼핑몰 문의 삭제
	int deleteQna(HashMap<String, Object> map);
	
	// 사업자 승인 리스트
	public List<Admin> selectAdminBiz(HashMap<String, Object> map);
	
	// 사업자 승인
	public int updateStoreUserStatusApr(HashMap<String, Object> map);

	public int updateStoreStatusApr(HashMap<String, Object> map);

	public int updateStoreSubmitStatusApr(HashMap<String, Object> map);
	
	// 사업자 반려
	public int updateStoreUserStatusRej(HashMap<String, Object> map);

	public int updateStoreStatusRej(HashMap<String, Object> map);

	public int updateStoreSubmitStatusRej(HashMap<String, Object> map);
	
	// 예약 리뷰 신고 리스트
	public List<Admin> selectReservationReviewReportList(HashMap<String, Object> map);
	
	// 상품 리뷰 신고 리스트
	public List<Admin> selectProductReviewReportList(HashMap<String, Object> map);
	
	// 리뷰 신고 반려
	int updateReportStatusReject(Map<String, Object> map);
	
	// 리뷰 신고 승인
	int updateReportStatusApprove(Map<String, Object> map);

	int selectReviewFileCount(Map<String, Object> map);

	int deleteReviewFile(Map<String, Object> map);

	int deleteReview(Map<String, Object> map);
	
	// 커뮤니티 글 신고 리스트
	public List<Admin> selectCommunityPostReportList(HashMap<String, Object> map);

	// 커뮤니티 댓글 신고 리스트
	public List<Admin> selectCommunityCommentReportList(HashMap<String, Object> map);

	// 커뮤니티 신고 반려
	public int updateCommunityReportStatusReject(Map<String, Object> map);

	// 커뮤니티 신고 승인
	public int updateCommunityReportStatusApprove(Map<String, Object> map);

	// 커뮤니티 글 삭제
	public int deleteBoard(Map<String, Object> map);

	// 커뮤니티 댓글 삭제
	public int deleteBoardComment(Map<String, Object> map);

	// 커뮤니티 글 파일 삭제
	public int deleteBoardFile(Map<String, Object> map);
	
	// 밴 할건지 선택
	int updateUserStatusBan(String reportedUserId);
	
	// 승인 시 STORE_DETAIL 기본 등록
	void insertDefaultStoreDetail(HashMap<String, Object> map);

	// 승인 시 STORE_POLICY 기본 등록
	void insertDefaultStorePolicy(HashMap<String, Object> map);

	// 사업자 재신청 정보 조회
	Admin selectBizReapplyInfo(HashMap<String, Object> map);

	// 사업자 재신청 업체 검색
	List<Admin> selectBizExternalStoreList(HashMap<String, Object> map);

	// 재신청 업체 선택 가능 여부
	int selectBizReapplyStoreCount(HashMap<String, Object> map);

	// 재신청 사업자등록증 파일 저장
	int insertBizReapplyStoreFile(HashMap<String, Object> map);

	// 재신청 STORE_USER 수정
	int updateStoreUserReapply(HashMap<String, Object> map);

	// 기존 반려 업체가 바뀐 경우 기존 업체 초기화
	int updateOldStoreReapplyReset(HashMap<String, Object> map);

	// 재신청 STORE 수정
	int updateStoreReapplyPending(HashMap<String, Object> map);

	// 재신청 STORE_SUBMIT 수정
	int updateStoreSubmitReapplyPending(HashMap<String, Object> map);

	// 회원조회 및 관리 리스트
	List<Admin> selectAdminUserList(HashMap<String, Object> map);

	// 회원 기본 정보 상세
	Admin selectAdminUserBasic(HashMap<String, Object> map);

	// 회원 상태 수정
	int updateAdminUserStatus(HashMap<String, Object> map);

	// 회원 닉네임 수정
	int updateAdminUserNickname(HashMap<String, Object> map);

	// 회원 반려동물 상세
	List<Admin> selectAdminUserPetList(HashMap<String, Object> map);

	// 회원 구독 상세
	Admin selectAdminUserSubscription(HashMap<String, Object> map);

	// 회원 포인트 상세
	List<Admin> selectAdminUserPointList(HashMap<String, Object> map);

	// 회원 쿠폰 상세
	List<Admin> selectAdminUserCouponList(HashMap<String, Object> map);

	// 회원 주문 상세
	List<Admin> selectAdminUserOrderList(HashMap<String, Object> map);

	// 회원 예약 상세
	List<Admin> selectAdminUserReservationList(HashMap<String, Object> map);

	// 회원 리뷰 상세
	List<Admin> selectAdminUserReviewList(HashMap<String, Object> map);

	// 회원 신고 상세
	List<Admin> selectAdminUserReportList(HashMap<String, Object> map);

	// 회원 커뮤니티 글 상세
	List<Admin> selectAdminUserCommunityPostList(HashMap<String, Object> map);

	// 회원 커뮤니티 댓글 상세
	List<Admin> selectAdminUserCommunityCommentList(HashMap<String, Object> map);

	// 사업자 회원조회 및 관리 리스트
	List<Admin> selectAdminBusinessUserList(HashMap<String, Object> map);

	// 사업자 기본 정보 상세
	Admin selectAdminBusinessUserBasic(HashMap<String, Object> map);

	// 사업자 업체 상세
	Admin selectAdminBusinessUserStoreDetail(HashMap<String, Object> map);

	// 사업자 업체 메뉴 목록
	List<Admin> selectAdminBusinessUserMenuList(HashMap<String, Object> map);

	// 사업자 업체 이미지 목록
	List<Admin> selectAdminBusinessUserStoreFileList(HashMap<String, Object> map);

	// 사업자 리뷰 상세
	List<Admin> selectAdminBusinessUserReviewList(HashMap<String, Object> map);

	// 사업자 리뷰 신고 상세
	List<Admin> selectAdminBusinessUserReportList(HashMap<String, Object> map);

	// 사업자 예약 상세
	List<Admin> selectAdminBusinessUserReservationList(HashMap<String, Object> map);

	// 회원 신고 누적 증가
	int updateUserRepCount(Map<String, Object> map);
	
	int selectAdminUserCount(HashMap<String, Object> map);

	int selectAdminBusinessUserCount(HashMap<String, Object> map);

	int selectBusinessActiveReservationCount(HashMap<String, Object> map);

	int updateAdminBusinessUserStatus(HashMap<String, Object> map);

	int updateAdminBusinessStoreStatus(HashMap<String, Object> map);
	
	int selectAdminProductCount(HashMap<String, Object> map);

	List<Admin> selectAdminProductList(HashMap<String, Object> map);

	Admin selectAdminProductDetail(HashMap<String, Object> map);

	List<Admin> selectAdminProductFileList(HashMap<String, Object> map);
	
	int updateAdminProduct(HashMap<String, Object> map);

	int selectAdminProductMainImageCount(HashMap<String, Object> map);

	int selectAdminProductDetailImageCount(HashMap<String, Object> map);

	int updateAdminProductMainImage(HashMap<String, Object> map);

	int updateAdminProductDetailImage(HashMap<String, Object> map);

	int insertAdminProductMainImage(HashMap<String, Object> map);

	int insertAdminProductDetailImage(HashMap<String, Object> map);
	
	List<Admin> selectAdminAnimalMainCategoryList(HashMap<String, Object> map);

	List<Admin> selectAdminAnimalSubCategoryList(HashMap<String, Object> map);

	List<Admin> selectAdminItemMainCategoryList(HashMap<String, Object> map);

	List<Admin> selectAdminItemSubCategoryList(HashMap<String, Object> map);

	int insertAdminProduct(HashMap<String, Object> map);

	int insertAdminProductFile(HashMap<String, Object> map);

}
