package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.BoardService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class BoardController {
	
	@Autowired
	BoardService BoardService;
	
	
	@RequestMapping("/board.do") 
	public String board(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/board";
	}
	
	@RequestMapping(value = "/board.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String board(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap = 서비스객체.함수(map);

		return new Gson().toJson(resultMap); 
	}

}
