package com.example.unipet.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.ProductMapper;

@Service
public class ProductService {

	@Autowired
	ProductMapper productMapper;

	public Map<String, Object> getProductList(HashMap<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        // Mapper에서 받아온 리스트를 담음
        resultMap.put("list", productMapper.selectProductList(map));
        resultMap.put("result", "success");
        return resultMap;
    }

    public Map<String, Object> getCategoryData() {
        List<Map<String, Object>> rawList = productMapper.selectCategoryList();
        Map<String, Object> result = new HashMap<>();
        
        Map<String, List<Map<String, Object>>> animalMap = new LinkedHashMap<>();
        Map<String, List<Map<String, Object>>> productMap = new LinkedHashMap<>();

        if (rawList != null) {
            for (Map<String, Object> row : rawList) {
                String catType = String.valueOf(row.get("CAT_TYPE"));
                String mainName = String.valueOf(row.get("MAIN_NAME"));
                
                Map<String, Object> subInfo = new HashMap<>();
                subInfo.put("subName", row.get("SUB_NAME"));
                subInfo.put("subNo", row.get("SUB_NO"));

                if ("ANIMAL".equals(catType)) {
                    animalMap.computeIfAbsent(mainName, k -> new ArrayList<>()).add(subInfo);
                } else {
                    productMap.computeIfAbsent(mainName, k -> new ArrayList<>()).add(subInfo);
                }
            }
        }
        
        result.put("animalMap", animalMap);
        result.put("productMap", productMap);
        return result;
    }
}