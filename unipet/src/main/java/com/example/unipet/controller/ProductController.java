package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.example.unipet.dao.ProductService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ProductController {

	@Autowired
	ProductService productService;

	@RequestMapping("/product.do")
	public String product() {
		return "/product/product";
	}

	@RequestMapping("/product/view.do")
	public String view(HttpServletRequest request, @RequestParam HashMap<String, Object> map) {

		System.out.println("productNo = " + map.get("productNo")); // 확인용

		request.setAttribute("productNo", map.get("productNo"));  // 🔥 이거 추가

		return "/product/productView";
	}

	@RequestMapping("/cart.do")
	public String cart() {
		return "/product/cart";
	}

	@RequestMapping(value = "/productCategory.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productCategory(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getCategoryList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/productList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String productList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getProductList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/product/detail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String detail(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getProductDetail(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/review/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getReviewList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/qna/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String qnaList(@RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = productService.getQnaList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/qna/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addQna(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", userId);

		HashMap<String, Object> resultMap = productService.addQna(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/cart/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addCart(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", userId);

		HashMap<String, Object> resultMap = productService.addCart(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/cart/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartList(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", userId);

		HashMap<String, Object> resultMap = productService.getCartList(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/cart/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartUpdate(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", userId);

		HashMap<String, Object> resultMap = productService.updateCartQty(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/cart/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartRemove(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", userId);

		HashMap<String, Object> resultMap = productService.removeCart(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/cart/count.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String cartCount(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = (String) session.getAttribute("sessionId");

		if (userId == null) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "success");
			resultMap.put("cartCount", 0);
			return new Gson().toJson(resultMap);
		}

		map.put("userId", userId);

		HashMap<String, Object> resultMap = productService.getCartCount(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/qna/update.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateQna(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = (String) session.getAttribute("sessionId");
		String userRole = (String) session.getAttribute("sessionRole");

		if (userId == null) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", userId);
		map.put("userRole", userRole);

		HashMap<String, Object> resultMap = productService.updateQna(map);
		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/qna/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deleteQna(HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
		String userId = (String) session.getAttribute("sessionId");
		String userRole = (String) session.getAttribute("sessionRole");

		if (userId == null) {
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("result", "login");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("userId", userId);
		map.put("userRole", userRole);

		HashMap<String, Object> resultMap = productService.deleteQna(map);
		return new Gson().toJson(resultMap);
	}
}