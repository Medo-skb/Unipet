package com.example.unipet.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.unipet.dao.GeminiService;

@RestController
@RequestMapping("/gemini")
public class GeminiController {

    @Autowired
    private GeminiService geminiService;

    @GetMapping("/chat")
    public ResponseEntity<?> gemini(@RequestParam String input) {
        try {
            return ResponseEntity.ok().body(geminiService.getContents(input));
        } catch (Exception e) {
            String errorMessage = e.getMessage();

            if (errorMessage != null && errorMessage.contains("503")) {
                return ResponseEntity.status(503).body("현재 응답이 일시적으로 지연되고 있습니다. 잠시 후 다시 시도해주세요.");
            }

            return ResponseEntity.internalServerError().body("챗봇 호출 중 오류가 발생했습니다.");
        }
    }
    
}