package com.example.unipet.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.User;

@Mapper
public interface UserMapper {

    int checkUser(HashMap<String, Object> map);
    int checkStoreUser(HashMap<String, Object> map);

    int insertUser(HashMap<String, Object> map);
    int insertBizUser(HashMap<String, Object> map);

    User selectUser(HashMap<String, Object> map);
    User selectStoreUser(HashMap<String, Object> map);

    User findId(HashMap<String, Object> map);
    User checkUserForReset(HashMap<String, Object> map);
    int resetPwd(HashMap<String, Object> map);

    User selectSocialUser(HashMap<String, Object> map);
    int insertSocialUser(HashMap<String, Object> map);
}