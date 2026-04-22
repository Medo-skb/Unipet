package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMypageMapper {

    HashMap<String, Object> getUserInfo(HashMap<String, Object> map);
    int updateUser(HashMap<String, Object> map);
    HashMap<String, Object> checkPassword(HashMap<String, Object> map);
    int changePwd(HashMap<String, Object> map);
    int deleteUser(HashMap<String, Object> map);

    int countPet(HashMap<String, Object> map);
    List<HashMap<String, Object>> getPetList(HashMap<String, Object> map);
    HashMap<String, Object> getPetByPetNo(HashMap<String, Object> map);
    HashMap<String, Object> getFirstPet(HashMap<String, Object> map);

    int addPet(HashMap<String, Object> map);
    int updatePet(HashMap<String, Object> map);
    int deletePet(HashMap<String, Object> map);
    int resetMainPet(HashMap<String, Object> map);
    int changeMainPet(HashMap<String, Object> map);

    List<HashMap<String, Object>> getReservationList(HashMap<String, Object> map);
    List<HashMap<String, Object>> getReservationAllList(HashMap<String, Object> map);

    // 추가
    List<HashMap<String, Object>> getOrderList(HashMap<String, Object> map);
}