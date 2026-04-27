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
	public HashMap<String, Object> editBizStatusApr(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int result = adminMapper.updateBizStatusApr(map);
			
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
	}
	
	
	

	
}