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
import com.example.unipet.model.Reservation;
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

	    // 1. 예약 메인 정보 저장
	    int res1 = reservationMapper.insertReservation(map);

	    // 2. 로그 기록을 위한 필수 파라미터 추가
	    // MyBatis XML의 #{action}, #{newStatus}, #{remark}와 매칭됩니다.
	    map.put("action", "CREATE");
	    map.put("newStatus", "WAI");
	    map.put("remark", "신규 예약 신청 완료 (결제 대기)");

	    // 3. 로그 저장
	    int res2 = reservationMapper.insertRsvLog(map);

	    if (res1 > 0 && res2 > 0) {
	        resultMap.put("result", "success");
	        resultMap.put("rsvNo", map.get("rsvNo")); // selectKey 등으로 채워진 rsvNo 반환
	    } else {
	        // 트랜잭션 처리를 위해 RuntimeException이나 명시적 Exception 발생
	        throw new Exception("예약 신청 중 오류가 발생했습니다.");
	    }
	    return resultMap;
	}

	// 2. 예약 확정 (결제 완료 확인 후 슬롯 업데이트 처리)
	
	// 결제 완료가 되면 (결제 시스템 개발자가) completeReservation을 호출해야함
	
	@Transactional(rollbackFor = Exception.class)
	public HashMap<String, Object> completeReservation(HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = new HashMap<>();

	    // 1. 슬롯 업데이트 실행 (XML에서 CNF 상태를 확인하므로 로직은 동일)
	    int resSlot = reservationMapper.updateRsvSlot(map);
	    
	    if (resSlot <= 0) {
	        resultMap.put("result", "fail");
	        resultMap.put("message", "예약 확정 조건을 만족하지 않거나 마감된 슬롯입니다.");
	        return resultMap;
	    }

	    // 2. 로그 파라미터 세팅 (WAI -> CNF)
	    map.put("action", "UPDATE_SLOT");
	    map.put("oldStatus", "WAI");
	    map.put("newStatus", "CNF"); // [수정] COM에서 CNF로 변경
	    map.put("remark", "결제 승인 확인: 슬롯 카운트 증가 및 상태 업데이트");
	    
	    // 3. 로그 기록
	    reservationMapper.insertRsvLog(map);

	    resultMap.put("result", "success");
	    return resultMap;
	}
	
	public HashMap<String, Object> getRsvInfo(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Reservation info = reservationMapper.selectRsvInfo(map);
			
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
	public void removeRsv(HashMap<String, Object> map) throws Exception {
	    // 1. RESERVATION 테이블 상태 변경 (CNF -> CAN)
	    reservationMapper.updateRsvStatusCancel(map);
	    
	    // 2. RSV_SLOT 테이블 카운트 감소 및 가용성 복구
	    reservationMapper.updateRsvSlotCancel(map);
	    
	    // 3. RSV_LOG 테이블 이력 기록
	    map.put("action", "CANCEL");
	    map.put("oldStatus", "CNF");
	    map.put("newStatus", "CAN");
	    map.put("remark", "결제 승인 후 취소");
	    reservationMapper.insertRsvLog(map);
	}
	
}