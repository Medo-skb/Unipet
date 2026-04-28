package com.example.unipet.dao;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.BoardMapper;
import com.example.unipet.model.Board;

@Service
public class BoardService {

	@Autowired
	BoardMapper boardMapper;

	// 조회 -> get, 수정 -> update, 삽입 -> add, 삭제 -> remove
	// ex) 게시글목록 : getBoardList, 게시글수정 -> updateBoard

	// === Mapper 호출 시 ===
	// 여러개 리턴 -> selectXXXList
	// 한개 리턴 -> selectXXX
	// 수정, 삭제, 삽입 -> updateXXX, deleteXXX, insertXXX

	public HashMap<String, Object> getBoardList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			int page = map.get("page") == null || map.get("page").equals("") ? 1
					: Integer.parseInt(map.get("page").toString());

			int pageSize = map.get("pageSize") == null || map.get("pageSize").equals("") ? 10
					: Integer.parseInt(map.get("pageSize").toString());

			int count = boardMapper.selectBoardCnt(map);

			int startIndex = (page - 1) * pageSize;

			map.put("startIndex", startIndex);
			map.put("pageSize", pageSize);

			List<Board> list = boardMapper.selectBoardList(map);

			for (int i = 0; i < list.size(); i++) {
				list.get(i).setDisplayNo(count - startIndex - i);
			}

			List<Board> categoryMainList = boardMapper.selectBoardMainTypeList(map);
			List<Board> categorySubList = boardMapper.selectBoardSubTypeList(map);
			List<Board> localList = boardMapper.selectBoardLocalList(map);

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

		try {
			if (map.get("boardNo") == null || map.get("boardNo").equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "잘못된 접근입니다.");
				return resultMap;
			}

			boardMapper.updateViewCount(map);

			Board info = boardMapper.selectBoardInfo(map);

			if (info == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 게시글입니다.");
				return resultMap;
			}

			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
			String writerId = info.getUserId() == null ? "" : info.getUserId();
			String privateYn = info.getPrivateYn() == null ? "N" : info.getPrivateYn();

			if ("Y".equals(privateYn) && !sessionId.equals(writerId)) {
				resultMap.put("result", "private");
				resultMap.put("message", "비공개 게시글입니다.");
				return resultMap;
			}

			List<Board> fileList = boardMapper.selectBoardFileList(map);
			Board likeInfo = boardMapper.selectBoardLikeInfo(map);

			resultMap.put("board", info);
			resultMap.put("fileList", fileList);

			if (likeInfo == null) {
				resultMap.put("likeCnt", 0);
				resultMap.put("myLike", "N");
			} else {
				resultMap.put("likeCnt", likeInfo.getLikeCnt());
				resultMap.put("myLike", likeInfo.getMyLike());
			}

			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getCommentList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Board> list = boardMapper.selectCommentList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> addComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
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
				Board boardInfo = boardMapper.selectBoardInfo(map);

