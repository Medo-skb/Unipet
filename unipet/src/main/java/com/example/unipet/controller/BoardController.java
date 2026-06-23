package com.example.unipet.controller;

import java.io.IOException;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.dao.BoardService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {

	@Autowired
	BoardService boardService;

	private String getSessionValue(HttpSession session, String key) {
		return session.getAttribute(key) == null ? "" : session.getAttribute(key).toString();
	}

	private String getAdminId(HttpSession session) {
		String adminId = getSessionValue(session, "adminId");

		if (adminId.equals("")) {
			adminId = getSessionValue(session, "sessionAdminId");
		}

		if (adminId.equals("")) {
			String sessionId = getSessionValue(session, "sessionId");

			if ("admin".equals(sessionId)) {
				adminId = sessionId;
			}
		}

		return adminId;
	}

	private String getAdminName(HttpSession session) {
		String adminName = getSessionValue(session, "adminName");

		if (adminName.equals("")) {
			adminName = getSessionValue(session, "sessionAdminName");
		}

		return adminName;
	}

	private boolean isBoardLogin(HttpSession session) {
		String sessionId = getSessionValue(session, "sessionId");
		String adminId = getAdminId(session);

		if (!sessionId.equals("")) {
			return true;
		}

		if (!adminId.equals("")) {
			return true;
		}

		return false;
	}

	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/board/list.do")
	public String list(HttpServletRequest request, HttpSession session, HttpServletResponse response,
			@RequestParam HashMap<String, Object> map) throws Exception {

		if (!isBoardLogin(session)) {
			return alertLogin(response);
		}

		request.setAttribute("bMainNo", map.get("bMainNo"));
		request.setAttribute("bSubNo", map.get("bSubNo"));
		request.setAttribute("keyword", map.get("keyword"));
		request.setAttribute("searchType", map.get("searchType"));
		request.setAttribute("sortType", map.get("sortType"));
		request.setAttribute("page", map.get("page"));
		request.setAttribute("tempYn", map.get("tempYn"));

		return "/board/board-list";
	}

	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/board/view.do")
	public String view(HttpServletRequest request, HttpSession session, HttpServletResponse response,
			@RequestParam HashMap<String, Object> map) throws Exception {

		if (!isBoardLogin(session)) {
			return alertLogin(response);
		}

		request.setAttribute("boardNo", map.get("boardNo"));

		return "/board/board-view";
	}

	@RequestMapping("/board/add.do")
	public String boardAdd(HttpServletRequest request, HttpSession session, HttpServletResponse response)
			throws Exception {

		if (!isBoardLogin(session)) {
			return alertLogin(response);
		}

		request.setAttribute("bMainNo", request.getParameter("bMainNo"));
		return "/board/board-add";
	}

	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/board/edit.do")
	public String edit(HttpServletRequest request, HttpSession session, HttpServletResponse response,
			@RequestParam HashMap<String, Object> map) throws Exception {

		if (!isBoardLogin(session)) {
			return alertLogin(response);
		}

		request.setAttribute("boardNo", map.get("boardNo"));

		return "/board/board-edit";
	}

	// form submit으로 수정하는 주소
	@RequestMapping("/board/update.do")
	public String updateBoard(HttpServletRequest request, HttpSession session,
			@RequestParam HashMap<String, Object> map,
			@RequestParam(value = "files", required = false) MultipartFile[] files) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.updateBoard(map, files);

		if (resultMap.get("result").equals("success")) {

			request.setAttribute("boardNo", map.get("boardNo"));

			if ("T".equals(map.get("bStatus"))) {
				request.setAttribute("msg", "temp");
				return "/board/board-edit";
			} else {
				request.setAttribute("msg", "update");
				return "/board/board-view";
			}

		} else if (resultMap.get("result").equals("login")) {
			return "/user/login";
		} else {
			request.setAttribute("boardNo", map.get("boardNo"));
			return "/board/board-edit";
		}
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String list(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");
		String sessionRole = getSessionValue(session, "sessionRole");
		String adminId = getAdminId(session);
		String adminName = getAdminName(session);

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);
		map.put("adminId", adminId);
		map.put("adminName", adminName);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoardList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBoardDetail(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");
		String sessionRole = getSessionValue(session, "sessionRole");
		String adminId = getAdminId(session);
		String adminName = getAdminName(session);

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);
		map.put("adminId", adminId);
		map.put("adminName", adminName);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoardDetail(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/comment/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCommentList(@RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getCommentList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/comment/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addComment(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.addComment(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/like.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardLike(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.boardLike(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/report.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardReport(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.boardReport(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addBoard(HttpSession session, @RequestParam HashMap<String, Object> map,
			@RequestParam(value = "files", required = false) MultipartFile[] files) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");
		String sessionRole = getSessionValue(session, "sessionRole");
		String adminId = getAdminId(session);
		String adminName = getAdminName(session);

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);
		map.put("adminId", adminId);
		map.put("adminName", adminName);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.addBoard(map, files);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/edit-info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBoardEditInfo(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoardEditInfo(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeBoard(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");
		String sessionRole = getSessionValue(session, "sessionRole");
		String adminId = getAdminId(session);
		String adminName = getAdminName(session);

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);
		map.put("adminId", adminId);
		map.put("adminName", adminName);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.removeBoard(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/file/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeFile(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.removeBoardFile(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/comment/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateComment(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");
		String sessionRole = getSessionValue(session, "sessionRole");
		String adminId = getAdminId(session);
		String adminName = getAdminName(session);

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);
		map.put("adminId", adminId);
		map.put("adminName", adminName);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.updateComment(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/comment/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeComment(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");
		String sessionRole = getSessionValue(session, "sessionRole");
		String adminId = getAdminId(session);
		String adminName = getAdminName(session);

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);
		map.put("adminId", adminId);
		map.put("adminName", adminName);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.removeComment(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/category/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBoardCategoryList(@RequestParam HashMap<String, Object> map) throws Exception {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoardCategoryList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/temp-recent.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getRecentTempBoard(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getRecentTempBoard(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/alarm/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBoardAlarmList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoardAlarmList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/board/alarm/read.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String readBoardAlarm(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {

		String sessionId = getSessionValue(session, "sessionId");

		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.readBoardAlarm(map);

		return new Gson().toJson(resultMap);
	}

	private String alertLogin(HttpServletResponse response) throws IOException {
		response.setContentType("text/html; charset=UTF-8");
		response.getWriter().println("<script>");
		response.getWriter().println("alert('로그인이 필요한 서비스입니다.');");
		response.getWriter().println("location.href='/user/login.do';");
		response.getWriter().println("</script>");
		response.getWriter().flush();

		return null;
	}
}