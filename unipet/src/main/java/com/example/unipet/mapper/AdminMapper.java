package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Admin;

@Mapper
public interface AdminMapper {
	
	// 사업자 승인 리스트
	public List<Admin> selectAdminBiz(HashMap<String, Object> map);
	
	// 사업자 승인
	public int updateBizStatusApr(HashMap<String, Object> map);
	
	// 사업자 거부
	public int updateBizStatusRej(HashMap<String, Object> map);

}
