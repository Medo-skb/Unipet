package com.example.unipet.model;

import lombok.Data;

@Data
public class Board {

	// ===== 게시글 =====
	int boardNo;
	int bSubNo;
	int localNo;
	String title;
	String bContent;
	String userId;
	int viewCount;
	String bStatus;
	String privateYn;
	String createTime;
	String updateTime;

	// ===== 게시판 대분류/소분류 =====
	int bMainNo;
	String bMainType;
	String bSubType;

	// ===== 지역 =====
	String localName;

	// ===== 좋아요 / 댓글 수 =====
	int likeCnt;
	int commentCnt;
	String myLike;

	// ===== 파일 =====
	int fileNo;
	String filePath;
	String fileName;
	String originName;
	long fileSize;
	String fileExt;
	String fileUrl;
	String thumbnail;

	// ===== 댓글 =====
	int commentNo;
	String cContent;
	Integer parentNo;

	// ===== 신고 =====
	String reporterId;
	String reportReason;
	String repStatus;

	// ===== 알림 =====
	int alarmNo;
	String receiverId;
	String senderId;
	String alarmType;
	String alarmContent;
	String readYn;
	String cdate;

	// ===== 화면 표시용 =====
	int displayNo;

}