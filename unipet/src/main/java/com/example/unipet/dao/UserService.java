package com.example.unipet.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.UserMapper;
import com.example.unipet.model.User;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    // 사용자 아이디 중복 체크
    public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int count = userMapper.checkUser(map);
            result.put("result", true);
            result.put("count", count);
            result.put("message", count > 0 ? "이미 사용중인 아이디입니다." : "사용 가능한 아이디입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "아이디 중복 체크 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 사업자 아이디 중복 체크
    public HashMap<String, Object> checkStoreUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int count = userMapper.checkStoreUser(map);
            result.put("result", true);
            result.put("count", count);
            result.put("message", count > 0 ? "이미 사용중인 아이디입니다." : "사용 가능한 아이디입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "사업자 아이디 중복 체크 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 사용자 회원가입
    public HashMap<String, Object> insertUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            // 중복 아이디 방지
            int idCount = userMapper.checkUser(map);

            if (idCount > 0) {
                result.put("result", false);
                result.put("message", "이미 사용중인 아이디입니다.");
                return result;
            }

            int count = userMapper.insertUser(map);
            result.put("result", count > 0);
            result.put("message", count > 0 ? "회원가입이 완료되었습니다." : "회원가입에 실패했습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "회원가입 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 사업자 회원가입
    public HashMap<String, Object> insertBizUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int count = userMapper.insertBizUser(map);
            result.put("result", count > 0);
            result.put("message", count > 0 ? "사업자 회원가입이 완료되었습니다." : "사업자 회원가입에 실패했습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "사업자 회원가입 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 일반 로그인
    public HashMap<String, Object> selectUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            User user = userMapper.selectUser(map);

            if (user != null) {
                result.put("result", true);
                result.put("user", user);
                result.put("message", "로그인 성공");
            } else {
                result.put("result", false);
                result.put("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "로그인 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 사업자 로그인
    public HashMap<String, Object> selectStoreUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            User user = userMapper.selectStoreUser(map);

            if (user != null) {
                result.put("result", true);
                result.put("user", user);
                result.put("message", "사업자 로그인 성공");
            } else {
                result.put("result", false);
                result.put("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "사업자 로그인 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 아이디 찾기
    public HashMap<String, Object> findId(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            User user = userMapper.findId(map);

            if (user != null) {
                result.put("result", true);
                result.put("userId", user.getUserId());
                result.put("message", "아이디 찾기 성공");
            } else {
                result.put("result", false);
                result.put("message", "일치하는 회원 정보가 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "아이디 찾기 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 비밀번호 재설정 전 회원 확인
    public HashMap<String, Object> checkUserForReset(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            User user = userMapper.checkUserForReset(map);

            if (user != null) {
                result.put("result", true);
                result.put("user", user);
                result.put("message", "회원 확인 완료");
            } else {
                result.put("result", false);
                result.put("message", "일치하는 회원 정보가 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "회원 확인 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 비밀번호 재설정
    public HashMap<String, Object> resetPwd(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int count = userMapper.resetPwd(map);
            result.put("result", count > 0);
            result.put("message", count > 0 ? "비밀번호가 변경되었습니다." : "비밀번호 변경에 실패했습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "비밀번호 재설정 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 소셜 로그인 사용자 조회
    public HashMap<String, Object> selectSocialUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            User user = userMapper.selectSocialUser(map);

            if (user != null) {
                result.put("result", true);
                result.put("user", user);
                result.put("message", "소셜 로그인 사용자 조회 성공");
            } else {
                result.put("result", false);
                result.put("message", "등록된 소셜 계정이 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "소셜 로그인 사용자 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 소셜 회원가입
    public HashMap<String, Object> insertSocialUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int count = userMapper.insertSocialUser(map);
            result.put("result", count > 0);
            result.put("message", count > 0 ? "소셜 회원가입이 완료되었습니다." : "소셜 회원가입에 실패했습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", false);
            result.put("message", "소셜 회원가입 중 오류가 발생했습니다.");
        }

        return result;
    }
}