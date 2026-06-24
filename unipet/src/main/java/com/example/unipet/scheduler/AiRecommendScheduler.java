package com.example.unipet.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.unipet.dao.AiRecommendService;

@Component
public class AiRecommendScheduler {

    @Autowired
    private AiRecommendService aiRecommendService;

    /**
     * 매일 새벽 3시에 실행되는 AI 맞춤 추천 생성 배치 작업
     * cron = "초 분 시 일 월 요일"
     */
    @Scheduled(cron = "0 0 3 * * *")
//    @Scheduled(cron = "0 0/3 * * * *")
    public void makeDailyAiRecommendation() {
        System.out.println("[배치 작업 시작] AI 맞춤 추천 데이터 생성을 시작합니다.");
        
        try {
            aiRecommendService.processAllUserRecommendations();
            
            System.out.println("[배치 작업 완료] 모든 활성 유저의 AI 추천 데이터가 갱신되었습니다.");
        } catch (Exception e) {
            System.err.println("[배치 작업 에러] AI 추천 데이터 생성 중 심각한 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
