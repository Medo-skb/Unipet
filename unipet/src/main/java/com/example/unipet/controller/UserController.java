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
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import com.example.unipet.dao.UserService;
import com.example.unipet.model.User;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @Value("${kakao.client-id:}")
    private String kakaoClientId;

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

    // ✅ 메인 (JSP 없이 바로 응답)
//    @GetMapping("/main.do")
//    @ResponseBody
//    public HashMap<String, Object> main(HttpSession session) {
//        HashMap<String, Object> map = new HashMap<>();
//        map.put("message", "로그인 성공");
//        map.put("sessionId", session.getAttribute("sessionId"));
//        map.put("sessionName", session.getAttribute("sessionName"));
//        map.put("sessionRole", session.getAttribute("sessionRole"));
//        return map;
//    }

    // 로그인 (AJAX)
    @PostMapping("/user/login.dox")
    @ResponseBody
    public HashMap<String, Object> login(@RequestParam HashMap<String, Object> map, HttpSession session) {
        HashMap<String, Object> result = userService.login(map, session);

        if (Boolean.TRUE.equals(result.get("result"))) {
            result.put("url", "/main.do"); // 🔥 여기 중요
        }

        return result;
    }

    // 로그아웃
    @GetMapping("/user/logout.do")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/main.do";
    }

    // ===================== 카카오 =====================

    @GetMapping("/user/kakao/login")
    public void kakaoLogin(HttpServletResponse response) throws IOException {
        String url = "https://kauth.kakao.com/oauth/authorize"
                + "?client_id=" + kakaoClientId
                + "&redirect_uri=" + URLEncoder.encode(kakaoRedirectUri, StandardCharsets.UTF_8)
                + "&response_type=code";

        response.sendRedirect(url);
    }

    @GetMapping("/user/kakao/callback")
    public void kakaoCallback(@RequestParam("code") String code,
                              HttpSession session,
                              HttpServletResponse response) throws Exception {

        RestTemplate restTemplate = new RestTemplate();

        // 토큰 요청
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String tokenUrl = "https://kauth.kakao.com/oauth/token"
                + "?grant_type=authorization_code"
                + "&client_id=" + kakaoClientId
                + "&redirect_uri=" + kakaoRedirectUri
                + "&code=" + code;

        ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, null, String.class);
        Map<String, Object> tokenMap = gson.fromJson(tokenResponse.getBody(), HashMap.class);

        String accessToken = tokenMap.get("access_token").toString();

        // 사용자 정보 요청
        HttpHeaders userHeader = new HttpHeaders();
        userHeader.setBearerAuth(accessToken);

        HttpEntity<String> entity = new HttpEntity<>(userHeader);

        ResponseEntity<String> userResponse = restTemplate.exchange(
                "https://kapi.kakao.com/v2/user/me",
                HttpMethod.GET,
                entity,
                String.class
        );

        Map<String, Object> userMap = gson.fromJson(userResponse.getBody(), HashMap.class);

        String socialId = userMap.get("id").toString();

        HashMap<String, Object> socialMap = new HashMap<>();
        socialMap.put("userId", "kakao_" + socialId);
        socialMap.put("userName", "카카오회원");
        socialMap.put("nickname", "카카오회원");
        socialMap.put("email", "");
        socialMap.put("role", "USER");
        socialMap.put("socialType", "KAKAO");
        socialMap.put("socialId", socialId);

        User user = userService.socialLogin(socialMap);

        session.setAttribute("sessionId", user.getUserId());
        session.setAttribute("sessionName", user.getUserName());
        session.setAttribute("sessionRole", user.getRole());

        // 🔥 main.do로 이동
        response.sendRedirect("/main.do");
    }

    // ===================== 네이버 =====================

    @GetMapping("/user/naver/login")
    public void naverLogin(HttpSession session, HttpServletResponse response) throws IOException {
        String state = Long.toHexString(random.nextLong());
        session.setAttribute("naverState", state);

        String url = "https://nid.naver.com/oauth2.0/authorize"
                + "?response_type=code"
                + "&client_id=" + naverClientId
                + "&redirect_uri=" + URLEncoder.encode(naverRedirectUri, StandardCharsets.UTF_8)
                + "&state=" + state;

        response.sendRedirect(url);
    }

    @GetMapping("/user/naver/callback")
    public void naverCallback(@RequestParam("code") String code,
                              @RequestParam("state") String state,
                              HttpSession session,
                              HttpServletResponse response) throws Exception {

        RestTemplate restTemplate = new RestTemplate();

        String tokenUrl = "https://nid.naver.com/oauth2.0/token"
                + "?grant_type=authorization_code"
                + "&client_id=" + naverClientId
                + "&client_secret=" + naverClientSecret
                + "&code=" + code
                + "&state=" + state;

        ResponseEntity<String> tokenResponse = restTemplate.getForEntity(tokenUrl, String.class);
        Map<String, Object> tokenMap = gson.fromJson(tokenResponse.getBody(), HashMap.class);

        String accessToken = tokenMap.get("access_token").toString();

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
        Map<String, Object> profile = (Map<String, Object>) userMap.get("response");

        String socialId = profile.get("id").toString();

        HashMap<String, Object> socialMap = new HashMap<>();
        socialMap.put("userId", "naver_" + socialId);
        socialMap.put("userName", "네이버회원");
        socialMap.put("nickname", "네이버회원");
        socialMap.put("email", "");
        socialMap.put("role", "USER");
        socialMap.put("socialType", "NAVER");
        socialMap.put("socialId", socialId);

        User user = userService.socialLogin(socialMap);

        session.setAttribute("sessionId", user.getUserId());
        session.setAttribute("sessionName", user.getUserName());
        session.setAttribute("sessionRole", user.getRole());

        // 🔥 main.do로 이동
        response.sendRedirect("/main.do");
    }
}