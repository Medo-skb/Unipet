package com.example.unipet.dao;

import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.solapi.sdk.NurigoApp;
import com.solapi.sdk.message.model.Message;
import com.solapi.sdk.message.service.DefaultMessageService;

@Service
public class SmsService {

    private final SecureRandom random = new SecureRandom();
    private final DefaultMessageService messageService;

    @Value("${sms.api.from}")
    private String fromNumber;

    public SmsService(
            @Value("${sms.api.key}") String apiKey,
            @Value("${sms.api.secret}") String apiSecret
    ) {
        this.messageService = NurigoApp.INSTANCE.initialize(
                apiKey,
                apiSecret,
                "https://api.coolsms.co.kr"
        );
    }

    public String createCode() {
        return String.format("%06d", random.nextInt(1000000));
    }

    public boolean sendSms(String phone, String code) {
        try {
            String to = phone.replaceAll("-", "");

            Message message = new Message();
            message.setFrom(fromNumber);
            message.setTo(to);
            message.setText("[UniPet] 인증번호는 [" + code + "] 입니다.");

            messageService.send(message);

            System.out.println("SMS 전송 성공");
            return true;
        } catch (Exception e) {
            System.out.println("SMS 전송 실패");
            e.printStackTrace();
            return false;
        }
    }
}