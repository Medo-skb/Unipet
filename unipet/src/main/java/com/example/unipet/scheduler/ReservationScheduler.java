package com.example.unipet.scheduler;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.unipet.dao.ReservationService; // 서비스 주입
import com.example.unipet.mapper.ReservationMapper;

@Component
public class ReservationScheduler {

    @Autowired
    private ReservationMapper reservationMapper;
    
    @Autowired
    private ReservationService reservationService;

    // 기존 로직: 슬롯 자동 마감
    @Scheduled(cron = "0 * * * * *")
    public void autoCloseExpiredSlots() {
        try {
            int updatedCount = reservationMapper.updateExpiredSlots();
            if (updatedCount > 0) {
                System.out.println("[시스템] " + updatedCount + "개의 슬롯이 정책에 의해 자동 마감되었습니다.");
            }
        } catch (Exception e) {
            System.err.println("[시스템 에러] 슬롯 마감 중 오류: " + e.getMessage());
        }
    }

    // 신규 로직: 이용 완료(30분 경과) 건 자동 FIN 처리 및 로그 기록
    @Scheduled(cron = "0 * * * * *")
    public void autoFinishReservations() {
        try {
            HashMap<String, Object> map = new HashMap<>();
            
            int finishedCount = reservationService.processAutoFinish(map);
            
            if (finishedCount > 0) {
                System.out.println("[시스템] " + finishedCount + "개의 예약이 이용 완료(FIN) 처리되었습니다.");
            }
        } catch (Exception e) {
            // 에러 발생 시 원인 파악을 위해 스택 트레이스 출력 추천
            System.err.println("[시스템 에러] 예약 자동 종료 중 오류 발생");
            e.printStackTrace();
        }
    }
}