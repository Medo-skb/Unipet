package com.example.unipet.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Main;

@Mapper
public interface MainMapper {

    // 최근 예약이 많은 업체 4개 조회
    List<Main> selectPopularStoreList();

    // 사람들이 많이 찜한 인기상품 4개 조회
    List<Main> selectPopularProductList();
}