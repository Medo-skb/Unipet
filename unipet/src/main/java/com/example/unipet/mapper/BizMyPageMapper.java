package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.BizMyPage;

@Mapper
public interface BizMyPageMapper {
	// 업체 이미지 리스트
	public List<BizMyPage> selectBizImgList(HashMap<String, Object> map);
	
	// 업체 소개 리스트
	public List<BizMyPage> selectBizStoreList(HashMap<String, Object> map);
	
	// 업체 메뉴 리스트
	public List<BizMyPage> selectBizStoreMenuList(HashMap<String, Object> map);

	
}
