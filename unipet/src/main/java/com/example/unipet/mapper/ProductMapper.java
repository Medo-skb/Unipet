package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Product;

@Mapper
public interface ProductMapper {

	// 여러개 리턴 -> selectXXXList
	public List<Product> selectAnimalMainList(HashMap<String, Object> map);

	public List<Product> selectAnimalSubList(HashMap<String, Object> map);

	public List<Product> selectItemMainList(HashMap<String, Object> map);

	public List<Product> selectItemSubList(HashMap<String, Object> map);

	public List<Product> selectProductList(HashMap<String, Object> map);

	public List<Product> selectProductFileList(HashMap<String, Object> map);

	public List<Product> selectProductImageList(HashMap<String, Object> map);

	public List<Product> selectProductDetailImageList(HashMap<String, Object> map);

	public List<Product> selectReviewList(HashMap<String, Object> map);

	public List<Product> selectQnaList(HashMap<String, Object> map);

	public List<Product> selectCartList(HashMap<String, Object> map);

	// 한개 리턴 -> selectXXX
	public Product selectProductView(HashMap<String, Object> map);

	public Product selectProductDetail(HashMap<String, Object> map);

	public Product selectReviewSummary(HashMap<String, Object> map);

	public Product selectQnaOne(HashMap<String, Object> map);

	public Product selectCartOne(HashMap<String, Object> map);

	public int selectCartCount(HashMap<String, Object> map);

	// 기존 신고 관련 메서드
	// 지금은 화면에서 삭제로 바꿨기 때문에 사용하지 않지만,
	// 기존 XML과 충돌 안 나게 남겨둠
	public Product selectReviewReportCheck(HashMap<String, Object> map);

	public int insertReviewReport(HashMap<String, Object> map);

	// 삭제
	public int deleteQna(HashMap<String, Object> map);

	public int deleteCart(HashMap<String, Object> map);

	// 상품리뷰 삭제
	public int deleteReview(HashMap<String, Object> map);

	// 수정
	public int updateQna(HashMap<String, Object> map);

	public int updateCartPlusQty(HashMap<String, Object> map);

	public int updateCartQty(HashMap<String, Object> map);

	// 삽입
	public int insertQna(HashMap<String, Object> map);

	public int insertCart(HashMap<String, Object> map);

}