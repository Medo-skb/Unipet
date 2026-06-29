package com.example.unipet.model;

import lombok.Data;

@Data
public class Review {
	private String userId;
	private String nickname;
	private String rating;
	private String rContents;
	private String cdate;
	private String rsvNo;
	private String filePaths;
	private String fileNames;
		

	// 리뷰 기본 정보
	private int reviewNo;
	private int storeNo;
	private int productNo;

	// 리뷰 AI 요약 정보
	private int summaryNo;
	private String targetType;
	private int targetNo;
	private String summaryText;
	private int lastReviewNo;
	private String summaryStatus;
	private String udate;
}
