package com.example.unipet.dao;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.unipet.mapper.GeminiMapper;
import com.example.unipet.model.ChatRequest;
import com.example.unipet.model.ChatResponse;
import com.example.unipet.model.StoreRecommend;

@Service
public class GeminiService {

	private AtomicInteger requestCount = new AtomicInteger(0);
	private LocalDate currentDate = LocalDate.now();
	
    @Qualifier("geminiRestTemplate")
    @Autowired
    private RestTemplate restTemplate;

    @Value("${gemini.api.url}")
    private String apiUrl;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    @Autowired
    private GeminiMapper geminiMapper;

    public String getContents(String prompt) {

        if (prompt == null || prompt.trim().isEmpty()) {
            return "질문을 입력해주세요.";
        }

        // Gemini 호출 없이 먼저 고정 답변 처리
        String fixedAnswer = getFixedAnswerByPrompt(prompt);
        if (fixedAnswer != null) {
            return fixedAnswer;
        }

        // 추천 의도가 있으면 지역이 없어도 추천 실행
        if (isStoreRecommendPrompt(prompt)) {
            return getStoreRecommendAnswer(prompt);
        }

        // 그 외 반려동물 질문만 Gemini 호출
        return getPetAnswer(prompt);
    }

    private String getFixedAnswerByPrompt(String prompt) {

        String text = prompt.replaceAll("\\s", "");

        if (text.contains("예약방법")) {
            return "원하는 업체 상세 페이지에서 예약하기를 누른 뒤 날짜와 시간을 선택하고 예약금을 결제하면 예약이 완료됩니다.";
        }

        if (text.contains("예약금")) {
            return "예약금은 서비스 예약 확정을 위해 미리 결제하는 금액입니다. 총 결제 금액의 일부가 예약금으로 부과됩니다.";
        }

        if (text.contains("예약취소")) {
            return "마이페이지 > 예약 내역에서 예약을 취소할 수 있습니다. 단, 환불 가능 여부는 예약 시간과 업체 정책에 따라 달라질 수 있습니다.";
        }

        if (text.contains("환불")) {
            return "환불은 예약 시간과 업체 환불 정책에 따라 처리됩니다. 자세한 내용은 예약 내역 또는 업체 안내를 확인해주세요.";
        }

        if (text.contains("커뮤니티") && text.contains("카테고리")) {
            return "커뮤니티 카테고리는 통합과 지역으로 나뉩니다. 통합은 자유로운 소통과 정보 공유, 지역은 산책·소모임·지역정보 등을 나누는 공간입니다.";
        }

        if (text.contains("배송")) {
            return "배송 정보는 주문 내역에서 확인할 수 있습니다. 상품과 판매자 상황에 따라 배송 일정이 달라질 수 있습니다.";
        }

        if (text.contains("포인트")) {
            return "포인트는 구매나 서비스 이용 시 적립될 수 있으며, 보유 포인트는 마이페이지에서 확인할 수 있습니다.";
        }

        return null;
    }
    
    private boolean isStoreRecommendPrompt(String prompt) {

        String text = prompt.replaceAll("\\s", "");

        return text.contains("추천")
                || text.contains("추천해")
                || text.contains("부탁")
                || text.contains("어디가좋")
                || text.contains("어디가괜찮")
                || text.contains("괜찮은곳")
                || text.contains("좋은곳")
                || text.contains("찾아줘")
                || text.contains("알려줘")
                || text.contains("업체")
                || text.contains("동물병원")
                || text.contains("병원")
                || text.contains("미용")
                || text.contains("호텔")
                || text.contains("건강검진")
                || text.contains("저렴")
                || text.contains("싼곳");
    }

