package com.example.unipet.model;

import lombok.Data;

@Data
public class Admin {
	
    // STORE
    int storeNo;
    String storeName;
    String sCategory;
    String sAddr;
    String sFullAddr;
    String sStatus;

    // STORE_USER
    String sUserId;
    String uStatus;

    // STORE_FILE
    String filePath;
    String fileName;
    String originName;

}
