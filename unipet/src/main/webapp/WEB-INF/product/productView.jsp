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

		<style>
			* {
				box-sizing: border-box;
			}

			body {
				margin: 0;
				font-family: 'Malgun Gothic', sans-serif;
				background-color: #f7f8fa;
				color: #333;
			}

			.wrap {
				width: 1200px;
				margin: 0 auto;
				padding: 30px 0;
			}

			.title {
				font-size: 30px;
				font-weight: bold;
				margin-bottom: 20px;
			}

			.detail-box,
			.review-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 25px;
				margin-bottom: 20px;
			}

			.detail-wrap {
				display: flex;
				gap: 30px;
			}

			.detail-left {
				width: 420px;
				flex-shrink: 0;
			}

			.main-img {
				width: 100%;
				height: 420px;
				object-fit: cover;
				border-radius: 10px;
				background: #f3f3f3;
				border: 1px solid #ddd;
			}

			.thumb-list {
				display: flex;
				gap: 8px;
				margin-top: 10px;
				flex-wrap: wrap;
			}

			.thumb-img {
				width: 75px;
				height: 75px;
				object-fit: cover;
				border: 1px solid #ddd;
				border-radius: 8px;
				background: #f3f3f3;
				cursor: pointer;
			}

			.detail-right {
				flex: 1;
			}

			.detail-right h3 {
				font-size: 28px;
				margin-top: 0;
				margin-bottom: 16px;
			}

			.detail-info {
				line-height: 2;
				font-size: 15px;
			}

			.price {
				font-size: 30px;
				color: #ff7a00;
				font-weight: bold;
				margin: 20px 0;
			}

			.qty-box {
				margin: 20px 0;
			}

			.qty-box button {
				width: 32px;
				height: 32px;
				border: 1px solid #ccc;
				background: #fff;
				cursor: pointer;
			}

			.qty-box span {
				display: inline-block;
				width: 50px;
				text-align: center;
				font-weight: bold;
			}

			.btn-area button,
			.review-top button,
			.qna-write-btn {
				min-width: 130px;
				height: 44px;
				border: none;
				border-radius: 8px;
				cursor: pointer;
				font-size: 15px;
				font-weight: bold;
			}

			.btn-cart {
				background: #e9ecef;
				color: #333;
				margin-right: 10px;
			}

			.btn-buy,
			.btn-review,
			.qna-write-btn {
				background: #ff7a00;
				color: #fff;
			}

			.empty-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 50px;
				text-align: center;
			}

			.review-top {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 20px;
			}

			.review-summary {
				font-size: 16px;
				font-weight: bold;
			}

			.review-item,
			.qna-item {
				border-top: 1px solid #eee;
				padding: 18px 0;
			}

			.review-item:first-child,
			.qna-item:first-child {
				border-top: none;
				padding-top: 0;
			}

			.review-head,
			.qna-head {
				display: flex;
				justify-content: space-between;
				margin-bottom: 8px;
				font-size: 14px;
			}

			.review-user,
			.qna-user {
				font-weight: bold;
			}

			.review-date,
			.qna-date {
				color: #888;
			}

			.review-rating {
				color: #ff7a00;
				font-weight: bold;
				margin-bottom: 8px;
			}

			.review-contents,
			.qna-contents,
			.answer-box {
				line-height: 1.7;
				font-size: 14px;
				white-space: pre-line;
			}

			.header {
				width: 100%;
				height: 70px;
				background: #ffffff;
				border-bottom: 1px solid #eee;
				display: flex;
				justify-content: space-between;
				align-items: center;
				padding: 0 40px;
				position: sticky;
				top: 0;
				z-index: 999;
				box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
			}

			.logo {
				font-size: 24px;
				font-weight: bold;
				color: #ff7a00;
			}

			.header-right {
				display: flex;
				align-items: center;
				gap: 20px;
			}

			.cart-box {
				position: relative;
				width: 48px;
				height: 48px;
				border-radius: 50%;
				background: #f8f9fa;
				display: flex;
				justify-content: center;
				align-items: center;
				cursor: pointer;
				transition: all 0.2s ease;
			}

			.cart-box:hover {
				background: #fff1e6;
				transform: scale(1.1);
			}

			.cart-icon {
				font-size: 22px;
			}

			.cart-badge {
				position: absolute;
				top: -4px;
				right: -4px;
				min-width: 20px;
				height: 20px;
				padding: 0 5px;
				background: #ff3b3b;
				color: white;
				font-size: 12px;
				font-weight: bold;
				border-radius: 999px;
				display: flex;
				align-items: center;
				justify-content: center;
			}

			/* 탭 */
			.tab-menu {
				display: flex;
				justify-content: center;
				align-items: center;
				gap: 20px;
				background: #cfd7ff;
				border-radius: 12px;
				padding: 14px 20px;
				margin-bottom: 20px;
			}

			.tab-btn {
				border: none;
				background: transparent;
				padding: 10px 22px;
				font-size: 20px;
				font-weight: bold;
				cursor: pointer;
				border-radius: 20px;
			}

			.tab-btn.active {
				background: #d8d2c8;
			}

			.tab-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 25px;
				margin-bottom: 20px;
			}

			.detail-desc-title {
				font-size: 20px;
				font-weight: bold;
				margin-bottom: 20px;
			}

			.detail-img-list img {
				max-width: 100%;
				display: block;
				margin: 0 auto 15px;
			}

			.qna-write-box {
				background: #f8f9fa;
				border: 1px solid #ddd;
				border-radius: 10px;
				padding: 20px;
				margin-bottom: 20px;
			}

			.qna-write-box input,
			.qna-write-box textarea,
			.qna-write-box select {
				width: 100%;
				border: 1px solid #ccc;
				border-radius: 8px;
				padding: 10px;
				font-size: 14px;
				margin-bottom: 10px;
				font-family: 'Malgun Gothic', sans-serif;
			}

			.qna-write-box textarea {
				height: 120px;
				resize: none;
			}

			.qna-status {
				display: inline-block;
				padding: 4px 10px;
				border-radius: 20px;
				font-size: 12px;
				font-weight: bold;
				margin-bottom: 8px;
			}

			.qna-status.waiting {
				background: #fff1c9;
				color: #7b5a00;
			}

			.qna-status.done {
				background: #dff4df;
				color: #1f6b1f;
			}

			.answer-box {
				margin-top: 12px;
				padding: 12px;
				background: #f8f8f8;
				border-radius: 8px;
			}
		</style>
	</head>

	<body>
		<div id="app">
			<div class="header">
				<div class="logo">UniPet</div>

				<div class="header-right">
					<div class="cart-box" @click="fnMoveCart()">
						<span class="cart-icon">🛒</span>
						<span class="cart-badge" v-if="cartCount > 0">{{cartCount}}</span>
					</div>
				</div>
			</div>

			<div class="wrap">

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

							<div class="detail-info">
								브랜드 : {{product.BRAND == null ? '-' : product.BRAND}}<br>
								동물분류 : {{product.A_SUB_TYPE}}<br>
								상품분류 : {{product.I_SUB_TYPE}}<br>
								재고 : {{product.STOCK_QTY}}개<br>
							</div>

							<div class="price">{{formatPrice(product.PRODUCT_PRICE)}}원</div>

							<div class="qty-box">
								수량 :
								<button @click="fnQty(-1)">-</button>
								<span>{{qty}}</span>
								<button @click="fnQty(1)">+</button>
							</div>

							<div class="btn-area">
								<button type="button" class="btn-cart" @click="fnAddCart()">장바구니</button>
								<button type="button" class="btn-buy">구매하기</button>
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
					<div class="detail-desc-title">{{product.PRODUCT_NAME}}</div>

					<div class="detail-img-list">
						<img v-for="img in detailImageList" :key="img.FILE_NO" :src="img.IMG">
					</div>
				</div>

				<!-- 상품평 -->
				<div v-if="product && tab == 'review'" class="review-box">
					<div class="review-top">
						<div class="review-summary">
							리뷰 {{reviewCount}}개 / 평균 별점 {{reviewAvg}}
						</div>
						<button type="button" class="btn-review" @click="fnMoveReviewWrite()">리뷰 작성</button>
					</div>

					<div v-if="reviewList.length == 0" class="empty-box">
						아직 작성된 리뷰가 없습니다.
					</div>

					<div v-else>
						<div class="review-item" v-for="review in reviewList" :key="review.REVIEW_NO">
							<div class="review-head">
								<span class="review-user">{{review.USER_ID}}</span>
								<span class="review-date">{{review.CDATE}}</span>
							</div>
							<div class="review-rating">별점 : {{review.RATING}} / 5</div>
							<div class="review-contents">{{review.CONTENTS}}</div>
						</div>
					</div>
				</div>

				<!-- 상품문의 -->
				<div v-if="product && tab == 'qna'" class="tab-box">
					<div class="qna-write-box">
						<select v-model="qnaForm.secretYn">
							<option value="N">공개문의</option>
							<option value="Y">비밀문의</option>
						</select>

						<input type="text" v-model="qnaForm.title" placeholder="문의 제목을 입력하세요">
						<textarea v-model="qnaForm.contents" placeholder="문의 내용을 입력하세요"></textarea>
						<button type="button" class="qna-write-btn" @click="fnAddQna()">문의 등록</button>
					</div>

					<div v-if="qnaList.length == 0" class="empty-box">
						아직 등록된 문의가 없습니다.
					</div>

					<div v-else>
						<div class="qna-item" v-for="qna in qnaList" :key="qna.QNA_NO">
							<div class="qna-head">
								<span class="qna-user">{{qna.USER_ID}}</span>
								<span class="qna-date">{{qna.CDATE}}</span>
							</div>

							<div class="qna-status" :class="qna.ANS_STATUS == 'Y' ? 'done' : 'waiting'">
								{{qna.ANS_STATUS == 'Y' ? '답변완료' : '답변대기'}}
							</div>

							<div style="font-weight:bold; margin-bottom:8px;">{{qna.QNA_TITLE}}</div>

							<div class="qna-contents">
								{{qna.IS_SECRET == 'Y' ? '비밀문의입니다.' : qna.Q_CONTENTS}}
							</div>

							<div class="answer-box"
								v-if="qna.ANS_STATUS == 'Y' && qna.A_CONTENTS != null && qna.A_CONTENTS != ''">
								판매자 답변<br>
								{{qna.A_CONTENTS}}
							</div>
						</div>
					</div>
				</div>

				<div v-if="!product" class="empty-box">
					상품 상세 조회 실패
				</div>
			</div>
		</div>
	</body>

	</html>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					productNo: "<%=request.getAttribute("productNo")%>",
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
							console.log(data);

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
							if (data.result == "success") {
								self.reviewList = data.list;
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
								self.qnaList = data.list;
							} else {
								self.qnaList = [];
							}
						},
						error: function () {
							alert("문의 조회 중 오류가 발생했습니다.");
						}
					});
				},

				fnAddQna: function () {
					let self = this;

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
					let newQty = self.qty + num;

					if (newQty < 1) {
						return;
					}

					self.qty = newQty;
				},

				fnAddCart: function () {
					let self = this;
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
							} else {
								alert("장바구니 담기 실패");
							}
						},
						error: function () {
							alert("장바구니 처리 중 오류가 발생했습니다.");
						}
					});
				},

				fnMoveReviewWrite: function () {
					location.href = "/review/write.do?productNo=" + this.productNo;
				},

				formatPrice: function (price) {
					return Number(price).toLocaleString();
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

				fnMoveCart: function () {
					location.href = "/cart.do";
				},
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