package com.example.unipet.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.MainService;
import com.example.unipet.model.Main;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MainController {

    @Autowired
    private MainService mainService;
    
    @RequestMapping("/main.do")
	public String main(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return "main/main";
	}

    @GetMapping("/api/main/basic")
    @ResponseBody
    public Main getMainBasicData() {
        return mainService.getMainBasicData();
    }
}