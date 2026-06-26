package com.example.unipet.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.common.Message;
import com.example.unipet.mapper.MainMapper;
import com.example.unipet.model.Main;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MainService {

	@Autowired 
    MainMapper mainMapper;
    
	// 메인 리스트
    public HashMap<String, Object> getMainBasicList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Main> list = mainMapper.selectPopularStoreList(map);
			List<Main> list2 = mainMapper.selectPopularProductList(map);
			List<Main> list3 = mainMapper.selectStoreByCategoryList(map);
			List<Main> list4 = mainMapper.selectProductByCategoryList(map);
			List<Main> list5 = mainMapper.selectAnimalMainCategoryList(map);
			
			resultMap.put("list", list);
			resultMap.put("list2", list2);
			resultMap.put("list3", list3);
			resultMap.put("list4", list4);
			resultMap.put("list5", list5);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
    
 // 소셜 로그인 기본정보 입력 여부 체크
    public HashMap<String, Object> socialBasicCheck(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            Main user = mainMapper.selectSocialBasicCheck(map);

            resultMap.put("result", "success");
            resultMap.put("needBasicInfo", user != null);

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("needBasicInfo", false);
            resultMap.put("message", Message.MSG_SERVER_ERR);
        }

        return resultMap;
    }
    
    // 통합 검색 업체
	public HashMap<String, Object> getSearchStoreList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Main> list = mainMapper.selectSearchStoreList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 업체 개수
	public HashMap<String, Object> getSearchStoreCount(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int count = mainMapper.selectSearchStoreCount(map);
			
			resultMap.put("count", count);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 통합 검색 상품
	public HashMap<String, Object> getSearchProductList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Main> list = mainMapper.selectSearchProductList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 상품 개수
	public HashMap<String, Object> getSearchProductCount(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int count = mainMapper.selectSearchProductCount(map);
			
			resultMap.put("count", count);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 통합 검색 커뮤니티
	public HashMap<String, Object> getSearchBoardList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Main> list = mainMapper.selectSearchBoardList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 커뮤니티 개수
	public HashMap<String, Object> getSearchBoardCount(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int count = mainMapper.selectSearchBoardCount(map);
			
			resultMap.put("count", count);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
	// 유치원 보내주개
	public HashMap<String, Object> getKindergartenStoreList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Main> list = mainMapper.selectKindergartenStoreList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.MSG_SEARCH);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.MSG_SERVER_ERR);
		}
		return resultMap;
	}
	
    // 홈페이지 문의 등록
    public HashMap<String, Object> insertUnipetQna(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            int cnt = mainMapper.insertUnipetQna(map);

            if (cnt > 0) {
                resultMap.put("result", "success");
                resultMap.put("message", "문의가 등록되었습니다.");
            } else {
                resultMap.put("result", "fail");
                resultMap.put("message", "문의 등록에 실패했습니다.");
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", Message.MSG_SERVER_ERR);
        }

        return resultMap;
    }

    // 홈페이지 문의 내역 조회
    public HashMap<String, Object> getUnipetQnaList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            int page = 1;
            int pageSize = 10;

            if (map.get("page") != null && !map.get("page").toString().equals("")) {
                page = Integer.parseInt(map.get("page").toString());
            }

            int start = (page - 1) * pageSize;

            map.put("start", start);
            map.put("pageSize", pageSize);

            List<Main> list = mainMapper.selectUnipetQnaList(map);
            int count = mainMapper.selectUnipetQnaCount(map);

            resultMap.put("list", list);
            resultMap.put("count", count);
            resultMap.put("page", page);
            resultMap.put("pageSize", pageSize);
            resultMap.put("result", "success");
            resultMap.put("message", Message.MSG_SEARCH);

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", Message.MSG_SERVER_ERR);
        }

        return resultMap;
    }
    
}