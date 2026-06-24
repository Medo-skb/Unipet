package com.example.unipet.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.unipet.dao.AdminService;
import com.example.unipet.model.Admin;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {
	
	@Autowired
	AdminService adminService;

	@Value("${kakao.maps.apikey}")
	private String kakaoJavascriptKey;
	
	@RequestMapping("/admin/login.do") 
	public String adminlogin(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		return "/admin/adminLogin";
	}
	
	@RequestMapping("/admin.do") 
	public String adminPage(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HttpSession session = request.getSession();
	    String role = (String) session.getAttribute("sessionRole");

	    if (role == null || !role.equals("ADMIN")) {
	        return "redirect:/admin/login.do";
	    }

	    return "redirect:/admin/userManage.do";
	}
	
	@RequestMapping("/admin/logout.do")
	public String adminLogout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);

		if (session != null) {
			session.invalidate();
		}

		return "redirect:/admin/login.do";
	}
	
	@RequestMapping("/admin/report.do") 
	public String adminReport(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HttpSession session = request.getSession();
	    String role = (String) session.getAttribute("sessionRole");

	    if (role == null || !role.equals("ADMIN")) {
	        return "redirect:/admin/login.do";
	    }

	    return "/admin/adminReport";
	}

	@RequestMapping("/admin/userManage.do") 
	public String adminUserManage(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HttpSession session = request.getSession();
	    String role = (String) session.getAttribute("sessionRole");

	    if (role == null || !role.equals("ADMIN")) {
	        return "redirect:/admin/login.do";
	    }

	    return "/admin/adminUserManage";
	}

	@RequestMapping("/admin/userCommunity.do") 
	public String adminUserCommunity(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HttpSession session = request.getSession();
	    String role = (String) session.getAttribute("sessionRole");

	    if (role == null || !role.equals("ADMIN")) {
	        return "redirect:/admin/login.do";
	    }

	    model.addAttribute("userId", map.get("userId"));

	    return "/admin/adminUserCommunity";
	}

	@RequestMapping("/admin/businessUserManage.do") 
	public String adminBusinessUserManage(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HttpSession session = request.getSession();
	    String role = (String) session.getAttribute("sessionRole");

	    if (role == null || !role.equals("ADMIN")) {
	        return "redirect:/admin/login.do";
	    }

	    model.addAttribute("kakaoMapApiKey", kakaoJavascriptKey);

	    return "/admin/adminBusinessUserManage";
	}

	@RequestMapping("/admin/storeApprove.do") 
	public String adminStoreApprove(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HttpSession session = request.getSession();
	    String role = (String) session.getAttribute("sessionRole");

	    if (role == null || !role.equals("ADMIN")) {
	        return "redirect:/admin/login.do";
	    }

	    model.addAttribute("kakaoJavascriptKey", kakaoJavascriptKey);

	    return "/admin/adminStoreApprove";
	}

	@RequestMapping("/admin/qnaAnswer.do") 
	public String adminQnaAnswer(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HttpSession session = request.getSession();
	    String role = (String) session.getAttribute("sessionRole");

	    if (role == null || !role.equals("ADMIN")) {
	        return "redirect:/admin/login.do";
	    }

	    return "/admin/adminQnaAnswer";
	}
	
	@RequestMapping(value = "/admin/login.dox", method = RequestMethod.POST)
	public String adminLoginCheck(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {

		Admin admin = adminService.getLoginAdmin(map);

		if (admin != null) {
			HttpSession session = request.getSession();

			session.setAttribute("sessionId", admin.getAdminId());
			session.setAttribute("sessionRole", "ADMIN");

			return "redirect:/admin.do";
		}

		request.setAttribute("msg", "아이디 또는 비밀번호가 틀렸습니다.");
		return "/admin/adminLogin";
	}
	
	@RequestMapping(value = "/admin/qna/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getQnaAnswerList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

	    HashMap<String, Object> resultMap = adminService.getQnaAnswerList(map);

	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/admin/qna/answer.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editQnaAnswer(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

	    HashMap<String, Object> resultMap = adminService.editQnaAnswer(map);

	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/admin/qna/delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeQna(Model model, @RequestParam HashMap<String, Object> map) throws Exception {

	    HashMap<String, Object> resultMap = adminService.removeQna(map);

	    return new Gson().toJson(resultMap);
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

	@RequestMapping(value = "/admin/biz/reapplyInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBizReapplyInfo(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		HttpSession session = request.getSession();
		String sessionId = (String) session.getAttribute("sessionId");
		String role = (String) session.getAttribute("sessionRole");

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		if (sessionId == null || !"BIZ".equals(role)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("oldSUserId", sessionId);
		resultMap = adminService.getBizReapplyInfo(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/biz/externalStoreList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getBizExternalStoreList(HttpServletRequest request, @RequestParam HashMap<String, Object> map) throws Exception {
		HttpSession session = request.getSession();
		String sessionId = (String) session.getAttribute("sessionId");
		String role = (String) session.getAttribute("sessionRole");

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		if (sessionId == null || !"BIZ".equals(role)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("oldSUserId", sessionId);
		resultMap = adminService.getBizExternalStoreList(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/biz/reapply.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editBizReapply(HttpServletRequest request,
			@RequestParam HashMap<String, Object> map,
			@RequestParam(value = "bizFile", required = false) MultipartFile bizFile) throws Exception {

		HttpSession session = request.getSession();
		String sessionId = (String) session.getAttribute("sessionId");
		String role = (String) session.getAttribute("sessionRole");

		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		if (sessionId == null || !"BIZ".equals(role)) {
			resultMap.put("result", "fail");
			resultMap.put("message", "로그인이 필요합니다.");
			return new Gson().toJson(resultMap);
		}

		map.put("oldSUserId", sessionId);

		if (bizFile != null && !bizFile.isEmpty()) {
			try {
				String originName = bizFile.getOriginalFilename();

				String fileExt = "";
				if (originName != null && originName.contains(".")) {
					fileExt = originName.substring(originName.lastIndexOf(".") + 1).toLowerCase();
				}

				String saveName = System.currentTimeMillis() + "_" + originName;

				String uploadPath = request.getServletContext().getRealPath("/img/bizfile/");
				File dir = new File(uploadPath);

				if (!dir.exists()) {
					dir.mkdirs();
				}

				File saveFile = new File(uploadPath, saveName);
				bizFile.transferTo(saveFile);

				map.put("bizFileName", saveName);
				map.put("fileName", saveName);
				map.put("originName", originName);
				map.put("filePath", "/img/bizfile/");
				map.put("fileExt", fileExt);
				map.put("fileSize", bizFile.getSize());
				map.put("isProof", "Y");

			} catch (Exception e) {
				e.printStackTrace();

				resultMap.put("result", "fail");
				resultMap.put("message", "사업자등록증 파일 저장 중 오류가 발생했습니다.");
				return new Gson().toJson(resultMap);
			}
		}

		resultMap = adminService.editBizReapply(map);

		if ("success".equals(resultMap.get("result"))) {
			session.setAttribute("sessionName", map.get("ceoName"));
			session.setAttribute("storeStatus", "PND");
		}

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
	
	@RequestMapping(value = "/admin/report/communityPostList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCommunityPostReportList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = adminService.getCommunityPostReportList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/communityCommentList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCommunityCommentReportList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap = adminService.getCommunityCommentReportList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/communityReject.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rejectCommunityReport(@RequestParam HashMap<String, Object> map) {

	    adminService.rejectCommunityReport(map);

	    Map<String, Object> result = new HashMap<>();
	    result.put("result", "success");

	    return new Gson().toJson(result);
	}

	@RequestMapping(value = "/admin/report/communityApprove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String approveCommunityReport(@RequestParam HashMap<String, Object> map) {

	    adminService.approveCommunityReport(map);

	    Map<String, Object> result = new HashMap<>();
	    result.put("result", "success");

	    return new Gson().toJson(result);
	}

	@RequestMapping(value = "/admin/user/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/basic.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserBasic(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserBasic(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/statusUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateAdminUserStatus(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.updateAdminUserStatus(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/nicknameUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateAdminUserNickname(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.updateAdminUserNickname(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/petList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserPetList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserPetList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/subscription.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserSubscription(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserSubscription(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/pointList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserPointList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserPointList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/couponList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserCouponList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserCouponList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/orderList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserOrderList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserOrderList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/reservationList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserReservationList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserReservationList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/reviewList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserReviewList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserReviewList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/reportList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserReportList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserReportList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/communityPostList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserCommunityPostList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserCommunityPostList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/user/communityCommentList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminUserCommunityCommentList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminUserCommunityCommentList(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/admin/businessUser/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminBusinessUserList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminBusinessUserList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/businessUser/basic.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminBusinessUserBasic(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminBusinessUserBasic(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/businessUser/storeDetail.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminBusinessUserStoreDetail(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminBusinessUserStoreDetail(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/businessUser/reviewList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminBusinessUserReviewList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminBusinessUserReviewList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/businessUser/reportList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminBusinessUserReportList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminBusinessUserReportList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/businessUser/reservationList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAdminBusinessUserReservationList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getAdminBusinessUserReservationList(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/admin/report/reservationGroupList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReservationReviewReportGroupList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getReservationReviewReportGroupList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/reservationDetailList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getReservationReviewReportDetailList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getReservationReviewReportDetailList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/communityPostGroupList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCommunityPostReportGroupList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getCommunityPostReportGroupList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/communityPostDetailList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCommunityPostReportDetailList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getCommunityPostReportDetailList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/communityCommentGroupList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCommunityCommentReportGroupList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getCommunityCommentReportGroupList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/communityCommentDetailList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getCommunityCommentReportDetailList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.getCommunityCommentReportDetailList(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/batchApprove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String approveReportBatch(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.approveReportBatch(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/report/batchReject.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String rejectReportBatch(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.rejectReportBatch(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/admin/businessUser/statusUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateAdminBusinessUserStatus(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.updateAdminBusinessUserStatus(map);
	    return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/admin/businessUser/storeStatusUpdate.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateAdminBusinessStoreStatus(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = adminService.updateAdminBusinessStoreStatus(map);
	    return new Gson().toJson(resultMap);
	}

}