package com.example.unipet.model;

import lombok.Data;

@Data
public class Reservation {
	private String rsvNo;
	private String slotNo;
	private String slotDate;
	private String slotTime;
	private String userId;
	private String petName;
	private String species;
	private String breed;
	private String menuName;
	private String menuPrice;
	private String request;
	
}
