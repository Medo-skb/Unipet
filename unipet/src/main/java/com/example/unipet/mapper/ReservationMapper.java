package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Default;
import com.example.unipet.model.Store;

@Mapper
public interface ReservationMapper {
	
	// 여러개 리턴 -> selectXXXList
	public List<Store> selectStoreList(HashMap<String, Object> map);
	// 한개 리턴 -> selectXXX
	public Default selectDefault(HashMap<String, Object> map);
	// 삭제 
	public int deleteDefault(HashMap<String, Object> map);
	// 수정
	public int updateDefault(HashMap<String, Object> map);
	// 삽입 
	public int insertDefault(HashMap<String, Object> map);
	
}
