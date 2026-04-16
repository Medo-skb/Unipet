<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>UniPet - 통합 펫 케어 쇼핑몰</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        :root {
            --unipet-mint: #78C3A8;
            --unipet-blue: #8FAADC;
            --unipet-green: #4F7057;
            --light-gray: #f9f9f9;
        }

        body {
            font-family: 'Pretendard', sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 0;
        }

        header {
            background: #fff;
            padding: 15px 0;
            text-align: center;
            border-bottom: 2px solid var(--unipet-mint);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .logo {
            width: 160px;
            cursor: pointer;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .recommend-banner {
            background: #fff;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 40px;
            border: 1px solid var(--unipet-mint);
            box-shadow: 0 4px 15px rgba(120, 195, 168, 0.1);
        }

        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 15px;
            color: var(--unipet-green);
        }

        .recommend-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
        }

        .search-area {
            display: flex;
            gap: 30px;
        }

        .sidebar {
            width: 240px;
            background: #fff;
            padding: 20px;
            border-radius: 15px;
            height: fit-content;
            border: 1px solid #eee;
        }

        .filter-group {
            margin-bottom: 25px;
        }

        .filter-group h4 {
            font-size: 15px;
            margin-bottom: 10px;
            color: #333;
            border-left: 4px solid var(--unipet-mint);
            padding-left: 10px;
        }

        .filter-item {
            font-size: 14px;
            padding: 8px 10px;
            color: #666;
            cursor: pointer;
            border-radius: 8px;
            transition: 0.2s;
        }

        .filter-item:hover {
            background: var(--light-gray);
            color: var(--unipet-mint);
        }

        .filter-item.active {
            background: var(--unipet-mint);
            color: #fff !important;
            font-weight: bold;
        }

        .sub-menu {
            padding-left: 15px;
            margin-top: 5px;
            background: #fcfcfc;
            border-radius: 8px;
        }

        .main-content {
            flex: 1;
        }

        .sort-bar {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-bottom: 20px;
            align-items: center;
        }

        .sort-bar span {
            cursor: pointer;
            color: #888;
            font-size: 14px;
        }

        .sort-bar span.active {
            color: #333;
            font-weight: bold;
            text-decoration: underline;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .product-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            border: 1px solid #eee;
            transition: 0.3s;
            cursor: pointer;
        }

        .product-card:hover {
            transform: translateY(-7px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08);
        }

        .img-box {
            width: 100%;
            height: 220px;
            background: #fafafa;
        }

        .img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .info-box {
            padding: 15px;
        }

        .p-brand {
            font-size: 12px;
            color: var(--unipet-green);
            font-weight: bold;
        }

        .p-name {
            font-size: 15px;
            font-weight: bold;
            margin: 5px 0;
            height: 38px;
            overflow: hidden;
        }

        .p-price {
            font-size: 17px;
            color: #ff5e00;
            font-weight: 800;
        }
    </style>
</head>

