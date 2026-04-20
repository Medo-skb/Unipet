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
    UserMapper userMapper;

    // 일반 / 사업자 로그인
    public HashMap<String, Object> login(HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String role = map.get("role") == null ? "" : map.get("role").toString();
        String pwd = map.get("pwd") == null ? "" : map.get("pwd").toString();

        if ("BIZ".equals(role)) {
            User storeUser = userMapper.selectStoreUser(map);

            if (storeUser == null || storeUser.getStoreUserPwd() == null || !pwd.equals(storeUser.getStoreUserPwd())) {
                resultMap.put("result", false);
                resultMap.put("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
                return resultMap;
            }

            session.setAttribute("sessionId", storeUser.getStoreUserId());
            session.setAttribute("sessionName", storeUser.getCeoName());
            session.setAttribute("sessionRole", "BIZ");

            resultMap.put("result", true);
            resultMap.put("message", storeUser.getCeoName() + "님 환영합니다.");
            resultMap.put("url", "/main.do");
            return resultMap;
        }

        User user = userMapper.selectUser(map);

        if (user == null || user.getPwd() == null || !pwd.equals(user.getPwd())) {
            resultMap.put("result", false);
            resultMap.put("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return resultMap;
        }

        session.setAttribute("sessionId", user.getUserId());
        session.setAttribute("sessionName", user.getUserName());
        session.setAttribute("sessionRole", user.getRole());

        resultMap.put("result", true);
        resultMap.put("message", user.getUserName() + "님 환영합니다.");
        resultMap.put("url", "/main.do");
        return resultMap;
    }

    // 아이디 중복체크
    public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        int cnt = userMapper.checkUser(map);
        resultMap.put("count", cnt);
        resultMap.put("result", cnt == 0);
        return resultMap;
    }

    // 일반 회원가입
    public HashMap<String, Object> signupUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        int cnt = userMapper.insertUser(map);

        resultMap.put("result", cnt > 0);
        resultMap.put("message", cnt > 0 ? "회원가입이 완료되었습니다." : "회원가입에 실패했습니다.");
        return resultMap;
    }

    // 소셜 회원 로그인/가입 처리
    public User socialLogin(HashMap<String, Object> map) {

        // 1차: socialType + socialId 로 조회
        User user = userMapper.selectSocialUser(map);

        // 2차: userId 로 조회 (이미 같은 user_id가 있을 수 있음)
        if (user == null) {
            HashMap<String, Object> userIdMap = new HashMap<>();
            userIdMap.put("userId", map.get("userId"));
            user = userMapper.selectUserById(userIdMap);
        }

        // 둘 다 없을 때만 insert
        if (user == null) {
            userMapper.insertSocialUser(map);

            // insert 후 다시 조회
            user = userMapper.selectSocialUser(map);

            if (user == null) {
                HashMap<String, Object> userIdMap = new HashMap<>();
                userIdMap.put("userId", map.get("userId"));
                user = userMapper.selectUserById(userIdMap);
            }
        }

        return user;
    }
}