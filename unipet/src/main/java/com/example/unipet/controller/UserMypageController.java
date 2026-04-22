package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.UserMypageService;

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
    public HashMap<String, Object> getMypage(HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.getMypageData(map);
    }

    @PostMapping("/user/update-user.dox")
    @ResponseBody
    public HashMap<String, Object> updateUser(@RequestParam HashMap<String, Object> map, HttpSession session) {
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.updateUserInfo(map);
    }

    @PostMapping("/user/check-password.dox")
    @ResponseBody
    public HashMap<String, Object> checkPassword(@RequestParam HashMap<String, Object> map, HttpSession session) {
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.checkPassword(map);
    }

    @PostMapping("/user/change-pwd.dox")
    @ResponseBody
    public HashMap<String, Object> changePwd(@RequestParam HashMap<String, Object> map, HttpSession session) {
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.changePassword(map);
    }

    @PostMapping("/user/delete-user.dox")
    @ResponseBody
    public HashMap<String, Object> deleteUser(HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));

        HashMap<String, Object> result = userMypageService.deleteUser(map);

        if ("success".equals(result.get("result"))) {
            session.invalidate();
        }

        return result;
    }

    @PostMapping("/user/pet-list.dox")
    @ResponseBody
    public HashMap<String, Object> getPetList(HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.getPetList(map);
    }

    @PostMapping("/user/add-pet.dox")
    @ResponseBody
    public HashMap<String, Object> addPet(@RequestParam HashMap<String, Object> map, HttpSession session) {
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.addPet(map);
    }

    @PostMapping("/user/update-pet.dox")
    @ResponseBody
    public HashMap<String, Object> updatePet(@RequestParam HashMap<String, Object> map, HttpSession session) {
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.updatePet(map);
    }

    @PostMapping("/user/delete-pet.dox")
    @ResponseBody
    public HashMap<String, Object> deletePet(@RequestParam("petNo") int petNo, HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));
        map.put("petNo", petNo);
        return userMypageService.deletePet(map);
    }

    @PostMapping("/user/change-main-pet.dox")
    @ResponseBody
    public HashMap<String, Object> changeMainPet(@RequestParam("petNo") int petNo, HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));
        map.put("petNo", petNo);
        return userMypageService.changeMainPet(map);
    }

    @PostMapping("/user/reservation-list.dox")
    @ResponseBody
    public HashMap<String, Object> getReservationList(HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.getReservationList(map);
    }

    @PostMapping("/user/reservation-all-list.dox")
    @ResponseBody
    public HashMap<String, Object> getReservationAllList(HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.getReservationAllList(map);
    }

    // 추가
    @PostMapping("/user/order-list.dox")
    @ResponseBody
    public HashMap<String, Object> getOrderList(HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("userId", session.getAttribute("sessionId"));
        return userMypageService.getOrderList(map);
    }
}