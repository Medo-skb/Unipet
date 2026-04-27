package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.PetMapper;
import com.example.unipet.mapper.ReservationMapper;
import com.example.unipet.mapper.ReviewMapper;
import com.example.unipet.model.Pet;
import com.example.unipet.model.Reservation;
import com.example.unipet.model.Store;

@Service
public class ReservationService {

	@Autowired 
	ReservationMapper reservationMapper;
	
	@Autowired
    ReviewMapper reviewMapper;
	
	@Autowired
    PetMapper petMapper;
	
	// 조회 -> get, 수정 -> edit, 삽입 -> add, 삭제 -> remove
	// ex) 학생목록 : getStudentList, 학생수정 -> editStudent
	
	// === Mapper 호출 시 === 
	// 여러개 리턴 -> selectXXXList
	//	List<User> list = defaultMapper.selectUserList();
	// 한개 리턴 -> selectXXX
	//	User info = defaultMapper.selectUser();
	// 수정, 삭제, 삽입 -> updateXXX, deleteXXX, insertXXX
	//	int result = defaultMapper.updateXXX();
	
	public HashMap<String, Object> getStoreList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Store> list = reservationMapper.selectStoreList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getStoreInfo(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Store info = reservationMapper.selectStoreInfo(map);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getStoreMenuList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Store> list = reservationMapper.selectStoreMenuList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getStoreImgList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Store> list = reservationMapper.selectStoreImgList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getStoreReviewList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Store> list = reservationMapper.selectStoreReviewList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getStoreReviewSummary(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    
	    HashMap<String, Object> summary = reservationMapper.selectStoreReviewSummary(map);
	    
	    if (summary != null) {
	        resultMap.put("count", summary.get("REVIEW_COUNT"));
	        resultMap.put("avg", summary.get("REVIEW_AVG"));
	    } else {
	        resultMap.put("count", 0);
	        resultMap.put("avg", 0);
	    }
	    
	    return resultMap;
	}
	
	public HashMap<String, Object> getStoreSlotList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Store> list = reservationMapper.selectStoreSlotList(map);
			
			resultMap.put("timelist", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getPetList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Pet> list = petMapper.selectPetList(map);
			
			resultMap.put("petlist", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getStorePolicy(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Store info = reservationMapper.selectStorePolicy(map);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_ADD);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> addReservation(HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    int res1 = reservationMapper.insertReservation(map);

	    map.put("action", "CREATE");
	    map.put("newStatus", "WAI");
	    map.put("remark", "신규 예약 신청 완료 (결제 대기)");

	    int res2 = reservationMapper.insertRsvLog(map);

	    if (res1 > 0 && res2 > 0) {
	        resultMap.put("result", "success");
	        resultMap.put("rsvNo", map.get("rsvNo"));
	    } else {
	        throw new Exception("예약 신청 중 오류가 발생했습니다.");
	    }
	    return resultMap;
	}

	// 결제 완료가 되면 (결제 시스템 개발자가) completeReservation을 호출해야함
	
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> completeReservation(HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    int resSlot = reservationMapper.updateRsvSlot(map);
	    
	    if (resSlot <= 0) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "예약 확정 조건을 만족하지 않거나 마감된 슬롯입니다.");
	        
	        throw new RuntimeException("예약 확정 실패: 마감 시간이 지났거나 유효하지 않은 예약입니다.");
	        
	    }

	    map.put("action", "UPDATE_SLOT");
	    map.put("oldStatus", "WAI");
	    map.put("newStatus", "CNF");
	    map.put("remark", "결제 승인 확인: 슬롯 카운트 증가 및 상태 업데이트");
	    
	    reservationMapper.insertRsvLog(map);

	    resultMap.put("result", "success");
	    return resultMap;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void removeRsv(HashMap<String, Object> map) throws Exception {
	    reservationMapper.updateRsvStatusCancel(map);
	    
	    reservationMapper.updateRsvSlotCancel(map);
	    
	    map.put("action", "CANCEL");
	    map.put("oldStatus", "CNF");
	    map.put("newStatus", "CAN");
	    map.put("remark", "결제 승인 후 취소");
	    reservationMapper.insertRsvLog(map);
	}
	
	
	@Transactional
	public int processAutoFinish(HashMap<String, Object> map) {
	    // 1. 종료 시간 30분이 지난 'COM' 상태 예약들 조회
	    List<Reservation> expiredList = reservationMapper.selectExpiredReservations(map);
	    
	    if (expiredList == null || expiredList.isEmpty()) {
	        return 0;
	    }

	    for (Reservation rsv : expiredList) {
	        // 2. 상태를 'FIN'으로 변경 (rsvNo 필드 사용)
	        HashMap<String, Object> updateMap = new HashMap<>();
	        updateMap.put("rsvNo", rsv.getRsvNo()); 
	        reservationMapper.updateRsvStatusToFin(updateMap);

	        // 3. 로그 기록 (기존 insertRsvLog 재사용)
	        HashMap<String, Object> logMap = new HashMap<>();
	        logMap.put("rsvNo", rsv.getRsvNo());
	        logMap.put("action", "AUTO_FINISH");
	        logMap.put("oldStatus", "COM");
	        logMap.put("newStatus", "FIN");
	        logMap.put("actorType", "SYSTEM");
	        logMap.put("userId", "SYSTEM");
	        logMap.put("remark", "이용시간 30분 경과 자동 종료");
	        
	        reservationMapper.insertRsvLog(logMap);
	    }
	    
	    return expiredList.size(); // 처리된 건수 반환
	}
	
	@Transactional
	public int processAutoCancel(int minutes) {
	    // 1. ReservationVO 대신 Reservation 클래스 사용
	    List<Reservation> expiredReservations = reservationMapper.selectExpiredWaiList(minutes);
	    
	    int count = 0;
	    for (Reservation rsv : expiredReservations) {
	        // 2. 상태 업데이트
	        int updated = reservationMapper.updateStatusToCancel(rsv.getRsvNo());
	        
	        if (updated > 0) {
	            // 3. rsv_log 기록
	            HashMap<String, Object> logMap = new HashMap<>();
	            logMap.put("rsvNo", rsv.getRsvNo());
	            logMap.put("action", "AUTO_CANCEL");
	            logMap.put("oldStatus", "WAI");
	            logMap.put("newStatus", "CAN");
	            logMap.put("actorType", "SYSTEM");
	            logMap.put("userId", "SYSTEM"); // 기존 매퍼의 #{userId}와 대응
	            logMap.put("remark", minutes + "분 내 미결제로 인한 자동 취소");
	            
	            reservationMapper.insertRsvLog(logMap);
	            count++;
	        }
	    }
	    return count;
	}
	
}