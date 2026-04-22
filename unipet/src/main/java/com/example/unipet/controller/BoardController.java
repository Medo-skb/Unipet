package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.BoardService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {

	@Autowired
	BoardService boardService;

	@RequestMapping("/board/list.do")
	public String list(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		request.setAttribute("bMainNo", map.get("bMainNo"));
		request.setAttribute("bSubNo", map.get("bSubNo"));
		request.setAttribute("keyword", map.get("keyword"));
		request.setAttribute("searchType", map.get("searchType"));
		request.setAttribute("sortType", map.get("sortType"));
		request.setAttribute("page", map.get("page"));
		return "/board/board-list";
	}

	@RequestMapping("/board/view.do")
	public String view(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		request.setAttribute("boardNo", map.get("boardNo"));
		return "/board/board-view";
	}

	@RequestMapping("/board/add.do")
	public String add(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		request.setAttribute("bMainNo", map.get("bMainNo"));
		return "/board/board-add";
	}

	@RequestMapping("/board/edit.do")
	public String edit(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		request.setAttribute("boardNo", map.get("boardNo"));
		return "/board/board-edit";
	}

	@RequestMapping("/board/list.dox")
	@ResponseBody
	public String getBoardList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = boardService.getBoardList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/detail.dox")
	@ResponseBody
	public String getBoardDetail(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = boardService.getBoardDetail(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/comment/list.dox")
	@ResponseBody
	public String getCommentList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = boardService.getCommentList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/comment/add.dox")
	@ResponseBody
	public String addComment(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = boardService.addComment(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/like.dox")
	@ResponseBody
	public String boardLike(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = boardService.boardLike(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/report.dox")
	@ResponseBody
	public String boardReport(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = boardService.boardReport(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/add.dox")
	@ResponseBody
	public String addBoard(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = boardService.addBoard(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/edit-info.dox")
	@ResponseBody
	public String getBoardEditInfo(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = boardService.getBoardEditInfo(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/update.dox")
	@ResponseBody
	public String updateBoard(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		map.put("sessionId", sessionId);

		HashMap<String, Object> resultMap = boardService.updateBoard(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/remove.dox")
	@ResponseBody
	public String removeBoard(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		String sessionRole = session.getAttribute("sessionRole") == null ? ""
				: (String) session.getAttribute("sessionRole");

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);

		HashMap<String, Object> resultMap = boardService.removeBoard(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/board/comment/update.dox")
	@ResponseBody
	public String updateComment(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		String sessionRole = session.getAttribute("sessionRole") == null ? "" : (String) session.getAttribute("sessionRole");

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);

		HashMap<String, Object> resultMap = boardService.updateComment(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping("/board/comment/remove.dox")
	@ResponseBody
	public String removeComment(HttpSession session, @RequestParam HashMap<String, Object> map) {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		String sessionRole = session.getAttribute("sessionRole") == null ? "" : (String) session.getAttribute("sessionRole");

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);

		HashMap<String, Object> resultMap = boardService.removeComment(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/board/category/list.dox")
	@ResponseBody
	public String getBoardCategoryList(@RequestParam HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = boardService.getBoardCategoryList(map);
		return new Gson().toJson(resultMap);
	}
}