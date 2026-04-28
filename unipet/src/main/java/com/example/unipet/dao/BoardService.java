package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.BoardMapper;

import java.io.File;
import java.util.UUID;

@Service
public class BoardService {

	@Autowired
	BoardMapper boardMapper;

	public HashMap<String, Object> getBoardList(HashMap<String, Object> map){
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();

	    try {
	        int page = map.get("page") == null || map.get("page").equals("") ? 1
	                : Integer.parseInt(map.get("page").toString());

	        int pageSize = map.get("pageSize") == null || map.get("pageSize").equals("") ? 10
	                : Integer.parseInt(map.get("pageSize").toString());

	        int count = boardMapper.selectBoardCnt(map);

	        int firstPageSize = count % pageSize;
	        if(firstPageSize == 0 && count > 0){
	            firstPageSize = pageSize;
	        }

	        int startIndex = 0;
	        int limitSize = pageSize;

	        if(page == 1){
	            startIndex = 0;
	            limitSize = firstPageSize;
	        } else {
	            startIndex = firstPageSize + ((page - 2) * pageSize);
	            limitSize = pageSize;
	        }

	        map.put("startIndex", startIndex);
	        map.put("pageSize", limitSize);

	        List<HashMap<String, Object>> list = boardMapper.selectBoardList(map);

	        for(int i=0; i<list.size(); i++){
	            list.get(i).put("DISPLAY_NO", count - startIndex - i);
	        }

	        List<HashMap<String, Object>> categoryMainList = boardMapper.selectBoardMainTypeList(map);
	        List<HashMap<String, Object>> categorySubList = boardMapper.selectBoardSubTypeList(map);
	        List<HashMap<String, Object>> localList = boardMapper.selectBoardLocalList(map);

	        resultMap.put("list", list);
	        resultMap.put("count", count);
	        resultMap.put("mainTypeList", categoryMainList);
	        resultMap.put("subTypeList", categorySubList);
	        resultMap.put("localList", localList);
	        resultMap.put("result", "success");

	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.MSG_SERVER_ERR);
	    }

