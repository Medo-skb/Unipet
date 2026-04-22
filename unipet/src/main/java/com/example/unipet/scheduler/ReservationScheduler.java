package com.example.unipet.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.example.unipet.mapper.ReservationMapper;

@Component // 최상위에 한 번만 선언
public class ReservationScheduler {

    @Autowired
    private ReservationMapper reservationMapper;

    // 매 1분마다 실행
    @Scheduled(cron = "0 * * * * *")
    public void autoCloseExpiredSlots() {
        try {
            int updatedCount = reservationMapper.updateExpiredSlots();
            if (updatedCount > 0) {
                System.out.println("[시스템] " + updatedCount + "개의 슬롯이 정책(Cutoff)에 의해 자동 마감되었습니다.");
            }
        } catch (Exception e) {
            System.err.println("[시스템 에러] 스케줄러 실행 중 오류 발생: " + e.getMessage());
        }
    }
}