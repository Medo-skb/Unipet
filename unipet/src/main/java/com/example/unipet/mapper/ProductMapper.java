package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductMapper {

		// 동물 카테고리
		public List<HashMap<String, Object>> selectAnimalMainList(HashMap<String, Object> map);
		public List<HashMap<String, Object>> selectAnimalSubList(HashMap<String, Object> map);

		// 상품 카테고리
		public List<HashMap<String, Object>> selectItemMainList(HashMap<String, Object> map);
		public List<HashMap<String, Object>> selectItemSubList(HashMap<String, Object> map);

		// 상품
		public List<HashMap<String, Object>> selectProductList(HashMap<String, Object> map);
		public HashMap<String, Object> selectProduct(HashMap<String, Object> map);
		public List<HashMap<String, Object>> selectProductFile(HashMap<String, Object> map);
	}