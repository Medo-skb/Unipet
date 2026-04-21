package com.example.unipet.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.User;

@Mapper
public interface UserMapper {

    int checkUser(HashMap<String, Object> map);

    int insertUser(HashMap<String, Object> map);

    User selectUser(HashMap<String, Object> map);

    User selectUserByUserId(HashMap<String, Object> map);

    int insertSocialUser(HashMap<String, Object> map);

    User selectStoreUser(HashMap<String, Object> map);
}