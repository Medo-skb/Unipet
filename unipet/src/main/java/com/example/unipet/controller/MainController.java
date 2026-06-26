package com.example.unipet.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.AiRecommendService;
import com.example.unipet.dao.MainService;
import com.example.unipet.model.AiRecommend;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class MainController {

	@Autowired 
    MainService mainService;
	
	@Autowired
    private AiRecommendService aiRecommendService;

	// 메인페이지
    @RequestMapping("/main.do")
	public String main(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return "main/main";
	}
    
    // 유치원 보내주개 배너
    @RequestMapping("/main/kindergarten.do")
	public String kindergarten(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return "main/kindergarten";
	}
    
    // 이용 약관
    @RequestMapping("/main/terms.do")
	public String terms(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return "main/terms";
	}
    
    // 개인정보 처리방침
    @RequestMapping("/main/privacy.do")
	public String privacy(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return "main/privacy";
	}
    
    // 회사소개
    @RequestMapping("/main/about.do")
	public String about(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return "main/about";
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
    public String searchStore(@RequestParam HashMap<String, Object> map, Model model) {
        model.addAttribute("keyword", map.get("keyword"));
        model.addAttribute("sCategory", map.get("sCategory"));
        return "main/main-search-store";
    }
    
    // 상품 전체 검색
    @RequestMapping("/main/search/product.do")
    public String mainSearchProduct(Model model, @RequestParam HashMap<String, Object> map) {
        model.addAttribute("keyword", map.get("keyword"));
        return "/main/main-search-product";
    }
    
    // 고객센터 기본 진입
    @RequestMapping("/unipet/customer.do")
    public String customer(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        return "redirect:/unipet/customer/inquiry.do";
    }

    // 고객센터 - 홈페이지 문의
    @RequestMapping("/unipet/customer/inquiry.do")
    public String customerInquiry(
            HttpServletRequest request,
            Model model,
            @RequestParam HashMap<String, Object> map,
            HttpSession session
    ) throws Exception {

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || userId.equals("")) {
            return "redirect:/user/login.do";
        }

        return "main/customer/customer-inquiry";
    }

    // 고객센터 - 문의 내역
    @RequestMapping("/unipet/customer/history.do")
    public String customerHistory(
            HttpServletRequest request,
            Model model,
            @RequestParam HashMap<String, Object> map,
            HttpSession session
    ) throws Exception {

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || userId.equals("")) {
            return "redirect:/user/login.do";
        }

        return "main/customer/customer-history";
    }

    // 챗봇
    @RequestMapping("/unipet/chatbot.do")
    public String gemini(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        return "main/gemini-chat";
    }

    // 홈페이지 문의 등록
    @RequestMapping(value = "/unipet/customer/inquiry/insert.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String insertUnipetQna(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || userId.equals("")) {
            resultMap.put("result", "notLogin");
            resultMap.put("message", "로그인 후 문의할 수 있습니다.");
            return new Gson().toJson(resultMap);
        }

        map.put("userId", userId);

        resultMap = mainService.insertUnipetQna(map);

        return new Gson().toJson(resultMap);
    }

    // 홈페이지 문의 내역 조회
    @RequestMapping(value = "/unipet/customer/history/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getUnipetQnaList(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null || userId.equals("")) {
            resultMap.put("result", "notLogin");
            resultMap.put("message", "로그인 후 확인할 수 있습니다.");
            return new Gson().toJson(resultMap);
        }

        map.put("userId", userId);

        resultMap = mainService.getUnipetQnaList(map);

        return new Gson().toJson(resultMap);
    }
    
    // 메인페이지 리스트
    @RequestMapping(value = "/getMainBasicList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getMainBasicList(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();

    	map.put("sessionId", session.getAttribute("sessionId"));

    	resultMap = mainService.getMainBasicList(map);

    	return new Gson().toJson(resultMap);
    }
    
    // 소셜 로그인 기본정보 입력 여부 체크
    @RequestMapping(value = "/main/social-basic-check.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String socialBasicCheck(HttpSession session) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        String userId = (String) session.getAttribute("sessionId");

        if (userId == null) {
            resultMap.put("result", "notLogin");
            return new Gson().toJson(resultMap);
        }

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);

        resultMap = mainService.socialBasicCheck(map);

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
    
    // 유치원 보내주개
    @RequestMapping(value = "/main/kindergarten.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getKindergartenStoreList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mainService.getKindergartenStoreList(map);
 
		return new Gson().toJson(resultMap);
	}
    
    // AI 맞춤 추천 데이터 가져오기
    @RequestMapping(value = "/getAiRecommendation.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getAiRecommendation(HttpSession session) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        
        String userId = (String) session.getAttribute("sessionId");
        
        if (userId == null) {
            resultMap.put("result", "fail");
            return new Gson().toJson(resultMap);
        }

        try {
            HashMap<String, Object> enrichedData = aiRecommendService.getEnrichedAiRecommendation(userId);
            
            if (enrichedData != null) {
                resultMap.putAll(enrichedData);
                resultMap.put("result", "success");
            } else {
                resultMap.put("result", "empty");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("result", "error");
        }
        
        return new Gson().toJson(resultMap);
    }
    
    

}