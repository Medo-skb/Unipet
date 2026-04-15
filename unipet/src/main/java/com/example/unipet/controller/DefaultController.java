package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.DefaultService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class DefaultController {
	
	@Autowired
	DefaultService defaultService;
	
	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/copy.do") 
	public String copy(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/copy";
	}
	
	// ajax가 호출하는 주소
	@RequestMapping(value = "/copy.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String copy(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap = 서비스객체.함수(map);

		return new Gson().toJson(resultMap); 
	}
	
	
	
	
	
	
	
	
	
	
	// ====================================
	@RequestMapping("/default.do") 
	public String test(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/default";
	}

	
	@RequestMapping(value = "/default.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		return new Gson().toJson(resultMap); 
	}

}
