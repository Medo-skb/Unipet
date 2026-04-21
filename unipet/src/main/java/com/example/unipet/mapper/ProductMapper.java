package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductMapper {

	// ===== 카테고리 =====
	public List<HashMap<String, Object>> selectAnimalMainList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectAnimalSubList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectItemMainList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectItemSubList(HashMap<String, Object> map);

	// ===== 상품 =====
	public List<HashMap<String, Object>> selectProductList(HashMap<String, Object> map);

	public HashMap<String, Object> selectProductView(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectProductFileList(HashMap<String, Object> map);

	// ===== 상세 =====
	public HashMap<String, Object> selectProductDetail(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectProductImageList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectProductDetailImageList(HashMap<String, Object> map);

	// ===== 리뷰 =====
	public List<HashMap<String, Object>> selectReviewList(HashMap<String, Object> map);

	public HashMap<String, Object> selectReviewSummary(HashMap<String, Object> map);

	// ===== QNA =====
	public List<HashMap<String, Object>> selectQnaList(HashMap<String, Object> map);

	public int insertQna(HashMap<String, Object> map);

	// ===== 장바구니 =====
	public int insertCart(HashMap<String, Object> map);

	public HashMap<String, Object> selectCartOne(HashMap<String, Object> map);

	public int updateCartPlusQty(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectCartList(HashMap<String, Object> map);

	public int updateCartQty(HashMap<String, Object> map);

	public int deleteCart(HashMap<String, Object> map);

	public int selectCartCount(HashMap<String, Object> map);
}