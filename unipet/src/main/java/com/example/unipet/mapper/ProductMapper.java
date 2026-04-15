package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Product;



@Mapper
public interface ProductMapper {
	// 1 & 2. 상품 목록 조회 (추천, 카테고리 필터, 검색, 정렬 통합)
    List<Product> selectProductList(HashMap<String, Object> map);

    // 3-1. 구매 확정 여부 확인 (설계 3번)
    int checkOrderComplete(HashMap<String, Object> map);

    // 3-2. 리뷰 중복 작성 확인 (설계 3번 비고)
    int checkReviewExists(HashMap<String, Object> map);

    // 3-3. 리뷰 등록
    int insertReview(HashMap<String, Object> map);

    // 3-4. 포인트 지급 (설계 3번)
    int updatePoint(HashMap<String, Object> map);

    // 4. Q&A 등록 (설계 4번)
    int insertQna(HashMap<String, Object> map);

	List<Map<String, Object>> selectCategoryList();
	
}
