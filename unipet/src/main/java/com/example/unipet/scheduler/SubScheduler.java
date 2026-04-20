//package com.example.unipet.scheduler;
//
//import java.util.HashMap;
//import java.util.List;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.scheduling.annotation.Scheduled;
//import org.springframework.stereotype.Component;
//
//import com.example.unipet.dao.PaymentService;
//
//@Component
//public class SubScheduler {
//
//	@Autowired
//	PaymentService paymentService;
//	
//	// 매일 새벽 2시에 실행 (초 분 시 일 월 요일)
//    @Scheduled(cron = "0/10 * * * * *")
//    public void scheduleSubscriptionBilling() {
//    	
//		List<HashMap<String, Object>> targets = paymentService.getTodayBillingList();
//        
//        for (HashMap<String, Object> target : targets) {
//            try {
//                // 2. 실제 결제 및 DB 업데이트 (Service에서 한 번에 처리)
//                paymentService.executeAutoBilling(target);
//                 System.out.println(target.get("USER_ID") + " 정기 결제 완료");
//            } catch (Exception e) {
//                // System.err.println(target.get("USER_ID") + " 정기 결제 실패: " + e.getMessage());
//            }
//        }
//
//    }
//	
//}
