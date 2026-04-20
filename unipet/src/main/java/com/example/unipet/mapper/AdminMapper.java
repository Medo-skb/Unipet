package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Admin;

@Mapper
public interface AdminMapper {
	
	// 여러개 리턴 -> selectXXXList
	public List<Admin> selectAdminBiz(HashMap<String, Object> map);

}
