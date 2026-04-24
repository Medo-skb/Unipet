package com.example.unipet.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.unipet.dao.AdminService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@RequestMapping("/admin.do") 
	public String adminPage(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/admin/adminPage";
	}
	
	@RequestMapping(value = "/adminBiz.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminBiz(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getAdminBiz(map);
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/editBizStatusApr.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editBizStatus(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.editBizStatusApr(map);
 
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/editBizStatusRej.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editBizStatusRej(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.editBizStatusRej(map);
 
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/getReservationReviewReportList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReservationReviewReportList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getReservationReviewReportList(map);
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/getProductReviewReportList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getProductReviewReportList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = adminService.getProductReviewReportList(map);
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/admin/report/reject.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rejectReport(@RequestParam HashMap<String, Object> map) {

	    adminService.rejectReport(map);

	    Map<String, Object> result = new HashMap<>();
	    result.put("result", "success");

	    return new Gson().toJson(result);
	}
	
	@RequestMapping(value = "/admin/report/approve.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String approveReport(@RequestParam HashMap<String, Object> map) {

	    adminService.approveReport(map);

	    Map<String, Object> result = new HashMap<>();
	    result.put("result", "success");

	    return new Gson().toJson(result);
	}
}