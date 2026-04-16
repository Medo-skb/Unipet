package com.example.unipet.controller;

import java.util.HashMap; 

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.UserService;
import com.google.gson.Gson;

@Controller

public class UserController {

	@Autowired
	UserService userService;
	
	 @GetMapping("user/join.do")
	    public String join() {
	        return "/user/join";
	    }

	@GetMapping("user/SignupUser.do")
	public String SignupUser(Model model) throws Exception {
		return "/user/signup-user";
	}

	@GetMapping("user/SignupBiz.do")
	public String SignupBiz(Model model) throws Exception {
		return "/user/signup-biz";
	}

	@PostMapping(value = "/check.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String check(@RequestParam HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = userService.checkUser(map);
		return new Gson().toJson(resultMap);
	}

	@PostMapping(value = "/signupUser.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String signupUser(@RequestParam HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = userService.signupUser(map);
		return new Gson().toJson(resultMap);
	}

	@PostMapping(value = "/signupBiz.dox", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String signupBiz(@RequestParam HashMap<String, Object> map) {

		HashMap<String, Object> resultMap = userService.signupBiz(map);
		return new Gson().toJson(resultMap);

	}
	
	 @RequestMapping(value = "/sendSms.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public String sendSms(@RequestParam HashMap<String, Object> map) throws Exception {
	        HashMap<String, Object> resultMap = new HashMap<String, Object>();
	        System.out.println("sendSms map : " + map);

	        resultMap = userService.sendSms(map);

	        return new Gson().toJson(resultMap);
	    }

	 @RequestMapping(value = "/verifySms.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public String verifySms(@RequestParam HashMap<String, Object> map) throws Exception {
	        HashMap<String, Object> resultMap = new HashMap<String, Object>();
	        System.out.println("verifySms map : " + map);

	        resultMap = userService.verifySms(map);

	        return new Gson().toJson(resultMap);
	    }
	 
	   @RequestMapping(value = "/findId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public String findId(@RequestParam HashMap<String, Object> map) throws Exception {
	        HashMap<String, Object> resultMap = new HashMap<String, Object>();
	        System.out.println("findId map : " + map);

	        resultMap = userService.findId(map);

	        return new Gson().toJson(resultMap);
	    }
	   
	   @RequestMapping(value = "/sendResetLink.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public String sendResetLink(@RequestParam HashMap<String, Object> map) throws Exception {
	        HashMap<String, Object> resultMap = new HashMap<String, Object>();
	        System.out.println("sendResetLink map : " + map);

	        resultMap = userService.sendResetLink(map);

	        return new Gson().toJson(resultMap);
	    }
	   
	   @RequestMapping(value = "/resetPwd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public String resetPwd(@RequestParam HashMap<String, Object> map) throws Exception {
	        HashMap<String, Object> resultMap = new HashMap<String, Object>();
	        System.out.println("resetPwd map : " + map);

	        resultMap = userService.resetPwd(map);

	        return new Gson().toJson(resultMap);
	    }
	   
	   
	   



	

}
