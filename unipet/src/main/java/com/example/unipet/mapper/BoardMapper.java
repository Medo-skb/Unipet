package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardMapper {

	public List<HashMap<String, Object>> selectBoardMainTypeList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectBoardSubTypeList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectBoardLocalList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectBoardList(HashMap<String, Object> map);

	public int selectBoardCnt(HashMap<String, Object> map);

	public int updateViewCount(HashMap<String, Object> map);

	public HashMap<String, Object> selectBoardInfo(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectBoardFileList(HashMap<String, Object> map);

	public HashMap<String, Object> selectBoardLikeInfo(HashMap<String, Object> map);

	public List<HashMap<String, Object>> selectCommentList(HashMap<String, Object> map);

	public int insertComment(HashMap<String, Object> map);

	public HashMap<String, Object> selectBoardLikeCheck(HashMap<String, Object> map);

	public int insertBoardLike(HashMap<String, Object> map);

	public int deleteBoardLike(HashMap<String, Object> map);

	public int insertBoardReport(HashMap<String, Object> map);
	
	public int insertBoard(HashMap<String, Object> map);

	public HashMap<String, Object> selectBoardInfoForEdit(HashMap<String, Object> map);

	public int updateBoard(HashMap<String, Object> map);

	public int deleteBoard(HashMap<String, Object> map);
	
	public HashMap<String, Object> selectCommentInfo(HashMap<String, Object> map);

	public int updateComment(HashMap<String, Object> map);

	public int deleteComment(HashMap<String, Object> map);
	
	public int insertBoardFile(HashMap<String, Object> map);

}