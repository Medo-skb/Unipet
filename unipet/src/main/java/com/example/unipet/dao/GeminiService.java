package com.example.unipet.dao;

import java.time.LocalDate;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.unipet.model.AiRecommendRequest;
import com.example.unipet.model.ChatRequest;
import com.example.unipet.model.ChatResponse;

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

    public String getContents(String prompt) {

        if (prompt == null || prompt.trim().isEmpty()) {
            return "질문을 입력해주세요.";
        }

        // Gemini 호출 없이 먼저 고정 답변 처리
        String fixedAnswer = getFixedAnswerByPrompt(prompt);
        if (fixedAnswer != null) {
            return fixedAnswer;
        }

        // 반려동물 질문만 Gemini 호출
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

    private String getPetAnswer(String prompt) {

        String finalPrompt = """
            너는 반려동물 플랫폼 UNIPET의 챗봇이다.
            강아지, 고양이, 조류, 기타 동물 등 반려동물 관련 질문에 답변한다.

            역할:
            - 반려동물 보호자가 이해하기 쉽게 설명한다.
            - 일반적인 관리, 산책, 식사, 목욕, 놀이, 훈련, 생활 팁을 안내한다.
            - UNIPET 서비스 이용과 관련된 질문도 도와준다.
            - 업체 추천, 특정 업체 안내, 예약 가능 업체 조회, 쇼핑 상품 추천은 제공하지 않는다.

            답변 규칙:
            - 답변은 한국어로 한다.
            - 답변은 필요한 내용을 생략하지 말고 4~6문장 이내로 자연스럽게 답한다.
            - 어려운 전문용어는 피하고 쉽게 설명한다.
            - 질문이 모호하면 가능한 범위에서 일반적인 기준으로 답변한다.
            - 확실하지 않은 정보는 추측하지 말고 모른다고 답한다.
            - 실시간 정보는 제공하지 않는다.
            - 특정 상품, 특정 업체, 예약 가능 여부는 단정하지 않는다.
            - 업체 추천을 요청받으면 직접 추천은 어렵고, UNIPET에서 지역과 카테고리를 선택해 확인하라고 안내한다.

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

   public String callGemini(String prompt) {

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

                requestCount.incrementAndGet();

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

    private boolean isOverLimit() {

        LocalDate today = LocalDate.now();

        // 날짜 바뀌면 카운트 초기화
        if (!today.equals(currentDate)) {
            requestCount.set(0);
            currentDate = today;
        }

        return requestCount.get() >= 100;
    }
    
    public String callGeminiForRecommend(String prompt) {

        if (isOverLimit()) {
            return "오늘 사용량이 초과되었습니다. 내일 다시 이용해주세요.";
        }

        String requestUrl = apiUrl + "?key=" + geminiApiKey;
        
        AiRecommendRequest request = new AiRecommendRequest(prompt); 

        int maxRetry = 2;
        for (int i = 0; i < maxRetry; i++) {
            try {
                // 구글 서버로 전송 (ChatResponse 구조는 동일하므로 그대로 재사용 가능)
                ChatResponse response = restTemplate.postForObject(requestUrl, request, ChatResponse.class);

                if (response == null || response.getCandidates() == null || response.getCandidates().isEmpty() ||
                    response.getCandidates().get(0).getContent() == null ||
                    response.getCandidates().get(0).getContent().getParts() == null ||
                    response.getCandidates().get(0).getContent().getParts().isEmpty() ||
                    response.getCandidates().get(0).getContent().getParts().get(0).getText() == null) {
                    return "현재 응답을 가져오지 못했습니다. 다시 시도해주세요.";
                }

                requestCount.incrementAndGet();
                StringBuilder result = new StringBuilder();
                var parts = response.getCandidates().get(0).getContent().getParts();

                for (var part : parts) {
                    if (part.getText() != null) {
                        result.append(part.getText());
                    }
                }
                return result.toString();

            } catch (Exception e) {
                if (e instanceof HttpClientErrorException.TooManyRequests) {
                    try { Thread.sleep(35000); } catch (InterruptedException ie) { Thread.currentThread().interrupt(); }
                }
                if (i == maxRetry - 1) {
                    e.printStackTrace();
                    return "요청이 많아 잠시 후 다시 시도해주세요.";
                }
            }
        }
        return "현재 추천 응답이 불안정합니다. 잠시 후 다시 시도해주세요.";
    }

}