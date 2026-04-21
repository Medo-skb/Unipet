package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.PetMapper;
import com.example.unipet.mapper.ReservationMapper;
import com.example.unipet.model.Pet;
import com.example.unipet.model.Store;

@Service
public class ReservationService {

	@Autowired 
	ReservationMapper reservationMapper;
	
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
	
	@Transactional
	public HashMap<String, Object> addReservation(HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    // 예약 테이블 및 로그만 기록 (상태는 기본값 WAI 등으로 입력됨)
	    int res1 = reservationMapper.insertReservation(map);
	    int res2 = reservationMapper.insertRsvLog(map);

	    if (res1 > 0 && res2 > 0) {
	        resultMap.put("result", "success");
	        resultMap.put("rsvNo", map.get("rsvNo"));
	    } else {
	        throw new Exception("예약 신청 실패");
	    }
	    return resultMap;
	}

	// 2. 예약 확정 (결제 완료 확인 후 슬롯 업데이트 처리)
	
	// 결제 완료가 되면 (결제 시스템 개발자가) completeReservation을 호출해야함
	
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> completeReservation(HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    // [STEP 1] 슬롯 업데이트 실행 
	    // 매퍼 내부의 EXISTS 조건에 의해 rsv_status가 'COM'이 아니면 업데이트가 되지 않음
	    int resSlot = reservationMapper.updateRsvSlotCount(map);
	    
	    if (resSlot <= 0) {
	        // 업데이트된 행이 0개라면: 상태가 'COM'이 아니거나, 이미 자리가 찼거나, slotNo가 틀린 경우
	        resultMap.put("result", "fail");
	        resultMap.put("message", "예약 확정 조건(결제 완료 상태)이 아니거나 슬롯이 마감되었습니다.");
	        return resultMap;
	    }

	    // [STEP 2] 결제 완료 및 슬롯 반영 로그 추가
	    map.put("action", "UPDATE_SLOT");
	    map.put("newStatus", "COM");
	    map.put("actorType", "SYSTEM");
	    reservationMapper.insertRsvLog(map);

	    resultMap.put("result", "success");
	    return resultMap;
	}
	
}