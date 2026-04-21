package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMypageMapper {

    List<HashMap<String, Object>> selectPetList(HashMap<String, Object> map);

    List<HashMap<String, Object>> selectReservation(HashMap<String, Object> map);

    List<HashMap<String, Object>> selectOrder(HashMap<String, Object> map);

    HashMap<String, Object> selectSubscription(HashMap<String, Object> map);

    List<HashMap<String, Object>> selectFavorite(HashMap<String, Object> map);

    int resetMainPet(HashMap<String, Object> map);

    int updateMainPet(HashMap<String, Object> map);
}