    private String getPetAnswer(String prompt) {

        String finalPrompt = """
            너는 반려동물 플랫폼 UNIPET의 챗봇이다.
            강아지, 고양이, 조류, 기타 동물 등 반려동물 관련 질문에 답변한다.

            역할:
            - 반려동물 보호자가 이해하기 쉽게 설명한다.
            - 일반적인 관리, 산책, 식사, 목욕, 놀이, 훈련, 생활 팁을 안내한다.
            - UNIPET 서비스 이용과 관련된 질문도 도와준다.

            답변 규칙:
            - 답변은 한국어로 한다.
            - 답변은 필요한 내용을 생략하지 말고 4~6문장 이내로 자연스럽게 답한다.
            - 어려운 전문용어는 피하고 쉽게 설명한다.
            - 질문이 모호하면 가능한 범위에서 일반적인 기준으로 답변한다.
            - 확실하지 않은 정보는 추측하지 말고 모른다고 답한다.
            - 실시간 정보는 제공하지 않는다.
            - 특정 상품, 업체, 예약 가능 여부는 실제 DB 조회 결과가 없으면 단정하지 않는다.

            건강/의료 관련 규칙:
            - 질병을 단정 진단하지 않는다.
            - 약 이름, 복용량, 치료법을 임의로 안내하지 않는다.
            - 구토, 설사, 호흡곤란, 경련, 출혈, 식욕부진 지속 등 위험 신호가 있으면 동물병원 방문을 권한다.
            - 응급 상황처럼 보이면 즉시 동물병원에 가라고 안내한다.

            답변 스타일:
            - 친절하지만 과하게 장황하지 않게 답한다.
            - 필요하면 마지막 문장에 보호자가 바로 할 수 있는 행동을 제안한다.
            - 목록이 필요할 때는 3~4개까지만 사용한다.

            사용자 질문:
            """ + prompt;

        return callGemini(finalPrompt);
    }

    private String getStoreRecommendAnswer(String prompt) {

        HashMap<String, Object> map = new HashMap<>();

        String animalKeyword = extractAnimalKeyword(prompt);
        String locationKeyword = extractLocationKeyword(prompt);
        String serviceKeyword = extractServiceKeyword(prompt);
        String categoryKeyword = extractCategoryKeyword(prompt);
        String interestKeyword = extractInterestKeyword(prompt);

        map.put("animalKeyword", animalKeyword);
        map.put("locationKeyword", locationKeyword);
        map.put("serviceKeyword", serviceKeyword);
        map.put("categoryKeyword", categoryKeyword);
        map.put("interestKeyword", interestKeyword);

        List<StoreRecommend> storeList = geminiMapper.selectStoreRecommendList(map);

        if (storeList == null || storeList.isEmpty()) {
            return "조건에 맞는 업체를 찾지 못했습니다. 지역명이나 원하는 서비스명을 조금 더 구체적으로 입력해 주세요.";
        }

        StringBuilder answer = new StringBuilder();

        int count = 0;

        for (StoreRecommend store : storeList) {
            if (count >= 3) {
                break;
            }

            answer.append(count + 1).append(". ")
                  .append(store.getStoreName()).append("\n");

            answer.append("상세보기|")
                  .append(store.getStoreNo()).append("\n");

            answer.append("추천 이유: ")
	            .append(makeRecommendReason(store, prompt))
	            .append("\n\n");

            count++;
        }

        return answer.toString().trim();
    }
    
    private String makeRecommendReason(StoreRecommend store, String prompt) {

        String interestKeyword = extractInterestKeyword(prompt);

        String matchedReview = extractMatchedReview(
            store.getReviewContents(),
            interestKeyword
        );

        String sourceText = "";

        if (store.getReviewContents() != null 
                && !store.getReviewContents().trim().isEmpty()) {

            sourceText += "전체 리뷰: "
                    + store.getReviewContents()
                    + "\n";
        }

        if (matchedReview != null && !matchedReview.isEmpty()) {
            sourceText += "핵심 리뷰: "
                    + matchedReview
                    + "\n";
        }

        if (store.getMenuNames() != null 
                && !store.getMenuNames().trim().isEmpty()) {

            sourceText += "등록 메뉴: "
                    + store.getMenuNames()
                    + "\n";
        }

        if (sourceText.trim().isEmpty()) {
            sourceText += "업체 소개: " + nullToBlank(store.getContents()) + "\n";
        }

        return makeRecommendReasonByGemini(sourceText, prompt, interestKeyword);
    }
    
