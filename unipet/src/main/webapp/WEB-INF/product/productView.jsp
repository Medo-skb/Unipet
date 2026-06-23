<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>UNIPET</title>

		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="/css/product/productView.css">
	</head>

	<body>
		<jsp:include page="/WEB-INF/header/header.jsp" />

		<div id="app">
			<div class="wrap">
				<div class="back-area">
					<button class="back-btn" @click="fnMoveList()">
						← 상품 목록으로
					</button>
				</div>

				<div v-if="product" class="detail-box">
					<div class="detail-wrap">
						<div class="detail-left">
							<div class="main-img-wrap">
								<div class="image-sale-badge" v-if="fnHasDiscount()">
									{{fnDiscountRate()}}% SALE
								</div>

								<img v-if="mainImage != ''" :src="mainImage" class="main-img">
								<img v-else src="/img/product/no-image.png" class="main-img">
							</div>

							<div class="thumb-list">
								<img v-for="file in fileList" :key="file.fileNo" :src="file.img" class="thumb-img"
									@click="fnChangeMainImage(file.img)">
							</div>
						</div>

						<div class="detail-right">
							<div class="shopping-benefit-line">
								<span>오늘의 특가</span>
								<span>빠른출고</span>
							</div>

							<div class="product-title-row">
								<h3>{{product.productName}}</h3>

								<button type="button" class="wish-btn" :class="{active : wishYn == 'Y'}"
									@click="fnToggleWish()">
									<span>{{wishYn == 'Y' ? '♥' : '♡'}}</span>
									{{wishYn == 'Y' ? '찜' : '찜하기'}}
									<em>{{wishCount}}</em>
								</button>
							</div>

							<div class="detail-rating">
								⭐ {{reviewAvg}} / 5.0 ({{reviewCount}}개 리뷰)
							</div>

							<div class="tag-box">
								<span>#인기상품</span>
								<span>#추천</span>
								<span>{{'#' + product.aSubType}}</span>
							</div>

							<div class="simple-desc">
								이 상품은 {{product.aSubType}}를 위한 {{product.iSubType}} 상품으로 일상에서 편하게 사용할 수 있습니다.
							</div>

							<div class="price-box">
								<div class="original-price" v-if="fnHasDiscount()">
									정상가 {{formatPrice(fnOriginalPrice())}}원
								</div>

								<div class="sale-line">
									<span class="discount-rate" v-if="fnHasDiscount()">
										{{fnDiscountRate()}}%
									</span>

									<span class="sale-price">
										{{formatPrice(fnSalePrice())}}원
									</span>
								</div>

								<div class="save-price" v-if="fnHasDiscount()">
									즉시할인 {{formatPrice(fnDiscountAmount())}}원
								</div>

								<div class="coupon-line">
									회원 구매 시 구매금액의 {{pointRate}}% 적립
								</div>

								<div class="point-line">
									<span class="point-label">적립</span>
									<span>예상 적립금 {{formatPrice(fnPointAmount())}}원</span>
								</div>
							</div>

							<div class="benefit-list">
								<div class="benefit-pill">안전결제</div>
								<div class="benefit-pill">UNIPET 추천상품</div>
							</div>

							<div class="detail-info">
								브랜드 : {{product.brand == null ? '-' : product.brand}}<br>
								동물분류 : {{product.aSubType}}<br>
								상품분류 : {{product.iSubType}}<br>
								재고 : {{product.stockQty}}개<br>
							</div>

							<div class="price">
								총 금액 : {{formatPrice(fnTotalPrice())}}원
							</div>

							<div class="delivery-box">
								<div>🚚 무료배송 (3만원 이상)</div>
								<div>📦 평균 배송 1~2일</div>
								<div>💳 카드/간편결제 가능</div>
							</div>

							<div class="qty-box">
								<button @click="fnQty(-1)">-</button>

								<input type="number" class="qty-input" v-model="qty" @change="fnChangeQty()" min="1"
									:max="product.stockQty">

								<button @click="fnQty(1)">+</button>
							</div>

							<div class="stock-status" v-if="product.stockQty < 10 && product.stockQty > 0">
								🔥 재고 얼마 안 남음!
							</div>

							<div class="stock-status" v-if="product.stockQty == 0">
								❌ 품절된 상품입니다.
							</div>

							<div class="btn-area">
								<button class="btn-cart" @click="fnAddCart()" :disabled="product.stockQty == 0">
									장바구니
								</button>

								<button class="btn-buy" @click="fnDirectOrder()" :disabled="product.stockQty == 0">
									구매하기
								</button>
							</div>
						</div>
					</div>
				</div>

				<div v-if="product" class="tab-menu">
					<button class="tab-btn" :class="{active : tab == 'detail'}" @click="tab='detail'">상세설명</button>
					<button class="tab-btn" :class="{active : tab == 'review'}" @click="tab='review'">상품평</button>
					<button class="tab-btn" :class="{active : tab == 'qna'}" @click="tab='qna'">상품문의</button>
				</div>

				<div v-if="product && tab == 'detail'" class="tab-box">
					<div class="detail-desc-top">
						<div class="detail-desc-badge">PRODUCT DETAIL</div>
						<div class="detail-desc-title">{{product.productName}}</div>
						<div class="detail-desc-sub">
							{{product.brand == null ? '브랜드 미등록' : product.brand}} ·
							{{product.aSubType}} ·
							{{product.iSubType}}
						</div>
						<div class="detail-desc-price">{{formatPrice(fnSalePrice())}}원</div>
					</div>

					<div class="detail-point-wrap">
						<div class="detail-point-box">
							<div class="detail-point-title">추천 대상</div>
							<div class="detail-point-text">
								{{product.aSubType}} (반려동물)을 위한 상품입니다.
							</div>
						</div>

						<div class="detail-point-box">
							<div class="detail-point-title">상품 특징</div>
							<div class="detail-point-text">
								실사용에 편리하도록 구성된 {{product.iSubType}} 상품입니다.
							</div>
						</div>

						<div class="detail-point-box">
							<div class="detail-point-title">구매 전 확인</div>
							<div class="detail-point-text">
								현재 재고는 {{product.stockQty}}개이며, 상품 옵션 및 수량을 확인해주세요.
							</div>
						</div>
					</div>

					<div class="detail-section-title">상품 설명</div>

					<div class="detail-desc-text">
						✔ 고품질 원료 사용<br>
						✔ 반려동물 안전 기준 충족<br>
						✔ 일상에서 편리하게 사용 가능<br>
						✔ {{product.aSubType}} 맞춤 설계 상품
					</div>

					<br>

					<div class="detail-section-title">상세 이미지</div>

					<div v-if="detailImageList.length > 0" class="detail-img-list">
						<img v-for="img in detailImageList" :key="img.fileNo" :src="img.img">
					</div>

					<div v-else class="detail-empty-desc">
						등록된 상세 이미지가 없습니다.
					</div>
				</div>

				<div v-if="product && tab == 'review'" class="review-box">
					<div class="review-top">
						<div class="review-summary">
							리뷰 {{reviewCount}}개 / 평균 ⭐ {{reviewAvg}}
						</div>
					</div>

					<div v-if="reviewList.length == 0" class="empty-box">
						아직 작성된 리뷰가 없습니다.
					</div>

					<div v-else>
						<div class="review-item" v-for="review in pagedReviewList" :key="review.reviewNo">
							<div class="review-head">
								<div class="review-user-area">
									<span class="review-user">
										{{review.writerNickname ? review.writerNickname : review.userId}}
									</span>

									<span class="review-date">{{review.reviewCdate}}</span>
								</div>

								<div class="review-action-area">
									<button v-if="fnCanEditReview(review)" type="button" class="review-action-btn edit"
										@click="fnReviewEdit(review)">
										수정
									</button>

									<button v-if="fnCanDeleteReview(review)" type="button"
										class="review-action-btn delete" @click="fnReviewDelete(review)">
										삭제
									</button>
								</div>
							</div>

							<div class="review-rating-img-row">
								<div class="review-rating">
									{{fnConvertStar(review.rating)}}
									<span class="review-score">{{review.rating}}점</span>
								</div>

								<div class="review-img-list" v-if="fnReviewImgArray(review).length > 0">
									<img v-for="(img, index) in fnReviewImgArray(review)"
										:key="'review-img-' + review.reviewNo + '-' + index" :src="img"
										class="review-img" @click="fnOpenReviewImgModal(img)" @error="fnReviewImgError">
								</div>
							</div>

							<div v-if="review.editMode" class="qna-edit-box">
								<select class="qna-edit-input" v-model="review.editRating">
									<option value="5">5점</option>
									<option value="4">4점</option>
									<option value="3">3점</option>
									<option value="2">2점</option>
									<option value="1">1점</option>
								</select>

								<textarea class="qna-edit-textarea" v-model="review.editContents"
									maxlength="500"></textarea>

								<div class="qna-edit-btn-row">
									<button class="qna-small-btn save" @click="fnReviewUpdate(review)">저장</button>
									<button class="qna-small-btn cancel" @click="fnReviewCancel(review)">취소</button>
								</div>
							</div>

							<div v-else class="review-contents">
								{{review.reviewContents}}
							</div>

						</div>

						<div class="review-pagination" v-if="reviewList.length > reviewPageSize">
							<button type="button" @click="fnGoReviewPage(1)" v-if="reviewCurrentPage > 1">
								&lt;&lt;
							</button>

							<button type="button" @click="fnGoReviewPage(reviewCurrentPage - 1)"
								v-if="reviewCurrentPage > 1">
								&lt;
							</button>

							<button type="button" v-for="page in reviewPageList" :key="'reviewPage' + page"
								:class="{active : reviewCurrentPage == page}" @click="fnGoReviewPage(page)">
								{{page}}
							</button>

							<button type="button" @click="fnGoReviewPage(reviewCurrentPage + 1)"
								v-if="reviewCurrentPage < reviewTotalPage">
								&gt;
							</button>

							<button type="button" @click="fnGoReviewPage(reviewTotalPage)"
								v-if="reviewCurrentPage < reviewTotalPage">
								&gt;&gt;
							</button>
						</div>
					</div>
				</div>

				<div v-if="product && tab == 'qna'" class="tab-box">
					<div class="qna-write-box">
						<div class="qna-write-header">
							<div class="qna-title">상품 문의</div>
							<div class="qna-desc">상품에 대해 궁금한 점을 남겨주세요.</div>
						</div>

						<div class="qna-secret-row">
							<div class="qna-secret-label">문의 유형</div>

							<div class="qna-secret-option-wrap">
								<label class="qna-secret-option" :class="{active : qnaForm.secretYn == 'N'}">
									<input type="radio" value="N" v-model="qnaForm.secretYn">
									<span>공개문의</span>
								</label>

								<label class="qna-secret-option" :class="{active : qnaForm.secretYn == 'Y'}">
									<input type="radio" value="Y" v-model="qnaForm.secretYn">
									<span>비밀문의</span>
								</label>
							</div>
						</div>

						<div class="qna-title-wrap">
							<input type="text" class="qna-title-input" v-model="qnaForm.title" :maxlength="qnaTitleMax"
								placeholder="문의 제목을 입력하세요">
							<div class="qna-title-count">
								{{qnaForm.title.length}} / {{qnaTitleMax}}
							</div>
						</div>

						<div class="qna-textarea-wrap">
							<textarea class="qna-contents-textarea" v-model="qnaForm.contents"
								:maxlength="qnaContentsMax" placeholder="문의 내용을 입력하세요"></textarea>
							<div class="qna-contents-count">
								{{qnaForm.contents.length}} / {{qnaContentsMax}}
							</div>
						</div>

						<button type="button" class="qna-write-btn" @click="fnAddQna()">문의 등록</button>
					</div>

					<div class="qna-list-box">
						<div v-if="qnaList.length == 0" class="empty-box">
							아직 등록된 문의가 없습니다.
						</div>

						<div v-else>
							<div class="qna-item" v-for="qna in qnaList" :key="qna.qnaNo">
								<div class="qna-top-row">
									<div class="qna-head-left">
										<span class="qna-user">
											{{qna.writerNickname ? qna.writerNickname : qna.userId}}
										</span>
										<span class="qna-type-badge secret" v-if="qna.privateYn == 'Y'">비밀문의</span>
										<span class="qna-type-badge open" v-else>공개문의</span>
									</div>
									<div class="qna-head-right">{{qna.qnaCdate}}</div>
								</div>

								<div class="qna-title-row" @click="fnToggleQna(qna)">
									<div class="qna-title-text">
										<span v-if="qna.privateYn == 'Y'">🔒</span>

										<span v-if="fnCanReadQna(qna)">
											{{qna.qnaTitle}}
										</span>

										<span v-else>
											비밀문의입니다.
										</span>
									</div>

									<div class="qna-title-right">
										<span class="qna-status" :class="qna.qnaStatus == 'Y' ? 'done' : 'waiting'">
											{{qna.qnaStatus == 'Y' ? '답변완료' : '답변대기'}}
										</span>
										<span class="qna-arrow">{{qna.open ? '▲' : '▼'}}</span>
									</div>
								</div>

								<div v-if="qna.open" class="qna-body-box">
									<div v-if="qna.editMode" class="qna-edit-box">
										<input type="text" class="qna-edit-input" v-model="qna.editTitle">

										<textarea class="qna-edit-textarea" v-model="qna.editContents"></textarea>

										<div class="qna-edit-btn-row">
											<button class="qna-small-btn save" @click="fnSaveQna(qna)">저장</button>
											<button class="qna-small-btn cancel"
												@click="fnCancelEditQna(qna)">취소</button>
										</div>
									</div>

									<div v-else>
										<div v-if="fnCanReadQna(qna)" class="qna-contents">
											<span v-if="qna.privateYn == 'Y'">🔒 </span>{{qna.qnaContents}}
										</div>

										<div v-else class="qna-secret-lock">
											🔒 비밀문의입니다. 작성자와 관리자만 확인할 수 있습니다.
										</div>

										<div v-if="fnCanReadQna(qna) && qna.qnaStatus == 'Y' && qna.qnaAnswer"
											class="answer-box">
											<div class="answer-title">💬 판매자 답변</div>
											<div>{{qna.qnaAnswer}}</div>
										</div>

										<div class="qna-btn-row" v-if="fnCanManageQna(qna)">
											<button class="qna-small-btn edit" @click="fnEditQna(qna)">수정</button>
											<button class="qna-small-btn delete"
												@click="fnDeleteQna(qna.qnaNo)">삭제</button>
										</div>
									</div>
								</div>
							</div>
						</div>

					</div>
				</div>

				<div v-if="!product" class="empty-box">
					상품 상세 조회 실패
				</div>
			</div>

			<div class="review-img-modal-wrap" v-if="reviewModalOpen" @click="fnCloseReviewImgModal()">
				<div class="review-img-modal-box" @click.stop>
					<button type="button" class="review-img-modal-close" @click="fnCloseReviewImgModal()">
						×
					</button>

					<img :src="reviewModalImg" class="review-img-modal-img">
				</div>
			</div>
		</div>

		<script>
			const app = Vue.createApp({
				data() {
					return {
						productNo: '<%=request.getAttribute("productNo")%>',
						currentUserId: '<%=session.getAttribute("sessionId") == null ? "" : session.getAttribute("sessionId")%>',
						currentUserRole: '<%=session.getAttribute("sessionRole") == null ? "" : session.getAttribute("sessionRole")%>',
						adminId: '<%=session.getAttribute("adminId") == null ? "" : session.getAttribute("adminId")%>',
						product: null,
						fileList: [],
						detailImageList: [],
						mainImage: "",
						qty: 1,
						reviewList: [],
						pagedReviewList: [],
						reviewCount: 0,
						reviewAvg: 0,
						reviewCurrentPage: 1,
						reviewPageSize: 5,
						reviewTotalPage: 1,
						reviewPageList: [],
						reviewPageBlockSize: 5,
						reviewModalOpen: false,
						reviewModalImg: "",
						qnaList: [],
						cartCount: 0,
						wishYn: "N",
						wishCount: 0,
						defaultDiscountRateList: [7, 9, 12, 15, 18, 20, 23, 25],
						pointRate: 1,
						tab: "detail",
						qnaTitleMax: 50,
						qnaContentsMax: 500,
						qnaForm: {
							title: "",
							contents: "",
							secretYn: "N"
						}
					};
				},
				methods: {
					fnGetProductView: function () {
						let self = this;
						let param = {
							productNo: self.productNo
						};

						$.ajax({
							url: "/product/detail.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success" && data.product != null) {
									self.product = data.product;
									self.fileList = data.imageList || [];
									self.detailImageList = data.detailImageList || [];

									if (self.fileList.length > 0) {
										self.mainImage = self.fileList[0].img;
									} else {
										self.mainImage = "";
									}

									self.fnGetWishInfo();

								} else {
									self.product = null;
								}
							},
							error: function () {
								alert("상품 상세 조회 중 오류가 발생했습니다.");
							}
						});
					},

					fnGetWishInfo: function () {
						let self = this;

						if (self.productNo == null || self.productNo == "") {
							return;
						}

						let param = {
							productNo: self.productNo
						};

						$.ajax({
							url: "/product/wish/info.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									self.wishYn = data.wishYn == "Y" ? "Y" : "N";
									self.wishCount = data.wishCount == null ? 0 : Number(data.wishCount);
								}
							}
						});
					},

					fnToggleWish: function () {
						let self = this;

						if (!self.fnCheckUserOnly()) {
							return;
						}

						let param = {
							productNo: self.productNo
						};

						$.ajax({
							url: "/product/wish/toggle.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									self.wishYn = data.wishYn == "Y" ? "Y" : "N";
									self.wishCount = data.wishCount == null ? 0 : Number(data.wishCount);

									if (self.wishYn == "Y") {
										alert("찜한 상품에 추가되었습니다.");
									} else {
										alert("찜한 상품에서 삭제되었습니다.");
									}

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "찜하기 처리 실패" : data.message);
								}
							},
							error: function () {
								alert("찜하기 처리 중 오류가 발생했습니다.");
							}
						});
					},

					fnConvertStar: function (rating) {
						const num = Math.floor(Number(rating || 0));
						return "⭐️".repeat(num);
					},

					fnReviewImgArray: function (review) {
						if (review == null) {
							return [];
						}

						if (review.reviewImgList == null || review.reviewImgList == "") {
							return [];
						}

						return String(review.reviewImgList)
							.split("||")
							.map(function (img) {
								return img.replaceAll("\\", "/").trim();
							})
							.filter(function (img) {
								return img != "";
							});
					},

					fnReviewImgError: function (event) {
						console.log("리뷰 이미지 로드 실패:", event.target.src);
						event.target.style.display = "none";
					},

					fnOpenReviewImgModal: function (img) {
						if (img == null || img == "") {
							return;
						}

						this.reviewModalImg = img;
						this.reviewModalOpen = true;
					},

					fnCloseReviewImgModal: function () {
						this.reviewModalOpen = false;
						this.reviewModalImg = "";
					},

					fnGetReviewList: function () {
						let self = this;
						let param = {
							productNo: self.productNo
						};

						$.ajax({
							url: "/review/list.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									self.reviewList = data.list || [];
									self.reviewCount = data.summary != null ? data.summary.reviewCount : 0;
									self.reviewAvg = data.summary != null ? data.summary.avgRating : 0;

									for (let i = 0; i < self.reviewList.length; i++) {
										self.reviewList[i].editMode = false;
										self.reviewList[i].editContents = self.reviewList[i].reviewContents;
										self.reviewList[i].editRating = self.reviewList[i].rating;
									}

									self.reviewCurrentPage = 1;
									self.fnSetReviewPaging();

								} else {
									self.reviewList = [];
									self.pagedReviewList = [];
									self.reviewCount = 0;
									self.reviewAvg = 0;
									self.reviewCurrentPage = 1;
									self.fnSetReviewPaging();
								}
							},
							error: function () {
								alert("리뷰 조회 중 오류가 발생했습니다.");
							}
						});
					},

					fnSetReviewPaging: function () {
						let self = this;

						self.reviewTotalPage = Math.ceil(self.reviewList.length / self.reviewPageSize);

						if (self.reviewTotalPage == 0) {
							self.reviewTotalPage = 1;
						}

						if (self.reviewCurrentPage > self.reviewTotalPage) {
							self.reviewCurrentPage = self.reviewTotalPage;
						}

						let start = (self.reviewCurrentPage - 1) * self.reviewPageSize;
						let end = start + self.reviewPageSize;

						self.pagedReviewList = self.reviewList.slice(start, end);

						self.fnSetReviewPageList();
					},

					fnSetReviewPageList: function () {
						let self = this;

						self.reviewPageList = [];

						let startPage = Math.floor((self.reviewCurrentPage - 1) / self.reviewPageBlockSize) * self.reviewPageBlockSize + 1;
						let endPage = startPage + self.reviewPageBlockSize - 1;

						if (endPage > self.reviewTotalPage) {
							endPage = self.reviewTotalPage;
						}

						for (let i = startPage; i <= endPage; i++) {
							self.reviewPageList.push(i);
						}
					},

					fnGoReviewPage: function (page) {
						if (page < 1) {
							page = 1;
						}

						if (page > this.reviewTotalPage) {
							page = this.reviewTotalPage;
						}

						this.reviewCurrentPage = page;
						this.fnSetReviewPaging();
					},

					fnCanEditReview: function (review) {
						if (review == null) {
							return false;
						}

						if (this.currentUserId == "") {
							return false;
						}

						if (this.fnIsAdmin()) {
							return false;
						}

						if (String(this.currentUserId) == String(review.userId)) {
							return true;
						}

						return false;
					},

					fnCanDeleteReview: function (review) {
						if (review == null) {
							return false;
						}

						if (this.fnIsAdmin()) {
							return true;
						}

						if (this.currentUserId != "" && String(this.currentUserId) == String(review.userId)) {
							return true;
						}

						return false;
					},

					fnReviewEdit: function (review) {
						if (!this.fnCanEditReview(review)) {
							alert("리뷰 수정 권한이 없습니다.");
							return;
						}

						review.editMode = true;
						review.editContents = review.reviewContents;
						review.editRating = review.rating;
					},

					fnReviewCancel: function (review) {
						review.editMode = false;
						review.editContents = review.reviewContents;
						review.editRating = review.rating;
					},

					fnReviewUpdate: function (review) {
						let self = this;

						if (!self.fnCanEditReview(review)) {
							alert("리뷰 수정 권한이 없습니다.");
							return;
						}

						if (review.editContents == null || review.editContents.trim() == "") {
							alert("리뷰 내용을 입력해주세요.");
							return;
						}

						if (review.editContents.length > 500) {
							alert("리뷰 내용은 500자 이하로 입력해주세요.");
							return;
						}

						let param = {
							reviewNo: review.reviewNo,
							productNo: self.productNo,
							contents: review.editContents,
							rating: review.editRating
						};

						$.ajax({
							url: "/review/update.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									alert("리뷰가 수정되었습니다.");
									self.fnGetReviewList();

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "리뷰 수정 실패" : data.message);
								}
							},
							error: function () {
								alert("리뷰 수정 중 오류가 발생했습니다.");
							}
						});
					},

					fnReviewDelete: function (review) {
						let self = this;

						if (!self.fnCanDeleteReview(review)) {
							alert("리뷰 삭제 권한이 없습니다.");
							return;
						}

						if (!confirm("이 리뷰를 삭제하시겠습니까?")) {
							return;
						}

						let param = {
							reviewNo: review.reviewNo,
							productNo: self.productNo
						};

						$.ajax({
							url: "/review/delete.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									alert("리뷰가 삭제되었습니다.");
									self.fnGetReviewList();

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "리뷰 삭제 실패" : data.message);
								}
							},
							error: function () {
								alert("리뷰 삭제 중 오류가 발생했습니다.");
							}
						});
					},

					fnGetQnaList: function () {
						let self = this;
						let param = {
							productNo: self.productNo
						};

						$.ajax({
							url: "/qna/list.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									self.qnaList = data.list || [];

									for (let i = 0; i < self.qnaList.length; i++) {
										self.qnaList[i].open = false;
										self.qnaList[i].editMode = false;
										self.qnaList[i].editTitle = self.qnaList[i].qnaTitle;
										self.qnaList[i].editContents = self.qnaList[i].qnaContents;
									}

								} else {
									self.qnaList = [];
								}
							},
							error: function () {
								alert("문의 조회 중 오류가 발생했습니다.");
							}
						});
					},

					fnCanReadQna: function (qna) {
						if (qna.privateYn != "Y") {
							return true;
						}

						if (this.fnIsAdmin()) {
							return true;
						}

						if (this.currentUserId != "" && this.currentUserId == qna.userId) {
							return true;
						}

						return false;
					},

					fnCanManageQna: function (qna) {
						if (this.fnIsAdmin()) {
							return true;
						}

						if (this.currentUserId != "" && this.currentUserId == qna.userId) {
							return true;
						}

						return false;
					},

					fnToggleQna: function (qna) {
						qna.open = !qna.open;
					},

					fnEditQna: function (qna) {
						qna.editMode = true;
						qna.editTitle = qna.qnaTitle;
						qna.editContents = qna.qnaContents;
					},

					fnCancelEditQna: function (qna) {
						qna.editMode = false;
						qna.editTitle = qna.qnaTitle;
						qna.editContents = qna.qnaContents;
					},

					fnSaveQna: function (qna) {
						let self = this;

						if (qna.editTitle == "") {
							alert("문의 제목을 입력해주세요.");
							return;
						}

						if (qna.editContents == "") {
							alert("문의 내용을 입력해주세요.");
							return;
						}

						let param = {
							qnaNo: qna.qnaNo,
							title: qna.editTitle,
							contents: qna.editContents
						};

						$.ajax({
							url: "/qna/update.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									alert("문의가 수정되었습니다.");
									self.fnGetQnaList();

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "문의 수정 실패" : data.message);
								}
							},
							error: function () {
								alert("문의 수정 중 오류가 발생했습니다.");
							}
						});
					},

					fnDeleteQna: function (qnaNo) {
						let self = this;

						if (!confirm("문의글을 삭제하시겠습니까?")) {
							return;
						}

						let param = {
							qnaNo: qnaNo
						};

						$.ajax({
							url: "/qna/delete.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									alert("문의가 삭제되었습니다.");
									self.fnGetQnaList();

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "문의 삭제 실패" : data.message);
								}
							},
							error: function () {
								alert("문의 삭제 중 오류가 발생했습니다.");
							}
						});
					},

					fnAddQna: function () {
						let self = this;

						if (self.currentUserId == "") {
							alert("로그인이 필요한 서비스입니다.");
							location.href = "/user/login.do";
							return;
						}

						if (self.qnaForm.title == "") {
							alert("문의 제목을 입력해주세요.");
							return;
						}

						if (self.qnaForm.contents == "") {
							alert("문의 내용을 입력해주세요.");
							return;
						}

						if (self.qnaForm.title.length > self.qnaTitleMax) {
							alert("문의 제목은 " + self.qnaTitleMax + "자 이하로 입력해주세요.");
							return;
						}

						if (self.qnaForm.contents.length > self.qnaContentsMax) {
							alert("문의 내용은 " + self.qnaContentsMax + "자 이하로 입력해주세요.");
							return;
						}

						let param = {
							productNo: self.productNo,
							title: self.qnaForm.title,
							contents: self.qnaForm.contents,
							secretYn: self.qnaForm.secretYn
						};

						$.ajax({
							url: "/qna/add.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									alert("문의가 등록되었습니다.");
									self.qnaForm.title = "";
									self.qnaForm.contents = "";
									self.qnaForm.secretYn = "N";
									self.fnGetQnaList();
									self.tab = "qna";

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "문의 등록 실패" : data.message);
								}
							},
							error: function () {
								alert("문의 등록 중 오류가 발생했습니다.");
							}
						});
					},

					fnChangeMainImage: function (img) {
						this.mainImage = img;
					},

					fnQty: function (num) {
						let self = this;
						let newQty = Number(self.qty) + num;

						if (newQty < 1) {
							return;
						}

						if (newQty > self.product.stockQty) {
							alert("재고수량을 초과할 수 없습니다.");
							return;
						}

						self.qty = newQty;
					},

					fnChangeQty: function () {
						let self = this;
						let newQty = Number(self.qty);

						if (newQty < 1 || isNaN(newQty)) {
							alert("수량은 1개 이상 입력해주세요.");
							self.qty = 1;
							return;
						}

						if (newQty > self.product.stockQty) {
							alert("재고수량을 초과할 수 없습니다.");
							self.qty = self.product.stockQty;
							return;
						}

						self.qty = newQty;
					},

					fnCheckUserOnly: function () {
						if (this.fnIsAdmin()) {
							alert("일반회원만 이용 가능한 기능입니다.");
							return false;
						}

						if (this.currentUserId == "") {
							alert("로그인이 필요한 서비스입니다.");
							location.href = "/user/login.do";
							return false;
						}

						return true;
					},

					fnAddCart: function () {
						let self = this;

						if (!self.fnCheckUserOnly()) {
							return;
						}

						if (self.qty > self.product.stockQty) {
							alert("재고수량을 초과할 수 없습니다.");
							return;
						}

						let param = {
							productNo: self.productNo,
							qty: self.qty
						};

						$.ajax({
							url: "/cart/add.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									self.fnGetCartCount();

									if (confirm("장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")) {
										pageChange("/cart.do", {});
									}

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "장바구니 담기 실패" : data.message);
								}
							},
							error: function () {
								alert("장바구니 처리 중 오류가 발생했습니다.");
							}
						});
					},

					fnDirectOrder: function () {
						let self = this;

						if (!self.fnCheckUserOnly()) {
							return;
						}

						if (self.qty > self.product.stockQty) {
							alert("재고수량을 초과할 수 없습니다.");
							return;
						}

						let param = {
							productNo: self.productNo,
							qty: self.qty
						};

						$.ajax({
							url: "/cart/add.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									let cartNoList = [data.cartNo];
									sessionStorage.setItem("cartNoList", JSON.stringify(cartNoList));
									pageChange("/payment/pay-shop.do", {});

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "바로구매 처리 실패" : data.message);
								}
							},
							error: function () {
								alert("바로구매 처리 중 오류가 발생했습니다.");
							}
						});
					},

					fnUpdateCartBadge: function (count) {
						let self = this;

						self.cartCount = count;

						let badge = document.querySelector(".cart-badge");

						if (badge != null) {
							if (count > 0) {
								badge.innerText = count;
								badge.classList.remove("cart-badge-hidden");
							} else {
								badge.innerText = "";
								badge.classList.add("cart-badge-hidden");
							}
						}
					},

					fnGetCartCount: function () {
						let self = this;
						let param = {};

						$.ajax({
							url: "/cart/count.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									self.cartCount = data.cartCount;

									let count = Number(data.cartCount);

									let badges = document.querySelectorAll(
										".cart-badge, .cart-count, .cartCnt, .cart-num, .cart-alarm, .cart-count-badge, #cartCount"
									);

									for (let i = 0; i < badges.length; i++) {
										if (count > 0) {
											badges[i].innerText = count;
										} else {
											badges[i].innerText = "";
										}
									}
								}
							}
						});
					},

					formatPrice: function (price) {
						if (price == null || price == undefined || price == "") {
							return "0";
						}

						return Number(price).toLocaleString();
					},

					fnDiscountRate: function () {
						if (this.product == null) {
							return 0;
						}

						if (this.product.discountRate != null && this.product.discountRate != "") {
							return Number(this.product.discountRate);
						}

						if (this.product.saleRate != null && this.product.saleRate != "") {
							return Number(this.product.saleRate);
						}

						let productNo = this.product.productNo == null || this.product.productNo == "" ? Number(this.productNo) : Number(this.product.productNo);
						let index = productNo % this.defaultDiscountRateList.length;

						return Number(this.defaultDiscountRateList[index]);
					},

					fnSalePrice: function () {
						if (this.product == null) {
							return 0;
						}

						if (this.product.salePrice != null && this.product.salePrice != "") {
							return Number(this.product.salePrice);
						}

						if (this.product.discountPrice != null && this.product.discountPrice != "") {
							return Number(this.product.discountPrice);
						}

						if (this.product.finalPrice != null && this.product.finalPrice != "") {
							return Number(this.product.finalPrice);
						}

						return Number(this.product.productPrice);
					},

					fnOriginalPrice: function () {
						if (this.product == null) {
							return 0;
						}

						if (this.product.originalPrice != null && this.product.originalPrice != "") {
							return Number(this.product.originalPrice);
						}

						if (this.product.consumerPrice != null && this.product.consumerPrice != "") {
							return Number(this.product.consumerPrice);
						}

						if (this.product.listPrice != null && this.product.listPrice != "") {
							return Number(this.product.listPrice);
						}

						let salePrice = this.fnSalePrice();
						let rate = this.fnDiscountRate();

						if (rate <= 0 || rate >= 100) {
							return salePrice;
						}

						return Math.round((salePrice / (1 - rate / 100)) / 10) * 10;
					},

					fnHasDiscount: function () {
						let salePrice = this.fnSalePrice();
						let originalPrice = this.fnOriginalPrice();
						let rate = this.fnDiscountRate();

						if (rate <= 0) {
							return false;
						}

						if (originalPrice <= salePrice) {
							return false;
						}

						return true;
					},

					fnDiscountAmount: function () {
						let amount = this.fnOriginalPrice() - this.fnSalePrice();

						if (amount < 0) {
							return 0;
						}

						return amount;
					},

					fnPointAmount: function () {
						return Math.floor(Number(this.fnTotalPrice()) * Number(this.pointRate) / 100);
					},

					fnMoveCart: function () {
						if (!this.fnCheckUserOnly()) {
							return;
						}

						pageChange("/cart.do", {});
					},

					fnMoveMain: function () {
						pageChange("/product.do", {});
					},

					fnMoveList: function () {
						pageChange("/product.do", {});
					},

					fnTotalPrice: function () {
						if (this.product == null) {
							return 0;
						}

						return Number(this.fnSalePrice()) * Number(this.qty);
					},

					fnIsAdmin: function () {
						if (this.adminId != "") {
							return true;
						}

						if (this.currentUserRole == "A") {
							return true;
						}

						if (this.currentUserRole == "ADMIN") {
							return true;
						}

						if (this.currentUserId == "admin") {
							return true;
						}

						return false;
					}
				},
				mounted() {
					let self = this;

					self.fnGetProductView();
					self.fnGetReviewList();
					self.fnGetQnaList();
					self.fnGetCartCount();
				}
			});

			app.mount('#app');
		</script>

		<jsp:include page="/WEB-INF/footer/footer.jsp" />

	</body>

	</html>