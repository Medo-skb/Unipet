<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app" v-cloak>
    <div class="container-main">
        <div class="admin-wrap">

            <jsp:include page="/WEB-INF/admin/adminSidebar.jsp">
                <jsp:param name="activeMenu" value="productManage" />
            </jsp:include>

            <section class="admin-content">
                <div class="content-card">
                    <h2>상품 등록 및 관리</h2>
                    <div class="content-desc">상품 목록을 조회하고 등록 및 수정 할 수 있습니다.</div>

                    <div class="admin-search-box">
                        <select class="admin-search-select" v-model="productStatus" @change="fnSearchProductList">
                            <option value="">전체 상태</option>
                            <option value="Y">판매중</option>
                            <option value="N">판매중지</option>
                        </select>

                        <input
                            type="text"
                            class="admin-search-input"
                            v-model="keyword"
                            @keyup.enter="fnSearchProductList"
                            placeholder="상품명, 브랜드 검색">

                        <button type="button" class="admin-search-btn" @click="fnSearchProductList">검색</button>
                        <button type="button" class="btn-add-product" @click="fnGoProductRegister">상품 등록</button>
                        </div>

                    <div class="admin-product-table-wrap">
                        <table class="admin-detail-table admin-product-table">
                            <thead>
                                <tr>
                                    <th>상품번호</th>
                                    <th>수정</th>
                                    <th>상품명</th>
                                    <th>브랜드</th>
                                    <th>동물 카테고리</th>
                                    <th>상품 카테고리</th>
                                    <th>가격</th>
                                    <th>재고</th>
                                    <th>상태</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in productList" :key="item.productNo">
                                    <td>{{ item.productNo }}</td>
                                    <td>
                                        <button type="button" class="admin-mini-btn" @click="fnGoProductEdit(item.productNo)">수정</button>
                                    </td>
                                    <td>
                                        <button type="button" class="detail-link-btn product-name-link" @click="fnGoProductView(item.productNo)">
                                            {{ fnEmpty(item.productName) }}
                                        </button>
                                    </td>
                                    <td>{{ fnEmpty(item.brand) }}</td>
                                    <td>{{ fnCategory(item.aMainType, item.aSubType) }}</td>
                                    <td>{{ fnCategory(item.iMainType, item.iSubType) }}</td>
                                    <td>{{ fnPrice(item.productPrice) }}</td>
                                    <td>{{ fnEmpty(item.stockQty) }}</td>
                                    <td>{{ fnProductStatus(item.productStatus) }}</td>
                                    <td>{{ fnDate(item.cdate) }}</td>
                                </tr>

                                <tr v-if="productList.length === 0">
                                    <td colspan="10">조회된 상품이 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="admin-pagination" v-if="totalCount > 0">
                        <button type="button" class="page-btn" :disabled="currentPage === 1" @click="fnMovePage(currentPage - 1)">이전</button>

                        <button type="button"
                                class="page-btn"
                                v-for="page in pageList"
                                :key="page"
                                :class="{ active: currentPage === page }"
                                @click="fnMovePage(page)">
                            {{ page }}
                        </button>

                        <button type="button" class="page-btn" :disabled="currentPage === totalPage" @click="fnMovePage(currentPage + 1)">다음</button>
                    </div>
                </div>
            </section>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
const app = Vue.createApp({
    data() {
        return {
            productList: [],
            keyword: "",
            productStatus: "",
            currentPage: 1,
            pageSize: 10,
            totalCount: 0
        };
    },
    computed: {
        totalPage: function () {
            return Math.ceil(this.totalCount / this.pageSize);
        },
        pageList: function () {
            let list = [];
            let startPage = Math.floor((this.currentPage - 1) / 10) * 10 + 1;
            let endPage = Math.min(startPage + 9, this.totalPage);

            for (let i = startPage; i <= endPage; i++) {
                list.push(i);
            }

            return list;
        }
    },
    methods: {
        fnGetProductList: function () {
            let self = this;

            $.ajax({
                url: "/admin/product/list.dox",
                type: "POST",
                dataType: "json",
                data: {
                    keyword: self.keyword,
                    productStatus: self.productStatus,
                    page: self.currentPage,
                    pageSize: self.pageSize
                },
                success: function (data) {
                    if (data.result === "success") {
                        self.productList = data.list || [];
                        self.totalCount = data.totalCount || 0;
                    } else {
                        alert(data.message || "상품 목록 조회에 실패했습니다.");
                    }
                }
            });
        },
        fnSearchProductList: function () {
            this.currentPage = 1;
            this.fnGetProductList();
        },
        fnMovePage: function (page) {
            if (page < 1 || page > this.totalPage) {
                return;
            }

            this.currentPage = page;
            this.fnGetProductList();
        },
        fnGoProductView: function (productNo) {
            location.href = "/product/view.do?productNo=" + productNo;
        },
        fnGoProductEdit: function (productNo) {
            location.href = "/admin/productEdit.do?productNo=" + productNo;
        },
        fnGoProductRegister: function () {
            location.href = "/admin/productRegister.do";
        },
        fnProductStatus: function (status) {
            if (status === "Y") {
                return "판매중";
            }

            if (status === "N") {
                return "판매중지";
            }

            return "-";
        },
        fnPrice: function (value) {
            if (value == null || value === "") {
                return "-";
            }

            return Number(value).toLocaleString() + "원";
        },
        fnDate: function (value) {
            if (value == null || value === "") {
                return "-";
            }

            let dateText = String(value).substring(0, 10);
            let dateParts = dateText.split("-");

            if (dateParts.length !== 3) {
                return value;
            }

            return dateParts[0].substring(2, 4) + "." + dateParts[1] + "." + dateParts[2];
        },
        fnEmpty: function (value) {
            if (value == null || value === "") {
                return "-";
            }

            return value;
        },
        fnCategory: function (mainType, subType) {
            if ((mainType == null || mainType === "") && (subType == null || subType === "")) {
                return "-";
            }

            if (mainType == null || mainType === "") {
                return subType;
            }

            if (subType == null || subType === "") {
                return mainType;
            }

            return mainType + " - " + subType;
        }
    },
    mounted: function () {
        this.fnGetProductList();
    }
});

app.mount("#app");
</script>

</body>
</html>