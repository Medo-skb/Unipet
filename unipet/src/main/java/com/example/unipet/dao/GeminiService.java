package com.example.unipet.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.unipet.model.ChatRequest;
import com.example.unipet.model.ChatResponse;

@Service
public class GeminiService {

    @Qualifier("geminiRestTemplate")
    @Autowired
    private RestTemplate restTemplate;

    @Value("${gemini.api.url}")
    private String apiUrl;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    public String getContents(String prompt) {

        // Gemini 요청 주소
        String requestUrl = apiUrl + "?key=" + geminiApiKey;

        // 요청 객체 생성
        String finalPrompt = """
        		너는 반려동물 플랫폼 UNIPET의 챗봇이다.
        		강아지, 고양이, 기타 동물 등 반려동물 관련 질문에 답변한다.

        		규칙:
        		- 답변은 한국어로 한다.
        		- 답변은 최대 3문장으로 짧고 명확하게 한다.
        		- 너무 길어질 경우 핵심만 요약한다.
        		- 확실하지 않은 정보는 추측하지 말고 모른다고 답한다.
        		- 실시간 정보(시간, 날씨 등)는 제공하지 않는다.

        		사용자 질문:
        		""" + prompt;

        		ChatRequest request = new ChatRequest(finalPrompt);

        // Gemini API 호출
        ChatResponse response = restTemplate.postForObject(requestUrl, request, ChatResponse.class);

        // 응답 텍스트 반환
        String message = response.getCandidates().get(0).getContent().getParts().get(0).getText();

        return message;
    }
}