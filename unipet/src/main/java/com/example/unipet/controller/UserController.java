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
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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

	@RequestMapping(value = "/user/new-pwd.do", method = RequestMethod.GET)
	public String newPwdPage(HttpSession session, Model model) {
	    
	    // 휴대폰 인증을 통과했는지 세션 확인
	    Object smsAuth = session.getAttribute("smsAuth");
	    Object resetUserId = session.getAttribute("resetUserId");

	    if (smsAuth == null || !(boolean) smsAuth || resetUserId == null) {
	        return "redirect:/user/login.do"; 
	    }

	    return "/user/new-pwd"; 
	}

	@GetMapping("/logout.do")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/user/login.do";
	}

	@GetMapping("/user/phone-verify.do")
	public String phoneVerifyPage() {
		return "user/phone-verify";
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

			if (user.getPhone() == null || user.getPhone().trim().isEmpty()) {
				session.setAttribute("needPhoneVerify", true);
				resultMap.put("needPhoneVerify", true);
			} else {
				session.removeAttribute("needPhoneVerify");
				resultMap.put("needPhoneVerify", false);
			}

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
			session.setAttribute("storeStatus", user.getStoreStatus());

			session.removeAttribute("needPhoneVerify");
			resultMap.put("needPhoneVerify", false);

			resultMap.put("message", user.getUserName() + "님 환영합니다 👋");
		}

		return gson.toJson(resultMap);
	}

	// =========================
	// 사용자 회원가입
	// =========================
	@PostMapping("/user/signupUser.dox")
	@ResponseBody
	public String signupUser(@RequestParam HashMap<String, Object> map, HttpSession session) {

		HashMap<String, Object> resultMap = new HashMap<>();

		Boolean phoneVerified = (Boolean) session.getAttribute("phoneVerified");
		String verifyPhone = (String) session.getAttribute("verifyPhone");
		String inputPhone = map.get("phone") == null ? "" : String.valueOf(map.get("phone")).replaceAll("[^0-9]", "");

		if (phoneVerified == null || !phoneVerified || verifyPhone == null || !verifyPhone.equals(inputPhone)) {
			resultMap.put("result", false);
			resultMap.put("message", "휴대폰 인증을 완료해주세요.");
			return gson.toJson(resultMap);
		}

		map.put("phone", verifyPhone);
		resultMap = userService.insertUser(map);

		if (Boolean.TRUE.equals(resultMap.get("result"))) {
			session.removeAttribute("phoneVerified");
			session.removeAttribute("verifiedPhone");
			session.removeAttribute("verifyPhone");
		}

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

			String originName = bizFile.getOriginalFilename();

			String fileExt = "";
			if (originName != null && originName.contains(".")) {
				fileExt = originName.substring(originName.lastIndexOf(".") + 1).toLowerCase();
			}

			map.put("bizFileName", originName);
			map.put("fileName", originName);
			map.put("originName", originName);

			// 수정: /upload -> /file/store/
			map.put("filePath", "/file/store/");

			map.put("fileExt", fileExt);
			map.put("fileSize", bizFile.getSize());

			// 추가: 사업자 증빙파일 여부
			map.put("isProof", "Y");
		}

		HashMap<String, Object> resultMap = userService.insertBizUser(map);
		return gson.toJson(resultMap);
	}
	
	@PostMapping("/user/check.dox")
	@ResponseBody
	public String checkUser(@RequestParam HashMap<String, Object> map) {
		return gson.toJson(userService.checkUser(map));
	}

	@PostMapping("/user/checkBiz.dox")
	@ResponseBody
	public String checkBizUser(@RequestParam HashMap<String, Object> map) {
		return gson.toJson(userService.checkStoreUser(map));
	}

	// 외부업체 검색
	@RequestMapping(value = "/user/external-store/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String externalStoreList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.getExternalStoreList(map);
		return gson.toJson(resultMap);
	}
	
	// =========================
	// SMS 인증번호 발송
	// =========================
	@PostMapping("/user/sendSms.dox")
	@ResponseBody
	public String sendSms(@RequestParam String phone, HttpSession session) {

		HashMap<String, Object> result = new HashMap<>();

		String cleanPhone = phone.replaceAll("[^0-9]", "");
		String code = String.format("%06d", new java.util.Random().nextInt(1000000));

		HashMap<String, Object> map = new HashMap<>();
		map.put("phone", cleanPhone);
		map.put("code", code);

		userService.insertPhoneVerify(map);

		
		smsService.sendSms(cleanPhone, code);

		session.setAttribute("verifyPhone", cleanPhone);

		result.put("result", true);
		result.put("message", "인증번호가 발송되었습니다.");
		result.put("code", code);

		return new Gson().toJson(result);
	}

	// =========================
	// SMS 인증번호 확인
	// =========================
	@PostMapping("/user/checkSms.dox")
	@ResponseBody
	public String checkSms(@RequestParam String code, HttpSession session) {
		HashMap<String, Object> result = new HashMap<>();

		String phone = (String) session.getAttribute("verifyPhone");

		if (phone == null) {
			result.put("result", false);
			result.put("message", "인증 요청을 먼저 해주세요.");
			return new Gson().toJson(result);
		}

		HashMap<String, Object> map = new HashMap<>();
		map.put("phone", phone);

		HashMap<String, Object> verify = userService.selectLatestPhoneVerify(map);

		if (verify == null) {
			result.put("result", false);
			result.put("message", "인증 정보가 없습니다.");
			return new Gson().toJson(result);
		}

		String dbCode = String.valueOf(verify.get("code"));
		String verifiedYn = String.valueOf(verify.get("verifiedYn"));

		if ("Y".equals(verifiedYn)) {
			result.put("result", false);
			result.put("message", "이미 인증 완료된 번호입니다.");
			return new Gson().toJson(result);
		}
		java.time.LocalDateTime expireTime = (java.time.LocalDateTime) verify.get("expireTime");

		if (expireTime.isBefore(java.time.LocalDateTime.now())) {
		    result.put("result", false);
		    result.put("message", "인증 시간이 만료되었습니다. 다시 요청해주세요.");
		    return new Gson().toJson(result);
		}

		
		if (!dbCode.equals(code)) {
			result.put("result", false);
			result.put("message", "인증번호가 일치하지 않습니다.");
			return new Gson().toJson(result);
		}

		HashMap<String, Object> updateMap = new HashMap<>();
		updateMap.put("verifyNo", verify.get("verifyNo"));
		userService.updatePhoneVerified(updateMap);

		session.setAttribute("phoneVerified", true);
		session.setAttribute("verifiedPhone", phone);
		session.setAttribute("smsAuth", true);

		result.put("result", true);
		result.put("message", "휴대폰 인증이 완료되었습니다.");
		return new Gson().toJson(result);
	}

	// 팝업은 안 띄우지만, login.jsp에서 호출 중이면 오류 방지용으로 false 반환
	@PostMapping("/user/check-need-verify.dox")
	@ResponseBody
	public HashMap<String, Object> checkNeedVerify(HttpSession session) {
		HashMap<String, Object> result = new HashMap<>();
		result.put("needVerify", false);
		session.removeAttribute("needPhoneVerify");
		return result;
	}

	// =========================
	// 사용자아이디 찾기
	// =========================
	@PostMapping("/user/findId.dox")
	@ResponseBody
	public String findId(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.findId(map);
		return gson.toJson(resultMap);
	}

	// 사업자 아이디찾기
	@PostMapping("/user/findBizId.dox")
	@ResponseBody
	public String findBizId(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = userService.findBizId(map);
		return gson.toJson(resultMap);
	}
	
	@RequestMapping(value = "/user/checkUserExist.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String checkUserExist(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        
        // 1. 파라미터 유효성 검사 (프론트에서 넘어온 값이 비어있는지 확인)
        String userId = (String) map.get("userId");
        String phone = (String) map.get("phone");

        if (userId == null || userId.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            resultMap.put("result", false);
            resultMap.put("message", "아이디와 휴대폰 번호를 모두 입력해주세요.");
            return new Gson().toJson(resultMap);
        }

        // 2. 서비스객체.함수(map) 호출
        resultMap = userService.getUserCheck(map);
 
        // 3. Gson을 이용하여 JSON 형태로 리턴
        return new Gson().toJson(resultMap); 
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

	@PostMapping("/user/resetPwd.dox")
	@ResponseBody
	public String resetPwd(@RequestParam HashMap<String, Object> map, HttpSession session) {
		HashMap<String, Object> resultMap = new HashMap<>();

		Object smsAuth = session.getAttribute("smsAuth");

		if (smsAuth == null || !(boolean) smsAuth) {
	        resultMap.put("result", false);
	        resultMap.put("message", "비정상적인 접근입니다. (휴대폰 인증 누락)");
	        return gson.toJson(resultMap);
	    }
	
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
	        session.removeAttribute("verifyPhone");
	    }

		return gson.toJson(resultMap);
	}

	// =========================
	// 카카오 로그인 시작
	// =========================
	@GetMapping("/user/kakao/login")
	public void kakaoLogin(HttpServletResponse response) throws IOException {
		String url = "https://kauth.kakao.com/oauth/authorize" + "?client_id="
				+ URLEncoder.encode(kakaoClientId, StandardCharsets.UTF_8) + "&redirect_uri="
				+ URLEncoder.encode(kakaoRedirectUri, StandardCharsets.UTF_8) + "&response_type=code" + "&prompt=login";

		response.sendRedirect(url);
	}

	// =========================
	// 카카오 로그인 콜백
	// =========================
	@GetMapping("/user/kakao/callback")
	public void kakaoCallback(@RequestParam(value = "code", required = false) String code,
			@RequestParam(value = "error", required = false) String error, HttpSession session,
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

		HttpEntity<MultiValueMap<String, String>> tokenRequest = new HttpEntity<>(tokenParams, tokenHeaders);

		ResponseEntity<String> tokenResponse = restTemplate.postForEntity("https://kauth.kakao.com/oauth/token",
				tokenRequest, String.class);

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

		ResponseEntity<String> userResponse = restTemplate.exchange("https://kapi.kakao.com/v2/user/me", HttpMethod.GET,
				userRequest, String.class);

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

		// 팝업 안 띄우므로 인증 세션 제거
		session.removeAttribute("needPhoneVerify");

		response.sendRedirect("/main.do");
		return;
	}

	// =========================
	// 네이버 로그인 시작
	// =========================
	@GetMapping("/user/naver/login")
	public void naverLogin(HttpSession session, HttpServletResponse response) throws IOException {
		String state = Long.toHexString(random.nextLong());
		session.setAttribute("naverState", state);

		String url = "https://nid.naver.com/oauth2.0/authorize" + "?response_type=code" + "&client_id="
				+ URLEncoder.encode(naverClientId, StandardCharsets.UTF_8) + "&redirect_uri="
				+ URLEncoder.encode(naverRedirectUri, StandardCharsets.UTF_8) + "&state=" + state
				+ "&auth_type=reauthenticate";

		response.sendRedirect(url);
	}

	// =========================
	// 네이버 로그인 콜백
	// =========================
	@GetMapping("/user/naver/callback")
	public void naverCallback(@RequestParam(value = "code", required = false) String code,
			@RequestParam(value = "state", required = false) String state,
			@RequestParam(value = "error", required = false) String error, HttpSession session,
			HttpServletResponse response) throws Exception {

		if (error != null || code == null || code.isBlank() || state == null || state.isBlank()) {
			response.sendRedirect("/user/login.do");
			return;
		}

		String sessionState = session.getAttribute("naverState") == null ? ""
				: session.getAttribute("naverState").toString();

		if (!state.equals(sessionState)) {
			response.sendRedirect("/user/login.do");
			return;
		}

		RestTemplate restTemplate = new RestTemplate();

		String tokenUrl = "https://nid.naver.com/oauth2.0/token" + "?grant_type=authorization_code" + "&client_id="
				+ URLEncoder.encode(naverClientId, StandardCharsets.UTF_8) + "&client_secret="
				+ URLEncoder.encode(naverClientSecret, StandardCharsets.UTF_8) + "&code="
				+ URLEncoder.encode(code, StandardCharsets.UTF_8) + "&state="
				+ URLEncoder.encode(state, StandardCharsets.UTF_8);

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

		ResponseEntity<String> userResponse = restTemplate.exchange("https://openapi.naver.com/v1/nid/me",
				HttpMethod.GET, entity, String.class);

		Map<String, Object> userMap = gson.fromJson(userResponse.getBody(), HashMap.class);

		String socialId = "";
		String email = "";
		String userName = "네이버회원";
		String nickname = "네이버회원";

		if (userMap != null) {
			Object responseObj = userMap.get("response");

			if (responseObj instanceof Map<?, ?> profile) {
				Object idObj = profile.get("id");
				if (idObj != null)
					socialId = idObj.toString();

				Object emailObj = profile.get("email");
				if (emailObj != null)
					email = emailObj.toString();

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

		// 팝업 안 띄우므로 인증 세션 제거
		session.removeAttribute("needPhoneVerify");

		response.sendRedirect("/main.do");
		return;
	}
	
	// 휴대폰 재인증 번호 저장
	@RequestMapping(value = "/user/updateSms.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String updateSms(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();

		String sessionId = (String) session.getAttribute("sessionId");
		String sessionRole = (String) session.getAttribute("sessionRole");
		String verifiedPhone = (String) session.getAttribute("verifiedPhone");
		String inputPhone = map.get("phone") == null ? "" : String.valueOf(map.get("phone")).replaceAll("[^0-9]", "");

		if (sessionId == null || sessionRole == null) {
			resultMap.put("result", false);
			resultMap.put("message", "로그인 후 이용해주세요.");
			return new Gson().toJson(resultMap);
		}

		if (!"USER".equals(sessionRole)) {
			resultMap.put("result", false);
			resultMap.put("message", "일반 사용자만 휴대폰 인증을 사용할 수 있습니다.");
			return new Gson().toJson(resultMap);
		}

		if (verifiedPhone == null || !verifiedPhone.equals(inputPhone)) {
			resultMap.put("result", false);
			resultMap.put("message", "휴대폰 인증 후 이용해주세요.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", sessionId);
		map.put("role", sessionRole);
		map.put("phone", verifiedPhone);

        resultMap = userService.updateSms(map);

		if (Boolean.TRUE.equals(resultMap.get("result"))) {
			session.removeAttribute("needPhoneVerify");
			session.removeAttribute("phoneVerified");
			session.removeAttribute("verifiedPhone");
			session.removeAttribute("verifyPhone");
		}
        
        return new Gson().toJson(resultMap); 
    }
}
