package com.example.unipet.dao;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;

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
import java.util.concurrent.atomic.AtomicInteger;

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

        // "추천" + "지역" 같이 있을 때만 추천 실행
        if (isStoreRecommendPrompt(prompt) && hasLocation(prompt)) {
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
                || text.contains("업체")
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

        map.put("animalKeyword", animalKeyword);
        map.put("locationKeyword", locationKeyword);
        map.put("serviceKeyword", serviceKeyword);

        List<StoreRecommend> storeList = geminiMapper.selectStoreRecommendList(map);

        if (storeList == null || storeList.isEmpty()) {
            return "조건에 맞는 업체를 찾지 못했습니다. 지역명이나 원하는 서비스명을 조금 더 구체적으로 입력해 주세요.";
        }

        String storeListText = makeStoreListText(storeList);

        String recommendPrompt = """
            너는 UNIPET의 업체 추천 도우미다.

            사용자 질문에 가장 적합한 업체를 아래 후보 목록에서 최대 3개 추천해라.

            규칙:
            - 반드시 후보 목록 안에 있는 업체만 추천한다.
            - 없는 업체를 만들지 않는다.
            - 업체명, 추천 이유, 바로가기 링크를 포함한다.
            - 추천 이유는 주소, 메뉴명, 소개글, 평점, 리뷰 수를 기준으로 짧게 작성한다.
			- 리뷰 내용을 그대로 인용하지 말고 요약해서 작성한다.
			- 문장이 중간에 끊기지 않게 각 업체 추천 이유는 한 문장으로 끝낸다.
            - 사용자가 지역을 말한 경우 주소를 추천 이유에 포함한다.
            - 사용자가 '싼 곳', '저렴한 곳', '가격'을 말한 경우 가격을 추천 이유에 포함한다.
            - 사용자가 진료나 질병 관련 질문을 한 경우 치료 가능하다고 단정하지 말고, 리뷰와 소개글 기준으로만 추천한다.
            - 답변은 한국어로 한다.
            - 너무 길게 설명하지 않는다.
            - 답변은 최대 3개 업체까지만 추천한다.
			- 각 업체의 추천 이유는 1문장으로 작성한다.
			- 따옴표를 사용하지 않는다.
			- 반드시 각 업체마다 "업체번호: 숫자" 형식을 포함한다.

			답변 형식:
			1. 업체명
			업체번호: 업체번호
			상세보기 버튼은 따로 만들 예정이므로 링크는 작성하지 않는다.
			추천 이유: 한 문장으로 작성한다.
			
			규칙 추가:
			- 각 업체는 업체명, 업체번호, 추천 이유를 반드시 모두 작성한다.
			- 추천 이유가 없는 업체는 추천하지 않는다.
			- 문장을 중간에 끊지 말고 반드시 마침표로 끝낸다.
			- 최대 3개 업체만 추천한다.

            사용자 질문:
            """ + prompt + """

            업체 후보:
            """ + storeListText;

        return callGemini(recommendPrompt);
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

                return response.getCandidates()
                        .get(0)
                        .getContent()
                        .getParts()
                        .get(0)
                        .getText();

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
            sb.append("---\n");
        }

        return sb.toString();
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
    
    private boolean hasLocation(String prompt) {

        String[] locations = {
            "서울", "인천", "부평", "부천", "강남", "홍대", "마포", "송도",
            "부산", "대구", "대전", "광주", "울산", "수원", "용인", "성남",
            "일산", "김포", "시흥", "안산", "안양", "천안", "청주"
        };

        for (String loc : locations) {
            if (prompt.contains(loc)) {
                return true;
            }
        }

        return false;
    }

    private String extractServiceKeyword(String prompt) {

        String keyword = prompt;

        keyword = keyword.replace("추천해줘", "");
        keyword = keyword.replace("추천", "");
        keyword = keyword.replace("업체", "");
        keyword = keyword.replace("병원", "");
        keyword = keyword.replace("곳", "");
        keyword = keyword.replace("잘하는", "");
        keyword = keyword.replace("알려줘", "");
        keyword = keyword.replace("싼", "");
        keyword = keyword.replace("저렴한", "");
        keyword = keyword.replace("좀", "");
        keyword = keyword.replace("인천", "");
        keyword = keyword.replace("서울", "");
        keyword = keyword.replace("부평", "");
        keyword = keyword.replace("부천", "");
        keyword = keyword.replace("강남", "");
        keyword = keyword.replace("홍대", "");
        keyword = keyword.replace("마포", "");
        keyword = keyword.replace("송도", "");
        keyword = keyword.replace("부산", "");
        keyword = keyword.replace("대구", "");
        keyword = keyword.replace("대전", "");
        keyword = keyword.replace("광주", "");
        keyword = keyword.replace("울산", "");
        keyword = keyword.replace("수원", "");
        keyword = keyword.replace("용인", "");
        keyword = keyword.replace("성남", "");
        keyword = keyword.replace("일산", "");
        keyword = keyword.replace("김포", "");
        keyword = keyword.replace("시흥", "");
        keyword = keyword.replace("안산", "");
        keyword = keyword.replace("안양", "");
        keyword = keyword.replace("천안", "");
        keyword = keyword.replace("청주", "");
        keyword = keyword.replace("강아지", "");
        keyword = keyword.replace("고양이", "");
        keyword = keyword.replace("반려견", "");
        keyword = keyword.replace("반려묘", "");

        keyword = keyword.trim();

        if (keyword.length() < 2) {
            return "";
        }

        return keyword;
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