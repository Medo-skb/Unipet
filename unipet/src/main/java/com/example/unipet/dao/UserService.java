package com.example.unipet.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.UserMapper;
import com.example.unipet.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    public HashMap<String, Object> login(HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String loginType = map.get("loginType") == null ? "USER" : map.get("loginType").toString();

        User user = null;

        if ("BIZ".equalsIgnoreCase(loginType)) {
            user = userMapper.selectStoreUser(map);

            if (user != null) {
                session.setAttribute("sessionId", user.getSUserId());
                session.setAttribute("sessionName", user.getCeoName());
                session.setAttribute("sessionRole", "BIZ");

                resultMap.put("result", true);
                resultMap.put("message", "사업자 로그인 성공");
                resultMap.put("role", "BIZ");
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "사업자 아이디 또는 비밀번호를 확인해주세요.");
            }

            return resultMap;
        }

        user = userMapper.selectUser(map);

        if (user != null) {
            session.setAttribute("sessionId", user.getUserId());
            session.setAttribute("sessionName", user.getUserName());
            session.setAttribute("sessionRole", "USER");

            resultMap.put("result", true);
            resultMap.put("message", "로그인 성공");
            resultMap.put("role", "USER");
        } else {
            resultMap.put("result", false);
            resultMap.put("message", "아이디 또는 비밀번호를 확인해주세요.");
        }

        return resultMap;
    }

    public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        int cnt = userMapper.checkUser(map);
        resultMap.put("result", cnt == 0);
        resultMap.put("count", cnt);
        resultMap.put("message", cnt > 0 ? "이미 사용중인 아이디입니다." : "사용 가능한 아이디입니다.");

        return resultMap;
    }

    public HashMap<String, Object> signupUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            int cnt = userMapper.insertUser(map);

            if (cnt > 0) {
                resultMap.put("result", true);
                resultMap.put("message", "회원가입 성공");
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "회원가입 실패");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "오류 발생");
        }

        return resultMap;
    }

    public User socialLogin(HashMap<String, Object> map) {
        User user = userMapper.selectUserByUserId(map);

        if (user == null) {
            userMapper.insertSocialUser(map);
            user = userMapper.selectUserByUserId(map);
        }

        return user;
    }
}