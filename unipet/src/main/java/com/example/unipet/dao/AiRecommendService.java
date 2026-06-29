package com.example.unipet.dao;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.AiRecommendMapper;
import com.example.unipet.model.AiRecommend;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;

@Service
public class AiRecommendService {

    @Autowired
    private AiRecommendMapper aiRecommendMapper;
    
    @Autowired
    private GeminiService geminiService; 

    public void processAllUserRecommendations() {
        Gson gson = new Gson();

        try {
            // 🎯 테스트용 특정 유저 지정
            List<String> userList = Arrays.asList("test_user01", "test_user02", "data1", "data2");
//            List<String> userList = Arrays.asList("test_user01");

            System.out.println("총 " + userList.size() + "명의 테스트 유저를 대상으로 AI 추천을 시작합니다.");
            
            List<HashMap<String, Object>> productCandidates = aiRecommendMapper.selectTopProductList();
            String productJson = gson.toJson(productCandidates);
            
            // 2. 유저별 반복 작업 시작
            for (String userId : userList) {
                try {
                    HashMap<String, Object> userData = aiRecommendMapper.getUserHistory(userId);
                    if (userData == null || userData.isEmpty()) continue;
                    
                    String fullAddress = (String) userData.get("userAddr");
                    String searchRegion = ""; 
                    if (fullAddress != null && !fullAddress.trim().isEmpty()) {
                        String[] addrParts = fullAddress.split(" ");
                        if (addrParts.length >= 2) {
                            searchRegion = addrParts[0] + " " + addrParts[1];
                        } else {
                            searchRegion = addrParts[0]; 
                        }
                    }

                    List<HashMap<String, Object>> storeCandidates = aiRecommendMapper.selectTopStoreList(searchRegion);
                    String storeJson = gson.toJson(storeCandidates);
                    String userJson = gson.toJson(userData);

                    String prompt = "너는 반려동물 맞춤형 큐레이터야. 아래 제공된 [사용자 데이터]를 분석하고, [추천 후보군 리스트] 안에서 "
                            + "가장 적합한 예약 업체와 쇼핑 상품을 각각 최대 4개씩(1~4개) 골라줘.\n"
                            + "⚠️ [중요] 반드시 [추천 후보군 리스트] 안에 존재하는 데이터만 사용해야 해. 후보군에 없는 가짜 번호(productNo, storeNo)를 지어내면 절대 안 돼!\n\n"
                            + "[사용자 데이터]\n" + userJson + "\n\n"
                            + "[추천 후보군 리스트]\n"
                            + "- 예약 업체 후보:\n" + storeJson + "\n"
                            + "- 쇼핑 상품 후보:\n" + productJson + "\n\n"
                            + "⚠️ [응답 작성 규칙 - 글자 끊김 방지를 위해 아주 엄격히 준수할 것]\n"
                            + "1. 오직 중괄호 { 로 시작하고 } 로 끝나는 순수 JSON 텍스트만 출력해. 마크다운(```json), 앞뒤 설명, 주석, 줄바꿈은 절대 금지야.\n"
                            + "2. 이름(name)이나 타입(type) 같은 텍스트는 전부 빼고, 오직 'storeNo'와 'productNo' 숫자 번호만 담아줘.\n"
                            + "3. 반드시 아래의 [출력 포맷 예시] 구조를 똑같이 지켜서 응답해줘. (후보가 부족하면 2~3개만 넣어도 됨)\n\n"
                            + "[출력 포맷 예시]\n"
                            + "{\"services\": [{\"storeNo\": 1}, {\"storeNo\": 2}, {\"storeNo\": 3}, {\"storeNo\": 4}], "
                            + "\"products\": [{\"productNo\": 10}, {\"productNo\": 11}, {\"productNo\": 12}, {\"productNo\": 13}]}";

                    String aiResponse = geminiService.callGeminiForRecommend(prompt);
                    aiResponse = aiResponse.replace("```json", "").replace("```", "").trim();
                    
                    if (!aiResponse.startsWith("{")) {
                        System.out.println("유저 [" + userId + "] API 응답 오류 또는 한도 초과로 건너뜁니다: " + aiResponse);
                        continue; 
                    }
                    
                    JsonObject jsonObject = JsonParser.parseString(aiResponse).getAsJsonObject();
                    String recServices = jsonObject.getAsJsonArray("services").toString();
                    String recProducts = jsonObject.getAsJsonArray("products").toString();

                    AiRecommend recommendObj = new AiRecommend();
                    recommendObj.setUserId(userId);
                    recommendObj.setRecServices(recServices);
                    recommendObj.setRecProducts(recProducts);

                    int existCount = aiRecommendMapper.checkRecommendationExist(userId);

                    if (existCount == 0) {
                        aiRecommendMapper.insertRecommendation(recommendObj);
                        System.out.println("유저 [" + userId + "] 님 최초 AI 추천 데이터 INSERT 완료");
                    } else {
                        aiRecommendMapper.updateRecommendation(recommendObj);
                        System.out.println("유저 [" + userId + "] 님 기존 AI 추천 데이터 UPDATE 완료");
                    }

                } catch (Exception e) {
                    System.out.println("유저 [" + userId + "] 추천 에러: " + e.getMessage());
                } finally {
                    System.out.println("⏳ 유저 [" + userId + "] 처리 완료. 한도 초과 방지를 위해 30초 대기합니다...");
                    try {
                        Thread.sleep(30000);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public AiRecommend getRecommendationByUserId(String userId) throws Exception {
        return aiRecommendMapper.getRecommendationByUserId(userId);
    }
    
    public HashMap<String, Object> getEnrichedAiRecommendation(String userId) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<>();
        
        AiRecommend aiData = aiRecommendMapper.getRecommendationByUserId(userId);
        if (aiData == null) {
            return null;
        }

        Gson gson = new Gson();
        List<Map<String, Object>> serviceList = gson.fromJson(aiData.getRecServices(), new TypeToken<List<Map<String, Object>>>(){}.getType());
        List<Map<String, Object>> productList = gson.fromJson(aiData.getRecProducts(), new TypeToken<List<Map<String, Object>>>(){}.getType());
        
        List<Integer> storeNoList = new ArrayList<>();
        for (Map<String, Object> svc : serviceList) {
            if (svc.get("storeNo") != null) {
                storeNoList.add(((Number) svc.get("storeNo")).intValue());
            }
        }
        
        if (!storeNoList.isEmpty()) {
            List<HashMap<String, Object>> storeDetails = aiRecommendMapper.selectStoreDetailsForAi(storeNoList);
            
            for (Map<String, Object> svc : serviceList) {
                int sNo = ((Number) svc.get("storeNo")).intValue();
                
                for (HashMap<String, Object> detail : storeDetails) {
                    int dNo = ((Number) detail.get("storeNo")).intValue();
                    if (sNo == dNo) {
                    	svc.put("storeName", detail.get("storeName"));
                    	svc.put("filePath", detail.get("filePath"));
                        svc.put("fileName", detail.get("fileName"));
                        svc.put("sAddr", detail.get("sAddr"));
                        svc.put("subTitle", detail.get("subTitle"));
                        svc.put("sCategoryName", detail.get("sCategoryName"));
                        break;
                    }
                }
            }
            
            List<Integer> productNoList = new ArrayList<>();
            for (Map<String, Object> prod : productList) {
                if (prod.get("productNo") != null) {
                    productNoList.add(((Number) prod.get("productNo")).intValue());
                }
            }
            
            if (!productNoList.isEmpty()) {
                List<HashMap<String, Object>> productDetails = aiRecommendMapper.selectProductDetailsForAi(productNoList);
                                
                for (Map<String, Object> prod : productList) {
                    int pNo = ((Number) prod.get("productNo")).intValue();
                    
                    for (HashMap<String, Object> detail : productDetails) {
                        int dNo = ((Number) detail.get("productNo")).intValue();
                        if (pNo == dNo) {
                        	prod.put("productName", detail.get("productName"));
                        	prod.put("productPrice", detail.get("productPrice"));
                        	prod.put("filePath", detail.get("filePath"));
                            prod.put("fileName", detail.get("fileName"));
                            break;
                        }
                    }
                }
            }
        }

        resultMap.put("aiServices", serviceList);
        resultMap.put("aiProducts", productList);
        
        return resultMap;
    }
}