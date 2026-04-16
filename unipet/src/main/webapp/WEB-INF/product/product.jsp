<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>UniPet Product</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
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
				width: 1400px;
				margin: 0 auto;
				padding: 30px 0;
			}

			.title {
				font-size: 30px;
				font-weight: bold;
				margin-bottom: 20px;
			}

			.container {
				display: flex;
				gap: 20px;
				align-items: flex-start;
			}

			.sidebar {
				width: 250px;
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 14px;
				padding: 16px;
				max-height: 780px;
				overflow-y: auto;
				flex-shrink: 0;
				position: sticky;
				top: 20px;
			}

			.category-tab-wrap {
				display: flex;
				gap: 8px;
				margin-bottom: 16px;
			}

			.category-tab {
				flex: 1;
				height: 40px;
				border: 1px solid #ddd;
				border-radius: 8px;
				background: #f8f9fa;
				cursor: pointer;
				font-weight: bold;
				font-size: 14px;
			}

			.category-tab.active {
				background: #ff7a00;
				color: #fff;
				border-color: #ff7a00;
			}

			.category-panel {
				display: none;
			}

			.category-panel.active {
				display: block;
			}

			.category-title {
				font-size: 17px;
				font-weight: bold;
				margin-bottom: 12px;
			}

			.category-all {
				padding: 10px 12px;
				background: #fff7ed;
				border: 1px solid #ffd8b0;
				border-radius: 8px;
				cursor: pointer;
				font-weight: bold;
				margin-bottom: 10px;
				font-size: 14px;
			}

			.category-all.active {
				background: #ffedd5;
				border-color: #ff7a00;
				color: #ff7a00;
			}

			.main-category {
				padding: 12px;
				background: #f1f3f5;
				border-radius: 8px;
				margin-top: 10px;
				cursor: pointer;
				font-weight: bold;
				display: flex;
				justify-content: space-between;
				align-items: center;
				font-size: 14px;
			}

			.main-category:hover {
				background: #e9ecef;
			}

			.main-category.active {
				background: #ffe8cc;
				color: #ff7a00;
				border: 1px solid #ffc078;
			}

			.main-btns {
				margin-top: 6px;
				padding-left: 4px;
			}

			.main-view-btn {
				display: inline-block;
				margin-top: 6px;
				padding: 6px 10px;
				background: #f8f9fa;
				border: 1px solid #ddd;
				border-radius: 6px;
				cursor: pointer;
				font-size: 12px;
			}

			.main-view-btn.active {
				background: #fff1e6;
				border-color: #ff7a00;
				color: #ff7a00;
				font-weight: bold;
			}

			.sub-list {
				display: none;
				padding: 8px 0 8px 10px;
			}

			.sub-item {
				padding: 8px 10px;
				margin-top: 4px;
				border-radius: 6px;
				cursor: pointer;
				font-size: 13px;
			}

			.sub-item:hover {
				background: #fff1e6;
				color: #ff7a00;
			}

			.sub-item.active {
				background: #fff1e6;
				color: #ff7a00;
				font-weight: bold;
				border: 1px solid #ffd8b0;
			}

			.content {
				flex: 1;
				min-width: 0;
			}

			.selected-filter-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 15px 20px;
				margin-bottom: 15px;
				display: flex;
				align-items: center;
				gap: 8px;
				flex-wrap: wrap;
			}

			.filter-label {
				font-size: 14px;
				font-weight: bold;
				color: #555;
				margin-right: 4px;
			}

			.filter-tag {
				display: inline-block;
				padding: 6px 12px;
				background: #fff1e6;
				color: #ff7a00;
				border-radius: 999px;
				font-size: 13px;
				font-weight: bold;
			}

			.filter-reset-btn {
				padding: 6px 12px;
				border: none;
				border-radius: 8px;
				background: #868e96;
				color: white;
				cursor: pointer;
				margin-left: auto;
			}

			.search-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 20px;
				margin-bottom: 20px;
				display: flex;
				gap: 8px;
				flex-wrap: wrap;
				align-items: center;
			}

			.search-box input,
			.search-box select {
				height: 40px;
				padding: 0 12px;
				border: 1px solid #ccc;
				border-radius: 8px;
			}

			.search-box input {
				width: 260px;
			}

			.search-box button {
				height: 40px;
				padding: 0 16px;
				border: none;
				border-radius: 8px;
				background: #ff7a00;
				color: white;
				cursor: pointer;
				font-weight: bold;
			}

			.product-list {
				display: grid;
				grid-template-columns: repeat(4, 1fr);
				gap: 20px;
			}

			.product-card {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 15px;
				cursor: pointer;
				transition: 0.2s;
			}

			.product-card:hover {
				transform: translateY(-3px);
				box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
			}

			.product-card img {
				width: 100%;
				height: 220px;
				object-fit: cover;
				border-radius: 10px;
				background: #f3f3f3;
			}

			.product-name {
				font-size: 16px;
				font-weight: bold;
				margin-top: 10px;
			}

			.product-info {
				font-size: 13px;
				color: #666;
				margin-top: 5px;
			}

			.product-price {
				font-size: 18px;
				font-weight: bold;
				color: #ff7a00;
				margin-top: 10px;
			}

			.empty-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 50px;
				text-align: center;
			}

			.detail-box {
				margin-top: 30px;
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 25px;
				display: none;
			}

			.detail-wrap {
				display: flex;
				gap: 30px;
			}

			.detail-left {
				width: 420px;
				flex-shrink: 0;
			}

			.detail-left img.main {
				width: 100%;
				height: 420px;
				object-fit: cover;
				border-radius: 10px;
				background: #f3f3f3;
			}

			.thumb-list {
				display: flex;
				gap: 8px;
				margin-top: 10px;
				flex-wrap: wrap;
			}

			.thumb-list img {
				width: 75px;
				height: 75px;
				object-fit: cover;
				border: 1px solid #ddd;
				border-radius: 8px;
				background: #f3f3f3;
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
				line-height: 1.9;
				font-size: 15px;
			}

			.price {
				font-size: 30px;
				color: #ff7a00;
				font-weight: bold;
				margin: 20px 0;
			}

			.btn-area button {
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

			.btn-buy {
				background: #ff7a00;
				color: #fff;
			}
		</style>
	</head>

	<body>

		<div class="wrap">
			<div class="title">쇼핑몰</div>

			<div class="container">
				<div class="sidebar">
					<div class="category-tab-wrap">
						<button type="button" id="animalTabBtn" class="category-tab active"
							onclick="fnShowCategoryTab('animal')">동물별</button>
						<button type="button" id="itemTabBtn" class="category-tab"
							onclick="fnShowCategoryTab('item')">상품별</button>
					</div>

					<div id="animalPanel" class="category-panel active">
						<div class="category-title">동물 카테고리</div>
						<div id="animalCategoryArea"></div>
					</div>

					<div id="itemPanel" class="category-panel">
						<div class="category-title">상품 카테고리</div>
						<div id="itemCategoryArea"></div>
					</div>
				</div>

				<div class="content">
					<div class="selected-filter-box">
						<span class="filter-label">선택 필터</span>
						<span id="selectedAnimalTag"></span>
						<span id="selectedItemTag"></span>
						<button type="button" class="filter-reset-btn" onclick="fnResetFilter()">전체 초기화</button>
					</div>

					<div class="search-box">
						<input type="text" id="keyword" placeholder="상품명 검색">
						<select id="sort">
							<option value="">최신순</option>
							<option value="priceAsc">가격 낮은순</option>
							<option value="priceDesc">가격 높은순</option>
						</select>
						<button type="button" onclick="fnGetProductList()">검색</button>
					</div>

					<div id="listArea" class="product-list"></div>
					<div id="detailArea" class="detail-box"></div>
				</div>
			</div>
		</div>

		<script>
			let selectedAMainNo = "";
			let selectedASubNo = "";
			let selectedIMainNo = "";
			let selectedISubNo = "";

			let selectedAnimalText = "동물 전체";
			let selectedItemText = "상품 전체";

			$(document).ready(function () {
				fnGetCategoryList();
				fnGetProductList();
				fnRenderSelectedFilter();
			});

			function fnShowCategoryTab(type) {
				$(".category-tab").removeClass("active");
				$(".category-panel").removeClass("active");

				if (type == "animal") {
					$("#animalTabBtn").addClass("active");
					$("#animalPanel").addClass("active");
				} else {
					$("#itemTabBtn").addClass("active");
					$("#itemPanel").addClass("active");
				}
			}

			function fnGetCategoryList() {
				$.ajax({
					url: "http://localhost:8080/productCategory.dox",
					type: "POST",
					dataType: "json",
					data: {},
					success: function (data) {
						if (data.result == "success") {
							fnDrawAnimalCategory(data.animalMainList, data.animalSubList);
							fnDrawItemCategory(data.itemMainList, data.itemSubList);
						} else {
							alert("카테고리 조회 실패");
						}
					},
					error: function () {
						alert("카테고리 조회 중 오류가 발생했습니다.");
					}
				});
			}

			function fnDrawAnimalCategory(mainList, subList) {
				let html = "";
				html += "<div class='category-all " + (selectedAMainNo == '' && selectedASubNo == '' ? "active" : "") + "' onclick='fnSelectAnimalAll()'>동물 전체보기</div>";

				$.each(mainList, function (index, main) {
					let mainActive = (selectedAMainNo == String(main.A_MAIN_NO));
					let mainBtnActive = (selectedAMainNo == String(main.A_MAIN_NO) && selectedASubNo == "");

					html += "<div class='main-category " + (mainActive ? "active" : "") + "' onclick=\"fnToggleSub('animalSub_" + main.A_MAIN_NO + "')\">";
					html += "<span>" + main.A_MAIN_TYPE + "</span><span>+</span>";
					html += "</div>";

					html += "<div class='main-btns'>";
					html += "<span class='main-view-btn " + (mainBtnActive ? "active" : "") + "' onclick='fnSelectAnimalMain(" + main.A_MAIN_NO + ",\"" + main.A_MAIN_TYPE + "\")'>" + main.A_MAIN_TYPE + " 전체보기</span>";
					html += "</div>";

					html += "<div class='sub-list' id='animalSub_" + main.A_MAIN_NO + "' style='" + (mainActive ? "display:block;" : "") + "'>";
					$.each(subList, function (i, sub) {
						if (main.A_MAIN_NO == sub.A_MAIN_NO) {
							let subActive = (selectedASubNo == String(sub.A_SUB_NO));
							html += "<div class='sub-item " + (subActive ? "active" : "") + "' onclick='fnSelectAnimalSub(" + sub.A_MAIN_NO + "," + sub.A_SUB_NO + ",\"" + sub.A_SUB_TYPE + "\")'>" + sub.A_SUB_TYPE + "</div>";
						}
					});
					html += "</div>";
				});

				$("#animalCategoryArea").html(html);
			}

			function fnDrawItemCategory(mainList, subList) {
				let html = "";
				html += "<div class='category-all " + (selectedIMainNo == '' && selectedISubNo == '' ? "active" : "") + "' onclick='fnSelectItemAll()'>상품 전체보기</div>";

				$.each(mainList, function (index, main) {
					let mainActive = (selectedIMainNo == String(main.I_MAIN_NO));
					let mainBtnActive = (selectedIMainNo == String(main.I_MAIN_NO) && selectedISubNo == "");

					html += "<div class='main-category " + (mainActive ? "active" : "") + "' onclick=\"fnToggleSub('itemSub_" + main.I_MAIN_NO + "')\">";
					html += "<span>" + main.I_MAIN_TYPE + "</span><span>+</span>";
					html += "</div>";

					html += "<div class='main-btns'>";
					html += "<span class='main-view-btn " + (mainBtnActive ? "active" : "") + "' onclick='fnSelectItemMain(" + main.I_MAIN_NO + ",\"" + main.I_MAIN_TYPE + "\")'>" + main.I_MAIN_TYPE + " 전체보기</span>";
					html += "</div>";

					html += "<div class='sub-list' id='itemSub_" + main.I_MAIN_NO + "' style='" + (mainActive ? "display:block;" : "") + "'>";
					$.each(subList, function (i, sub) {
						if (main.I_MAIN_NO == sub.I_MAIN_NO) {
							let subActive = (selectedISubNo == String(sub.I_SUB_NO));
							html += "<div class='sub-item " + (subActive ? "active" : "") + "' onclick='fnSelectItemSub(" + sub.I_MAIN_NO + "," + sub.I_SUB_NO + ",\"" + sub.I_SUB_TYPE + "\")'>" + sub.I_SUB_TYPE + "</div>";
						}
					});
					html += "</div>";
				});

				$("#itemCategoryArea").html(html);
			}

			function fnToggleSub(id) {
				$("#" + id).slideToggle(150);
			}

			function fnSelectAnimalAll() {
				selectedAMainNo = "";
				selectedASubNo = "";
				selectedAnimalText = "동물 전체";
				fnRenderSelectedFilter();
				fnGetCategoryList();
				fnGetProductList();
			}

			function fnSelectAnimalMain(aMainNo, aMainType) {
				selectedAMainNo = String(aMainNo);
				selectedASubNo = "";
				selectedAnimalText = aMainType + " 전체";
				fnRenderSelectedFilter();
				fnGetCategoryList();
				fnGetProductList();
			}

			function fnSelectAnimalSub(aMainNo, aSubNo, aSubType) {
				selectedAMainNo = String(aMainNo);
				selectedASubNo = String(aSubNo);
				selectedAnimalText = aSubType;
				fnRenderSelectedFilter();
				fnGetCategoryList();
				fnGetProductList();
			}

			function fnSelectItemAll() {
				selectedIMainNo = "";
				selectedISubNo = "";
				selectedItemText = "상품 전체";
				fnRenderSelectedFilter();
				fnGetCategoryList();
				fnGetProductList();
			}

			function fnSelectItemMain(iMainNo, iMainType) {
				selectedIMainNo = String(iMainNo);
				selectedISubNo = "";
				selectedItemText = iMainType + " 전체";
				fnRenderSelectedFilter();
				fnGetCategoryList();
				fnGetProductList();
			}

			function fnSelectItemSub(iMainNo, iSubNo, iSubType) {
				selectedIMainNo = String(iMainNo);
				selectedISubNo = String(iSubNo);
				selectedItemText = iSubType;
				fnRenderSelectedFilter();
				fnGetCategoryList();
				fnGetProductList();
			}

			function fnResetFilter() {
				selectedAMainNo = "";
				selectedASubNo = "";
				selectedIMainNo = "";
				selectedISubNo = "";
				selectedAnimalText = "동물 전체";
				selectedItemText = "상품 전체";
				$("#keyword").val("");
				$("#sort").val("");
				fnRenderSelectedFilter();
				fnGetCategoryList();
				fnGetProductList();
			}

			function fnRenderSelectedFilter() {
				$("#selectedAnimalTag").html("<span class='filter-tag'>" + selectedAnimalText + "</span>");
				$("#selectedItemTag").html("<span class='filter-tag'>" + selectedItemText + "</span>");
			}

			function fnGetProductList() {
				let nparmap = {};
				nparmap.keyword = $("#keyword").val();
				nparmap.aMainNo = selectedAMainNo;
				nparmap.aSubNo = selectedASubNo;
				nparmap.iMainNo = selectedIMainNo;
				nparmap.iSubNo = selectedISubNo;
				nparmap.sort = $("#sort").val();

				$.ajax({
					url: "http://localhost:8080/productList.dox",
					type: "POST",
					dataType: "json",
					data: nparmap,
					success: function (data) {
						let html = "";

						if (data.result == "success") {
							if (data.list.length == 0) {
								$("#listArea").removeClass("product-list");
								html = "<div class='empty-box'>조회된 상품이 없습니다.</div>";
							} else {
								$("#listArea").addClass("product-list");
								$.each(data.list, function (index, item) {
									html += "<div class='product-card' onclick='fnGetProductView(" + item.PRODUCT_NO + ")'>";

									if (item.MAIN_IMG != null && item.MAIN_IMG != "") {
										html += "<img src='" + item.MAIN_IMG + "'>";
									} else {
										html += "<img src='http://localhost:8080/img/no-image.png'>";
									}

									html += "<div class='product-name'>" + item.PRODUCT_NAME + "</div>";
									html += "<div class='product-info'>브랜드 : " + (item.BRAND == null ? "-" : item.BRAND) + "</div>";
									html += "<div class='product-info'>동물 : " + item.A_SUB_TYPE + "</div>";
									html += "<div class='product-info'>상품 : " + item.I_SUB_TYPE + "</div>";
									html += "<div class='product-price'>" + item.PRODUCT_PRICE + "원</div>";
									html += "</div>";
								});
							}
						} else {
							$("#listArea").removeClass("product-list");
							html = "<div class='empty-box'>상품 목록 조회 실패</div>";
						}

						$("#listArea").html(html);
					},
					error: function (xhr) {
						console.log(xhr.responseText);
						alert("상품 목록 조회 중 오류가 발생했습니다.");
					}
				});
			}

			function fnGetProductView(productNo) {
				$.ajax({
					url: "http://localhost:8080/productView.dox",
					type: "POST",
					dataType: "json",
					data: {productNo: productNo},
					success: function (data) {
						let html = "";
						let p = data.product;

						if (data.result == "success" && p != null) {
							html += "<div class='detail-wrap'>";

							html += "<div class='detail-left'>";
							if (data.fileList != null && data.fileList.length > 0) {
								html += "<img class='main' src='" + data.fileList[0].FILE_PATH + data.fileList[0].FILE_NAME + "'>";
							} else {
								html += "<img class='main' src='http://localhost:8080/img/no-image.png'>";
							}

							html += "<div class='thumb-list'>";
							if (data.fileList != null && data.fileList.length > 0) {
								$.each(data.fileList, function (i, file) {
									html += "<img src='" + file.FILE_PATH + file.FILE_NAME + "'>";
								});
							}
							html += "</div>";
							html += "</div>";

							html += "<div class='detail-right'>";
							html += "<h3>" + p.PRODUCT_NAME + "</h3>";
							html += "<div class='detail-info'>";
							html += "브랜드 : " + (p.BRAND == null ? "-" : p.BRAND) + "<br>";
							html += "동물분류 : " + p.A_SUB_TYPE + "<br>";
							html += "상품분류 : " + p.I_SUB_TYPE + "<br>";
							html += "재고 : " + p.STOCK_QTY + "<br>";
							html += "</div>";
							html += "<div class='price'>" + p.PRODUCT_PRICE + "원</div>";
							html += "<div class='btn-area'>";
							html += "<button type='button' class='btn-cart'>장바구니</button>";
							html += "<button type='button' class='btn-buy'>구매하기</button>";
							html += "</div>";
							html += "</div>";

							html += "</div>";
						} else {
							html = "<div class='empty-box'>상품 상세 조회 실패</div>";
						}

						$("#detailArea").html(html).show();
						$("html, body").animate({
							scrollTop: $("#detailArea").offset().top - 20
						}, 300);
					},
					error: function (xhr) {
						console.log(xhr.responseText);
						alert("상품 상세 조회 중 오류가 발생했습니다.");
					}
				});
			}
		</script>

	</body>

	</html>