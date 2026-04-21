package com.example.unipet.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.mapper.UserMapper;
import com.example.unipet.model.User;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private SmsService smsService;

    public HashMap<String, Object> login(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        User user = userMapper.selectUser(map);

        if (user != null) {
            resultMap.put("result", true);
            resultMap.put("user", user);
        } else {
            resultMap.put("result", false);
        }
        return resultMap;
    }

    public HashMap<String, Object> loginBiz(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        User user = userMapper.selectStoreUser(map);

        if (user != null) {
            resultMap.put("result", true);
            resultMap.put("user", user);
        } else {
            resultMap.put("result", false);
        }
        return resultMap;
    }

    public HashMap<String, Object> signupUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        int cnt = userMapper.insertUser(map);
        resultMap.put("result", cnt > 0);
        return resultMap;
    }

   
    public HashMap<String, Object> signupBiz(HashMap<String, Object> map, MultipartFile bizFile) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            if (bizFile != null && !bizFile.isEmpty()) {
                String fileName = bizFile.getOriginalFilename();
                map.put("bizFileName", fileName);
            }

            int cnt = userMapper.insertBizUser(map);
            resultMap.put("result", cnt > 0);

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
        }

        return resultMap;
    }

    public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        int cnt = userMapper.checkUser(map);
        resultMap.put("result", cnt == 0);
        return resultMap;
    }

    public HashMap<String, Object> checkStoreUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        int cnt = userMapper.checkStoreUser(map);
        resultMap.put("result", cnt == 0);
        return resultMap;
    }

    public HashMap<String, Object> sendSms(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String phone = map.get("phone") == null ? "" : map.get("phone").toString().trim();

            if (phone.equals("")) {
                resultMap.put("result", false);
                resultMap.put("message", "휴대폰 번호가 없습니다.");
                return resultMap;
            }

            String code = smsService.createCode();
            boolean sendResult = smsService.sendSms(phone, code);

            if (sendResult) {
                resultMap.put("result", true);
                resultMap.put("message", "인증번호가 발송되었습니다.");
                resultMap.put("code", code);
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "문자 발송에 실패했습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "SMS 처리 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    public HashMap<String, Object> findId(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        User user = userMapper.findId(map);

        if (user != null) {
            resultMap.put("result", true);
            resultMap.put("userId", user.getUserId());
            resultMap.put("message", "아이디 찾기 성공");
        } else {
            resultMap.put("result", false);
            resultMap.put("message", "일치하는 회원정보가 없습니다.");
        }

        return resultMap;
    }

    public HashMap<String, Object> checkUserForReset(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        User user = userMapper.checkUserForReset(map);

        if (user != null) {
            resultMap.put("result", true);
            resultMap.put("message", "비밀번호 재설정 대상 확인 완료");
        } else {
            resultMap.put("result", false);
            resultMap.put("message", "일치하는 회원정보가 없습니다.");
        }

        return resultMap;
    }

    public HashMap<String, Object> resetPwd(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        int cnt = userMapper.resetPwd(map);

        if (cnt > 0) {
            resultMap.put("result", true);
            resultMap.put("message", "비밀번호가 변경되었습니다.");
        } else {
            resultMap.put("result", false);
            resultMap.put("message", "비밀번호 변경 실패");
        }

        return resultMap;
    }

    public User socialLogin(HashMap<String, Object> map) {
        User user = userMapper.selectSocialUser(map);

        if (user == null) {
            userMapper.insertSocialUser(map);
            user = userMapper.selectSocialUser(map);
        }

        return user;
    }
}