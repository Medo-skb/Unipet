package com.example.unipet.dao;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.BizMyPageMapper;
import com.example.unipet.model.BizMyPage;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class BizMyPageService {

	@Autowired 
	BizMyPageMapper bizMyPageMapper;
	
	@Autowired
	private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;
	
	// 오늘의 일정
	public HashMap<String, Object> getTodayScheduleList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<BizMyPage> list = bizMyPageMapper.selectTodayScheduleList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 메뉴 예약 분포
	public HashMap<String, Object> getMenuChartList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<BizMyPage> list = bizMyPageMapper.selectMenuChartList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 하루 예약 건수 차트
	public HashMap<String, Object> getDailyReservationChartList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<BizMyPage> list = bizMyPageMapper.selectDailyReservationChartList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 승인된 업체 리스트 조회
	public HashMap<String, Object> getApprovedStore(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        List<BizMyPage> list = bizMyPageMapper.selectApprovedStore(map);

	        resultMap.put("list", list);
	        resultMap.put("result", "success");
	        resultMap.put("message", Message.MSG_SEARCH);
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }

	    return resultMap;
	}
	
	// 승인된 업체 존재 여부
	public boolean hasApprovedStore(HashMap<String, Object> map) {
	    return bizMyPageMapper.selectApprovedStoreCount(map) > 0;
	}

	// 사업자 신청 상태 조회
	public HashMap<String, Object> getBizApplyStatus(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        BizMyPage info = bizMyPageMapper.selectBizApplyStatus(map);

	        resultMap.put("info", info);
	        resultMap.put("result", "success");
	        resultMap.put("message", Message.MSG_SEARCH);
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }

	    return resultMap;
	}
	
	// 사업자 회원 탈퇴
	@Transactional
	public Map<String, Object> withdrawRequest(Map<String, Object> map) {
	    Map<String, Object> result = new HashMap<>();

	    // 1. 본인 STORE 존재 여부 확인
	    int storeCnt = bizMyPageMapper.selectStoreCountByUserId(map);

	    // 2. STORE가 있으면 폐업 상태 확인
	    if (storeCnt > 0) {
	        int closedStoreCnt = bizMyPageMapper.selectClosedStoreCount(map);

	        if (closedStoreCnt == 0) {
	            result.put("success", false);
	            result.put("message", "업체가 폐업 상태일 때만 탈퇴 신청이 가능합니다.");
	            return result;
	        }

	        // 3. STORE 삭제
	        bizMyPageMapper.deleteStoreByUserId(map);
	    }

	    // 4. 회원 상태 EXT 변경
	    bizMyPageMapper.updateWithdrawRequestStatus(map);

	    result.put("success", true);
	    result.put("message", "탈퇴되었습니다.");
	    return result;
	}
	
	// 업체 이미지 리스트
	public HashMap<String, Object> getBizImgList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<BizMyPage> list = bizMyPageMapper.selectBizImgList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 업체 설정 리스트
	public HashMap<String, Object> getBizStoreList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<BizMyPage> list = bizMyPageMapper.selectBizStoreList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 업체 메뉴 리스트
	public HashMap<String, Object> getBizStoreMenuList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<BizMyPage> list = bizMyPageMapper.selectBizStoreMenuList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 업체 이미지 업로드
	public HashMap<String, Object> addStoreImage(MultipartFile file, int storeNo, String sUserId, HttpServletRequest request) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String originName = file.getOriginalFilename();

			String extension = "";
			if (originName != null && originName.lastIndexOf(".") > -1) {
			    extension = originName.substring(originName.lastIndexOf(".") + 1);
			}

			String saveFileName = UUID.randomUUID().toString() + extension;

			String uploadFolder = "/img/store/";
			String realPath = request.getServletContext().getRealPath(uploadFolder);

			File folder = new File(realPath);
			if (!folder.exists()) {
				folder.mkdirs();
			}

			File dest = new File(realPath, saveFileName);
			file.transferTo(dest);

			BizMyPage item = new BizMyPage();
			item.setStoreNo(storeNo);
			item.setOriginName(originName);
			item.setFileName(saveFileName);
			item.setFilePath(uploadFolder);
			item.setFileSize(file.getSize());
			item.setFileExt(extension);

			int count = bizMyPageMapper.selectStoreImageCount(storeNo);

			if (count == 0) {
				item.setIsMain("Y");
			} else {
				item.setIsMain("N");
			}

			bizMyPageMapper.insertStoreImage(item);

			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 이미지 삭제
	public HashMap<String, Object> removeStoreImage(int fileNo, HttpServletRequest request) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			// 1. DB에서 파일 정보 조회
			BizMyPage fileInfo = bizMyPageMapper.selectStoreImage(fileNo);

			if (fileInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", Message.MSG_ERR);
				return resultMap;
			}

			// 2. 실제 파일 삭제
			String realPath = request.getServletContext().getRealPath(fileInfo.getFilePath());
			File file = new File(realPath, fileInfo.getFileName());

			if (file.exists()) {
				file.delete();
			}

			// 3. DB 삭제
			bizMyPageMapper.deleteStoreImage(fileNo);

			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_REMOVE);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_ERR);
		}

		return resultMap;
	}
	
	// 대표 이미지 설정
	public HashMap<String, Object> editStoreMainImage(int fileNo) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			BizMyPage fileInfo = bizMyPageMapper.selectStoreImageInfo(fileNo);

			if (fileInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", Message.MSG_ERR);
				return resultMap;
			}

			bizMyPageMapper.updateStoreImageMainReset(fileInfo.getStoreNo());
			bizMyPageMapper.updateStoreImageMain(fileNo);

			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_EDIT);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 업체 설정 수정
	public HashMap<String, Object> editBizStoreInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			// 1. 승인된 업체가 있는지 먼저 확인
			List<BizMyPage> approvedStoreList = bizMyPageMapper.selectApprovedStore(map);

			if (approvedStoreList == null || approvedStoreList.isEmpty()) {
			    resultMap.put("result", "fail");
			    resultMap.put("message", "승인된 업체가 없습니다.");
			    return resultMap;
			}

			// 2. 폐업 시도일 때만 예약 상태 체크
			if ("N".equals(String.valueOf(map.get("isOpen")))) {
				int blockedCount = bizMyPageMapper.selectCloseBlockedReservationCount(map);

				if (blockedCount > 0) {
					resultMap.put("result", "fail");
					resultMap.put("message", "모든 예약이 종료되어야 폐업할 수 있습니다.");
					return resultMap;
				}
			}

			// 3. 조건 통과 시 수정
			bizMyPageMapper.updateBizStore(map);
			bizMyPageMapper.updateBizStoreDetail(map);
			bizMyPageMapper.updateBizStorePolicy(map);

			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_EDIT);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 업체 메뉴 수정
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> editBizStoreMenu(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<HashMap<String, Object>> menuList =
			        (List<HashMap<String, Object>>) map.get("menuList");

			List<Object> deleteMenuNoList =
			        (List<Object>) map.get("deleteMenuNoList");

			if (deleteMenuNoList != null) {
			    for (Object menuNo : deleteMenuNoList) {
			        HashMap<String, Object> deleteMap = new HashMap<String, Object>();
			        deleteMap.put("menuNo", menuNo);

			        bizMyPageMapper.deleteBizStoreMenu(deleteMap);
			    }
			}

			for (HashMap<String, Object> item : menuList) {
			    Object menuNo = item.get("menuNo");

			    if (menuNo == null || "".equals(String.valueOf(menuNo)) || "0".equals(String.valueOf(menuNo))) {
			        bizMyPageMapper.insertBizStoreMenu(item);
			    } else {
			        bizMyPageMapper.updateBizStoreMenu(item);
			    }
			}

			resultMap.put("result", "success");
			resultMap.put("message", "업체 메뉴 수정 완료");

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 사업자 내 정보 조회
	public HashMap<String, Object> getBizUserInfo(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			BizMyPage info = bizMyPageMapper.selectBizUserInfo(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 아이디 중복 확인
	public HashMap<String, Object> getBizUserId(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			int count = bizMyPageMapper.checkBizUserId(map);

			resultMap.put("result", "success");
			resultMap.put("exists", count > 0);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 내 정보 수정
	public HashMap<String, Object> editBizUser(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String rawPwd = String.valueOf(map.get("sUserPwd"));

			String encPwd = passwordEncoder.encode(rawPwd);

			map.put("sUserPwd", encPwd);

			bizMyPageMapper.updateBizUser(map);

			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_EDIT);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 예약 요약
	public HashMap<String, Object> getReservationSummary(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			BizMyPage info = bizMyPageMapper.selectReservationSummary(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 예약 목록
	public HashMap<String, Object> getReservationList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<BizMyPage> list = bizMyPageMapper.selectReservationList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 리뷰 요약
	public HashMap<String, Object> getReviewSummary(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			BizMyPage info = bizMyPageMapper.selectReviewSummary(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 리뷰 목록
	public HashMap<String, Object> getReviewList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<BizMyPage> list = bizMyPageMapper.selectReviewList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}
	
	// 리뷰 메뉴 목록
	public HashMap<String, Object> getReviewMenuList(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        List<BizMyPage> list = bizMyPageMapper.selectReviewMenuList(map);

	        resultMap.put("list", list);
	        resultMap.put("result", "success");
	        resultMap.put("message", Message.MSG_SEARCH);
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }

	    return resultMap;
	}
	
	// 리뷰 신고 등록
	public HashMap<String, Object> addReviewReport(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        bizMyPageMapper.insertReviewReport(map);

	        resultMap.put("result", "success");
	        resultMap.put("message", "리뷰가 신고되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }

	    return resultMap;
	}
	
	// 사업자번호 중복 확인
	public HashMap<String, Object> checkBiznum(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        int count = bizMyPageMapper.checkBiznum(map);

	        resultMap.put("result", "success");
	        resultMap.put("count", count);
	        resultMap.put("message", count > 0 ? "이미 등록된 사업자번호입니다." : "사용 가능한 사업자번호입니다.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("message", "사업자번호 중복확인 중 오류가 발생했습니다.");
	    }

	    return resultMap;
	}

	// 반려 후 재신청
	public HashMap<String, Object> editRejectedStore(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
		    if (map.get("biznum") == null || String.valueOf(map.get("biznum")).isBlank()) {
		        resultMap.put("result", "fail");
		        resultMap.put("message", "사업자번호를 입력해주세요.");
		        return resultMap;
		    }

		    String biznum = String.valueOf(map.get("biznum"));
		    if (!biznum.matches("^\\d{3}-\\d{2}-\\d{5}$")) {
		        resultMap.put("result", "fail");
		        resultMap.put("message", "사업자번호를 XXX-XX-XXXXX 형식으로 입력해주세요.");
		        return resultMap;
		    }

		    int biznumCount = bizMyPageMapper.checkBiznum(map);
		    if (biznumCount > 0) {
		        resultMap.put("result", "fail");
		        resultMap.put("message", "이미 등록된 사업자번호입니다.");
		        return resultMap;
		    }

		    int result = bizMyPageMapper.updateRejectedStore(map);

		    resultMap.put("result", "success");
			resultMap.put("message", "재신청되었습니다.");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", "서버 오류가 발생했습니다.");
		}

		return resultMap;
	}
	
}