	    return resultMap;
	}
	public HashMap<String, Object> getBoardDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		if (map.get("boardNo") == null || map.get("boardNo").equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "잘못된 접근입니다.");
			return resultMap;
		}

		boardMapper.updateViewCount(map);

		HashMap<String, Object> info = boardMapper.selectBoardInfo(map);

		if (info == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "존재하지 않는 게시글입니다.");
			return resultMap;
		}

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
		String writerId = info.get("USER_ID") == null ? "" : info.get("USER_ID").toString();
		String privateYn = info.get("PRIVATE") == null ? "N" : info.get("PRIVATE").toString();

		if ("Y".equals(privateYn) && !sessionId.equals(writerId)) {
			resultMap.put("result", "private");
			resultMap.put("message", "비공개 게시글입니다.");
			return resultMap;
		}

		List<HashMap<String, Object>> fileList = boardMapper.selectBoardFileList(map);
		HashMap<String, Object> likeInfo = boardMapper.selectBoardLikeInfo(map);

		resultMap.put("board", info);
		resultMap.put("fileList", fileList);
		resultMap.put("likeCnt", likeInfo == null ? 0 : likeInfo.get("LIKE_CNT"));
		resultMap.put("myLike", likeInfo == null ? "N" : likeInfo.get("MY_LIKE"));
		resultMap.put("result", "success");

		return resultMap;
	}

	public HashMap<String, Object> getCommentList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		List<HashMap<String, Object>> list = boardMapper.selectCommentList(map);

		resultMap.put("list", list);
		resultMap.put("result", "success");
		return resultMap;
	}

	public HashMap<String, Object> addComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
		String contents = map.get("contents") == null ? "" : map.get("contents").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		if (contents.equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "댓글 내용을 입력해주세요.");
			return resultMap;
		}

		contents = badWordFilter(contents);
		map.put("contents", contents);
		map.put("userId", sessionId);

		int cnt = boardMapper.insertComment(map);

		if (cnt > 0) {
			HashMap<String, Object> boardInfo = boardMapper.selectBoardInfo(map);

			if (boardInfo != null) {
				String writerId = boardInfo.get("USER_ID").toString();
				String senderId = map.get("sessionId").toString();

				if (!writerId.equals(senderId)) {
					HashMap<String, Object> alarmMap = new HashMap<String, Object>();
					alarmMap.put("receiverId", writerId);
					alarmMap.put("senderId", senderId);
					alarmMap.put("boardNo", map.get("boardNo"));
					alarmMap.put("commentNo", "");
					alarmMap.put("alarmType", "COMMENT");
					alarmMap.put("alarmContent", senderId + "님이 내 게시글에 댓글을 남겼습니다.");

					boardMapper.insertBoardAlarm(alarmMap);
				}
			}
			
			resultMap.put("result", "success");
			resultMap.put("message", "댓글이 등록되었습니다.");
		} else {
			resultMap.put("result", "fail");
			resultMap.put("message", "댓글 등록 실패");
		}

		return resultMap;
	}

	public HashMap<String, Object> boardLike(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		map.put("userId", sessionId);

		HashMap<String, Object> check = boardMapper.selectBoardLikeCheck(map);

		if (check == null) {
			boardMapper.insertBoardLike(map);
			HashMap<String, Object> boardInfo = boardMapper.selectBoardInfo(map);

			if (boardInfo != null) {
				String writerId = boardInfo.get("USER_ID").toString();
				String senderId = map.get("sessionId").toString();

				if (!writerId.equals(senderId)) {
					HashMap<String, Object> alarmMap = new HashMap<String, Object>();
					alarmMap.put("receiverId", writerId);
					alarmMap.put("senderId", senderId);
					alarmMap.put("boardNo", map.get("boardNo"));
					alarmMap.put("commentNo", "");
					alarmMap.put("alarmType", "LIKE");
					alarmMap.put("alarmContent", senderId + "님이 내 게시글을 추천했습니다.");

					boardMapper.insertBoardAlarm(alarmMap);
				}
			}
			
			resultMap.put("message", "추천되었습니다.");
		} else {
			boardMapper.deleteBoardLike(map);
			resultMap.put("message", "추천이 취소되었습니다.");
		}

		HashMap<String, Object> likeInfo = boardMapper.selectBoardLikeInfo(map);

		resultMap.put("likeCnt", likeInfo == null ? 0 : likeInfo.get("LIKE_CNT"));
		resultMap.put("myLike", likeInfo == null ? "N" : likeInfo.get("MY_LIKE"));
		resultMap.put("result", "success");

		return resultMap;
	}

	public HashMap<String, Object> boardReport(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		if (map.get("reportReason") == null || map.get("reportReason").equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "신고 사유를 선택해주세요.");
			return resultMap;
		}

		map.put("reporterId", sessionId);
		if (map.get("commentNo") == null || "".equals(map.get("commentNo"))) {
			map.put("commentNo", null);
		}
		try {
			int cnt = boardMapper.insertBoardReport(map);

			if (cnt > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "신고가 접수되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "신고 접수 실패");
			}
		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", "이미 신고한 대상입니다.");
		}

		return resultMap;
	}

	private String badWordFilter(String text) {
		if (text == null) {
			return "";
		}

		String[] badWords = { "씨발", "병신", "미친", "개새끼", "지랄", "꺼져" };
		String result = text;

		for (int i = 0; i < badWords.length; i++) {
			result = result.replaceAll(badWords[i], "***");
		}

		return result;
	}

	public HashMap<String, Object> addBoard(HashMap<String, Object> map, MultipartFile[] files) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
		String title = map.get("title") == null ? "" : map.get("title").toString();
		String bContent = map.get("bContent") == null ? "" : map.get("bContent").toString();
		String bSubNo = map.get("bSubNo") == null ? "" : map.get("bSubNo").toString();
		String privateYn = map.get("privateYn") == null ? "N" : map.get("privateYn").toString();
		String bStatus = map.get("bStatus") == null ? "Y" : map.get("bStatus").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		if (title.equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "제목을 입력해주세요.");
			return resultMap;
		}

		if (bContent.equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "본문을 입력해주세요.");
			return resultMap;
		}

		if (bSubNo.equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "카테고리를 선택해주세요.");
			return resultMap;
		}

		map.put("userId", sessionId);
		map.put("privateYn", privateYn);
		map.put("bStatus", bStatus);

		int cnt = boardMapper.insertBoard(map);

		if (cnt > 0) {
			try {
				int boardNo = Integer.parseInt(String.valueOf(map.get("boardNo")));

				String uploadPath = "C:/upload/board/";
				File folder = new File(uploadPath);

				if (!folder.exists()) {
					folder.mkdirs();
				}

				if (files != null) {
					for (int i = 0; i < files.length; i++) {
						MultipartFile file = files[i];

						if (file != null && !file.isEmpty()) {
							String originName = file.getOriginalFilename();
							String fileExt = "";

							if (originName != null && originName.lastIndexOf(".") > -1) {
								fileExt = originName.substring(originName.lastIndexOf(".") + 1);
							}

							String fileName = UUID.randomUUID().toString();
							if (!fileExt.equals("")) {
								fileName += "." + fileExt;
							}

							File dest = new File(uploadPath + fileName);
							file.transferTo(dest);

							HashMap<String, Object> fileMap = new HashMap<String, Object>();
							fileMap.put("boardNo", boardNo);
							fileMap.put("filePath", "/upload/board/");
							fileMap.put("fileName", fileName);
							fileMap.put("originName", originName);
							fileMap.put("fileSize", file.getSize());
							fileMap.put("fileExt", fileExt);

							boardMapper.insertBoardFile(fileMap);
						}
					}
				}

				resultMap.put("result", "success");

				if ("T".equals(bStatus)) {
					resultMap.put("message", "임시저장되었습니다.");
				} else {
					resultMap.put("message", "게시글이 등록되었습니다.");
				}

				resultMap.put("boardNo", boardNo);

			} catch (Exception e) {
				e.printStackTrace();
				resultMap.put("result", "fail");
				resultMap.put("message", "파일 업로드 중 오류가 발생했습니다.");
			}
		} else {
			resultMap.put("result", "fail");
			resultMap.put("message", "게시글 등록 실패");
		}

		return resultMap;
	}

	public HashMap<String, Object> getBoardEditInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		HashMap<String, Object> board = boardMapper.selectBoardInfoForEdit(map);

		if (board == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "존재하지 않는 게시글입니다.");
			return resultMap;
		}

		String writerId = board.get("USER_ID") == null ? "" : board.get("USER_ID").toString();

		if (!sessionId.equals(writerId)) {
			resultMap.put("result", "deny");
			resultMap.put("message", "수정 권한이 없습니다.");
			return resultMap;
		}

		List<HashMap<String, Object>> categoryMainList = boardMapper.selectBoardMainTypeList(map);
		List<HashMap<String, Object>> categorySubList = boardMapper.selectBoardSubTypeList(map);
		List<HashMap<String, Object>> localList = boardMapper.selectBoardLocalList(map);
		List<HashMap<String, Object>> fileList = boardMapper.selectBoardFileList(map);

		resultMap.put("board", board);
		resultMap.put("mainTypeList", categoryMainList);
		resultMap.put("subTypeList", categorySubList);
		resultMap.put("localList", localList);
		resultMap.put("fileList", fileList);
		resultMap.put("result", "success");

		return resultMap;
	}

	public HashMap<String, Object> updateBoard(HashMap<String, Object> map, MultipartFile[] files) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
		String title = map.get("title") == null ? "" : map.get("title").toString();
		String bContent = map.get("bContent") == null ? "" : map.get("bContent").toString();
		String bSubNo = map.get("bSubNo") == null ? "" : map.get("bSubNo").toString();
		String privateYn = map.get("privateYn") == null ? "N" : map.get("privateYn").toString();
		String bStatus = map.get("bStatus") == null ? "Y" : map.get("bStatus").toString();
		map.put("bStatus", bStatus);

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		if (title.equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "제목을 입력해주세요.");
			return resultMap;
		}

		if (bContent.equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "본문을 입력해주세요.");
			return resultMap;
		}

		if (bSubNo.equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "카테고리를 선택해주세요.");
			return resultMap;
		}

		HashMap<String, Object> board = boardMapper.selectBoardInfoForEdit(map);

		if (board == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "존재하지 않는 게시글입니다.");
			return resultMap;
		}

		String writerId = board.get("USER_ID") == null ? "" : board.get("USER_ID").toString();

		if (!sessionId.equals(writerId)) {
			resultMap.put("result", "deny");
			resultMap.put("message", "수정 권한이 없습니다.");
			return resultMap;
		}

		map.put("privateYn", privateYn);

		int cnt = boardMapper.updateBoard(map);

		if (cnt > 0) {
			try {
				int boardNo = Integer.parseInt(String.valueOf(map.get("boardNo")));

				String uploadPath = "C:/upload/board/";
				File folder = new File(uploadPath);

				if (!folder.exists()) {
					folder.mkdirs();
				}

				if (files != null) {
					for (int i = 0; i < files.length; i++) {
						MultipartFile file = files[i];

						if (file != null && !file.isEmpty()) {
							String originName = file.getOriginalFilename();
							String fileExt = "";

							if (originName != null && originName.lastIndexOf(".") > -1) {
								fileExt = originName.substring(originName.lastIndexOf(".") + 1);
							}

							String fileName = UUID.randomUUID().toString();
							if (!fileExt.equals("")) {
								fileName = fileName + "." + fileExt;
							}

							File dest = new File(uploadPath + fileName);
							file.transferTo(dest);

							HashMap<String, Object> fileMap = new HashMap<String, Object>();
							fileMap.put("boardNo", boardNo);
							fileMap.put("filePath", "/upload/board/");
							fileMap.put("fileName", fileName);
							fileMap.put("originName", originName);
							fileMap.put("fileSize", file.getSize());
							fileMap.put("fileExt", fileExt);

							boardMapper.insertBoardFile(fileMap);
						}
					}
				}

				resultMap.put("result", "success");
				resultMap.put("message", "게시글이 수정되었습니다.");

			} catch (Exception e) {
				e.printStackTrace();
				resultMap.put("result", "fail");
				resultMap.put("message", "파일 업로드 중 오류가 발생했습니다.");
			}
		} else {
			resultMap.put("result", "fail");
			resultMap.put("message", "게시글 수정 실패");
		}

		return resultMap;
	}

	public HashMap<String, Object> removeBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
		String sessionRole = map.get("sessionRole") == null ? "" : map.get("sessionRole").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		HashMap<String, Object> board = boardMapper.selectBoardInfoForEdit(map);

		if (board == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "존재하지 않는 게시글입니다.");
			return resultMap;
		}

		String writerId = board.get("USER_ID") == null ? "" : board.get("USER_ID").toString();

		if (!sessionId.equals(writerId) && !sessionRole.equals("A")) {
			resultMap.put("result", "deny");
			resultMap.put("message", "삭제 권한이 없습니다.");
			return resultMap;
		}

		int cnt = boardMapper.deleteBoard(map);

		if (cnt > 0) {
			resultMap.put("result", "success");
			resultMap.put("message", "게시글이 삭제되었습니다.");
		} else {
			resultMap.put("result", "fail");
			resultMap.put("message", "게시글 삭제 실패");
		}

		return resultMap;
	}

	public HashMap<String, Object> removeBoardFile(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
		String boardNo = map.get("boardNo") == null ? "" : map.get("boardNo").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		// 파일 정보 조회
		HashMap<String, Object> fileInfo = boardMapper.selectBoardFileInfo(map);

		if (fileInfo == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "파일 정보가 없습니다.");
			return resultMap;
		}

		// 실제 파일 삭제
		try {
			String filePath = fileInfo.get("FILE_PATH").toString();
			String fileName = fileInfo.get("FILE_NAME").toString();

			File file = new File("C:" + filePath + fileName);
			if (file.exists()) {
				file.delete();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// DB 삭제
		boardMapper.deleteBoardFile(map);

		resultMap.put("result", "success");
		resultMap.put("message", "파일이 삭제되었습니다.");

		return resultMap;
	}

	public HashMap<String, Object> updateComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
		String sessionRole = map.get("sessionRole") == null ? "" : map.get("sessionRole").toString();
		String contents = map.get("contents") == null ? "" : map.get("contents").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		if (contents.equals("")) {
			resultMap.put("result", "fail");
			resultMap.put("message", "댓글 내용을 입력해주세요.");
			return resultMap;
		}

		HashMap<String, Object> commentInfo = boardMapper.selectCommentInfo(map);

		if (commentInfo == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "존재하지 않는 댓글입니다.");
			return resultMap;
		}

		String writerId = commentInfo.get("USER_ID") == null ? "" : commentInfo.get("USER_ID").toString();

		if (!sessionId.equals(writerId) && !sessionRole.equals("A")) {
			resultMap.put("result", "deny");
			resultMap.put("message", "수정 권한이 없습니다.");
			return resultMap;
		}

		contents = badWordFilter(contents);
		map.put("contents", contents);

		int cnt = boardMapper.updateComment(map);

		if (cnt > 0) {
			resultMap.put("result", "success");
			resultMap.put("message", "댓글이 수정되었습니다.");
		} else {
			resultMap.put("result", "fail");
			resultMap.put("message", "댓글 수정 실패");
		}

		return resultMap;
	}

	public HashMap<String, Object> removeComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
		String sessionRole = map.get("sessionRole") == null ? "" : map.get("sessionRole").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		HashMap<String, Object> commentInfo = boardMapper.selectCommentInfo(map);

		if (commentInfo == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "존재하지 않는 댓글입니다.");
			return resultMap;
		}

		String writerId = commentInfo.get("USER_ID") == null ? "" : commentInfo.get("USER_ID").toString();

		if (!sessionId.equals(writerId) && !sessionRole.equals("A")) {
			resultMap.put("result", "deny");
			resultMap.put("message", "삭제 권한이 없습니다.");
			return resultMap;
		}

		int cnt = boardMapper.deleteComment(map);

		if (cnt > 0) {
			resultMap.put("result", "success");
			resultMap.put("message", "댓글이 삭제되었습니다.");
		} else {
			resultMap.put("result", "fail");
			resultMap.put("message", "댓글 삭제 실패");
		}

		return resultMap;
	}

	public HashMap<String, Object> getBoardCategoryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		List<HashMap<String, Object>> mainTypeList = boardMapper.selectBoardMainTypeList(map);
		List<HashMap<String, Object>> subTypeList = boardMapper.selectBoardSubTypeList(map);
		List<HashMap<String, Object>> localList = boardMapper.selectBoardLocalList(map);

		resultMap.put("mainTypeList", mainTypeList);
		resultMap.put("subTypeList", subTypeList);
		resultMap.put("localList", localList);
		resultMap.put("result", "success");

		return resultMap;
	}
	
	public HashMap<String, Object> getRecentTempBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		HashMap<String, Object> info = boardMapper.selectRecentTempBoard(map);

		if (info == null) {
			resultMap.put("result", "fail");
			resultMap.put("message", "최근 임시저장 글이 없습니다.");
			return resultMap;
		}

		resultMap.put("info", info);
		resultMap.put("result", "success");

		return resultMap;
	}
	
	public HashMap<String, Object> getBoardAlarmList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		List<HashMap<String, Object>> list = boardMapper.selectBoardAlarmList(map);

		resultMap.put("list", list);
		resultMap.put("result", "success");

		return resultMap;
	}
	
	public HashMap<String, Object> readBoardAlarm(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

		if (sessionId.equals("")) {
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return resultMap;
		}

		boardMapper.updateBoardAlarmRead(map);

		resultMap.put("result", "success");
		return resultMap;
	}
}