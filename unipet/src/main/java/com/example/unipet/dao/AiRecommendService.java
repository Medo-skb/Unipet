package com.example.unipet.dao;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.AiRecommendMapper;
import com.example.unipet.model.AiRecommend;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

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
//            List<String> userList = Arrays.asList("test_user01", "test_user02", "data1", "data2");
            List<String> userList = Arrays.asList("test_user01");

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
                                  + "가장 적합한 예약 업체 2개와 쇼핑 상품 2개를 골라줘.\n"
                                  + "만약 제공된 후보군이 부족하더라도, 펫 정보에 맞춰 일반적인 상품이라도 반드시 2개를 채워서 추천해.\n\n"
                                  + "[사용자 데이터]\n" + userJson + "\n\n"
                                  + "[추천 후보군 리스트]\n"
                                  + "- 예약 업체 후보:\n" + storeJson + "\n"
                                  + "- 쇼핑 상품 후보:\n" + productJson + "\n\n"
                                  + "⚠️ [응답 작성 규칙 - 반드시 지킬 것]\n"
                                  + "1. 오직 중괄호 { 로 시작하고 } 로 끝나는 순수 JSON 텍스트만 출력해. 마크다운(```json)은 절대 금지야.\n"
                                  + "2. JSON 내부에 '이유(reason)' 같은 불필요한 텍스트는 전부 빼고, 오직 번호, 타입, 이름만 남겨.\n"
                                  + "3. 반드시 아래의 JSON 포맷을 똑같이 지켜서 대답해:\n"
                                  + "{\"services\": [{\"storeNo\": 1, \"type\": \"미용실\", \"name\": \"가게명\"}], "
                                  + "\"products\": [{\"productNo\": 10, \"name\": \"상품명\"}]}";

                    String aiResponse = geminiService.callGemini(prompt);
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
                    // 🎯 여기에 프린트문을 넣어 코드가 진짜 적용되었는지 콘솔로 확인합니다!
                    System.out.println("⏳ 유저 [" + userId + "] 처리 완료. 한도 초과 방지를 위해 30초 대기합니다...");
                    try {
                        Thread.sleep(30000);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                    }
                }
            } // for문 끝
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public AiRecommend getRecommendationByUserId(String userId) throws Exception {
        return aiRecommendMapper.getRecommendationByUserId(userId);
    }
}