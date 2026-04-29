package com.example.unipet.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.UserMapper;
import com.example.unipet.model.User;

@Service
public class UserService {

	@Autowired
	private UserMapper userMapper;

	@Autowired
	PasswordEncoder passwordEncoder;

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
			int idCount = userMapper.checkUser(map);

			if (idCount > 0) {
				result.put("result", false);
				result.put("message", "이미 사용중인 아이디입니다.");
				return result;
			}

			String rawPwd = (String) map.get("pwd");
			map.put("pwd", passwordEncoder.encode(rawPwd));

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
			String rawPwd = (String) map.get("pwd");
			map.put("pwd", passwordEncoder.encode(rawPwd));

			// 1. 사업자 계정 저장
			int count = userMapper.insertBizUser(map);

			if (count > 0) {

				// 2. store 테이블 저장용 기본값 세팅
				// 프론트에서 값이 넘어오면 그 값을 사용하고, 없으면 기본값 사용
				if (map.get("storeName") == null || String.valueOf(map.get("storeName")).isBlank()) {
					map.put("storeName", "임시매장");
				}

				if (map.get("sCategory") == null || String.valueOf(map.get("sCategory")).isBlank()) {
					map.put("sCategory", "기타");
				}

				if (map.get("sAddr") == null) {
					map.put("sAddr", "");
				}

				if (map.get("sFullAddr") == null) {
					map.put("sFullAddr", "");
				}

				if (map.get("lat") == null || String.valueOf(map.get("lat")).isBlank()) {
					map.put("lat", 0);
				}

				if (map.get("lng") == null || String.valueOf(map.get("lng")).isBlank()) {
					map.put("lng", 0);
				}

				// 3. store 테이블 저장
				userMapper.insertStore(map);

				// 4. 방금 생성된 STORE_NO 조회
				int storeNo = userMapper.selectStoreNoByUserId(map);

				// 5. 사업자등록증 파일 정보가 있으면 store_file 저장
				if (map.get("originName") != null && !String.valueOf(map.get("originName")).isBlank()) {
					HashMap<String, Object> fileMap = new HashMap<>();
					fileMap.put("storeNo", storeNo);
					fileMap.put("fileName", map.get("fileName") != null ? map.get("fileName") : map.get("bizFileName"));
					fileMap.put("originName",
							map.get("originName") != null ? map.get("originName") : map.get("bizFileName"));
					fileMap.put("filePath", map.get("filePath") != null ? map.get("filePath") : "/upload");
					fileMap.put("fileExt", map.get("fileExt") != null ? map.get("fileExt")
							: getFileExt(String.valueOf(map.get("bizFileName"))));
					fileMap.put("fileSize", map.get("fileSize") != null ? map.get("fileSize") : 0);

					userMapper.insertStoreFile(fileMap);
				}
			}

			result.put("result", count > 0);
			result.put("message", count > 0 ? "사업자 회원가입이 완료되었습니다." : "사업자 회원가입에 실패했습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", false);
			result.put("message", "사업자 회원가입 중 오류가 발생했습니다.");
		}

		return result;
	}

	// 파일 확장자 추출
	private String getFileExt(String fileName) {
		if (fileName == null || !fileName.contains(".")) {
			return "";
		}
		return fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
	}

	// 일반 로그인
	public HashMap<String, Object> selectUser(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			String rawPwd = (String) map.get("pwd");
			System.out.println(rawPwd);
			User user = userMapper.selectUser(map);

			if (user != null && passwordEncoder.matches(rawPwd, user.getPwd())) {
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
				String rawPwd = (String) map.get("pwd");

				if (passwordEncoder.matches(rawPwd, user.getPwd())) {
					result.put("result", true);
					result.put("user", user);
					result.put("message", "사업자 로그인 성공");
				} else {
					result.put("result", false);
					result.put("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
				}
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

	// 사용자 아이디 찾기
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

	// 사업자 아이디 찾기
	public HashMap<String, Object> findBizId(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			User user = userMapper.findBizId(map);

			if (user != null) {
				result.put("result", true);
				result.put("userId", user.getUserId());
				result.put("message", "사업자 아이디 찾기 성공");
			} else {
				result.put("result", false);
				result.put("message", "일치하는 사업자 정보가 없습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", false);
			result.put("message", "사업자 아이디 찾기 중 오류가 발생했습니다.");
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
			String rawPwd = (String) map.get("pwd");
			map.put("pwd", passwordEncoder.encode(rawPwd));

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

	// 휴대폰 번호 저장
	public HashMap<String, Object> updatePhone(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			int count = userMapper.updatePhone(map);
			result.put("result", count > 0);
			result.put("message", count > 0 ? "휴대폰 번호가 저장되었습니다." : "휴대폰 번호 저장 실패");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", false);
			result.put("message", "휴대폰 번호 저장 중 오류가 발생했습니다.");
		}

		return result;
	}

	// 휴대폰 인증번호 저장
	public void insertPhoneVerify(HashMap<String, Object> map) {
		String phone = String.valueOf(map.get("phone"));
		phone = phone.replace("-", "");
		map.put("phone", phone);

		userMapper.insertPhoneVerify(map);
	}

	// 최신 인증번호 조회
	public HashMap<String, Object> selectLatestPhoneVerify(HashMap<String, Object> map) {
		String phone = String.valueOf(map.get("phone"));
		phone = phone.replace("-", "");
		map.put("phone", phone);

		return userMapper.selectLatestPhoneVerify(map);
	}

	// 인증 완료 처리
	public void updatePhoneVerified(HashMap<String, Object> map) {
		userMapper.updatePhoneVerified(map);
	}
}