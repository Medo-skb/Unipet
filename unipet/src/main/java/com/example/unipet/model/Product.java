package com.example.unipet.model;


public class Product {
	// 1. PRODUCT 테이블 필드
    int productNo;          // PRODUCT_NO (PK)
    int storeNo;            // STORE_NO (입점업체 번호)
    String productName;     // PRODUCT_NAME
    String brand;           // BRAND
    int productPrice;       // PRODUCT_PRICE
    int stockQty;           // STOCK_QTY
    int aSubNo;             // A_SUB_NO (동물 소분류)
    int iSubNo;             // I_SUB_NO (상품 소분류)
    String productStatus;    // PRODUCT_STATUS (판매상태)
    String cdate;           // CDATE (등록일)

    // 2. 검색 및 필터링용 필드 (설계 2번 반영)
    String aMainType;       // A_MAIN_TYPE (동물 대분류명)
    String aSubType;        // A_SUB_TYPE (동물 소분류명)
    String iMainType;       // I_MAIN_TYPE (상품 대분류명)
    String iSubType;        // I_SUB_TYPE (상품 소분류명)
    String sortType;        // 정렬 기준 (가격순, 판매량순 등)
    String keyword;         // 검색어

    // 3. 리뷰 및 Q&A용 필드 (설계 3, 4번 반영)
    int starRating;         // STAR_RATING (별점)
    String reviewContents;  // REVIEW_CONTENTS (리뷰 내용)
    String qnaTitle;        // QNA_TITLE (문의 제목)
    String qContents;       // Q_CONTENTS (문의 내용)
    String aContents;       // A_CONTENTS (답변 내용)
    String isSecret;        // IS_SECRET (비밀글 여부 'Y'/'N')
    String ansStatus;       // ANS_STATUS (답변 여부)

    // 4. 장바구니 및 주문용 필드
    String userId;          // USER_ID (유저 아이디)
    int qty;                // QTY (장바구니/주문 수량)
    int ordNo;              // ORD_NO (주문 번호)
    
    // 5. 파일(이미지) 정보
    String filePath;        // FILE_PATH (이미지 경로)
    String fileName;        // FILE_NAME (이미지 이름)
    
    
	public int getProductNo() {
		return productNo;
	}
	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}
	public int getStoreNo() {
		return storeNo;
	}
	public void setStoreNo(int storeNo) {
		this.storeNo = storeNo;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public int getProductPrice() {
		return productPrice;
	}
	public void setProductPrice(int productPrice) {
		this.productPrice = productPrice;
	}
	public int getStockQty() {
		return stockQty;
	}
	public void setStockQty(int stockQty) {
		this.stockQty = stockQty;
	}
	public int getaSubNo() {
		return aSubNo;
	}
	public void setaSubNo(int aSubNo) {
		this.aSubNo = aSubNo;
	}
	public int getiSubNo() {
		return iSubNo;
	}
	public void setiSubNo(int iSubNo) {
		this.iSubNo = iSubNo;
	}
	public String getProductStatus() {
		return productStatus;
	}
	public void setProductStatus(String productStatus) {
		this.productStatus = productStatus;
	}
	public String getCdate() {
		return cdate;
	}
	public void setCdate(String cdate) {
		this.cdate = cdate;
	}
	public String getaMainType() {
		return aMainType;
	}
	public void setaMainType(String aMainType) {
		this.aMainType = aMainType;
	}
	public String getaSubType() {
		return aSubType;
	}
	public void setaSubType(String aSubType) {
		this.aSubType = aSubType;
	}
	public String getiMainType() {
		return iMainType;
	}
	public void setiMainType(String iMainType) {
		this.iMainType = iMainType;
	}
	public String getiSubType() {
		return iSubType;
	}
	public void setiSubType(String iSubType) {
		this.iSubType = iSubType;
	}
	public String getSortType() {
		return sortType;
	}
	public void setSortType(String sortType) {
		this.sortType = sortType;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public int getStarRating() {
		return starRating;
	}
	public void setStarRating(int starRating) {
		this.starRating = starRating;
	}
	public String getReviewContents() {
		return reviewContents;
	}
	public void setReviewContents(String reviewContents) {
		this.reviewContents = reviewContents;
	}
	public String getQnaTitle() {
		return qnaTitle;
	}
	public void setQnaTitle(String qnaTitle) {
		this.qnaTitle = qnaTitle;
	}
	public String getqContents() {
		return qContents;
	}
	public void setqContents(String qContents) {
		this.qContents = qContents;
	}
	public String getaContents() {
		return aContents;
	}
	public void setaContents(String aContents) {
		this.aContents = aContents;
	}
	public String getIsSecret() {
		return isSecret;
	}
	public void setIsSecret(String isSecret) {
		this.isSecret = isSecret;
	}
	public String getAnsStatus() {
		return ansStatus;
	}
	public void setAnsStatus(String ansStatus) {
		this.ansStatus = ansStatus;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getQty() {
		return qty;
	}
	public void setQty(int qty) {
		this.qty = qty;
	}
	public int getOrdNo() {
		return ordNo;
	}
	public void setOrdNo(int ordNo) {
		this.ordNo = ordNo;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	   
}