    private String makeRecommendReasonByGemini(String sourceText, String userPrompt, String interestKeyword) {

    	String prompt = """
    		    사용자의 요청과 가장 관련 있는 리뷰 내용을 중심으로
    		    업체 추천 이유를 자연스럽게 작성해라.

    		    매우 중요:
    		    - 메뉴 설명보다 리뷰 내용을 우선 사용한다.
    		    - 리뷰에 있는 표현을 자연스럽게 바꿔 사용한다.
    		    - "서비스를 받을 수 있어 추천드립니다" 같은 뻔한 문장은 사용하지 않는다.
    		    - 실제 이용 경험이 느껴지는 문장으로 작성한다.
    		    - 리뷰 기반 문장을 우선 작성한다.
    		    - 반드시 한 문장만 작성한다.
    		    - 반드시 마지막은 "추천드립니다."로 끝낸다.
    		    - 없는 내용은 만들지 않는다.

    		    사용자 질문:
    		    """ + userPrompt + """

    		    업체 정보:
    		    """ + sourceText;

        String result = callGemini(prompt);

        if (result == null || result.trim().isEmpty()) {
            return "";
        }

        return result.trim();
    }
    
    private String extractInterestKeyword(String prompt) {

        String text = prompt.replaceAll("\\s", "");

        if (text.contains("안과") || text.contains("눈") || text.contains("눈병") || text.contains("결막염")) {
            return "안과";
        }

        if (text.contains("피부") || text.contains("피부병") || text.contains("피부염")) {
            return "피부";
        }

        if (text.contains("치과") || text.contains("이빨") || text.contains("치아") || text.contains("스케일링")) {
            return "치과";
        }

        if (text.contains("슬개골") || text.contains("관절") || text.contains("다리")) {
            return "관절";
        }

        if (text.contains("건강검진") || text.contains("검진")) {
            return "건강검진";
        }

        if (text.contains("응급") || text.contains("24시") || text.contains("야간")) {
            return "응급";
        }

        return "";
    }
    
    private String extractMatchedReview(String reviewContents, String keyword) {

        if (reviewContents == null || reviewContents.trim().isEmpty()) {
            return "";
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            return "";
        }

        String[] reviews = reviewContents.split(" / ");

        String[] searchWords;

        if (keyword.equals("안과")) {
            searchWords = new String[] {"안과", "눈", "눈물", "눈병", "결막염", "안구"};
        } else if (keyword.equals("피부")) {
            searchWords = new String[] {"피부", "피부병", "피부염", "가려움", "털빠짐"};
        } else if (keyword.equals("치과")) {
            searchWords = new String[] {"치과", "치아", "이빨", "스케일링", "구강"};
        } else if (keyword.equals("관절")) {
            searchWords = new String[] {"관절", "슬개골", "다리", "절뚝", "수술"};
        } else if (keyword.equals("건강검진")) {
            searchWords = new String[] {"건강검진", "검진", "검사", "피검사"};
        } else if (keyword.equals("응급")) {
            searchWords = new String[] {"응급", "24시", "야간", "급히", "위급"};
        } else {
            searchWords = new String[] {keyword};
        }

        for (String review : reviews) {
            String cleanReview = review.trim().replaceAll("\\s+", " ");

            if (cleanReview.isEmpty()) {
                continue;
            }

            for (String word : searchWords) {
                if (cleanReview.contains(word)) {
                    if (cleanReview.length() > 70) {
                        cleanReview = cleanReview.substring(0, 70) + "...";
                    }

                    return cleanReview;
                }
            }
        }

        return "";
    }

