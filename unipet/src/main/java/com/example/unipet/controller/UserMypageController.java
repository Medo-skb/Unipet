package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.UserMypageService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserMypageController {

    @Autowired
    private UserMypageService userMypageService;

    @GetMapping("/user/mypage.do")
    public String mypage() {
        return "user/UserMypage";
    }

    @PostMapping("/user/mypage.dox")
    @ResponseBody
    public String getMypage(HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));

        HashMap<String, Object> result = userMypageService.getMypageData(map);
        return new Gson().toJson(result);
    }

    @PostMapping("/user/change-main-pet.dox")
    @ResponseBody
    public String changeMainPet(@RequestParam HashMap<String, Object> map, HttpSession session) {
        map.put("userId", session.getAttribute("sessionId"));

        HashMap<String, Object> result = userMypageService.changeMainPet(map);
        return new Gson().toJson(result);
    }
}