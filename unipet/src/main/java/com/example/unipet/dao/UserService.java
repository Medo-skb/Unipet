package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.UserMapper;
import com.example.unipet.model.Store;
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
	        int count = userMapper.checkUser(map);
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

	// 사업자번호 중복 체크
	public HashMap<String, Object> checkBiznum(HashMap<String, Object> map) {
	    HashMap<String, Object> result = new HashMap<>();

	    try {
	        int count = userMapper.checkBiznum(map);
	        result.put("result", true);
	        result.put("count", count);
	        result.put("message", count > 0 ? "이미 등록된 사업자번호입니다." : "사용 가능한 사업자번호입니다.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", false);
	        result.put("message", "사업자번호 중복 체크 중 오류가 발생했습니다.");
	    }

	    return result;
	}

	// 외부업체 검색
	public HashMap<String, Object> getExternalStoreList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Store> list = userMapper.selectExternalStoreList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 사용자 회원가입
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> insertUser(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			int idCount = userMapper.checkUser(map);

			if (idCount > 0) {
				result.put("result", false);
				result.put("message", "이미 사용중인 아이디입니다.");
				return result;
			}

			String phone = (String) map.get("phone");
			if (phone != null) {
				map.put("phone", normalizePhone(phone));
			}

			String rawPwd = (String) map.get("pwd");
			map.put("pwd", passwordEncoder.encode(rawPwd));

			// 휴대폰 번호를 새 가입자에게 귀속
			clearPhoneOwner(map);

			int count = userMapper.insertUser(map);
			result.put("result", count > 0);
			result.put("message", count > 0 ? "회원가입이 완료되었습니다." : "회원가입에 실패했습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			result.put("result", false);
			result.put("message", "회원가입 중 오류가 발생했습니다.");
		}

		return result;
	}

	// 사업자 회원가입
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> insertBizUser(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			int idCount = userMapper.checkUser(map);
			if (idCount > 0) {
				result.put("result", false);
				result.put("message", "이미 사용중인 아이디입니다.");
				return result;
			}

			if (map.get("storeNo") == null || String.valueOf(map.get("storeNo")).isBlank()) {
				result.put("result", false);
				result.put("message", "신청할 업체를 선택해주세요.");
				return result;
			}

			int availableStoreCount = userMapper.selectAvailableStoreCount(map);
			if (availableStoreCount == 0) {
			    result.put("result", false);
			    result.put("message", "신청할 수 없는 업체입니다.");
			    return result;
			}

			if (map.get("biznum") == null || String.valueOf(map.get("biznum")).isBlank()) {
			    result.put("result", false);
			    result.put("message", "사업자번호를 입력해주세요.");
			    return result;
			}

			String biznum = String.valueOf(map.get("biznum"));
			if (!biznum.matches("^\\d{3}-\\d{2}-\\d{5}$")) {
			    result.put("result", false);
			    result.put("message", "사업자번호를 XXX-XX-XXXXX 형식으로 입력해주세요.");
			    return result;
			}

			int biznumCount = userMapper.checkBiznum(map);
			if (biznumCount > 0) {
			    result.put("result", false);
			    result.put("message", "이미 등록된 사업자번호입니다.");
			    return result;
			}

			int pendingStoreCount = userMapper.selectPendingSubmitCountByStore(map);
			if (pendingStoreCount > 0) {
				result.put("result", false);
				result.put("message", "이미 검토 중인 업체입니다.");
				return result;
			}

			int pendingUserCount = userMapper.selectPendingSubmitCountByUser(map);
			if (pendingUserCount > 0) {
				result.put("result", false);
				result.put("message", "이미 검토 중인 신청이 있습니다.");
				return result;
			}

			if (map.get("originName") == null || String.valueOf(map.get("originName")).isBlank()) {
				result.put("result", false);
				result.put("message", "사업자등록증 파일을 첨부해주세요.");
				return result;
			}

			String rawPwd = (String) map.get("pwd");
			map.put("pwd", passwordEncoder.encode(rawPwd));

			// 1. 사업자 계정 저장
			int count = userMapper.insertBizUser(map);

			if (count > 0) {
				// 2. 사업자등록증 증빙 파일 저장
				map.put("fileName", map.get("fileName") != null ? map.get("fileName") : map.get("bizFileName"));
				map.put("originName", map.get("originName") != null ? map.get("originName") : map.get("bizFileName"));
				map.put("filePath", map.get("filePath") != null ? map.get("filePath") : "/file/store/");
				map.put("fileExt", map.get("fileExt") != null ? map.get("fileExt") : getFileExt(String.valueOf(map.get("bizFileName"))));
				map.put("fileSize", map.get("fileSize") != null ? map.get("fileSize") : 0);
				userMapper.insertStoreFile(map);

				// 3. 사업자 업체 신청 내역 저장
				userMapper.insertStoreSubmit(map);

				// 4. 신청한 업체 상태를 검토 대기 상태로 변경
				int updatedStoreCount = userMapper.updateStoreStatusToPending(map);
				if (updatedStoreCount == 0) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					result.put("result", false);
					result.put("message", "신청할 수 없는 업체입니다.");
					return result;
				}
			}

			result.put("result", count > 0);
			result.put("message", count > 0 ? "사업자 회원가입이 완료되었습니다." : "사업자 회원가입에 실패했습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
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

	// 휴대폰 번호 숫자만 추출
	private String normalizePhone(String phone) {
		if (phone == null) {
			return "";
		}
		return phone.replaceAll("[^0-9]", "");
	}

	// 같은 휴대폰 번호를 가진 기존 일반 사용자 계정 해제
	private void clearPhoneOwner(HashMap<String, Object> map) {
		if (map.get("phone") == null || String.valueOf(map.get("phone")).isBlank()) {
			return;
		}

		userMapper.clearUserPhoneOwner(map);
	}

	// 일반 로그인
	public HashMap<String, Object> selectUser(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			User user = userMapper.selectUser(map);

			if (user == null) {
				result.put("result", false);
				result.put("message", "존재하지 않는 아이디입니다.");
				return result;
			}

			if ("BAN".equals(user.getUserStatus())) {
				result.put("result", false);
				result.put("message", "정지된 사용자입니다. 고객센터에 문의하세요.");
				return result;
			} else if ("EXT".equals(user.getUserStatus())) {
				result.put("result", false);
				result.put("message", "탈퇴한 사용자입니다.");
				return result;
			}

			String rawPwd = (String) map.get("pwd");
			if (passwordEncoder.matches(rawPwd, user.getPwd())) {
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
			String rawPwd = (String) map.get("pwd");
			User user = userMapper.selectStoreUser(map);

			if (user != null && passwordEncoder.matches(rawPwd, user.getPwd())) {
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

	public HashMap<String, Object> findId(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			User user = userMapper.findId(map);

			if (user != null) {
				result.put("result", true);
				result.put("userId", user.getUserId());
				result.put("message", "아이디를 찾았습니다.");
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
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> updatePhone(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();

		try {
			map.put("phone", normalizePhone(String.valueOf(map.get("phone"))));
			clearPhoneOwner(map);

			int count = userMapper.updatePhone(map);
			result.put("result", count > 0);
			result.put("message", count > 0 ? "휴대폰 번호가 저장되었습니다." : "휴대폰 번호 저장 실패");
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			result.put("result", false);
			result.put("message", "휴대폰 번호 저장 중 오류가 발생했습니다.");
		}

		return result;
	}

	public void insertPhoneVerify(HashMap<String, Object> map) {
		String phone = String.valueOf(map.get("phone"));
		map.put("phone", normalizePhone(phone));

		userMapper.insertPhoneVerify(map);
	}

	public HashMap<String, Object> selectLatestPhoneVerify(HashMap<String, Object> map) {
		String phone = String.valueOf(map.get("phone"));
		map.put("phone", normalizePhone(phone));

		return userMapper.selectLatestPhoneVerify(map);
	}

	public void updatePhoneVerified(HashMap<String, Object> map) {
		userMapper.updatePhoneVerified(map);
	}

	public HashMap<String, Object> getUserCheck(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String phone = (String) map.get("phone");
			if (phone != null) {
				map.put("phone", phone.replaceAll("[^0-9]", ""));
			}

			int userCount = userMapper.selectUserCheckCount(map);

			if (userCount > 0) {
				resultMap.put("result", true);
				resultMap.put("message", "회원 확인 완료");
			} else {
				resultMap.put("result", false);
				resultMap.put("message", "일치하는 회원 정보가 없습니다.");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", false);
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	// 휴대폰 재인증 번호 저장
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> updateSms(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			map.put("phone", normalizePhone(String.valueOf(map.get("phone"))));
			clearPhoneOwner(map);

			userMapper.updateSms(map);

			resultMap.put("result", true);
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			resultMap.put("result", false);
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
}
