package com.example.unipet.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.UserMypageMapper;

@Service
public class UserMypageService {

    @Autowired
    private UserMypageMapper mapper;

    public HashMap<String, Object> getMypageData(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        result.put("petList", mapper.selectPetList(map));
        result.put("reservationList", mapper.selectReservation(map));
        result.put("orderList", mapper.selectOrder(map));
        result.put("subscription", mapper.selectSubscription(map));
        result.put("favoriteList", mapper.selectFavorite(map));
        result.put("result", "success");

        return result;
    }

    public HashMap<String, Object> changeMainPet(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        mapper.resetMainPet(map);
        int cnt = mapper.updateMainPet(map);

        result.put("result", cnt > 0 ? "success" : "fail");
        return result;
    }
}