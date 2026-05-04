package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.StoreRecommend;

@Mapper
public interface GeminiMapper {
    List<StoreRecommend> selectStoreRecommendList(HashMap<String, Object> map);
    
}