    private String callGemini(String prompt) {

        if (isOverLimit()) {
            return "오늘 사용량이 초과되었습니다. 내일 다시 이용해주세요.";
        }

        String requestUrl = apiUrl + "?key=" + geminiApiKey;
        ChatRequest request = new ChatRequest(prompt);

        int maxRetry = 2;

        for (int i = 0; i < maxRetry; i++) {
            try {
                ChatResponse response = restTemplate.postForObject(requestUrl, request, ChatResponse.class);

                if (response == null ||
                    response.getCandidates() == null ||
                    response.getCandidates().isEmpty() ||
                    response.getCandidates().get(0).getContent() == null ||
                    response.getCandidates().get(0).getContent().getParts() == null ||
                    response.getCandidates().get(0).getContent().getParts().isEmpty() ||
                    response.getCandidates().get(0).getContent().getParts().get(0).getText() == null) {

                    return "현재 응답을 가져오지 못했습니다. 다시 시도해주세요.";
                }

                requestCount.incrementAndGet(); // 🔥 성공 시 카운트 증가

                StringBuilder result = new StringBuilder();

                var parts = response.getCandidates()
                    .get(0)
                    .getContent()
                    .getParts();

                for (var part : parts) {
                    if (part.getText() != null) {
                        result.append(part.getText());
                    }
                }

                return result.toString();

            } catch (Exception e) {

                // 429 (쿼터 초과) 처리
            	if (e instanceof HttpClientErrorException.TooManyRequests) {
            	    try {
            	        Thread.sleep(35000);
            	    } catch (InterruptedException ie) {
            	        Thread.currentThread().interrupt();
            	    }
            	}

                if (i == maxRetry - 1) {
                    e.printStackTrace();
                    return "요청이 많아 잠시 후 다시 시도해주세요.";
                }
            }
        }

        return "현재 챗봇 응답이 불안정합니다. 잠시 후 다시 시도해주세요.";
    }

    private String nullToBlank(String value) {
        return value == null ? "" : value;
    }

    private String extractAnimalKeyword(String prompt) {

        if (prompt.contains("강아지") || prompt.contains("반려견") || prompt.contains("개 ")) {
            return "강아지";
        }

        if (prompt.contains("고양이") || prompt.contains("반려묘") || prompt.contains("냥이")) {
            return "고양이";
        }

        return "";
    }

    private String extractLocationKeyword(String prompt) {

        String[] locations = {
            "서울", "인천", "부평", "부천", "강남", "홍대", "마포", "송도",
            "부산", "대구", "대전", "광주", "울산", "수원", "용인", "성남",
            "일산", "김포", "시흥", "안산", "안양", "천안", "청주"
        };

        for (String location : locations) {
            if (prompt.contains(location)) {
                return location;
            }
        }

        return "";
    }

    private String extractServiceKeyword(String prompt) {

        String text = prompt.replaceAll("\\s", "");

        if (text.contains("건강검진")) {
            return "건강검진";
        }

        if (text.contains("미용") || text.contains("컷") || text.contains("목욕") || text.contains("스파") || text.contains("샴푸")) {
            return "미용";
        }

        if (text.contains("호텔") || text.contains("위탁") || text.contains("훈련")) {
            return "호텔";
        }

        if (text.contains("동물병원") || text.contains("병원") || text.contains("진료") || text.contains("접종") || text.contains("응급")) {
            return "";
        }

        return "";
    }
    
    private String extractCategoryKeyword(String prompt) {

        String text = prompt.replaceAll("\\s", "");

        if (text.contains("미용") || text.contains("컷") || text.contains("목욕") || text.contains("스파") || text.contains("샴푸")) {
            return "SAL";
        }

        if (text.contains("호텔") || text.contains("위탁") || text.contains("훈련")) {
            return "BRD";
        }

        if (text.contains("동물병원") || text.contains("병원") || text.contains("진료") || text.contains("건강검진") || text.contains("접종") || text.contains("응급")) {
            return "HOS";
        }

        return "";
    }
    
    private boolean isOverLimit() {

        LocalDate today = LocalDate.now();

        // 날짜 바뀌면 카운트 초기화
        if (!today.equals(currentDate)) {
            requestCount.set(0);
            currentDate = today;
        }

        return requestCount.get() >= 100; // 하루 100번 제한
    }

}