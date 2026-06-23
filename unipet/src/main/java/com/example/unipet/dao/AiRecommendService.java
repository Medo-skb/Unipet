package com.example.unipet.dao;

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
            // 1. 유저 목록 조회
            List<String> userList = aiRecommendMapper.selectUserList();
            
            // 🎯 [수정] 업체(Store) 후보군은 유저 지역마다 다르므로 밖에서 미리 뽑지 않고 삭제합니다.
            
            // 쇼핑 상품은 지역 제한이 없으므로 성능을 위해 반복문 밖에서 1번만 뽑습니다.
            List<HashMap<String, Object>> productCandidates = aiRecommendMapper.selectTopProductList();
            String productJson = gson.toJson(productCandidates);

            // 2. 유저별 반복 작업 시작
            for (String userId : userList) {
                try {
                    HashMap<String, Object> userData = aiRecommendMapper.getUserHistory(userId);
                    if (userData == null || userData.isEmpty()) continue;
                    
                    // 유저의 전체 주소에서 '시/도'만 잘라내기
                    String fullAddress = (String) userData.get("userAddr");
                    String searchRegion = ""; 
                    
                    if (fullAddress != null && !fullAddress.trim().isEmpty()) {
                        String[] addrParts = fullAddress.split(" ");
                        if (addrParts.length >= 2) {
                            searchRegion = addrParts[0] + " " + addrParts[1]; // 🎯 결과: "인천 부평구"
                        } else {
                            searchRegion = addrParts[0]; 
                        }
                    }

                    // 🎯 잘라낸 지역(searchRegion)을 파라미터로 넘겨서 해당 지역 업체만 뽑아옵니다.
                    // (여기서 변수가 최초로 선언되므로 에러가 사라집니다)
                    List<HashMap<String, Object>> storeCandidates = aiRecommendMapper.selectTopStoreList(searchRegion);
                    String storeJson = gson.toJson(storeCandidates);

                    // 유저 정보 JSON 변환
                    String userJson = gson.toJson(userData);

                    // 3. 프롬프트 작성 
                    String prompt = "너는 반려동물 맞춤형 큐레이터야. 아래 제공된 [사용자 데이터]를 분석하고, [추천 후보군 리스트] 안에서 "
                                  + "가장 적합한 예약 업체 2개와 쇼핑 상품 2개를 골라줘.\n\n"
                                  + "[사용자 데이터]\n" + userJson + "\n\n"
                                  + "[추천 후보군 리스트]\n"
                                  + "- 예약 업체 후보:\n" + storeJson + "\n"
                                  + "- 쇼핑 상품 후보:\n" + productJson + "\n\n"
                                  + "반드시 아래의 JSON 형식으로만 대답해 줘 (마크다운 백틱 없이 순수 JSON만 출력해):\n"
                                  + "{\"services\": [{\"storeNo\": 1, \"type\": \"미용실\", \"name\": \"가게명\", \"reason\": \"이유\"}], "
                                  + "\"products\": [{\"productNo\": 10, \"name\": \"상품명\", \"reason\": \"이유\"}]}";

                    // 4. Gemini API 호출 재사용
                    String aiResponse = geminiService.callGemini(prompt);

                 // 5. 응답 파싱 및 DB 저장
                    JsonObject jsonObject = JsonParser.parseString(aiResponse).getAsJsonObject();
                    String recServices = jsonObject.getAsJsonArray("services").toString();
                    String recProducts = jsonObject.getAsJsonArray("products").toString();

                    // 🎯 맵 대신 우리가 만든 Model 객체에 데이터를 예쁘게 담아서 넘깁니다.
                    AiRecommend recommendObj = new AiRecommend();
                    recommendObj.setUserId(userId);
                    recommendObj.setRecServices(recServices);
                    recommendObj.setRecProducts(recProducts);

                    int existCount = aiRecommendMapper.checkRecommendationExist(userId);

                    if (existCount == 0) {
                        // 0개라면 최초 추천이므로 INSERT 실행
                        aiRecommendMapper.insertRecommendation(recommendObj);
                        System.out.println("유저 [" + userId + "] 님 최초 AI 추천 데이터 INSERT 완료");
                    } else {
                        // 0개가 아니라면 이미 과거 기록이 있으므로 UPDATE 실행
                        aiRecommendMapper.updateRecommendation(recommendObj);
                        System.out.println("유저 [" + userId + "] 님 기존 AI 추천 데이터 UPDATE 완료");
                    }

                } catch (Exception e) {
                    System.out.println("유저 [" + userId + "] 추천 에러: " + e.getMessage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public AiRecommend getRecommendationByUserId(String userId) throws Exception {
        return aiRecommendMapper.getRecommendationByUserId(userId);
    }
}