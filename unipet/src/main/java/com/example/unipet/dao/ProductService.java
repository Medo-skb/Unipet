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

	// 카테고리 조회
	public HashMap<String, Object> getCategoryList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<HashMap<String, Object>> animalMainList = productMapper.selectAnimalMainList(map);
			List<HashMap<String, Object>> animalSubList = productMapper.selectAnimalSubList(map);
			List<HashMap<String, Object>> itemMainList = productMapper.selectItemMainList(map);
			List<HashMap<String, Object>> itemSubList = productMapper.selectItemSubList(map);

			resultMap.put("animalMainList", animalMainList);
			resultMap.put("animalSubList", animalSubList);
			resultMap.put("itemMainList", itemMainList);
			resultMap.put("itemSubList", itemSubList);
			resultMap.put("result", "success");
			resultMap.put("message", "조회 성공");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 상품 목록 조회
	public HashMap<String, Object> getProductList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<HashMap<String, Object>> list = productMapper.selectProductList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", "조회 성공");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}

	// 상품 상세 조회
	public HashMap<String, Object> getProduct(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			HashMap<String, Object> product = productMapper.selectProduct(map);
			List<HashMap<String, Object>> fileList = productMapper.selectProductFile(map);

			resultMap.put("product", product);
			resultMap.put("fileList", fileList);
			resultMap.put("result", "success");
			resultMap.put("message", "조회 성공");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
}