package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.AdminMapper;
import com.example.unipet.model.Admin;

@Service
public class AdminService {

	@Autowired 
	AdminMapper adminMapper;
	
	// 관리자 로그인
	public Admin getLoginAdmin(HashMap<String, Object> map) {
		return adminMapper.selectAdminLogin(map);
	}
	
	// 쇼핑몰 문의 미답변 목록
	public HashMap<String, Object> getQnaAnswerList(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        List<Admin> list = adminMapper.selectQnaAnswerList(map);

	        resultMap.put("list", list);
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }

	    return resultMap;
	}
	
	// 쇼핑몰 문의 답변 등록
	public HashMap<String, Object> editQnaAnswer(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        adminMapper.updateQnaAnswer(map);

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }

	    return resultMap;
	}
	
	// 쇼핑몰 문의 삭제
	public HashMap<String, Object> removeQna(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        adminMapper.deleteQna(map);

	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	    }

	    return resultMap;
	}
	
	// 사업자 승인 리스트
	public HashMap<String, Object> getAdminBiz(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectAdminBiz(map);
			
			resultMap.put("list", list);
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
	
	// 사업자 승인
	@Transactional
	public HashMap<String, Object> editBizStatusApr(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        int result = adminMapper.updateBizStatusApr(map);

	        adminMapper.insertDefaultStoreDetail(map);
	        adminMapper.insertDefaultStorePolicy(map);

	        resultMap.put("result", "success");
	        resultMap.put("message", Message.MSG_ADD);

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }

	    return resultMap;
	}
	
	// 사업자 거부
	public HashMap<String, Object> editBizStatusRej(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = adminMapper.updateBizStatusRej(map);
			
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 예약 리뷰 신고 리스트
	public HashMap<String, Object> getReservationReviewReportList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectReservationReviewReportList(map);
			
			resultMap.put("list", list);
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
	
	// 상품 리뷰 신고 리스트
	public HashMap<String, Object> getProductReviewReportList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Admin> list = adminMapper.selectProductReviewReportList(map);
			
			resultMap.put("list", list);
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
	
	// 리뷰 신고 반려
	@Transactional
	public void rejectReport(Map<String, Object> map) {
		adminMapper.updateReportStatusReject(map);
	}

	// 리뷰 신고 승인
	@Transactional
	public void approveReport(Map<String, Object> map) {

	    // 1. 신고 상태 승인 처리
	    adminMapper.updateReportStatusApprove(map);

	    // 2. 리뷰 파일이 있으면 삭제
	    int fileCnt = adminMapper.selectReviewFileCount(map);
	    if (fileCnt > 0) {
	        adminMapper.deleteReviewFile(map);
	    }

	    // 3. 리뷰 삭제
	    adminMapper.deleteReview(map);

	    // 4. 정지 여부가 Y면 USERS.USER_STATUS = 'BAN'
	    if ("Y".equals(map.get("banYn"))) {
	        adminMapper.updateUserStatusBan((String) map.get("reportedUserId"));
	    }
	}
	
	// 커뮤니티 글 신고 리스트
	public HashMap<String, Object> getCommunityPostReportList(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        List<Admin> list = adminMapper.selectCommunityPostReportList(map);

	        resultMap.put("list", list);
	        resultMap.put("result", "success");
	        resultMap.put("message", Message.MSG_SEARCH);
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }
	    return resultMap;
	}

	// 커뮤니티 댓글 신고 리스트
	public HashMap<String, Object> getCommunityCommentReportList(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	        List<Admin> list = adminMapper.selectCommunityCommentReportList(map);

	        resultMap.put("list", list);
	        resultMap.put("result", "success");
	        resultMap.put("message", Message.MSG_SEARCH);
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }
	    return resultMap;
	}

	// 커뮤니티 신고 반려
	@Transactional
	public void rejectCommunityReport(Map<String, Object> map) {
	    adminMapper.updateCommunityReportStatusReject(map);
	}

	// 커뮤니티 신고 승인
	@Transactional
	public void approveCommunityReport(Map<String, Object> map) {

	    // 신고 상태를 ACC로 변경
	    adminMapper.updateCommunityReportStatusApprove(map);

	    // 신고 대상 글/댓글 삭제
	    String type = (String) map.get("type");

	    if ("POST".equals(type)) {
	        adminMapper.deleteBoardFile(map);
	        adminMapper.deleteBoard(map);
	    } else if ("COMMENT".equals(type)) {
	        adminMapper.deleteBoardComment(map);
	    }

	    // 계정 정지 선택 시 USERS.USER_STATUS = BAN
	    if ("Y".equals(map.get("banYn"))) {
	        adminMapper.updateUserStatusBan((String) map.get("reportedUserId"));
	    }
	}
	
	
	
}