				if (boardInfo != null) {
					String writerId = boardInfo.getUserId();
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

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> boardLike(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

			if (sessionId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			map.put("userId", sessionId);

			Board check = boardMapper.selectBoardLikeCheck(map);

			if (check == null) {
				boardMapper.insertBoardLike(map);

				Board boardInfo = boardMapper.selectBoardInfo(map);

				if (boardInfo != null) {
					String writerId = boardInfo.getUserId();
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

			Board likeInfo = boardMapper.selectBoardLikeInfo(map);

			if (likeInfo == null) {
				resultMap.put("likeCnt", 0);
				resultMap.put("myLike", "N");
			} else {
				resultMap.put("likeCnt", likeInfo.getLikeCnt());
				resultMap.put("myLike", likeInfo.getMyLike());
			}

			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> boardReport(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
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

			int cnt = boardMapper.insertBoardReport(map);

			if (cnt > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "신고가 접수되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "신고 접수 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
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

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
			String sessionRole = map.get("sessionRole") == null ? "" : map.get("sessionRole").toString();
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

			if ("1".equals(bSubNo) && !"A".equals(sessionRole) && !"BIZ".equals(sessionRole)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "공지사항은 관리자만 작성할 수 있습니다.");
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

				if ("T".equals(bStatus)) {
					resultMap.put("message", "임시저장되었습니다.");
				} else {
					resultMap.put("message", "게시글이 등록되었습니다.");
				}

				resultMap.put("boardNo", boardNo);

			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "게시글 등록 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getBoardEditInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

			if (sessionId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			Board board = boardMapper.selectBoardInfoForEdit(map);

			if (board == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 게시글입니다.");
				return resultMap;
			}

			String writerId = board.getUserId() == null ? "" : board.getUserId();

			if (!sessionId.equals(writerId)) {
				resultMap.put("result", "deny");
				resultMap.put("message", "수정 권한이 없습니다.");
				return resultMap;
			}

			List<Board> categoryMainList = boardMapper.selectBoardMainTypeList(map);
			List<Board> categorySubList = boardMapper.selectBoardSubTypeList(map);
			List<Board> localList = boardMapper.selectBoardLocalList(map);
			List<Board> fileList = boardMapper.selectBoardFileList(map);

			resultMap.put("board", board);
			resultMap.put("mainTypeList", categoryMainList);
			resultMap.put("subTypeList", categorySubList);
			resultMap.put("localList", localList);
			resultMap.put("fileList", fileList);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> updateBoard(HashMap<String, Object> map, MultipartFile[] files) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
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

			Board board = boardMapper.selectBoardInfoForEdit(map);

			if (board == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 게시글입니다.");
				return resultMap;
			}

			String writerId = board.getUserId() == null ? "" : board.getUserId();

			if (!sessionId.equals(writerId)) {
				resultMap.put("result", "deny");
				resultMap.put("message", "수정 권한이 없습니다.");
				return resultMap;
			}

			map.put("privateYn", privateYn);

			int cnt = boardMapper.updateBoard(map);

			if (cnt > 0) {
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

			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "게시글 수정 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> removeBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
			String sessionRole = map.get("sessionRole") == null ? "" : map.get("sessionRole").toString();

			if (sessionId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			Board board = boardMapper.selectBoardInfoForEdit(map);

			if (board == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 게시글입니다.");
				return resultMap;
			}

			String writerId = board.getUserId() == null ? "" : board.getUserId();

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

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> removeBoardFile(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

			if (sessionId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			Board fileInfo = boardMapper.selectBoardFileInfo(map);

			if (fileInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "파일 정보가 없습니다.");
				return resultMap;
			}

			String filePath = fileInfo.getFilePath();
			String fileName = fileInfo.getFileName();

			File file = new File("C:" + filePath + fileName);

			if (file.exists()) {
				file.delete();
			}

			boardMapper.deleteBoardFile(map);

			resultMap.put("result", "success");
			resultMap.put("message", "파일이 삭제되었습니다.");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> updateComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
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

			Board commentInfo = boardMapper.selectCommentInfo(map);

			if (commentInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 댓글입니다.");
				return resultMap;
			}

			String writerId = commentInfo.getUserId() == null ? "" : commentInfo.getUserId();

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

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> removeComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
			String sessionRole = map.get("sessionRole") == null ? "" : map.get("sessionRole").toString();

			if (sessionId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			Board commentInfo = boardMapper.selectCommentInfo(map);

			if (commentInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 댓글입니다.");
				return resultMap;
			}

			String writerId = commentInfo.getUserId() == null ? "" : commentInfo.getUserId();

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

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getBoardCategoryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Board> mainTypeList = boardMapper.selectBoardMainTypeList(map);
			List<Board> subTypeList = boardMapper.selectBoardSubTypeList(map);
			List<Board> localList = boardMapper.selectBoardLocalList(map);

			resultMap.put("mainTypeList", mainTypeList);
			resultMap.put("subTypeList", subTypeList);
			resultMap.put("localList", localList);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getRecentTempBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

			if (sessionId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			Board info = boardMapper.selectRecentTempBoard(map);

			if (info == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "최근 임시저장 글이 없습니다.");
				return resultMap;
			}

			resultMap.put("info", info);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getBoardAlarmList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

			if (sessionId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			List<Board> list = boardMapper.selectBoardAlarmList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> readBoardAlarm(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();

			if (sessionId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			boardMapper.updateBoardAlarmRead(map);

			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

}