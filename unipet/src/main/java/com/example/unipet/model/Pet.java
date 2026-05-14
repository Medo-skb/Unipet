package com.example.unipet.model;

import lombok.Data;

@Data
public class Pet {
	private String petNo;
	private String petName;
	private String species;
	private String breed;
	private String birthdate;
	private String gender;
	private String isMain;
	
}
