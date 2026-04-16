package com.example.unipet.dao;

import java.io.File;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.mapper.UserMapper;
import com.example.unipet.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {

    @Autowired
    UserMapper userMapper;

    @Autowired
    HttpSession session;

    // 로그인
    public HashMap<String, Object> login(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            User user = userMapper.selectUser(map);

            if (user == null) {
                resultMap.put("result", false);
                resultMap.put("message", "없는 아이디입니다.");
                return resultMap;
            }

            if (!user.getPwd().equals(String.valueOf(map.get("pwd")))) {
                resultMap.put("result", false);
                resultMap.put("message", "비밀번호를 확인해주세요.");
                return resultMap;
            }

            Object roleObj = map.get("role");
            if (roleObj != null) {
                String loginRole = String.valueOf(roleObj);
                if (!loginRole.equals(user.getRole())) {
                    resultMap.put("result", false);
                    resultMap.put("message", "회원 유형이 올바르지 않습니다.");
                    return resultMap;
                }
            }

            if ("BIZ".equals(user.getRole())) {
                if (!"APPROVED".equals(user.getBizStatus())) {
                    resultMap.put("result", false);
                    resultMap.put("message", "사업자 승인이 완료되지 않았습니다.");
                    return resultMap;
                }
            }

            session.setAttribute("sessionId", user.getUserId());
            session.setAttribute("sessionName", user.getUserName());
            session.setAttribute("sessionRole", user.getRole());

            resultMap.put("result", true);
            resultMap.put("message", user.getUserName() + "님 환영합니다.");

            if ("BIZ".equals(user.getRole())) {
                resultMap.put("url", "/biz/main.do");
            } else {
                resultMap.put("url", "/main.do");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "로그인 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // 아이디 중복 체크
    public HashMap<String, Object> checkUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            int cnt = userMapper.checkUser(map);

            if (cnt > 0) {
                resultMap.put("result", false);
                resultMap.put("message", "이미 사용중인 아이디입니다.");
            } else {
                resultMap.put("result", true);
                resultMap.put("message", "사용 가능한 아이디입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "중복 확인 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // 일반 회원가입
    public HashMap<String, Object> signupUser(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            map.put("role", "USER");

            int cnt = userMapper.insertUser(map);

            if (cnt > 0) {
                resultMap.put("result", true);
                resultMap.put("message", "회원가입이 완료되었습니다.");
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "회원가입에 실패했습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "회원가입 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // 사업자 회원가입
    @Transactional
    public HashMap<String, Object> signupBiz(HashMap<String, Object> map, MultipartFile bizFile) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            if (bizFile == null || bizFile.isEmpty()) {
                resultMap.put("result", false);
                resultMap.put("message", "사업자등록증 파일을 업로드해주세요.");
                return resultMap;
            }

            String originName = bizFile.getOriginalFilename();
            String ext = "";

            if (originName != null && originName.lastIndexOf(".") > -1) {
                ext = originName.substring(originName.lastIndexOf("."));
            }

            String saveName = System.currentTimeMillis() + ext;

            String savePath = System.getProperty("user.dir") + "/upload/biz/";
            File folder = new File(savePath);

            if (!folder.exists()) {
                folder.mkdirs();
            }

            File saveFile = new File(savePath + saveName);
            bizFile.transferTo(saveFile);

            map.put("bizFileName", originName);
            map.put("bizFilePath", saveName);
            map.put("role", "BIZ");
            map.put("bizStatus", "WAIT");

            int userCnt = userMapper.insertBizUser(map);
            int bizCnt = 0;

            if (userCnt > 0) {
                bizCnt = userMapper.insertBizInfo(map);
            }

            if (userCnt > 0 && bizCnt > 0) {
                resultMap.put("result", true);
                resultMap.put("message", "사업자 회원가입이 완료되었습니다.");
            } else {
                throw new RuntimeException("사업자 회원가입 실패");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "사업자 회원가입 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // 휴대폰 인증번호 발송
    public HashMap<String, Object> sendSms(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String phone = String.valueOf(map.get("phone"));
            String code = String.valueOf((int)(Math.random() * 900000) + 100000);

            session.setAttribute("smsCode", code);
            session.setAttribute("authPhone", phone);
            session.removeAttribute("phoneAuthYn");

            System.out.println("테스트용 인증번호 : " + code);

            resultMap.put("result", true);
            resultMap.put("message", "인증번호가 발송되었습니다. (테스트용)");

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "인증번호 발송에 실패했습니다.");
        }

        return resultMap;
    }

    // 휴대폰 인증번호 확인
    public HashMap<String, Object> verifySms(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            String inputCode = String.valueOf(map.get("smsCode"));
            String sessionCode = (String) session.getAttribute("smsCode");

            if (sessionCode != null && sessionCode.equals(inputCode)) {
                session.setAttribute("phoneAuthYn", "Y");
                resultMap.put("result", true);
                resultMap.put("message", "휴대폰 인증이 완료되었습니다.");
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "인증번호가 일치하지 않습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "휴대폰 인증 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // 아이디 찾기
    public HashMap<String, Object> findId(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            User user = userMapper.findId(map);

            if (user != null) {
                resultMap.put("result", true);
                resultMap.put("message", "아이디 찾기 성공");
                resultMap.put("userId", user.getUserId());
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "일치하는 회원정보가 없습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "아이디 찾기 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // 비밀번호 재설정 링크 발송(임시)
    public HashMap<String, Object> sendResetLink(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            User user = userMapper.selectUser(map);

            if (user != null) {
                resultMap.put("result", true);
                resultMap.put("message", "비밀번호 재설정 링크가 발송되었습니다. (임시)");
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "일치하는 회원정보가 없습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "재설정 링크 발송 중 오류가 발생했습니다.");
        }

        return resultMap;
    }

    // 비밀번호 변경
    public HashMap<String, Object> resetPwd(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            int cnt = userMapper.resetPwd(map);

            if (cnt > 0) {
                resultMap.put("result", true);
                resultMap.put("message", "비밀번호가 변경되었습니다.");
            } else {
                resultMap.put("result", false);
                resultMap.put("message", "비밀번호 변경에 실패했습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", false);
            resultMap.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
        }

        return resultMap;
    }
}