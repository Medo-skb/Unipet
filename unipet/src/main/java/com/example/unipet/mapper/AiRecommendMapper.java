package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.AiRecommend;

@Mapper
public interface AiRecommendMapper {
    
    // 1. 추천을 진행할 활성 유저 아이디 목록 조회
    List<String> selectUserList() throws Exception;
    
    // 2. AI에게 선택지로 줄 인기 예약 업체 TOP 5 조회
    List<HashMap<String, Object>> selectTopStoreList(String userRegion) throws Exception;
    
    // 3. AI에게 선택지로 줄 인기 쇼핑 상품 TOP 5 조회
    List<HashMap<String, Object>> selectTopProductList() throws Exception;
    
    // 4. 특정 유저의 반려동물 정보 및 최근 활동 기록 조회
    HashMap<String, Object> getUserHistory(String userId) throws Exception;
    
    // 5. AI가 응답한 추천 결과를 DB에 저장 (있으면 수정, 없으면 등록)
    int checkRecommendationExist(String userId) throws Exception;
    void insertRecommendation(AiRecommend aiRecommend) throws Exception;
    void updateRecommendation(AiRecommend aiRecommend) throws Exception;
    
    // 프론트엔드에서 메인 페이지 로딩 시 추천 데이터를 꺼내갈 메서드
    AiRecommend getRecommendationByUserId(String userId) throws Exception;
    
    List<HashMap<String, Object>> selectStoreDetailsForAi(List<Integer> storeNoList) throws Exception;
    
    List<HashMap<String, Object>> selectProductDetailsForAi(List<Integer> productNoList) throws Exception;
}
