package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.MainService;
import com.example.unipet.model.Main;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MainController {

	@Autowired
    MainService mainService;
    
	// 메인페이지
    @RequestMapping("/main.do")
	public String main(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return "main/main";
	}
    
    // 메인 통합 검색
    @RequestMapping("/main/search.do")
    public String mainSearch(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	
    	String keyword = map.get("keyword") == null ? "" : map.get("keyword").toString();
    	map.put("keyword", keyword);
    	
    	HashMap<String, Object> storeMap = mainService.getSearchStoreList(map);
    	
    	model.addAttribute("keyword", keyword);
    	model.addAttribute("storeMap", storeMap);
    	
    	return "main/main-search";
    }
    
    // 업체 전체 검색
    @RequestMapping("/main/search/store.do")
    public String mainSearchStore(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	return "main/main-search-store";
    }
    
    // 상품 전체 검색
    @RequestMapping("/main/search/product.do")
    public String mainSearchProduct(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	return "main/main-search-product";
    }
    
    // 커뮤니티 전체 검색
    @RequestMapping("/main/search/board.do")
    public String mainSearchBoard(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	return "main/main-search-board";
    }
    
    // 챗봇
    @RequestMapping("/gemini/test.do")
	public String gemini(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return "main/gemini-chat";
	}
    
    // 메인페이지 리스트
    @RequestMapping(value = "/getMainBasicList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getMainBasicList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getMainBasicList(map);
 
		return new Gson().toJson(resultMap);
	}
    
    // 통합 검색 업체
    @RequestMapping(value = "/getSearchStoreList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSearchStoreList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	resultMap = mainService.getSearchStoreList(map);

    	return new Gson().toJson(resultMap);
    }
    
    // 업체 개수
    @RequestMapping(value = "/getSearchStoreCount.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSearchStoreCount(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	resultMap = mainService.getSearchStoreCount(map);

    	return new Gson().toJson(resultMap);
    }
    
    // 통합 검색 상품
    @RequestMapping(value = "/getSearchProductList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSearchProductList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	resultMap = mainService.getSearchProductList(map);

    	return new Gson().toJson(resultMap);
    }
    
    // 상품 개수
    @RequestMapping(value = "/getSearchProductCount.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSearchProductCount(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	resultMap = mainService.getSearchProductCount(map);

    	return new Gson().toJson(resultMap);
    }
    
    // 통합 검색 커뮤니티
    @RequestMapping(value = "/getSearchBoardList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSearchBoardList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	resultMap = mainService.getSearchBoardList(map);

    	return new Gson().toJson(resultMap);
    }
    
    // 커뮤니티 개수
    @RequestMapping(value = "/getSearchBoardCount.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSearchBoardCount(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	resultMap = mainService.getSearchBoardCount(map);

    	return new Gson().toJson(resultMap);
    }

}