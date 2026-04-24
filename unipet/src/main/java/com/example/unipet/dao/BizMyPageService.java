package com.example.unipet.dao;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.BizMyPageMapper;
import com.example.unipet.model.BizMyPage;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class BizMyPageService {

	@Autowired 
	BizMyPageMapper bizMyPageMapper;
	
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
			List<HashMap<String, Object>> menuList = (List<HashMap<String, Object>>) map.get("menuList");

			for (HashMap<String, Object> item : menuList) {
				bizMyPageMapper.updateBizStoreMenu(item);
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
	
}