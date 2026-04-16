package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.ReservationService;
import com.google.gson.Gson;

import ch.qos.logback.core.model.Model;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ReservationController {
	
	@Autowired
	ReservationService reservationService;
	
	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/reservation/search.do") 
	public String search(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/reservation/search";
	}

	@RequestMapping(value = "/reservation/search.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String search(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		resultMap = 서비스객체.함수(map);
		
		resultMap = reservationService.getStoreList(map);

		return new Gson().toJson(resultMap); 
	}
}
