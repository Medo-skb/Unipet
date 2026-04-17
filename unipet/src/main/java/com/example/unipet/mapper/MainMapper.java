package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.unipet.model.Default;
import com.example.unipet.model.Main;

@Mapper
public interface MainMapper {

    // 최근 예약이 많은 업체 4개 조회
    public List<Main> selectPopularStoreList(HashMap<String, Object> map);

    // 사람들이 많이 찜한 인기상품 4개 조회
    public List<Main> selectPopularProductList(HashMap<String, Object> map);
    
	// 카테고리별 랜덤 업체 조회
    public List<Main> selectStoreByCategoryList(HashMap<String, Object> map);
    
    // 상품 카테고리 조회
    public List<Main> selectProductByCategoryList(HashMap<String, Object> map);
    
    // 카테고리별 랜덤 상품 조회
    public List<Main> selectAnimalMainCategoryList(HashMap<String, Object> map);
    
    // 통합 검색 업체
    public List<Main> selectSearchStoreList(HashMap<String, Object> map);
    
    // 업체 전체 개수
    int selectSearchStoreCount(HashMap<String, Object> map);
    
    // 통합 검색 상품
    public List<Main> selectSearchProductList(HashMap<String, Object> map);
    
    // 상품 개수
    int selectSearchProductCount(HashMap<String, Object> map);
    
    // 통합 검색 커뮤니티
    public List<Main> selectSearchBoardList(HashMap<String, Object> map);
    
    // 커뮤니티 전체 개수
    int selectSearchBoardCount(HashMap<String, Object> map);
    
}
