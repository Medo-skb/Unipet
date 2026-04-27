<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>상품 상세</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"
			integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>

		<!-- <link rel="stylesheet" href="/css/product/productView.css"> -->
		<link rel="stylesheet" href="/css/product/productView2.css">

	</head>

	<body>
		<jsp:include page="/WEB-INF/header/header.jsp" />

		<div id="app">
			<!-- <div class="header">
				<div class="logo" @click="fnMoveMain()">
					UniPet <span class="logo-sub">shop</span>
				</div>

				<div class="header-right">
					<div class="cart-box" @click="fnMoveCart()">
						<span class="cart-icon">🛒</span>
						<span class="cart-badge" v-if="cartCount > 0">{{cartCount}}</span>
					</div>
				</div>
			</div> -->

			<div class="wrap">
				<div class="back-area">
					<button class="back-btn" @click="fnMoveList()">
						← 상품 목록으로
					</button>
				</div>
				<div v-if="product" class="detail-box">
					<div class="detail-wrap">
						<div class="detail-left">
							<img v-if="mainImage != ''" :src="mainImage" class="main-img">
							<img v-else src="/img/product/no-image.png" class="main-img">

							<div class="thumb-list">
								<img v-for="file in fileList" :key="file.FILE_NO" :src="file.IMG" class="thumb-img"
									@click="fnChangeMainImage(file.IMG)">
							</div>
						</div>

						<div class="detail-right">
							<h3>{{product.PRODUCT_NAME}}</h3>

							<div class="detail-rating">
								⭐ {{reviewAvg}} / 5.0 ({{reviewCount}}개 리뷰)
							</div>

							<div class="tag-box">
								<span>#인기상품</span>
								<span>#추천</span>
								<span>{{'#' + product.A_SUB_TYPE}}</span>
							</div>

							<div class="simple-desc">
								이 상품은 {{product.A_SUB_TYPE}}를 위한 {{product.I_SUB_TYPE}} 상품으로 일상에서 편하게 사용할 수 있습니다.
							</div>

							<div class="detail-info">
								브랜드 : {{product.BRAND == null ? '-' : product.BRAND}}<br>
								동물분류 : {{product.A_SUB_TYPE}}<br>
								상품분류 : {{product.I_SUB_TYPE}}<br>
								재고 : {{product.STOCK_QTY}}개<br>
							</div>

							<div class="price">{{formatPrice(product && product.PRODUCT_PRICE)}}원</div>

							<div class="total-price">
								총 금액 : {{formatPrice(fnTotalPrice())}}원
							</div>

							<div class="delivery-box">
								<div>🚚 무료배송 (3만원 이상)</div>
								<div>📦 평균 배송 1~2일</div>
								<div>💳 카드/간편결제 가능</div>
							</div>

							<div class="qty-box">
								<button @click="fnQty(-1)">-</button>

								<input 
									type="number"
									class="qty-input"
									v-model="qty"
									@change="fnChangeQty()"
									min="1"
									:max="product.STOCK_QTY"
								>

								<button @click="fnQty(1)">+</button>
							</div>

							<div class="stock-status" v-if="product.STOCK_QTY < 10">
								🔥 재고 얼마 안 남음!
							</div>
							<div class="stock-status" v-if="product.STOCK_QTY == 0">
								❌ 품절된 상품입니다.
							</div>

							<div class="btn-area">
								<button class="btn-cart" 
									@click="fnAddCart()" 
									:disabled="product.STOCK_QTY == 0">
								장바구니
								</button>

								<button class="btn-buy" 
									@click="fnDirectOrder()" 
									:disabled="product.STOCK_QTY == 0">
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

				<!-- 상세설명 -->
				<div v-if="product && tab == 'detail'" class="tab-box">
					<div class="detail-desc-top">
						<div class="detail-desc-badge">PRODUCT DETAIL</div>
						<div class="detail-desc-title">{{product.PRODUCT_NAME}}</div>
						<div class="detail-desc-sub">
							{{product.BRAND == null ? '브랜드 미등록' : product.BRAND}} ·
							{{product.A_SUB_TYPE}} ·
							{{product.I_SUB_TYPE}}
						</div>
						<div class="detail-desc-price">{{formatPrice(product && product.PRODUCT_PRICE)}}원</div>
					</div>

					<div class="detail-point-wrap">
						
						<div class="detail-point-box">
							<div class="detail-point-title">추천 대상</div>
							<div class="detail-point-text">
								{{product.A_SUB_TYPE}} (반려동물)을 위한 상품입니다.
							</div>
						</div>

						<div class="detail-point-box">
							<div class="detail-point-title">상품 특징</div>
							<div class="detail-point-text">
								실사용에 편리하도록 구성된 {{product.I_SUB_TYPE}} 상품입니다.
							</div>
						</div>

						<div class="detail-point-box">
							<div class="detail-point-title">구매 전 확인</div>
							<div class="detail-point-text">
								현재 재고는 {{product.STOCK_QTY}}개이며, 상품 옵션 및 수량을 확인해주세요.
							</div>
						</div>
					</div>
					
					<div class="detail-section-title">상품 설명</div>

					<div class="detail-desc-text">
						✔ 고품질 원료 사용<br>
						✔ 반려동물 안전 기준 충족<br>
						✔ 일상에서 편리하게 사용 가능<br>
						✔ {{product.A_SUB_TYPE}} 맞춤 설계 상품
					</div>
					
					<br>
					
			
					<div class="detail-section-title">상세 이미지</div>

					<div v-if="detailImageList.length > 0" class="detail-img-list">
						<img v-for="img in detailImageList" :key="img.FILE_NO" :src="img.IMG">
					</div>

					<div v-else class="detail-empty-desc">
						등록된 상세 이미지가 없습니다.
					</div>
				</div>

				<!-- 상품평 -->
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
						<div class="review-item" v-for="review in reviewList" :key="review.REVIEW_NO">
							<div class="review-head">
								<span class="review-user">{{ review.USER_ID }}</span>
								<span class="review-date">{{ review.CDATE }}</span>
							</div>
							<div class="review-rating">
								<span v-for="n in review.RATING" :key="'star-' + n" class="star-filled">★</span>
							</div>
							<!-- <div class="review-rating">별점 : {{ review.RATING }} / 5</div> -->
							<div class="review-contents">{{ review.R_CONTENTS }}</div>
						</div>
					</div>
				</div>

				<!-- 상품문의 -->
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

						<input type="text" v-model="qnaForm.title" placeholder="문의 제목을 입력하세요">
						<textarea v-model="qnaForm.contents" placeholder="문의 내용을 입력하세요"></textarea>
						<button type="button" class="qna-write-btn" @click="fnAddQna()">문의 등록</button>
					</div>

					<div class="qna-list-box">
						<div v-if="qnaList.length == 0" class="empty-box">
							아직 등록된 문의가 없습니다.
						</div>

						<div v-else>
							<div class="qna-item" v-for="qna in qnaList" :key="qna.QNA_NO">
								<div class="qna-top-row">
									<div class="qna-head-left">
										<span class="qna-user">{{qna.USER_ID}}</span>
										<span class="qna-type-badge secret" v-if="qna.IS_SECRET == 'Y'">비밀문의</span>
										<span class="qna-type-badge open" v-else>공개문의</span>
									</div>
									<div class="qna-head-right">{{qna.CDATE}}</div>
								</div>

								<div class="qna-title-row" @click="fnToggleQna(qna)">
									<div class="qna-title-text">
										<span v-if="qna.IS_SECRET == 'Y'">🔒</span>
										{{qna.QNA_TITLE}}
									</div>
									<div class="qna-title-right">
										<span class="qna-status" :class="qna.ANS_STATUS == 'Y' ? 'done' : 'waiting'">
											{{qna.ANS_STATUS == 'Y' ? '답변완료' : '답변대기'}}
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
											<span v-if="qna.IS_SECRET == 'Y'">🔒 </span>{{qna.Q_CONTENTS}}
										</div>

										<div v-else class="qna-secret-lock">
											🔒 비밀문의입니다. 작성자와 관리자만 확인할 수 있습니다.
										</div>

										<div v-if="fnCanReadQna(qna) && qna.ANS_STATUS == 'Y' && qna.A_CONTENTS"
											class="answer-box">
											<div class="answer-title">💬 판매자 답변</div>
											<div>{{qna.A_CONTENTS}}</div>
										</div>

										<div class="qna-btn-row" v-if="fnCanManageQna(qna)">
											<button class="qna-small-btn edit" @click="fnEditQna(qna)">수정</button>
											<button class="qna-small-btn delete"
												@click="fnDeleteQna(qna.QNA_NO)">삭제</button>
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
		</div>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					productNo: '<%=request.getAttribute("productNo")%>',
					currentUserId: '<%=(String)session.getAttribute("sessionId") == null ? "" : (String)session.getAttribute("sessionId")%>',
					currentUserRole: '<%=(String)session.getAttribute("sessionRole") == null ? "" : (String)session.getAttribute("sessionRole")%>',
					product: null,
					fileList: [],
					detailImageList: [],
					mainImage: "",
					qty: 1,
					reviewList: [],
					reviewCount: 0,
					reviewAvg: 0,
					qnaList: [],
					cartCount: 0,
					tab: "detail",
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
									self.mainImage = self.fileList[0].IMG;
								} else {
									self.mainImage = "";
								}
							} else {
								self.product = null;
							}
						},
						error: function () {
							alert("상품 상세 조회 중 오류가 발생했습니다.");
						}
					});
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
							console.log(data);
							if (data.result == "success") {
								self.reviewList = data.list || [];
								self.reviewCount = data.summary != null ? data.summary.REVIEW_COUNT : 0;
								self.reviewAvg = data.summary != null ? data.summary.REVIEW_AVG : 0;
							} else {
								self.reviewList = [];
								self.reviewCount = 0;
								self.reviewAvg = 0;
							}
						},
						error: function () {
							alert("리뷰 조회 중 오류가 발생했습니다.");
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
									self.qnaList[i].editTitle = self.qnaList[i].QNA_TITLE;
									self.qnaList[i].editContents = self.qnaList[i].Q_CONTENTS;
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
					if (qna.IS_SECRET != "Y") {
						return true;
					}

					if (this.currentUserRole == "A") {
						return true;
					}

					if (this.currentUserId != "" && this.currentUserId == qna.USER_ID) {
						return true;
					}

					return false;
				},

				fnCanManageQna: function (qna) {
					if (this.currentUserRole == "A") {
						return true;
					}

					if (this.currentUserId != "" && this.currentUserId == qna.USER_ID) {
						return true;
					}

					return false;
				},

				fnToggleQna: function (qna) {
					qna.open = !qna.open;
				},

				fnEditQna: function (qna) {
					qna.editMode = true;
					qna.editTitle = qna.QNA_TITLE;
					qna.editContents = qna.Q_CONTENTS;
				},

				fnCancelEditQna: function (qna) {
					qna.editMode = false;
					qna.editTitle = qna.QNA_TITLE;
					qna.editContents = qna.Q_CONTENTS;
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

					$.ajax({
						url: "/qna/update.dox",
						dataType: "json",
						type: "POST",
						data: {
							qnaNo: qna.QNA_NO,
							title: qna.editTitle,
							contents: qna.editContents
						},
						success: function (data) {
							if (data.result == "success") {
								alert("문의가 수정되었습니다.");
								self.fnGetQnaList();
							} else if (data.result == "login") {
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";
							} else {
								alert("문의 수정 실패");
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

					$.ajax({
						url: "/qna/delete.dox",
						dataType: "json",
						type: "POST",
						data: {
							qnaNo: qnaNo
						},
						success: function (data) {
							if (data.result == "success") {
								alert("문의가 삭제되었습니다.");
								self.fnGetQnaList();
							} else if (data.result == "login") {
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";
							} else {
								alert("문의 삭제 실패");
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
						alert("로그인이 필요합니다.");
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
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";
							} else {
								alert("문의 등록 실패");
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

					if (newQty > self.product.STOCK_QTY) {
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

					if (newQty > self.product.STOCK_QTY) {
						alert("재고수량을 초과할 수 없습니다.");
						self.qty = self.product.STOCK_QTY;
						return;
					}

					self.qty = newQty;
				},

				fnAddCart: function () {
					let self = this;
					if (self.qty > self.product.STOCK_QTY) {
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
								alert("장바구니에 담았습니다.");
								self.fnGetCartCount();
							} else if (data.result == "login") {
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";
							} else {
								alert("장바구니 담기 실패");
							}
						},
						error: function () {
							alert("장바구니 처리 중 오류가 발생했습니다.");
						}
					});
				},

				fnDirectOrder: function () {
					let self = this;
					if (self.qty > self.product.STOCK_QTY) {
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
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";
							} else {
								alert("바로구매 처리 실패");
							}
						},
						error: function () {
							alert("바로구매 처리 중 오류가 발생했습니다.");
						}
					});
				},

				fnGetCartCount: function () {
					let self = this;
					$.ajax({
						url: "/cart/count.dox",
						dataType: "json",
						type: "POST",
						data: {},
						success: function (data) {
							if (data.result == "success") {
								self.cartCount = data.cartCount;
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

				fnMoveCart: function () {
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

					return Number(this.product.PRODUCT_PRICE) * Number(this.qty);
				}
			},
			mounted() {
				this.fnGetProductView();
				this.fnGetReviewList();
				this.fnGetQnaList();
				this.fnGetCartCount();
			}
		});

		app.mount('#app');
	</script>

	<jsp:include page="/WEB-INF/footer/footer.jsp" />

	</body>

	</html>