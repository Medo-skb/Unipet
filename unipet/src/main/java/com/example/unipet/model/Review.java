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
		
}
