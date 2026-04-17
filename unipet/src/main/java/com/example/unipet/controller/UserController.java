package com.example.unipet.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.dao.UserService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

	@Autowired
	UserService userService;

	@Value("${kakao.client-id}")
	private String kakaoClientId;

	@Value("${kakao.redirect-uri}")
	private String kakaoRedirectUri;

	@Value("${naver.client-id}")
	private String naverClientId;

	@Value("${naver.client-secret}")
	private String naverClientSecret;

	@Value("${naver.redirect-uri}")
	private String naverRedirectUri;

	// =========================================================
	// 1. 페이지 이동용 메서드
	// =========================================================

	// 로그인 페이지 이동
	@GetMapping("/user/login.do")
	public String login() {
		return "user/login";
	}

	// 회원가입 유형 선택 페이지 이동
	@GetMapping("/user/join.do")
	public String join() {
		return "user/join";
	}

	// 일반 사용자 회원가입 페이지 이동
	@GetMapping("/user/SignupUser.do")
	public String signupUserPage() {
		return "user/signup-user";
	}

	// 사업자 회원가입 페이지 이동
	@GetMapping("/user/SignupBiz.do")
	public String signupBizPage() {
		return "user/signup-biz";
	}

	// 아이디 찾기 페이지 이동
	@GetMapping("/user/find-id.do")
	public String findIdPage() {
		return "user/find-id";
	}

	// 비밀번호 찾기 페이지 이동
	@GetMapping("/user/find-pwd.do")
	public String findPwdPage() {
		return "user/find-pwd";
	}

	// 새 비밀번호 설정 페이지 이동
	@GetMapping("/user/new-pwd.do")
	public String newPwdPage() {
		return "user/new-pwd";
	}

	// =========================================================
	// 2. 일반 회원가입 / 로그인 처리
	// =========================================================

	// 아이디 중복 체크
	@PostMapping(value = "/user/check.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.checkUser(map);
		return new Gson().toJson(resultMap);
	}

	// 일반 회원가입 처리
	@PostMapping(value = "/user/signupUser.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String signupUser(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.signupUser(map);
		return new Gson().toJson(resultMap);
	}

	// 사업자 회원가입 처리
	@PostMapping(value = "/user/signupBiz.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String signupBiz(@RequestParam HashMap<String, Object> map, @RequestParam("bizFile") MultipartFile bizFile) {

		HashMap<String, Object> resultMap = userService.signupBiz(map, bizFile);
		return new Gson().toJson(resultMap);
	}

	// 일반 로그인 처리
	@PostMapping(value = "/user/login.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String loginProc(@RequestParam HashMap<String, Object> map, HttpSession session) {
		HashMap<String, Object> resultMap = userService.login(map);

		if (Boolean.TRUE.equals(resultMap.get("result"))) {
			session.setAttribute("sessionId", resultMap.get("sessionId"));
			session.setAttribute("sessionName", resultMap.get("sessionName"));
			session.setAttribute("sessionRole", resultMap.get("sessionRole"));
		}

		return new Gson().toJson(resultMap);
	}

	// =========================================================
	// 3. 카카오 로그인 (SecurityConfig 없이 직접 구현)
	// =========================================================

	// 카카오 로그인 시작
	@GetMapping("/user/kakao/login")
	public void kakaoLogin(HttpServletResponse response) throws IOException {

		String url = "https://kauth.kakao.com/oauth/authorize" + "?client_id="
				+ URLEncoder.encode(kakaoClientId, StandardCharsets.UTF_8) + "&redirect_uri="
				+ URLEncoder.encode(kakaoRedirectUri, StandardCharsets.UTF_8) + "&response_type=code";

		response.sendRedirect(url);
	}

	// 카카오 콜백
	/*
	 * @GetMapping("/user/kakao/callback") public String
	 * kakaoCallback(@RequestParam("code") String code, HttpSession session) throws
	 * Exception {
	 * 
	 * HashMap<String, Object> userInfo = userService.kakaoLogin(code);
	 * 
	 * session.setAttribute("sessionId", userInfo.get("userId"));
	 * session.setAttribute("sessionName", userInfo.get("userName"));
	 * session.setAttribute("sessionRole", "USER");
	 * 
	 * return "redirect:/main.do"; }
	 */

	// =========================================================
	// 4. 네이버 로그인 (SecurityConfig 없이 직접 구현)
	// =========================================================

	// 네이버 로그인 시작
	@GetMapping("/user/naver/login")
	public void naverLogin(HttpServletResponse response, HttpSession session) throws IOException {

		String state = String.valueOf(new SecureRandom().nextInt(1000000));
		session.setAttribute("naverState", state);

		String url = "https://nid.naver.com/oauth2.0/authorize" + "?response_type=code" + "&client_id="
				+ URLEncoder.encode(naverClientId, StandardCharsets.UTF_8) + "&redirect_uri="
				+ URLEncoder.encode(naverRedirectUri, StandardCharsets.UTF_8) + "&state="
				+ URLEncoder.encode(state, StandardCharsets.UTF_8);

		response.sendRedirect(url);
	}

	// 네이버 콜백
	/*
	 * @GetMapping("/user/naver/callback") public String
	 * naverCallback(@RequestParam("code") String code,
	 * 
	 * @RequestParam("state") String state, HttpSession session) throws Exception {
	 * 
	 * String savedState = (String) session.getAttribute("naverState");
	 * 
	 * if (savedState == null || !savedState.equals(state)) { return
	 * "redirect:/user/login.do"; }
	 * 
	 * HashMap<String, Object> userInfo = userService.naverLogin(code, state);
	 * 
	 * session.setAttribute("sessionId", userInfo.get("userId"));
	 * session.setAttribute("sessionName", userInfo.get("userName"));
	 * session.setAttribute("sessionRole", "USER");
	 * 
	 * return "redirect:/main.do"; }
	 */

	// =========================================================
	// 5. 휴대폰 인증 처리
	// =========================================================

	// 인증번호 발송
	@PostMapping(value = "/user/sendSms.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sendSms(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.sendSms(map);
		return new Gson().toJson(resultMap);
	}

	// 인증번호 확인
	@PostMapping(value = "/user/verifySms.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String verifySms(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.verifySms(map);
		return new Gson().toJson(resultMap);
	}

	// =========================================================
	// 6. 아이디 / 비밀번호 찾기 처리
	// =========================================================

	// 이름 + 휴대폰번호로 아이디 찾기
	@PostMapping(value = "/user/findId.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String findId(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.findId(map);
		return new Gson().toJson(resultMap);
	}

	// 아이디 + 휴대폰번호로 회원 확인 (비밀번호 찾기용)
	@PostMapping(value = "/user/checkUserForReset.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String checkUserForReset(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.checkUserForReset(map);
		return new Gson().toJson(resultMap);
	}

	// 비밀번호 재설정 확인용
	@PostMapping(value = "/user/sendResetLink.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String sendResetLink(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.sendResetLink(map);
		return new Gson().toJson(resultMap);
	}

	// 새 비밀번호 변경
	@PostMapping(value = "/user/resetPwd.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String resetPwd(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.resetPwd(map);
		return new Gson().toJson(resultMap);
	}
}