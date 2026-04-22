package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.mapper.UserMypageMapper;

@Service
public class UserMypageService {

    @Autowired
    private UserMypageMapper userMypageMapper;

    private void convertDateFields(HashMap<String, Object> map) {
        if (map == null) {
            return;
        }

        Object birthdate = map.get("birthdate");
        Object cdate = map.get("cdate");
        Object rsvDate = map.get("rsvDate");
        Object orderDate = map.get("orderDate");

        if (birthdate != null) {
            map.put("birthdate", birthdate.toString());
        }

        if (cdate != null) {
            map.put("cdate", cdate.toString());
        }

        if (rsvDate != null) {
            map.put("rsvDate", rsvDate.toString());
        }

        if (orderDate != null) {
            map.put("orderDate", orderDate.toString());
        }
    }

    public HashMap<String, Object> getMypageData(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            HashMap<String, Object> userInfo = userMypageMapper.getUserInfo(map);
            result.put("result", "success");
            result.put("userInfo", userInfo);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "마이페이지 정보 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> updateUserInfo(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int cnt = userMypageMapper.updateUser(map);

            if (cnt > 0) {
                result.put("result", "success");
                result.put("message", "회원정보가 수정되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "회원정보 수정에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "회원정보 수정 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> checkPassword(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            HashMap<String, Object> user = userMypageMapper.checkPassword(map);

            if (user != null) {
                result.put("result", "success");
                result.put("message", "비밀번호가 일치합니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "비밀번호가 일치하지 않습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "비밀번호 확인 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> changePassword(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int cnt = userMypageMapper.changePwd(map);

            if (cnt > 0) {
                result.put("result", "success");
                result.put("message", "비밀번호가 변경되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "비밀번호 변경에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> deleteUser(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            int cnt = userMypageMapper.deleteUser(map);

            if (cnt > 0) {
                result.put("result", "success");
                result.put("message", "회원 탈퇴가 완료되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "회원 탈퇴에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "회원 탈퇴 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> getPetList(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            List<HashMap<String, Object>> petList = userMypageMapper.getPetList(map);

            for (HashMap<String, Object> pet : petList) {
                convertDateFields(pet);
            }

            result.put("result", "success");
            result.put("petList", petList);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "반려동물 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> addPet(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            String petName = map.get("petName") == null ? "" : map.get("petName").toString().trim();
            String species = map.get("species") == null ? "" : map.get("species").toString().trim();

            if (petName.isEmpty()) {
                result.put("result", "fail");
                result.put("message", "반려동물 이름은 필수입니다.");
                return result;
            }

            if (species.isEmpty()) {
                result.put("result", "fail");
                result.put("message", "종(species)은 필수입니다.");
                return result;
            }

            int petCount = userMypageMapper.countPet(map);
            map.put("isMain", petCount == 0 ? "Y" : "N");

            int cnt = userMypageMapper.addPet(map);

            if (cnt > 0) {
                result.put("result", "success");
                result.put("message", "반려동물 정보가 등록되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "반려동물 등록에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "반려동물 등록 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> updatePet(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            String petName = map.get("petName") == null ? "" : map.get("petName").toString().trim();
            String species = map.get("species") == null ? "" : map.get("species").toString().trim();

            if (petName.isEmpty()) {
                result.put("result", "fail");
                result.put("message", "반려동물 이름은 필수입니다.");
                return result;
            }

            if (species.isEmpty()) {
                result.put("result", "fail");
                result.put("message", "종(species)은 필수입니다.");
                return result;
            }

            int cnt = userMypageMapper.updatePet(map);

            if (cnt > 0) {
                result.put("result", "success");
                result.put("message", "반려동물 정보가 수정되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "반려동물 수정에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "반려동물 수정 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> deletePet(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            HashMap<String, Object> petInfo = userMypageMapper.getPetByPetNo(map);
            convertDateFields(petInfo);

            int cnt = userMypageMapper.deletePet(map);

            if (cnt > 0) {
                if (petInfo != null && "Y".equals(String.valueOf(petInfo.get("isMain")))) {
                    HashMap<String, Object> firstPet = userMypageMapper.getFirstPet(map);
                    if (firstPet != null && firstPet.get("petNo") != null) {
                        HashMap<String, Object> mainMap = new HashMap<>();
                        mainMap.put("userId", map.get("userId"));
                        mainMap.put("petNo", firstPet.get("petNo"));
                        userMypageMapper.changeMainPet(mainMap);
                    }
                }

                result.put("result", "success");
                result.put("message", "반려동물 정보가 삭제되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "반려동물 삭제에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "반려동물 삭제 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> changeMainPet(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            userMypageMapper.resetMainPet(map);
            int cnt = userMypageMapper.changeMainPet(map);

            if (cnt > 0) {
                result.put("result", "success");
                result.put("message", "대표 프로필이 변경되었습니다.");
            } else {
                result.put("result", "fail");
                result.put("message", "대표 프로필 변경에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "대표 프로필 변경 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> getReservationList(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            List<HashMap<String, Object>> reservationList = userMypageMapper.getReservationList(map);

            for (HashMap<String, Object> item : reservationList) {
                convertDateFields(item);
            }

            result.put("result", "success");
            result.put("reservationList", reservationList);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "예약 내역 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    public HashMap<String, Object> getReservationAllList(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            List<HashMap<String, Object>> reservationList = userMypageMapper.getReservationAllList(map);

            for (HashMap<String, Object> item : reservationList) {
                convertDateFields(item);
            }

            result.put("result", "success");
            result.put("reservationList", reservationList);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "전체 예약 내역 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 추가
    public HashMap<String, Object> getOrderList(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            List<HashMap<String, Object>> orderList = userMypageMapper.getOrderList(map);

            for (HashMap<String, Object> item : orderList) {
                convertDateFields(item);
            }

            result.put("result", "success");
            result.put("orderList", orderList);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", "주문 내역 조회 중 오류가 발생했습니다.");
        }

        return result;
    }
}