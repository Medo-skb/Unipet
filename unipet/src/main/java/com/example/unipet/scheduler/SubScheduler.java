package com.example.unipet.scheduler;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.unipet.dao.PaymentService;

@Component
public class SubScheduler {

    @Autowired
    private PaymentService paymentService;

    // 10초마다 오늘 결제할 사람 있는지 확인 (테스트용)
    @Scheduled(cron = "0 0 20 * * *")
    public void scheduleSubscriptionBilling() {
        // 1. 명단 확보
        List<HashMap<String, Object>> targets = paymentService.getTodayBillingList();
        
        if (targets != null && !targets.isEmpty()) {
            for (HashMap<String, Object> target : targets) {
                paymentService.executeAutoBilling(target);
            }
        }
    }
}