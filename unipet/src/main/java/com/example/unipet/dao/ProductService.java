package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.ProductMapper;

@Service
public class ProductService {

	@Autowired
	ProductMapper productMapper;

	// 카테고리
	public HashMap<String, Object> getCategoryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("animalMainList", productMapper.selectAnimalMainList(map));
			resultMap.put("animalSubList", productMapper.selectAnimalSubList(map));
			resultMap.put("itemMainList", productMapper.selectItemMainList(map));
			resultMap.put("itemSubList", productMapper.selectItemSubList(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 상품 리스트
	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("list", productMapper.selectProductList(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 상품 상세 (기본)
	public HashMap<String, Object> getProductView(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("product", productMapper.selectProductView(map));
			resultMap.put("fileList", productMapper.selectProductFileList(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 🔥 상세 (이미지 포함)
	public HashMap<String, Object> getProductDetail(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			resultMap.put("product", productMapper.selectProductDetail(map));
			resultMap.put("imageList", productMapper.selectProductImageList(map));
			resultMap.put("detailImageList", productMapper.selectProductDetailImageList(map));

			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 리뷰
	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			resultMap.put("list", productMapper.selectReviewList(map));
			resultMap.put("summary", productMapper.selectReviewSummary(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// QNA
	public HashMap<String, Object> getQnaList(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			resultMap.put("list", productMapper.selectQnaList(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// QNA 등록
	public HashMap<String, Object> addQna(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			int cnt = productMapper.insertQna(map);
			resultMap.put("result", cnt > 0 ? "success" : "fail");
		} catch (Exception e) {
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 장바구니 담기
	public HashMap<String, Object> addCart(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			HashMap<String, Object> cartInfo = productMapper.selectCartOne(map);

			int result = 0;
			HashMap<String, Object> cartResult = null;

			if (cartInfo == null) {
				result = productMapper.insertCart(map);
				cartResult = productMapper.selectCartOne(map);
			} else {
				result = productMapper.updateCartPlusQty(map);
				cartResult = productMapper.selectCartOne(map);
			}

			if (result > 0) {
				resultMap.put("result", "success");

				if (cartResult != null) {
					resultMap.put("cartNo", cartResult.get("CART_NO"));
				}
			} else {
				resultMap.put("result", "fail");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 장바구니 리스트
	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			resultMap.put("list", productMapper.selectCartList(map));
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 수량 변경
	public HashMap<String, Object> updateCartQty(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			int result = productMapper.updateCartQty(map);
			resultMap.put("result", result > 0 ? "success" : "fail");
		} catch (Exception e) {
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 삭제
	public HashMap<String, Object> removeCart(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			int result = productMapper.deleteCart(map);
			resultMap.put("result", result > 0 ? "success" : "fail");
		} catch (Exception e) {
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	// 개수
	public HashMap<String, Object> getCartCount(HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			int count = productMapper.selectCartCount(map);

			resultMap.put("cartCount", count);
			resultMap.put("result", "success");
		} catch (Exception e) {
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	public HashMap<String, Object> updateQna(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			HashMap<String, Object> qnaInfo = productMapper.selectQnaOne(map);

			if (qnaInfo == null) {
				resultMap.put("result", "fail");
				return resultMap;
			}

			String loginUserId = String.valueOf(map.get("userId"));
			String loginUserRole = map.get("userRole") == null ? "" : String.valueOf(map.get("userRole"));
			String writerId = String.valueOf(qnaInfo.get("USER_ID"));

			if (!loginUserId.equals(writerId) && !"A".equals(loginUserRole)) {
				resultMap.put("result", "fail");
				return resultMap;
			}

			int cnt = productMapper.updateQna(map);
			resultMap.put("result", cnt > 0 ? "success" : "fail");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
		}

		return resultMap;
	}

	public HashMap<String, Object> deleteQna(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			HashMap<String, Object> qnaInfo = productMapper.selectQnaOne(map);

			if (qnaInfo == null) {
				resultMap.put("result", "fail");
				return resultMap;
			}

			String loginUserId = String.valueOf(map.get("userId"));
			String loginUserRole = map.get("userRole") == null ? "" : String.valueOf(map.get("userRole"));
			String writerId = String.valueOf(qnaInfo.get("USER_ID"));

			if (!loginUserId.equals(writerId) && !"A".equals(loginUserRole)) {
				resultMap.put("result", "fail");
				return resultMap;
			}

			int cnt = productMapper.deleteQna(map);
			resultMap.put("result", cnt > 0 ? "success" : "fail");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
		}

		return resultMap;
	}
}