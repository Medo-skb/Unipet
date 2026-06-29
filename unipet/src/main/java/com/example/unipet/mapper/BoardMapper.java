package com.example.unipet.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.unipet.model.Board;

@Mapper
public interface BoardMapper {

	// 여러개 리턴 -> selectXXXList
	public List<Board> selectBoardMainTypeList(HashMap<String, Object> map);

	public List<Board> selectBoardSubTypeList(HashMap<String, Object> map);

	public List<Board> selectBoardLocalList(HashMap<String, Object> map);

	public List<Board> selectBoardList(HashMap<String, Object> map);

	public List<Board> selectBoardFileList(HashMap<String, Object> map);

	public List<Board> selectCommentList(HashMap<String, Object> map);

	public List<Board> selectBoardAlarmList(HashMap<String, Object> map);

	// 금칙어 목록 조회
	public List<String> selectBadWordList();

	// 한개 리턴 -> selectXXX
	public int selectBoardCnt(HashMap<String, Object> map);

	public Board selectBoardInfo(HashMap<String, Object> map);

	public Board selectBoardLikeInfo(HashMap<String, Object> map);

	public Board selectBoardLikeCheck(HashMap<String, Object> map);

	public Board selectBoardInfoForEdit(HashMap<String, Object> map);

	public Board selectCommentInfo(HashMap<String, Object> map);

	public Board selectBoardFileInfo(HashMap<String, Object> map);

	public Board selectRecentTempBoard(HashMap<String, Object> map);

	public Board selectPrevBoardInfo(HashMap<String, Object> map);

	public Board selectNextBoardInfo(HashMap<String, Object> map);

	// 삭제
	public int deleteBoardLike(HashMap<String, Object> map);

	public int deleteBoard(HashMap<String, Object> map);

	public int deleteComment(HashMap<String, Object> map);

	public int deleteBoardFile(HashMap<String, Object> map);

	// 수정
	public int updateViewCount(HashMap<String, Object> map);

	public int updateBoard(HashMap<String, Object> map);

	public int updateComment(HashMap<String, Object> map);

	public int updateBoardAlarmRead(HashMap<String, Object> map);

	// 삽입
	public int insertComment(HashMap<String, Object> map);

	public int insertBoardLike(HashMap<String, Object> map);

	public int insertBoardReport(HashMap<String, Object> map);

	public int insertBoard(HashMap<String, Object> map);

	public int insertBoardFile(HashMap<String, Object> map);

	public int insertBoardAlarm(HashMap<String, Object> map);

}