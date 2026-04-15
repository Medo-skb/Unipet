package com.example.unipet.dao;

import java.util.HashMap;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.UserMapper;
import com.example.unipet.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

    @Autowired
    UserMapper userMapper;

    @Autowired
    HttpSession session;

    // =========================
    // 로그인
    // =========================
    public HashMap<String, Object> login(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            User user = userMapper.selectUser(map);

            resultMap.put("result", false);

            if (user != null) {
                if (user.getPwd().equals(String.valueOf(map.get("pwd")))) {
                    resultMap.put("message", user.getUserName() + "님 환영합니다.");
                    resultMap.put("result", true);

                    session.setAttribute("sessionId", user.getUserId());
                    session.setAttribute("sessionName", user.getUserName());
                    session.setAttribute("sessionRole", user.getRole());

                    resultMap.put("url", "/main.do");
                } else {
                    resultMap.put("message", "비밀번호를 확인해주세요.");
                }
            } else {
                resultMap.put("message", "없는 아이디입니다.");
            }

            resultMap.put("status", "success");

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "로그인 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // =========================
    // 아이디 중복 체크
    // =========================
    public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            int cnt = userMapper.checkUser(map);

            if (cnt > 0) {
                resultMap.put("result", false);
                resultMap.put("message", "이미 사용중인 아이디입니다.");
            } else {
                resultMap.put("result", true);
                resultMap.put("message", "사용 가능한 아이디입니다.");
            }

            resultMap.put("status", "success");

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "중복 확인 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // =========================
    // 일반 회원가입
    // =========================
    public HashMap<String, Object> signupUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            String phoneAuthYn = (String) session.getAttribute("phoneAuthYn");

            if (!"Y".equals(phoneAuthYn)) {
                resultMap.put("result", false);
                resultMap.put("status", "fail");
                resultMap.put("message", "휴대폰 인증을 완료해주세요.");
                return resultMap;
            }

            int cnt = userMapper.insertUser(map);

            if (cnt > 0) {
                resultMap.put("result", true);
                resultMap.put("message", "회원가입이 완료되었습니다.");
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "회원가입에 실패했습니다.");
            }

            resultMap.put("status", "success");

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "회원가입 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // =========================
    // 사업자 회원가입
    // =========================
    public HashMap<String, Object> signupBiz(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            int cnt = userMapper.insertBiz(map);

            if (cnt > 0) {
                resultMap.put("result", true);
                resultMap.put("message", "사업자 회원가입이 완료되었습니다.");
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "사업자 회원가입에 실패했습니다.");
            }

            resultMap.put("status", "success");

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "사업자 회원가입 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // =========================
    // 휴대폰 인증번호 발송
    // =========================
    public HashMap<String, Object> sendSms(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            String phone = String.valueOf(map.get("phone"));

            Random random = new Random();
            int code = 100000 + random.nextInt(900000);

            session.setAttribute("smsCode", String.valueOf(code));
            session.setAttribute("authPhone", phone);
            session.removeAttribute("phoneAuthYn");

            System.out.println("테스트용 인증번호 : " + code);

            resultMap.put("result", true);
            resultMap.put("status", "success");
            resultMap.put("message", "인증번호가 발송되었습니다. (테스트용)");

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "인증번호 발송에 실패했습니다.");
        }

        return resultMap;
    }

    // =========================
    // 휴대폰 인증번호 확인
    // =========================
    public HashMap<String, Object> verifySms(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            String inputCode = String.valueOf(map.get("smsCode"));
            String sessionCode = (String) session.getAttribute("smsCode");

            if (sessionCode != null && sessionCode.equals(inputCode)) {
                session.setAttribute("phoneAuthYn", "Y");

                resultMap.put("result", true);
                resultMap.put("status", "success");
                resultMap.put("message", "휴대폰 인증이 완료되었습니다.");
            } else {
                resultMap.put("result", false);
                resultMap.put("status", "fail");
                resultMap.put("message", "인증번호가 일치하지 않습니다.");
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "휴대폰 인증 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // =========================
    // 아이디 찾기
    // =========================
    public HashMap<String, Object> findId(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            User user = userMapper.findId(map);

            if (user != null) {
                resultMap.put("result", true);
                resultMap.put("status", "success");
                resultMap.put("message", "아이디 찾기 성공");
                resultMap.put("userId", user.getUserId());
            } else {
                resultMap.put("result", false);
                resultMap.put("status", "fail");
                resultMap.put("message", "일치하는 회원정보가 없습니다.");
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "아이디 찾기 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // =========================
    // 비밀번호 재설정 링크 발송
    // =========================
    public HashMap<String, Object> sendResetLink(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            User user = userMapper.selectUser(map);

            if (user != null) {
                // 실제 메일 발송 API 붙이기 전 임시 처리
                resultMap.put("result", true);
                resultMap.put("status", "success");
                resultMap.put("message", "비밀번호 재설정 링크가 발송되었습니다. (임시)");
            } else {
                resultMap.put("result", false);
                resultMap.put("status", "fail");
                resultMap.put("message", "일치하는 회원정보가 없습니다.");
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "재설정 링크 발송 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // =========================
    // 새 비밀번호 변경
    // =========================
    public HashMap<String, Object> resetPwd(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            int cnt = userMapper.resetPwd(map);

            if (cnt > 0) {
                resultMap.put("result", true);
                resultMap.put("status", "success");
                resultMap.put("message", "비밀번호가 변경되었습니다.");
            } else {
                resultMap.put("result", false);
                resultMap.put("status", "fail");
                resultMap.put("message", "비밀번호 변경에 실패했습니다.");
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", false);
            resultMap.put("status", "fail");
            resultMap.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
        }

        return resultMap;
    }
}