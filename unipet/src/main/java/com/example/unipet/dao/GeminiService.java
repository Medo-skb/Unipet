package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.unipet.mapper.GeminiMapper;
import com.example.unipet.model.ChatRequest;
import com.example.unipet.model.ChatResponse;
import com.example.unipet.model.StoreRecommend;

@Service
public class GeminiService {

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

        String intent = getIntent(prompt);

        if ("STORE_RECOMMEND".equals(intent)) {
            return getStoreRecommendAnswer(prompt);
        }

        String fixedAnswer = getAnswerByIntent(intent);

        if (fixedAnswer != null) {
            return fixedAnswer;
        }

        return getPetAnswer(prompt);
    }
    
    private String getIntent(String prompt) {

        String requestUrl = apiUrl + "?key=" + geminiApiKey;

        String intentPrompt = """
            사용자의 질문을 보고 아래 intent 중 하나만 골라서 답변하세요.

            [intent 목록]
			RESERVATION_METHOD
			RESERVATION_DEPOSIT
			RESERVATION_CANCEL
			REFUND_POLICY
			COMMUNITY_CATEGORY
			SHOPPING_DELIVERY
			POINT_INFO
			STORE_RECOMMEND
			UNKNOWN

            규칙:
            - 반드시 intent 값 하나만 출력하세요.
            - 설명 문장, 마침표, 따옴표는 붙이지 마세요.
            - 다음과 같은 질문은 STORE_RECOMMEND를 출력하세요:
			  * 업체 추천
			  * 병원 추천
			  * 미용 잘하는 곳
			  * 호텔 추천
			  * 건강검진 추천
			  * 저렴한 곳, 싼 곳
			  * 특정 지역 + 서비스 추천 (예: 부평 미용, 강남 병원)
			- 메뉴 이용 질문도 아니고 업체 추천 질문도 아니면 UNKNOWN을 출력하세요.

            사용자 질문:
            """ + prompt;

        ChatRequest request = new ChatRequest(intentPrompt);

        ChatResponse response = restTemplate.postForObject(requestUrl, request, ChatResponse.class);

        String intent = response.getCandidates()
                .get(0)
                .getContent()
                .getParts()
                .get(0)
                .getText();

        return intent.trim()
                .replace("\"", "")
                .replace(".", "")
                .replace(" ", "");
    }
    
    private String getAnswerByIntent(String intent) {

        switch (intent) {

            case "RESERVATION_METHOD":
                return "원하는 업체 상세 페이지에서 예약하기를 누른 뒤 날짜와 시간을 선택하고 예약금을 결제하면 예약이 완료됩니다.";

            case "RESERVATION_DEPOSIT":
                return "예약금은 서비스 예약 확정을 위해 미리 결제하는 금액입니다. 총 결제 금액의 일부가 예약금으로 부과됩니다.";

            case "RESERVATION_CANCEL":
                return "마이페이지 > 예약 내역에서 예약을 취소할 수 있습니다. 단, 환불 가능 여부는 예약 시간과 업체 정책에 따라 달라질 수 있습니다.";

            case "REFUND_POLICY":
                return "환불은 예약 시간과 업체 환불 정책에 따라 처리됩니다. 자세한 내용은 예약 내역 또는 업체 안내를 확인해주세요.";

            case "COMMUNITY_CATEGORY":
                return "커뮤니티 카테고리는 통합과 지역으로 나뉩니다. 통합은 자유로운 소통과 정보 공유, 지역은 산책·소모임·지역정보 등을 나누는 공간입니다.";

            case "SHOPPING_DELIVERY":
                return "배송 정보는 주문 내역에서 확인할 수 있습니다. 상품과 판매자 상황에 따라 배송 일정이 달라질 수 있습니다.";

            case "POINT_INFO":
                return "포인트는 구매나 서비스 이용 시 적립될 수 있으며, 보유 포인트는 마이페이지에서 확인할 수 있습니다.";

            default:
                return null;
        }
    }
    
    private String getPetAnswer(String prompt) {

        String requestUrl = apiUrl + "?key=" + geminiApiKey;

        String finalPrompt = """
            너는 반려동물 플랫폼 UNIPET의 챗봇이다.
            강아지, 고양이, 조류, 기타 동물 등 반려동물 관련 질문에 답변한다.

            역할:
            - 반려동물 보호자가 이해하기 쉽게 설명한다.
            - 일반적인 관리, 산책, 식사, 목욕, 놀이, 훈련, 생활 팁을 안내한다.
            - UNIPET 서비스 이용과 관련된 질문도 도와준다.

            답변 규칙:
            - 답변은 한국어로 한다.
            - 답변은 최대 3문장으로 짧고 명확하게 한다.
            - 어려운 전문용어는 피하고 쉽게 설명한다.
            - 질문이 모호하면 가능한 범위에서 일반적인 기준으로 답변한다.
            - 확실하지 않은 정보는 추측하지 말고 모른다고 답한다.
            - 실시간 정보(시간, 날씨, 현재 예약 가능 여부 등)는 제공하지 않는다.
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

        ChatRequest request = new ChatRequest(finalPrompt);

        ChatResponse response = restTemplate.postForObject(requestUrl, request, ChatResponse.class);

        String message = response.getCandidates()
                .get(0)
                .getContent()
                .getParts()
                .get(0)
                .getText();

        return message;
        
    }
    
    private String getStoreRecommendAnswer(String prompt) {

        HashMap<String, Object> map = new HashMap<>();

        String keyword = extractSimpleKeyword(prompt);
        map.put("keyword", keyword);

        System.out.println("===== 업체 추천 챗봇 =====");
        System.out.println("사용자 입력: " + prompt);
        System.out.println("검색 키워드: " + keyword);

        List<StoreRecommend> storeList = geminiMapper.selectStoreRecommendList(map);

        System.out.println("DB 조회 결과 개수: " + (storeList == null ? 0 : storeList.size()));

        if (storeList == null || storeList.isEmpty()) {
            return "조건에 맞는 업체를 찾지 못했습니다. 지역명이나 원하는 서비스명을 조금 더 구체적으로 입력해 주세요.";
        }

        String storeListText = makeStoreListText(storeList);

        String requestUrl = apiUrl + "?key=" + geminiApiKey;

        String recommendPrompt = """
            너는 UNIPET의 업체 추천 도우미다.

            사용자 질문에 가장 적합한 업체를 아래 후보 목록에서 최대 3개 추천해라.

            규칙:
            - 반드시 후보 목록 안에 있는 업체만 추천한다.
            - 없는 업체를 만들지 않는다.
            - 업체명, 추천 이유, 바로가기 링크를 포함한다.
            - 추천 이유는 사용자 질문에 따라 리뷰, 업체 소개글, 주소, 가격 중 관련 있는 기준만 사용한다.
            - 사용자가 지역을 말한 경우 주소를 추천 이유에 포함한다.
            - 사용자가 '싼 곳', '저렴한 곳', '가격'을 말한 경우 가격을 추천 이유에 포함한다.
            - 사용자가 진료나 질병 관련 질문을 한 경우 치료 가능하다고 단정하지 말고, 리뷰와 소개글 기준으로만 추천한다.
            - 답변은 한국어로 한다.
            - 너무 길게 설명하지 않는다.

            답변 형식:
            1. 업체명
            추천 이유:
            바로가기: /reservation/store-detail.do?storeNo=업체번호

            사용자 질문:
            """ + prompt + """

            업체 후보:
            """ + storeListText;

        ChatRequest request = new ChatRequest(recommendPrompt);

        ChatResponse response = restTemplate.postForObject(requestUrl, request, ChatResponse.class);

        return response.getCandidates()
                .get(0)
                .getContent()
                .getParts()
                .get(0)
                .getText();
    }
    
    private String makeStoreListText(List<StoreRecommend> storeList) {

        StringBuilder sb = new StringBuilder();

        for (StoreRecommend store : storeList) {
            sb.append("업체번호: ").append(store.getStoreNo()).append("\n");
            sb.append("업체명: ").append(nullToBlank(store.getStoreName())).append("\n");
            sb.append("주소: ").append(nullToBlank(store.getAddr())).append("\n");
            sb.append("소개 제목: ").append(nullToBlank(store.getSubTitle())).append("\n");
            sb.append("소개글: ").append(nullToBlank(store.getContents())).append("\n");
            sb.append("메뉴: ").append(nullToBlank(store.getMenuNames())).append("\n");
            sb.append("최저가격: ").append(store.getMinPrice() == null ? "정보 없음" : store.getMinPrice() + "원").append("\n");
            sb.append("평점: ").append(store.getAvgRating() == null ? "0" : store.getAvgRating()).append("\n");
            sb.append("리뷰 수: ").append(store.getReviewCount()).append("\n");
            sb.append("리뷰 내용: ").append(nullToBlank(store.getReviewContents())).append("\n");
            
            String link = "/reservation/store-detail.do?storeNo=" + store.getStoreNo();

            sb.append("바로가기: ").append(link).append("\n");
            sb.append("---\n");
        }

        return sb.toString();
    }
    
    private String nullToBlank(String value) {
        return value == null ? "" : value;
    }
    
    private String extractSimpleKeyword(String prompt) {

        String keyword = prompt;

        keyword = keyword.replace("추천해줘", "");
        keyword = keyword.replace("추천", "");
        keyword = keyword.replace("업체", "");
        keyword = keyword.replace("병원", "");
        keyword = keyword.replace("곳", "");
        keyword = keyword.replace("잘하는", "");
        keyword = keyword.replace("알려줘", "");
        keyword = keyword.replace("강아지", "");
        keyword = keyword.replace("고양이", "");
        keyword = keyword.replace("싼", "");
        keyword = keyword.replace("저렴한", "");
        keyword = keyword.replace("좀", "");
        keyword = keyword.replace("  ", " ");
        
        keyword = keyword.trim();
        

	     // 너무 짧으면 원문 그대로 사용
	     if (keyword.length() < 2) {
	         return prompt;
	     }
	     
	     return keyword;
    }
}