package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.BizMyPageMapper;
import com.example.unipet.model.BizMyPage;

@Service
public class BizMyPageService {

	@Autowired 
	BizMyPageMapper bizMyPageMapper;
	
	// 업체 이미지 리스트
	public HashMap<String, Object> getBizImgList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<BizMyPage> list = bizMyPageMapper.selectBizImgList(map);
			
			resultMap.put("list", list);
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
	
	public HashMap<String, Object> getBizStoreList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<BizMyPage> list = bizMyPageMapper.selectBizStoreList(map);
			
			resultMap.put("list", list);
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
	
	public HashMap<String, Object> getBizStoreMenuList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<BizMyPage> list = bizMyPageMapper.selectBizStoreMenuList(map);
			
			resultMap.put("list", list);
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
	
	
	
	
	
	

	
}