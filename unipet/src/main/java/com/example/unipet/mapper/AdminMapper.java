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
	
	// 사업자 승인 리스트
	public List<Admin> selectAdminBiz(HashMap<String, Object> map);
	
	// 사업자 승인
	public int updateBizStatusApr(HashMap<String, Object> map);
	
	// 사업자 거부
	public int updateBizStatusRej(HashMap<String, Object> map);
	
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
	
}