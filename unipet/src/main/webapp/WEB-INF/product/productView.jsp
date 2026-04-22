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

			.detail-box,
			.review-box,
			.tab-box {
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
				margin-bottom: 20px;
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
				cursor: pointer;
				display: flex;
				align-items: baseline;
				gap: 6px;
			}

			.logo-sub {
				font-size: 12px;
				color: #999;
				font-weight: normal;
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

			.detail-desc-top {
				background: linear-gradient(135deg, #fff8f2 0%, #ffffff 100%);
				border: 1px solid #ffe0c2;
				border-radius: 16px;
				padding: 28px;
				margin-bottom: 24px;
			}

			.detail-desc-badge {
				display: inline-block;
				padding: 6px 12px;
				border-radius: 999px;
				background: #ffefe2;
				color: #ff7a00;
				font-size: 12px;
				font-weight: bold;
				margin-bottom: 14px;
			}

			.detail-desc-title {
				font-size: 28px;
				font-weight: bold;
				margin-bottom: 10px;
				color: #222;
			}

			.detail-desc-sub {
				font-size: 14px;
				color: #777;
				margin-bottom: 14px;
			}

			.detail-desc-price {
				font-size: 30px;
				font-weight: bold;
				color: #ff7a00;
			}

			.detail-point-wrap {
				display: grid;
				grid-template-columns: repeat(3, 1fr);
				gap: 16px;
				margin-bottom: 24px;
			}

			.detail-point-box {
				background: #fff;
				border: 1px solid #eee;
				border-radius: 14px;
				padding: 20px;
				box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
			}

			.detail-point-title {
				font-size: 16px;
				font-weight: bold;
				margin-bottom: 10px;
				color: #333;
			}

			.detail-point-text {
				font-size: 14px;
				line-height: 1.7;
				color: #666;
			}

			.detail-section-title {
				font-size: 20px;
				font-weight: bold;
				margin-bottom: 18px;
				color: #333;
			}

			.detail-empty-desc {
				background: #fafafa;
				border: 1px dashed #ddd;
				border-radius: 14px;
				padding: 40px 20px;
				text-align: center;
				color: #999;
				font-size: 14px;
			}

			.detail-rating {
				font-size: 14px;
				color: #ff7a00;
				font-weight: bold;
				margin-bottom: 10px;
			}

			.delivery-box {
				background: #fafafa;
				border: 1px solid #eee;
				border-radius: 10px;
				padding: 12px;
				font-size: 13px;
				color: #555;
				margin-top: 10px;
			}

			.tag-box span {
				display: inline-block;
				background: #fff1e6;
				color: #ff7a00;
				padding: 4px 10px;
				border-radius: 999px;
				font-size: 12px;
				margin-right: 6px;
			}

			.stock-status {
				color: red;
				font-size: 13px;
				font-weight: bold;
				margin-top: 6px;
			}

			.simple-desc {
				font-size: 14px;
				color: #666;
				line-height: 1.6;
				margin-top: 10px;
			}

			.qna-write-box {
				background: #f8f9fa;
				border: 1px solid #ddd;
				border-radius: 10px;
				padding: 20px;
				margin-bottom: 20px;
			}

			.qna-write-box input,
			.qna-write-box textarea {
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

			.qna-write-header {
				margin-bottom: 16px;
			}

			.qna-title {
				font-size: 20px;
				font-weight: bold;
				color: #222;
				margin-bottom: 4px;
			}

			.qna-desc {
				font-size: 13px;
				color: #888;
			}

			.qna-secret-row {
				display: flex;
				align-items: center;
				gap: 16px;
				margin-bottom: 14px;
				flex-wrap: wrap;
			}

			.qna-secret-label {
				font-size: 14px;
				font-weight: bold;
				color: #444;
				min-width: 70px;
			}

			.qna-secret-option-wrap {
				display: flex;
				align-items: center;
				gap: 10px;
				flex-wrap: wrap;
			}

			.qna-secret-option {
				display: inline-flex;
				align-items: center;
				justify-content: center;
				gap: 6px;
				min-width: 110px;
				height: 42px;
				padding: 0 16px;
				border: 1px solid #ddd;
				border-radius: 999px;
				background: #fff;
				cursor: pointer;
				font-size: 14px;
				color: #555;
				white-space: nowrap;
				transition: all 0.2s ease;
			}

			.qna-secret-option:hover {
				border-color: #ffb36b;
				background: #fffaf5;
			}

			.qna-secret-option.active {
				border-color: #ff7a00;
				background: #fff1e6;
				color: #ff7a00;
				font-weight: bold;
			}

			.qna-secret-option input[type="radio"] {
				margin: 0;
				width: 16px;
				height: 16px;
				flex-shrink: 0;
			}

			.qna-list-box {
				margin-top: 10px;
			}

			.qna-top-row {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 10px;
			}

			.qna-head-left {
				display: flex;
				align-items: center;
				gap: 8px;
			}

			.qna-head-right {
				color: #888;
				font-size: 13px;
			}

			.qna-type-badge {
				display: inline-block;
				padding: 4px 10px;
				border-radius: 999px;
				font-size: 12px;
				font-weight: bold;
			}

			.qna-type-badge.secret {
				background: #fff1c9;
				color: #7b5a00;
			}

			.qna-type-badge.open {
				background: #eaf7ea;
				color: #2c7a2c;
			}

			.qna-title-row {
				display: flex;
				justify-content: space-between;
				align-items: center;
				cursor: pointer;
				padding: 14px 16px;
				background: #fafafa;
				border: 1px solid #eee;
				border-radius: 10px;
			}

			.qna-title-text {
				font-weight: bold;
				font-size: 15px;
			}

			.qna-title-right {
				display: flex;
				align-items: center;
				gap: 10px;
			}

			.qna-status {
				display: inline-block;
				padding: 4px 10px;
				border-radius: 20px;
				font-size: 12px;
				font-weight: bold;
			}

			.qna-status.waiting {
				background: #fff1c9;
				color: #7b5a00;
			}

			.qna-status.done {
				background: #dff4df;
				color: #1f6b1f;
			}

			.qna-arrow {
				font-size: 12px;
				color: #888;
			}

			.qna-body-box {
				padding: 16px;
				background: #fff;
				border: 1px solid #f0f0f0;
				border-top: none;
				border-radius: 0 0 10px 10px;
			}

			.qna-secret-lock {
				padding: 16px;
				background: #fafafa;
				border-radius: 8px;
				color: #888;
				font-size: 14px;
			}

			.qna-btn-row {
				margin-top: 14px;
				display: flex;
				gap: 8px;
			}

			.qna-small-btn {
				height: 34px;
				padding: 0 14px;
				border: none;
				border-radius: 8px;
				cursor: pointer;
				font-size: 13px;
				font-weight: bold;
			}

			.qna-small-btn.edit {
				background: #e9ecef;
				color: #333;
			}

			.qna-small-btn.delete {
				background: #ffe3e3;
				color: #d6336c;
			}

			.qna-small-btn.save {
				background: #ff7a00;
				color: #fff;
			}

			.qna-small-btn.cancel {
				background: #adb5bd;
				color: #fff;
			}

			.qna-edit-input,
			.qna-edit-textarea {
				width: 100%;
				border: 1px solid #ddd;
				border-radius: 8px;
				padding: 10px;
				font-size: 14px;
				font-family: 'Malgun Gothic', sans-serif;
				margin-bottom: 10px;
			}

			.qna-edit-textarea {
				height: 120px;
				resize: none;
			}

			.answer-title {
				font-weight: bold;
				margin-bottom: 8px;
				color: #444;
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
				<div class="logo" @click="fnMoveMain()">
					UniPet <span class="logo-sub">shop</span>
				</div>

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

							<div class="delivery-box">
								<div>🚚 무료배송 (3만원 이상)</div>
								<div>📦 평균 배송 1~2일</div>
								<div>💳 카드/간편결제 가능</div>
							</div>

							<div class="qty-box">
								수량 :
								<button @click="fnQty(-1)">-</button>
								<span>{{qty}}</span>
								<button @click="fnQty(1)">+</button>
							</div>

							<div class="stock-status" v-if="product.STOCK_QTY < 10">
								🔥 재고 얼마 안 남음!
							</div>

							<div class="btn-area">
								<button type="button" class="btn-cart" @click="fnAddCart()">장바구니</button>
								<button type="button" class="btn-buy" @click="fnDirectOrder()">구매하기</button>
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
									<div class="qna-title-text">{{qna.QNA_TITLE}}</div>
									<div class="qna-title-right">
										<span class="qna-status" :class="qna.ANS_STATUS == 'Y' ? 'done' : 'waiting'">
											{{qna.ANS_STATUS == 'Y' ? '답변완료' : '답변대기'}}
										</span>
										<span class="qna-arrow">{{qna.open ? '▲' : '▼'}}</span>
									</div>
								</div>

								<div v-if="qna.open" class="qna-body-box">
									<div v-if="qna.editMode">
										<input type="text" class="qna-edit-input" v-model="qna.editTitle">
										<textarea class="qna-edit-textarea" v-model="qna.editContents"></textarea>

										<div class="qna-btn-row">
											<button class="qna-small-btn save" @click="fnSaveQna(qna)">저장</button>
											<button class="qna-small-btn cancel"
												@click="fnCancelEditQna(qna)">취소</button>
										</div>
									</div>

									<div v-else>
										<div v-if="fnCanReadQna(qna)" class="qna-contents">
											{{qna.Q_CONTENTS}}
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
	</body>

	</html>

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
								location.href = "/payment/pay-shop.do";
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
					location.href = "/cart.do";
				},

				fnMoveMain: function () {
					location.href = "/product.do";
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