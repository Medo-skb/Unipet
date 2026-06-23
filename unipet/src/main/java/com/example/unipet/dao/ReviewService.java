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
	
	@Autowired
	GeminiService geminiService;
	
	@Value("${review.summary.min-count}")
	private int summaryMinCount;

	@Value("${review.summary.review-limit}")
	private int summaryReviewLimit;

	@Value("${review.summary.refresh-count}")
	private int summaryRefreshCount;
	
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
	        editReviewSummaryAfterAdd(map);
	        
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
	        editReviewSummaryAfterAdd(map);
	        
	        resultMap.put("result", "success");
	    } catch (Exception e) {
	        e.printStackTrace();
	        // 트랜잭션 수동 롤백
	        TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	
	// 초기 리뷰 AI 요약 생성
	public HashMap<String, Object> addInitialReviewSummary(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			map.put("minReviewCount", summaryMinCount);

			List<Review> storeTargetList = reviewMapper.selectStoreReviewSummaryTargetList(map);
			List<Review> productTargetList = reviewMapper.selectProductReviewSummaryTargetList(map);

			int successCount = 0;
			int failCount = 0;

			for (Review target : storeTargetList) {
				if (editReviewSummary(target.getTargetType(), target.getTargetNo())) {
					successCount++;
				} else {
					failCount++;
				}
			}

			for (Review target : productTargetList) {
				if (editReviewSummary(target.getTargetType(), target.getTargetNo())) {
					successCount++;
				} else {
					failCount++;
				}
			}

			resultMap.put("successCount", successCount);
			resultMap.put("failCount", failCount);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	// 리뷰 등록 후 AI 요약 갱신
	public void editReviewSummaryAfterAdd(HashMap<String, Object> map) {
		try {
			String targetType = "";
			int targetNo = 0;

			if (map.get("storeNo") != null) {
				targetType = "STO";
				targetNo = Integer.parseInt(String.valueOf(map.get("storeNo")));
			} else if (map.get("productNo") != null) {
				targetType = "PRD";
				targetNo = Integer.parseInt(String.valueOf(map.get("productNo")));
			} else {
				return;
			}

			HashMap<String, Object> summaryMap = new HashMap<String, Object>();
			summaryMap.put("targetType", targetType);
			summaryMap.put("targetNo", targetNo);

			Review summary = reviewMapper.selectReviewSummary(summaryMap);
			List<Review> reviewList = getReviewSummaryList(targetType, targetNo);

			if (reviewList.size() < summaryMinCount) {
				return;
			}

			if (summary == null) {
				editReviewSummary(targetType, targetNo);
				return;
			}

			int newReviewCount = 0;
			for (Review review : reviewList) {
				if (review.getReviewNo() > summary.getLastReviewNo()) {
					newReviewCount++;
				}
			}

			if (newReviewCount >= summaryRefreshCount) {
				editReviewSummary(targetType, targetNo);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 리뷰 AI 요약 생성/수정
	private boolean editReviewSummary(String targetType, int targetNo) {
		try {
			List<Review> reviewList = getReviewSummaryList(targetType, targetNo);

			if (reviewList.size() < summaryMinCount) {
				return false;
			}

			String prompt = makeReviewSummaryPrompt(reviewList);
			String summaryText = geminiService.callGemini(prompt);
			summaryText = cleanSummaryText(summaryText);

			if (summaryText == null || summaryText.isEmpty() || isGeminiErrorMessage(summaryText)) {
				return false;
			}

			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("targetType", targetType);
			map.put("targetNo", targetNo);
			map.put("summaryText", summaryText);
			map.put("lastReviewNo", reviewList.get(0).getReviewNo());
			map.put("summaryStatus", "S");

			Review summary = reviewMapper.selectReviewSummary(map);

			if (summary == null) {
				reviewMapper.insertReviewSummary(map);
			} else {
				reviewMapper.updateReviewSummary(map);
			}

			return true;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	// 리뷰 요약용 리뷰 목록 조회
	private List<Review> getReviewSummaryList(String targetType, int targetNo) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("targetNo", targetNo);
		map.put("reviewLimit", summaryReviewLimit);

		if ("STO".equals(targetType)) {
			return reviewMapper.selectStoreReviewSummaryList(map);
		}

		return reviewMapper.selectProductReviewSummaryList(map);
	}

	// 리뷰 AI 요약 프롬프트 생성
	private String makeReviewSummaryPrompt(List<Review> reviewList) {
		StringBuilder prompt = new StringBuilder();

		prompt.append("다음 리뷰들을 보고 사용자가 참고할 수 있는 한 줄 요약을 작성해줘.\n");
		prompt.append("규칙:\n");
		prompt.append("- 한국어로 작성\n");
		prompt.append("- 1문장만 작성\n");
		prompt.append("- 80자 이내\n");
		prompt.append("- 과장하지 말고 리뷰에 반복적으로 나타난 특징만 요약\n");
		prompt.append("- 따옴표, 번호, 마크다운 없이 문장만 출력\n\n");

		for (Review review : reviewList) {
			prompt.append("평점: ").append(review.getRating());
			prompt.append(", 리뷰: ").append(review.getRContents()).append("\n");
		}

		return prompt.toString();
	}

	// 리뷰 AI 요약 결과 정리
	private String cleanSummaryText(String summaryText) {
		if (summaryText == null) {
			return "";
		}

		summaryText = summaryText.replace("\n", " ");
		summaryText = summaryText.replace("\r", " ");
		summaryText = summaryText.replace("\"", "");
		summaryText = summaryText.replace("'", "");
		summaryText = summaryText.trim();

		if (summaryText.length() > 190) {
			summaryText = summaryText.substring(0, 190);
		}

		return summaryText;
	}

	// Gemini 오류 응답 저장 방지
	private boolean isGeminiErrorMessage(String summaryText) {
		return summaryText.contains("사용량") ||
			   summaryText.contains("응답을 가져오지 못했습니다") ||
			   summaryText.contains("요청이 많아") ||
			   summaryText.contains("불안정");
	}

	
}