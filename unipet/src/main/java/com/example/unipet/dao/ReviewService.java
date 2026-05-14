package com.example.unipet.dao;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.ReviewMapper;
import com.example.unipet.model.Order;
import com.example.unipet.model.Reservation;
import com.example.unipet.model.Review;

@Service
public class ReviewService {

	@Autowired 
	ReviewMapper reviewMapper;
	
	// 조회 -> get, 수정 -> edit, 삽입 -> add, 삭제 -> remove
	// ex) 학생목록 : getStudentList, 학생수정 -> editStudent
	
	// === Mapper 호출 시 === 
	// 여러개 리턴 -> selectXXXList
	//	List<User> list = defaultMapper.selectUserList();
	// 한개 리턴 -> selectXXX
	//	User info = defaultMapper.selectUser();
	// 수정, 삭제, 삽입 -> updateXXX, deleteXXX, insertXXX
	//	int result = defaultMapper.updateXXX();
	
	public HashMap<String, Object> getRsvInfo(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Reservation info = reviewMapper.selectRsvInfo(map);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getOrderInfo(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Order info = reviewMapper.selectOrderInfo(map);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	
//	@Value("${file.review-path}")
//    private String uploadPath; // 설정 파일의 경로가 이 변수로 들어옴.
//	
//	@Transactional
//	public HashMap<String, Object> addReviewRsv(HashMap<String, Object> map, List<MultipartFile> files) {
//	    HashMap<String, Object> resultMap = new HashMap<>();
//	    try {
//	        reviewMapper.insertReviewRsv(map);
//	        int reviewNo = Integer.parseInt(String.valueOf(map.get("reviewNo")));
//
//	        if (files != null && !files.isEmpty() && !files.get(0).getOriginalFilename().isEmpty()) {
//	            for (MultipartFile file : files) {
//	                String originName = file.getOriginalFilename();
//	                String ext = originName.substring(originName.lastIndexOf("."));
//	                String saveName = UUID.randomUUID().toString() + ext;
//
//	                File dest = new File(uploadPath + saveName);
//	                if (!dest.exists()) dest.mkdirs();
//	                file.transferTo(dest);
//
//	                HashMap<String, Object> fileMap = new HashMap<>();
//	                fileMap.put("reviewNo", reviewNo);
//	                fileMap.put("filePath", "/img/review/");
//	                fileMap.put("fileName", saveName);
//	                fileMap.put("originName", originName);
//	                
//	                fileMap.put("fileSize", file.getSize()); // 실제 파일 크기 (byte 단위)
//	                fileMap.put("fileExt", ext.replace(".", "")); // 확장자 (점 빼고 저장)
//	                
//	                reviewMapper.insertReviewFile(fileMap);
//	            }
//	        }
//	        resultMap.put("result", "success");
//	    } catch (Exception e) {
//	        e.printStackTrace();
//	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
//	        resultMap.put("result", "fail");
//	    }
//	    return resultMap;
//	}
	
	@Value("${file.review-path}")
	private String uploadPath;

	@Transactional
	public HashMap<String, Object> addReviewRsv(HashMap<String, Object> map, List<MultipartFile> files) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        reviewMapper.insertReviewRsv(map);
	        int reviewNo = Integer.parseInt(String.valueOf(map.get("reviewNo")));

	        if (files != null && !files.isEmpty() && !files.get(0).getOriginalFilename().isEmpty()) {
	            for (MultipartFile file : files) {
	                String originName = file.getOriginalFilename();
	                String ext = originName.substring(originName.lastIndexOf("."));
	                String saveName = UUID.randomUUID().toString() + ext;

	                // 핵심 수정: uploadPath를 바탕으로 정확한 파일 객체 생성
	                File dest = new File(uploadPath, saveName);
	                
	                // 해당 경로까지의 폴더가 없으면 자동으로 생성 (부모 폴더까지 포함)
	                if (!dest.getParentFile().exists()) {
	                    dest.getParentFile().mkdirs();
	                }

	                // 파일 저장
	                file.transferTo(dest);

	                HashMap<String, Object> fileMap = new HashMap<>();
	                fileMap.put("reviewNo", reviewNo);
	                fileMap.put("filePath", "/img/review/"); // DB에는 웹에서 접근할 가상 경로 저장
	                fileMap.put("fileName", saveName);
	                fileMap.put("originName", originName);
	                fileMap.put("fileSize", file.getSize());
	                fileMap.put("fileExt", ext.replace(".", ""));
	                
	                reviewMapper.insertReviewFile(fileMap);
	            }
	        }
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	
//	@Transactional
//	public HashMap<String, Object> addReviewPrd(HashMap<String, Object> map, List<MultipartFile> files) {
//	    HashMap<String, Object> resultMap = new HashMap<>();
//	    try {
//	        reviewMapper.insertReviewPrd(map);
//	        int reviewNo = Integer.parseInt(String.valueOf(map.get("reviewNo")));
//
//	        if (files != null && !files.isEmpty() && !files.get(0).getOriginalFilename().isEmpty()) {
//	            for (MultipartFile file : files) {
//	                String originName = file.getOriginalFilename();
//	                String ext = originName.substring(originName.lastIndexOf("."));
//	                String saveName = UUID.randomUUID().toString() + ext;
//
//	                File dest = new File(uploadPath + saveName);
//	                if (!dest.exists()) dest.mkdirs();
//	                file.transferTo(dest);
//
//	                HashMap<String, Object> fileMap = new HashMap<>();
//	                fileMap.put("reviewNo", reviewNo);
//	                fileMap.put("filePath", "/img/review/");
//	                fileMap.put("fileName", saveName);
//	                fileMap.put("originName", originName);
//	                
//	                fileMap.put("fileSize", file.getSize()); // 실제 파일 크기 (byte 단위)
//	                fileMap.put("fileExt", ext.replace(".", "")); // 확장자 (점 빼고 저장)
//	                
//	                reviewMapper.insertReviewFile(fileMap);
//	            }
//	        }
//	        resultMap.put("result", "success");
//	    } catch (Exception e) {
//	        e.printStackTrace();
//	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
//	        resultMap.put("result", "fail");
//	    }
//	    return resultMap;
//	}
	
	@Transactional
	public HashMap<String, Object> addReviewPrd(HashMap<String, Object> map, List<MultipartFile> files) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        // 1. 상품 리뷰 본문 저장
	        reviewMapper.insertReviewPrd(map);
	        int reviewNo = Integer.parseInt(String.valueOf(map.get("reviewNo")));

	        // 2. 파일 처리
	        if (files != null && !files.isEmpty() && !files.get(0).getOriginalFilename().isEmpty()) {
	            for (MultipartFile file : files) {
	                String originName = file.getOriginalFilename();
	                String ext = originName.substring(originName.lastIndexOf("."));
	                String saveName = UUID.randomUUID().toString() + ext;

	                // [수정 포인트 1] 문자열 더하기 대신 File 생성자 사용 (OS별 슬래시 자동 처리)
	                File dest = new File(uploadPath, saveName);
	                
	                // [수정 포인트 2]mkdirs() 버그 수정
	                // dest는 파일 경로이므로, dest.mkdirs()를 하면 파일명으로 폴더가 생깁니다.
	                // 반드시 부모 폴더(getParentFile)가 존재하는지 확인하고 생성해야 합니다.
	                if (!dest.getParentFile().exists()) {
	                    dest.getParentFile().mkdirs();
	                }

	                // [수정 포인트 3] 파일 물리적 저장
	                file.transferTo(dest);

	                HashMap<String, Object> fileMap = new HashMap<>();
	                fileMap.put("reviewNo", reviewNo);
	                fileMap.put("filePath", "/img/review/");
	                fileMap.put("fileName", saveName);
	                fileMap.put("originName", originName);
	                fileMap.put("fileSize", file.getSize()); 
	                fileMap.put("fileExt", ext.replace(".", "")); 
	                
	                reviewMapper.insertReviewFile(fileMap);
	            }
	        }
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        // 트랜잭션 수동 롤백
	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}

	
}