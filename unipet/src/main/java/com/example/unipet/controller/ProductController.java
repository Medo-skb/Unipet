package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.example.unipet.dao.ProductService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProductController {

	@Autowired
	ProductService productService;

	// 상품 리스트 페이지
	@RequestMapping("/product.do")
	public String product() {
		return "/product/product";
	}

	// 상품 상세 페이지
	@RequestMapping("/product/view.do")
	public String productView(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {
		request.setAttribute("productNo", map.get("productNo"));
		return "/product/productView";
	}

	// 장바구니 페이지
	@RequestMapping("/cart.do")
	public String cart() {
		return "/product/cart";
	}

	// 카테고리
	@RequestMapping(value = "/productCategory.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productCategory(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getCategoryList(map);
		return new Gson().toJson(resultMap);
	}

	// 상품 리스트
	@RequestMapping(value = "/productList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getProductList(map);
		return new Gson().toJson(resultMap);
	}

	// 🔥 상세 + 이미지 + 기타
	@RequestMapping(value = "/product/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String detail(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getProductDetail(map);
		return new Gson().toJson(resultMap);
	}

	// 리뷰 목록
	@RequestMapping(value = "/review/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getReviewList(map);
		return new Gson().toJson(resultMap);
	}

	// QNA 목록
	@RequestMapping(value = "/qna/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getQnaList(map);
		return new Gson().toJson(resultMap);
	}

	// QNA 등록
	@RequestMapping(value = "/qna/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addQna(@RequestParam HashMap<String, Object> map) throws Exception {

		map.put("userId", "test1234"); // 테스트용

		HashMap<String, Object> resultMap = productService.addQna(map);
		return new Gson().toJson(resultMap);
	}

	// 장바구니 담기
	@RequestMapping(value = "/cart/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addCart(@RequestParam HashMap<String, Object> map) throws Exception {

		map.put("userId", "test1234");

		HashMap<String, Object> resultMap = productService.addCart(map);
		return new Gson().toJson(resultMap);
	}

	// 장바구니 리스트 🔥 (아까 빠진거)
	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartList(@RequestParam HashMap<String, Object> map) throws Exception {

		map.put("userId", "test1234");

		HashMap<String, Object> resultMap = productService.getCartList(map);
		return new Gson().toJson(resultMap);
	}

	// 수량 변경
	@RequestMapping(value = "/cart/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartUpdate(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.updateCartQty(map);
		return new Gson().toJson(resultMap);
	}

	// 삭제
	@RequestMapping(value = "/cart/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartRemove(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.removeCart(map);
		return new Gson().toJson(resultMap);
	}

	// 개수
	@RequestMapping(value = "/cart/count.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartCount(@RequestParam HashMap<String, Object> map) throws Exception {

		map.put("userId", "test1234");

		HashMap<String, Object> resultMap = productService.getCartCount(map);
		return new Gson().toJson(resultMap);
	}
}