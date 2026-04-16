package com.example.unipet.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.ProductService;


import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProductController {

	@Autowired
	ProductService productService;

	// [페이지 이동] 쇼핑몰 메인 (shopMain + shopSearch 통합)
	@RequestMapping("/product.do")
	public String main() {
		return "product/product";
	}

	// [데이터 요청] 상품 리스트 가져오기 (AI추천, 필터 검색 포함)
	@RequestMapping(value = "/list.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getList(@RequestBody HashMap<String, Object> map) {
		return productService.getProductList(map);
	}

	@RequestMapping(value = "/category/list.dox", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCategories() {
		return productService.getCategoryData();
	}

	@RequestMapping("/product/view.do")
	public String productView(HttpServletRequest request, Model model) {
		// JSP에서 보낸 productNo를 받아서 model에 담아 상세페이지 JSP로 넘김
		String productNo = request.getParameter("productNo");
		model.addAttribute("productNo", productNo);
		return "/product/productDetail"; // 상세페이지 JSP 파일명
	}
}