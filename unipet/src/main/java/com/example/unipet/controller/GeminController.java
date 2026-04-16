package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.GeminiService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class GeminController {
	
	@Autowired
	private GeminiService geminiService;
	
	@GetMapping("/gemini/test")
	@ResponseBody
	public String geminiTest() throws Exception {
		String category = "강아지 미용"; // 지금은 테스트용 하드코딩

		String prompt = """
		너는 쇼핑몰 추천 문구 생성기다.

		규칙:
		1. 반드시 한 문장만 출력한다.
		2. 설명 금지
		3. 자연스럽게 작성

		사용자는 %s 카테고리에 관심이 있다.
		이 정보를 기반으로 추천 문구를 만들어라.
		""".formatted(category);
	    
	    String result = geminiService.callGeminiTextOnly(prompt);

	    return result;
	}
}