<body>
    <div id="app">
        <header>
            <img src="../img/unipet_logo.png" class="logo" @click="fnReload">
        </header>

        <div class="container">
            <div class="recommend-banner" v-if="recommendList.length > 0">
                <div class="section-title">⭐ UniPet 맞춤 추천</div>
                <div class="recommend-grid">
                    <div v-for="item in recommendList" :key="item.PRODUCT_NO" class="product-card"
                        @click="fnDetail(item.PRODUCT_NO)">
                        <div class="img-box">
                            <img :src="'/upload/' + item.FILE_NAME" onerror="this.src='https://via.placeholder.com/200'">
                        </div>
                        <div class="info-box">
                            <div class="p-brand">{{item.BRAND}}</div>
                            <div class="p-name">{{item.PRODUCT_NAME}}</div>
                            <div class="p-price">{{item.PRODUCT_PRICE?.toLocaleString()}}원</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="search-area">
                <aside class="sidebar">
                    <div class="filter-group">
                        <h4>반려동물 종류</h4>
                        <div class="filter-item" :class="{active: aSubNo=='' && animalMain==''}"
                            @click="fnResetFilters">전체보기</div>
                        <div v-for="(subs, main) in animalMap" :key="main">
                            <div class="filter-item" :class="{active: animalMain==main && aSubNo==''}"
                                @click="fnSetAnimal(main, '')">{{main}}</div>
                            <div v-if="animalMain == main" class="sub-menu">
                                <div v-for="sub in subs" :key="sub.subNo" class="filter-item"
                                    :class="{active: aSubNo==sub.subNo}" @click="fnSetAnimal(main, sub.subNo)">
                                    - {{sub.subName}}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="filter-group">
                        <h4>상품 카테고리</h4>
                        <div v-for="(subs, main) in productMap" :key="main">
                            <div class="filter-item" :class="{active: productMain==main && iSubNo==''}"
                                @click="fnSetProduct(main, '')">{{main}}</div>
                            <div v-if="productMain == main" class="sub-menu">
                                <div v-for="sub in subs" :key="sub.subNo" class="filter-item"
                                    :class="{active: iSubNo==sub.subNo}" 
                                    @click="fnSetProduct(main, sub.subNo)">
                                    - {{sub.subName}}
                                </div>
                            </div>
                        </div>
                    </div>
                </aside>

                <main class="main-content">
                    <div class="sort-bar">
                        <div class="search-input-group" style="margin-right:auto; display:flex; gap:5px;">
                            <input v-model="keyword" placeholder="상품명 검색" @keyup.enter="fnList"
                                style="padding:8px 12px; border-radius:5px; border:1px solid #ddd; width:200px;">
                            <button @click="fnList"
                                style="background:var(--unipet-mint); color:#fff; border:none; padding:8px 15px; border-radius:5px; cursor:pointer; font-weight:bold;">검색</button>
                        </div>
                        <span :class="{active: sortType=='new'}" @click="fnSort('new')">최신순</span>
                        <span :class="{active: sortType=='priceAsc'}" @click="fnSort('priceAsc')">낮은가격순</span>
                    </div>

                    <div class="product-grid">
                        <div v-for="item in list" :key="item.PRODUCT_NO" class="product-card" @click="fnDetail(item.PRODUCT_NO)">
                            <div class="img-box">
                                <img :src="'/upload/' + item.FILE_NAME" onerror="this.src='https://via.placeholder.com/200'">
                            </div>
                            <div class="info-box">
                                <div class="p-brand">{{item.BRAND}}</div>
                                <div class="p-name">{{item.PRODUCT_NAME}}</div>
                                <div class="p-price">{{item.PRODUCT_PRICE?.toLocaleString()}}원</div>
                            </div>
                        </div>
                    </div>
                    <div v-if="list.length == 0" style="text-align:center; padding:50px; color:#999;">검색 결과가 없습니다.</div>
                </main>
            </div>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    recommendList: [], 
                    list: [],
                    animalMap: {}, 
                    productMap: {},
                    animalMain: '', 
                    productMain: '',
                    aSubNo: '', 
                    iSubNo: '',
                    keyword: '', 
                    sortType: 'new'
                }
            },
            methods: {
                fnGetCategories() {
                    let self = this;
                    $.ajax({
                        url: "http://localhost:8080/product/list.dox", // 실제 컨트롤러 매핑 주소 확인 필요
                        type: "POST",
                        success: function (data) {
                            self.animalMap = data.animalMap;
                            self.productMap = data.productMap;
                        }
                    });
                },
                fnSetAnimal(main, subNo) {
                    this.iSubNo = ''; // 상품 카테고리 필터 초기화
                    this.productMain = '';
                    if (subNo === '') {
                        this.animalMain = (this.animalMain === main) ? '' : main;
                        this.aSubNo = '';
                    } else {
                        this.aSubNo = subNo;
                    }
                    this.fnList();
                },
                fnSetProduct(main, subNo) {
                    this.aSubNo = ''; // 동물 카테고리 필터 초기화
                    this.animalMain = '';
                    if (subNo === '') {
                        this.productMain = (this.productMain === main) ? '' : main;
                        this.iSubNo = '';
                    } else {
                        this.iSubNo = subNo;
                    }
                    this.fnList();
                },
                fnResetFilters() {
                    this.animalMain = ''; 
                    this.productMain = '';
                    this.aSubNo = ''; 
                    this.iSubNo = '';
                    this.keyword = '';
                    this.fnList();
                },
                fnList() {
                    let self = this;
                    let param = {
                        aSubNo: self.aSubNo,
                        iSubNo: self.iSubNo,
                        keyword: self.keyword,
                        sortType: self.sortType
                    };
                    $.ajax({
                        url: "/list.dox", 
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(param),
                        success: function (data) {
                            self.list = data.list;
                        }
                    });
                },
                fnGetRecommend() {
                    let self = this;
                    $.ajax({
                        url: "/list.dox", 
                        type: "POST", 
                        contentType: "application/json",
                        data: JSON.stringify({isBest: 'Y'}),
                        success: function (data) {
                            self.recommendList = data.list ? data.list.slice(0, 4) : [];
                        }
                    });
                },
                fnSort(type) {
                    this.sortType = type; 
                    this.fnList();
                },
                fnDetail(pNo) {
                    location.href = "/product/view.do?productNo=" + pNo;
                },
                fnReload() {
                    location.href = "/product.do";
                }
            },
            mounted() {
                this.fnGetCategories();
                this.fnList();
                this.fnGetRecommend();
            }
        }).mount('#app');
    </script>
</body>
</html>