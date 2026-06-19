package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.ProductService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ProductController {

	@Autowired
	ProductService productService;

	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/product.do")
	public String product(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		return "/product/product";
	}

	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/product/view.do")
	public String view(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		request.setAttribute("productNo", map.get("productNo"));
		return "/product/productView";
	}

	// 웹브라우저로 접속하는 주소, return은 jsp파일
	@RequestMapping("/cart.do")
	public String cart(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		return "/product/cart";
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/productCategory.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productCategory(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getCategoryList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/productList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getProductList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/product/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String detail(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getProductDetail(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/review/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getReviewList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/qna/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getQnaList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/qna/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addQna(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");

		map.put("userId", userId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.addQna(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/cart/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addCart(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");

		map.put("userId", userId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.addCart(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");

		map.put("userId", userId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getCartList(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/cart/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartUpdate(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");

		map.put("userId", userId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.updateCartQty(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/cart/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartRemove(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");

		map.put("userId", userId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.removeCart(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/cart/count.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartCount(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");

		map.put("userId", userId);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.getCartCount(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/qna/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateQna(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		String userRole = session.getAttribute("sessionRole") == null ? ""
				: (String) session.getAttribute("sessionRole");

		map.put("userId", userId);
		map.put("userRole", userRole);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.updateQna(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	@RequestMapping(value = "/qna/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteQna(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		String userRole = session.getAttribute("sessionRole") == null ? ""
				: (String) session.getAttribute("sessionRole");

		map.put("userId", userId);
		map.put("userRole", userRole);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.deleteQna(map);

		return new Gson().toJson(resultMap);
	}

	// ajax가 호출하는 주소
	// 상품리뷰 삭제 - 관리자만 가능
	@RequestMapping(value = "/review/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewDelete(@RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
		String sessionId = session.getAttribute("sessionId") == null ? "" : (String) session.getAttribute("sessionId");
		String sessionRole = session.getAttribute("sessionRole") == null ? ""
				: (String) session.getAttribute("sessionRole");

		map.put("sessionId", sessionId);
		map.put("sessionRole", sessionRole);

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = productService.deleteReview(map);

		return new Gson().toJson(resultMap);
	}

}