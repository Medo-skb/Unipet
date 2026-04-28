package com.example.unipet.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.dao.SmsService;
import com.example.unipet.dao.UserService;
import com.example.unipet.model.User;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private SmsService smsService;

    @Value("${kakao.client-id:}")
    private String kakaoClientId;

    @Value("${kakao.client-secret:}")
    private String kakaoClientSecret;

    @Value("${kakao.redirect-uri:}")
    private String kakaoRedirectUri;

    @Value("${naver.client-id:}")
    private String naverClientId;

    @Value("${naver.client-secret:}")
    private String naverClientSecret;

    @Value("${naver.redirect-uri:}")
    private String naverRedirectUri;

    private final Gson gson = new Gson();
    private final SecureRandom random = new SecureRandom();

    // =========================
    // 페이지 이동
    // =========================

    @GetMapping("/user/login.do")
    public String login() {
        return "user/login";
    }

    @GetMapping("/user/join.do")
    public String join() {
        return "user/join";
    }

    @GetMapping("/user/signup-user.do")
    public String signupUserPage() {
        return "user/signup-user";
    }

    @GetMapping("/user/signup-biz.do")
    public String signupBizPage() {
        return "user/signup-biz";
    }

    @GetMapping("/user/find-id.do")
    public String findIdPage() {
        return "user/find-id";
    }

    @GetMapping("/user/find-pwd.do")
    public String findPwdPage() {
        return "user/find-pwd";
    }

    @GetMapping("/user/new-pwd.do")
    public String newPwdPage() {
        return "user/new-pwd";
    }

    @GetMapping("/logout.do")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/login.do";
    }

    // =========================
    // 사용자 로그인
    // =========================
    @PostMapping("/user/login.dox")
    @ResponseBody
    public String loginProc(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = userService.selectUser(map);

        if (Boolean.TRUE.equals(resultMap.get("result"))) {
            User user = (User) resultMap.get("user");

            session.setAttribute("sessionId", user.getUserId());
            session.setAttribute("sessionName", user.getUserName());
            session.setAttribute("sessionRole", "USER");

            resultMap.put("message", user.getUserName() + "님 환영합니다 👋");
        }

        return gson.toJson(resultMap);
    }

    // =========================
    // 사업자 로그인
    // =========================
    @PostMapping("/user/loginBiz.dox")
    @ResponseBody
    public String loginBizProc(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = userService.selectStoreUser(map);

        if (Boolean.TRUE.equals(resultMap.get("result"))) {
            User user = (User) resultMap.get("user");

            session.setAttribute("sessionId", user.getUserId());
            session.setAttribute("sessionName", user.getUserName());
            session.setAttribute("sessionRole", "BIZ");

            resultMap.put("message", user.getUserName() + "님 환영합니다 👋");
        }

        return gson.toJson(resultMap);
    }

    // =========================
    // 사용자 회원가입
    // =========================
    @PostMapping("/user/signupUser.dox")
    @ResponseBody
    public String signupUser(@RequestParam HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = userService.insertUser(map);
        return gson.toJson(resultMap);
    }

    // =========================
    // 사업자 회원가입
    // =========================
    @PostMapping("/user/signupBiz.dox")
    @ResponseBody
    public String signupBiz(@RequestParam HashMap<String, Object> map,
                            @RequestParam(value = "bizFile", required = false) MultipartFile bizFile) {

        if (bizFile != null && !bizFile.isEmpty()) {
            map.put("bizFileName", bizFile.getOriginalFilename());
        }

        HashMap<String, Object> resultMap = userService.insertBizUser(map);
        return gson.toJson(resultMap);
    }

    // =========================
    // 사용자 아이디 중복체크
    // =========================
    @PostMapping("/user/check.dox")
    @ResponseBody
    public String checkUser(@RequestParam HashMap<String, Object> map) {
        return gson.toJson(userService.checkUser(map));
    }

    // =========================
    // 사업자 아이디 중복체크
    // =========================
    @PostMapping("/user/checkBiz.dox")
    @ResponseBody
    public String checkBizUser(@RequestParam HashMap<String, Object> map) {
        return gson.toJson(userService.checkStoreUser(map));
    }

    // =========================
    // SMS 인증번호 발송
    // =========================
    @PostMapping("/user/sendSms.dox")
    @ResponseBody
    public String sendSms(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String phone = map.get("phone") == null ? "" : map.get("phone").toString();

        if (phone.isBlank()) {
            resultMap.put("result", false);
            resultMap.put("message", "휴대폰 번호를 입력해주세요.");
            return gson.toJson(resultMap);
        }

        String code = smsService.createCode();
        boolean sendResult = smsService.sendSms(phone, code);

        if (sendResult) {
            session.setAttribute("smsCode", code);
            session.setAttribute("smsPhone", phone);

            resultMap.put("result", true);
            resultMap.put("message", "인증번호가 발송되었습니다.");
            resultMap.put("code", code); // 테스트 끝나면 삭제
        } else {
            resultMap.put("result", false);
            resultMap.put("message", "SMS 전송 실패");
        }

        return gson.toJson(resultMap);
    }

    // =========================
    // SMS 인증번호 확인
    // =========================
    @PostMapping("/user/checkSms.dox")
    @ResponseBody
    public String checkSms(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        String inputCode = map.get("code") == null ? "" : map.get("code").toString().trim();
        Object sessionCode = session.getAttribute("smsCode");
        Object sessionPhone = session.getAttribute("smsPhone");

        if (sessionCode != null && sessionCode.toString().trim().equals(inputCode)) {
            resultMap.put("result", true);
            resultMap.put("message", "인증 성공");
            session.setAttribute("smsAuth", true);

            if (sessionPhone != null) {
                session.setAttribute("verifiedPhone", sessionPhone.toString());
            }
        } else {
            resultMap.put("result", false);
            resultMap.put("message", "인증번호가 일치하지 않습니다.");
        }

        return gson.toJson(resultMap);
    }

    // =========================
    // 아이디 찾기
    // =========================
    @PostMapping("/user/findId.dox")
    @ResponseBody
    public String findId(@RequestParam HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = userService.findId(map);
        return gson.toJson(resultMap);
    }

    // =========================
    // 비밀번호 재설정 대상 확인
    // =========================
    @PostMapping("/user/checkUserForReset.dox")
    @ResponseBody
    public String checkUserForReset(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        Object smsAuth = session.getAttribute("smsAuth");
        Object verifiedPhone = session.getAttribute("verifiedPhone");

        if (smsAuth == null || !(boolean) smsAuth) {
            resultMap.put("result", false);
            resultMap.put("message", "휴대폰 인증 후 이용해주세요.");
            return gson.toJson(resultMap);
        }

        if (verifiedPhone == null) {
            resultMap.put("result", false);
            resultMap.put("message", "인증된 휴대폰 정보가 없습니다.");
            return gson.toJson(resultMap);
        }

        map.put("phone", verifiedPhone.toString());
        resultMap = userService.checkUserForReset(map);

        if (Boolean.TRUE.equals(resultMap.get("result"))) {
            session.setAttribute("resetUserId", map.get("userId"));
        }

        return gson.toJson(resultMap);
    }

    // =========================
    // 새 비밀번호 저장
    // =========================
    @PostMapping("/user/resetPwd.dox")
    @ResponseBody
    public String resetPwd(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> resultMap = new HashMap<>();

        Object resetUserId = session.getAttribute("resetUserId");

        if (resetUserId == null) {
            resultMap.put("result", false);
            resultMap.put("message", "비밀번호 재설정 대상이 없습니다.");
            return gson.toJson(resultMap);
        }

        map.put("userId", resetUserId.toString());
        resultMap = userService.resetPwd(map);

        if (Boolean.TRUE.equals(resultMap.get("result"))) {
            session.removeAttribute("resetUserId");
            session.removeAttribute("smsAuth");
            session.removeAttribute("smsCode");
            session.removeAttribute("smsPhone");
            session.removeAttribute("verifiedPhone");
        }

        return gson.toJson(resultMap);
    }

    // =========================
    // 카카오 로그인 시작
    // =========================
    @GetMapping("/user/kakao/login")
    public void kakaoLogin(HttpServletResponse response) throws IOException {
        String url = "https://kauth.kakao.com/oauth/authorize"
                + "?client_id=" + URLEncoder.encode(kakaoClientId, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(kakaoRedirectUri, StandardCharsets.UTF_8)
                + "&response_type=code"
                + "&prompt=login";

        response.sendRedirect(url);
    }

    // =========================
    // 카카오 로그인 콜백
    // =========================
    @GetMapping("/user/kakao/callback")
    public void kakaoCallback(@RequestParam(value = "code", required = false) String code,
                              @RequestParam(value = "error", required = false) String error,
                              HttpSession session,
                              HttpServletResponse response) throws Exception {

        if (error != null || code == null || code.isBlank()) {
            response.sendRedirect("/user/login.do");
            return;
        }

        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders tokenHeaders = new HttpHeaders();
        tokenHeaders.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> tokenParams = new LinkedMultiValueMap<>();
        tokenParams.add("grant_type", "authorization_code");
        tokenParams.add("client_id", kakaoClientId);
        tokenParams.add("redirect_uri", kakaoRedirectUri);
        tokenParams.add("code", code);

        if (kakaoClientSecret != null && !kakaoClientSecret.isBlank()) {
            tokenParams.add("client_secret", kakaoClientSecret);
        }

        HttpEntity<MultiValueMap<String, String>> tokenRequest =
                new HttpEntity<>(tokenParams, tokenHeaders);

        ResponseEntity<String> tokenResponse = restTemplate.postForEntity(
                "https://kauth.kakao.com/oauth/token",
                tokenRequest,
                String.class
        );

        Map<String, Object> tokenMap = gson.fromJson(tokenResponse.getBody(), HashMap.class);
        String accessToken = (tokenMap != null && tokenMap.get("access_token") != null)
                ? tokenMap.get("access_token").toString()
                : "";

        if (accessToken.isBlank()) {
            response.sendRedirect("/user/login.do");
            return;
        }

        HttpHeaders userHeaders = new HttpHeaders();
        userHeaders.setBearerAuth(accessToken);

        HttpEntity<String> userRequest = new HttpEntity<>(userHeaders);

        ResponseEntity<String> userResponse = restTemplate.exchange(
                "https://kapi.kakao.com/v2/user/me",
                HttpMethod.GET,
                userRequest,
                String.class
        );

        Map<String, Object> userMap = gson.fromJson(userResponse.getBody(), HashMap.class);

        if (userMap == null || userMap.get("id") == null) {
            response.sendRedirect("/user/login.do");
            return;
        }

        String socialId = userMap.get("id").toString();
        String email = "";
        String userName = "카카오회원";
        String nickname = "카카오회원";

        Object kakaoAccountObj = userMap.get("kakao_account");
        if (kakaoAccountObj instanceof Map<?, ?> kakaoAccount) {
            Object emailObj = kakaoAccount.get("email");
            if (emailObj != null) {
                email = emailObj.toString();
            }

            Object profileObj = kakaoAccount.get("profile");
            if (profileObj instanceof Map<?, ?> profile) {
                Object nicknameObj = profile.get("nickname");
                if (nicknameObj != null && !nicknameObj.toString().isBlank()) {
                    userName = nicknameObj.toString();
                    nickname = nicknameObj.toString();
                }
            }
        }

        HashMap<String, Object> socialMap = new HashMap<>();
        socialMap.put("userId", "kakao_" + socialId);
        socialMap.put("userName", userName);
        socialMap.put("nickname", nickname);
        socialMap.put("email", email);
        socialMap.put("socialType", "KAKAO");

        HashMap<String, Object> selectResult = userService.selectSocialUser(socialMap);

        if (!Boolean.TRUE.equals(selectResult.get("result"))) {
            userService.insertSocialUser(socialMap);
            selectResult = userService.selectSocialUser(socialMap);
        }

        if (!Boolean.TRUE.equals(selectResult.get("result"))) {
            response.sendRedirect("/user/login.do");
            return;
        }

        User user = (User) selectResult.get("user");

        session.setAttribute("sessionId", user.getUserId());
        session.setAttribute("sessionName", user.getUserName());
        session.setAttribute("sessionRole", "USER");

        response.sendRedirect("/main.do");
    }

    // =========================
    // 네이버 로그인 시작
    // =========================
    @GetMapping("/user/naver/login")
    public void naverLogin(HttpSession session, HttpServletResponse response) throws IOException {
        String state = Long.toHexString(random.nextLong());
        session.setAttribute("naverState", state);
        String url = "https://nid.naver.com/oauth2.0/authorize"
                + "?response_type=code"
                + "&client_id=" + URLEncoder.encode(naverClientId, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(naverRedirectUri, StandardCharsets.UTF_8)
                + "&state=" + state
                + "&auth_type=reauthenticate";  // 🔥 추가
      
        response.sendRedirect(url);
    }

    // =========================
    // 네이버 로그인 콜백
    // =========================
    @GetMapping("/user/naver/callback")
    public void naverCallback(@RequestParam(value = "code", required = false) String code,
                              @RequestParam(value = "state", required = false) String state,
                              @RequestParam(value = "error", required = false) String error,
                              HttpSession session,
                              HttpServletResponse response) throws Exception {

        if (error != null || code == null || code.isBlank() || state == null || state.isBlank()) {
            response.sendRedirect("/user/login.do");
            return;
        }

        String sessionState = session.getAttribute("naverState") == null
                ? "" : session.getAttribute("naverState").toString();

        if (!state.equals(sessionState)) {
            response.sendRedirect("/user/login.do");
            return;
        }

        RestTemplate restTemplate = new RestTemplate();

        String tokenUrl = "https://nid.naver.com/oauth2.0/token"
                + "?grant_type=authorization_code"
                + "&client_id=" + URLEncoder.encode(naverClientId, StandardCharsets.UTF_8)
                + "&client_secret=" + URLEncoder.encode(naverClientSecret, StandardCharsets.UTF_8)
                + "&code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
                + "&state=" + URLEncoder.encode(state, StandardCharsets.UTF_8);

        ResponseEntity<String> tokenResponse = restTemplate.getForEntity(tokenUrl, String.class);
        Map<String, Object> tokenMap = gson.fromJson(tokenResponse.getBody(), HashMap.class);

        String accessToken = (tokenMap != null && tokenMap.get("access_token") != null)
                ? tokenMap.get("access_token").toString()
                : "";

        if (accessToken.isBlank()) {
            response.sendRedirect("/user/login.do");
            return;
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);

        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<String> userResponse = restTemplate.exchange(
                "https://openapi.naver.com/v1/nid/me",
                HttpMethod.GET,
                entity,
                String.class
        );

        Map<String, Object> userMap = gson.fromJson(userResponse.getBody(), HashMap.class);

        String socialId = "";
        String email = "";
        String userName = "네이버회원";
        String nickname = "네이버회원";

        if (userMap != null) {
            Object responseObj = userMap.get("response");

            if (responseObj instanceof Map<?, ?> profile) {
                Object idObj = profile.get("id");
                if (idObj != null) {
                    socialId = idObj.toString();
                }

                Object emailObj = profile.get("email");
                if (emailObj != null) {
                    email = emailObj.toString();
                }

                Object nameObj = profile.get("name");
                Object nicknameObj = profile.get("nickname");

                if (nameObj != null && !nameObj.toString().isBlank()) {
                    userName = nameObj.toString();
                }

                if (nicknameObj != null && !nicknameObj.toString().isBlank()) {
                    nickname = nicknameObj.toString();
                } else {
                    nickname = userName;
                }
            }
        }

        if (socialId.isBlank()) {
            response.sendRedirect("/user/login.do");
            return;
        }

        HashMap<String, Object> socialMap = new HashMap<>();
        socialMap.put("userId", "naver_" + socialId);
        socialMap.put("userName", userName);
        socialMap.put("nickname", nickname);
        socialMap.put("email", email);
        socialMap.put("socialType", "NAVER");

        HashMap<String, Object> selectResult = userService.selectSocialUser(socialMap);

        if (!Boolean.TRUE.equals(selectResult.get("result"))) {
            userService.insertSocialUser(socialMap);
            selectResult = userService.selectSocialUser(socialMap);
        }

        if (!Boolean.TRUE.equals(selectResult.get("result"))) {
            response.sendRedirect("/user/login.do");
            return;
        }

        User user = (User) selectResult.get("user");

        session.setAttribute("sessionId", user.getUserId());
        session.setAttribute("sessionName", user.getUserName());
        session.setAttribute("sessionRole", "USER");

        response.sendRedirect("/main.do");
    }
}