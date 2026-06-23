package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.ProductMapper;
import com.example.unipet.model.Product;

@Service
public class ProductService {

	@Autowired
	ProductMapper productMapper;

	// 조회 -> get, 수정 -> update, 삽입 -> add, 삭제 -> remove
	// ex) 상품목록 : getProductList, 장바구니수정 -> updateCartQty

	// === Mapper 호출 시 ===
	// 여러개 리턴 -> selectXXXList
	// List<Product> list = productMapper.selectProductList(map);
	// 한개 리턴 -> selectXXX
	// Product info = productMapper.selectProductDetail(map);
	// 수정, 삭제, 삽입 -> updateXXX, deleteXXX, insertXXX
	// int result = productMapper.updateCartQty(map);

	public HashMap<String, Object> getCategoryList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Product> animalMainList = productMapper.selectAnimalMainList(map);
			List<Product> animalSubList = productMapper.selectAnimalSubList(map);
			List<Product> itemMainList = productMapper.selectItemMainList(map);
			List<Product> itemSubList = productMapper.selectItemSubList(map);

			resultMap.put("animalMainList", animalMainList);
			resultMap.put("animalSubList", animalSubList);
			resultMap.put("itemMainList", itemMainList);
			resultMap.put("itemSubList", itemSubList);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Product> list = productMapper.selectProductList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getProductView(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			Product product = productMapper.selectProductView(map);
			List<Product> fileList = productMapper.selectProductFileList(map);

			resultMap.put("product", product);
			resultMap.put("fileList", fileList);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getProductDetail(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			Product product = productMapper.selectProductDetail(map);
			List<Product> imageList = productMapper.selectProductImageList(map);
			List<Product> detailImageList = productMapper.selectProductDetailImageList(map);

			resultMap.put("product", product);
			resultMap.put("imageList", imageList);
			resultMap.put("detailImageList", detailImageList);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getProductWishInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			int wishCount = productMapper.selectProductWishCount(map);
			int myWishCount = 0;

			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (!userId.equals("")) {
				myWishCount = productMapper.selectMyProductWish(map);
			}

			resultMap.put("result", "success");
			resultMap.put("wishYn", myWishCount > 0 ? "Y" : "N");
			resultMap.put("wishCount", wishCount);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getProductWishList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (userId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			List<Product> list = productMapper.selectProductWishList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> toggleProductWish(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (userId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			if (map.get("productNo") == null || map.get("productNo").toString().equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "상품 번호가 없습니다.");
				return resultMap;
			}

			int myWishCount = productMapper.selectMyProductWish(map);

			if (myWishCount > 0) {
				productMapper.deleteProductWish(map);
				resultMap.put("wishYn", "N");
				resultMap.put("message", "찜한 상품에서 삭제되었습니다.");
			} else {
				productMapper.insertProductWish(map);
				resultMap.put("wishYn", "Y");
				resultMap.put("message", "찜한 상품에 추가되었습니다.");
			}

			int wishCount = productMapper.selectProductWishCount(map);

			resultMap.put("result", "success");
			resultMap.put("wishCount", wishCount);

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Product> list = productMapper.selectReviewList(map);
			Product summary = productMapper.selectReviewSummary(map);

			resultMap.put("list", list);
			resultMap.put("summary", summary);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getQnaList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			List<Product> list = productMapper.selectQnaList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> addQna(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (userId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			int result = productMapper.insertQna(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "상품문의가 등록되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "상품문의 등록 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> addCart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (userId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			Product cartInfo = productMapper.selectCartOne(map);

			int result = 0;
			Product cartResult = null;

			if (cartInfo == null) {
				result = productMapper.insertCart(map);
				cartResult = productMapper.selectCartOne(map);
			} else {
				result = productMapper.updateCartPlusQty(map);
				cartResult = productMapper.selectCartOne(map);
			}

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "장바구니에 담았습니다.");

				if (cartResult != null) {
					resultMap.put("cartNo", cartResult.getCartNo());
				}

			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "장바구니 담기 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (userId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			List<Product> list = productMapper.selectCartList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> updateCartQty(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (userId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			int result = productMapper.updateCartQty(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "수량이 변경되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "수량 변경 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> removeCart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (userId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			int result = productMapper.deleteCart(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "장바구니에서 삭제되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "장바구니 삭제 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> getCartCount(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String userId = map.get("userId") == null ? "" : map.get("userId").toString();

			if (userId.equals("")) {
				resultMap.put("cartCount", 0);
				resultMap.put("result", "success");
				return resultMap;
			}

			int count = productMapper.selectCartCount(map);

			resultMap.put("cartCount", count);
			resultMap.put("result", "success");

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> updateQna(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String loginUserId = map.get("userId") == null ? "" : map.get("userId").toString();
			String loginUserRole = map.get("userRole") == null ? "" : map.get("userRole").toString();

			if (loginUserId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			Product qnaInfo = productMapper.selectQnaOne(map);

			if (qnaInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 문의입니다.");
				return resultMap;
			}

			String writerId = qnaInfo.getUserId() == null ? "" : qnaInfo.getUserId();

			if (!loginUserId.equals(writerId) && !"A".equals(loginUserRole)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "수정 권한이 없습니다.");
				return resultMap;
			}

			int result = productMapper.updateQna(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "문의가 수정되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "문의 수정 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	public HashMap<String, Object> deleteQna(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String loginUserId = map.get("userId") == null ? "" : map.get("userId").toString();
			String loginUserRole = map.get("userRole") == null ? "" : map.get("userRole").toString();

			if (loginUserId.equals("")) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			Product qnaInfo = productMapper.selectQnaOne(map);

			if (qnaInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 문의입니다.");
				return resultMap;
			}

			String writerId = qnaInfo.getUserId() == null ? "" : qnaInfo.getUserId();

			if (!loginUserId.equals(writerId) && !"A".equals(loginUserRole)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "삭제 권한이 없습니다.");
				return resultMap;
			}

			int result = productMapper.deleteQna(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "문의가 삭제되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "문의 삭제 실패");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	// 상품리뷰 수정 - 작성자만 가능, 관리자는 수정 불가
	public HashMap<String, Object> updateReview(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
			String sessionRole = map.get("sessionRole") == null ? "" : map.get("sessionRole").toString();
			String adminId = map.get("adminId") == null ? "" : map.get("adminId").toString();

			boolean isAdmin = "A".equals(sessionRole) || "ADMIN".equals(sessionRole) || "admin".equals(sessionId)
					|| !adminId.equals("");

			if (sessionId.equals("") && !isAdmin) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			if (isAdmin) {
				resultMap.put("result", "fail");
				resultMap.put("message", "관리자는 리뷰 수정이 불가능합니다.");
				return resultMap;
			}

			if (map.get("reviewNo") == null || map.get("reviewNo").equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "리뷰 번호가 없습니다.");
				return resultMap;
			}

			String contents = "";

			if (map.get("contents") != null) {
				contents = map.get("contents").toString();
			} else if (map.get("reviewContents") != null) {
				contents = map.get("reviewContents").toString();
			}

			if (contents.trim().equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "리뷰 내용을 입력해주세요.");
				return resultMap;
			}

			map.put("contents", contents);
			map.put("reviewContents", contents);

			Product reviewInfo = productMapper.selectReviewOne(map);

			if (reviewInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 리뷰입니다.");
				return resultMap;
			}

			String writerId = reviewInfo.getUserId() == null ? "" : reviewInfo.getUserId();

			if (!sessionId.equals(writerId)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "리뷰 수정 권한이 없습니다.");
				return resultMap;
			}

			int result = productMapper.updateReview(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "리뷰가 수정되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "리뷰 수정에 실패했습니다.");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

	// 상품리뷰 삭제 - 작성자 또는 관리자 가능
	public HashMap<String, Object> deleteReview(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			String sessionId = map.get("sessionId") == null ? "" : map.get("sessionId").toString();
			String sessionRole = map.get("sessionRole") == null ? "" : map.get("sessionRole").toString();
			String adminId = map.get("adminId") == null ? "" : map.get("adminId").toString();

			boolean isAdmin = "A".equals(sessionRole) || "ADMIN".equals(sessionRole) || "admin".equals(sessionId)
					|| !adminId.equals("");

			if (sessionId.equals("") && !isAdmin) {
				resultMap.put("result", "login");
				resultMap.put("message", "로그인이 필요합니다.");
				return resultMap;
			}

			if (map.get("reviewNo") == null || map.get("reviewNo").equals("")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "리뷰 번호가 없습니다.");
				return resultMap;
			}

			Product reviewInfo = productMapper.selectReviewOne(map);

			if (reviewInfo == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "존재하지 않는 리뷰입니다.");
				return resultMap;
			}

			String writerId = reviewInfo.getUserId() == null ? "" : reviewInfo.getUserId();

			if (!isAdmin && !sessionId.equals(writerId)) {
				resultMap.put("result", "fail");
				resultMap.put("message", "리뷰 삭제 권한이 없습니다.");
				return resultMap;
			}

			int result = productMapper.deleteReview(map);

			if (result > 0) {
				resultMap.put("result", "success");
				resultMap.put("message", "리뷰가 삭제되었습니다.");
			} else {
				resultMap.put("result", "fail");
				resultMap.put("message", "리뷰 삭제에 실패했습니다.");
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}

		return resultMap;
	}

}