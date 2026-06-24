<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapApiKey}&autoload=false"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app" v-cloak>
    <div class="container-main">
        <div class="admin-wrap">

            <jsp:include page="/WEB-INF/admin/adminSidebar.jsp">
                <jsp:param name="activeMenu" value="businessUserManage" />
            </jsp:include>

            <section class="admin-content">
                <div class="content-card">
                    <h2>사업자 회원 조회 및 관리</h2>
                    <div class="content-desc">사업자 회원 정보, 업체 정보, 신고 및 예약 내역을 조회합니다.</div>

                    <div class="admin-search-box">
                        <select class="admin-search-select" v-model="sStatus" @change="fnSearchBusinessUserList">
                            <option value="">전체 상태</option>
                            <option value="AFF">제휴</option>
                            <option value="GEN">가입</option>
                            <option value="PND">대기</option>
                            <option value="REJ">반려</option>
                        </select>

                        <select class="admin-search-select" v-model="isOpen" @change="fnSearchBusinessUserList">
                            <option value="">전체 영업</option>
                            <option value="Y">영업중</option>
                            <option value="N">폐업</option>
                        </select>

                        <select class="admin-search-select" v-model="sortType" @change="fnSearchBusinessUserList">
                            <option value="">기본순</option>
                            <option value="ratingDesc">평점 높은순</option>
                            <option value="ratingAsc">평점 낮은순</option>
                            <option value="reservationDesc">예약 많은순</option>
                            <option value="reservationAsc">예약 적은순</option>
                        </select>

                        <input
                            type="text"
                            class="admin-search-input"
                            v-model="keyword"
                            @keyup.enter="fnSearchBusinessUserList"
                            placeholder="사업자 아이디, 대표자명, 업체명 검색">
                        <button type="button" class="admin-search-btn" @click="fnSearchBusinessUserList">검색</button>
                    </div>

                    <div class="admin-user-sticky-area">
                        <div class="admin-user-head-wrap">
                            <table class="admin-user-table admin-user-head-table business-user-table">
                                <thead>
                                    <tr>
                                        <th>사업자 아이디</th>
                                        <th>기본 정보</th>
                                        <th>업체</th>
                                        <th>업체 상태</th>
                                        <th>폐업 여부</th>
                                        <th>평점</th>
                                        <th>예약 건수(취소 외/취소)</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>

                    <div class="admin-user-table-wrap">
                        <table class="admin-user-table business-user-table">
                            <thead class="admin-user-hidden-thead">
                                <tr>
                                    <th>사업자 아이디</th>
                                    <th>기본 정보</th>
                                    <th>업체</th>
                                    <th>업체 상태</th>
                                    <th>폐업 여부</th>
                                    <th>평점</th>
                                    <th>예약 건수(취소 외/취소)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in businessUserList" :key="item.storeNo">
                                    <td>
                                        <div class="user-id-text" :title="item.sUserId">{{ fnShortId(item.sUserId) }}</div>
                                    </td>
                                    <td>
                                        <button type="button" class="detail-link-btn" @click="fnOpenBasic(item)">상세보기</button>
                                    </td>
                                    <td>
                                        <button type="button" class="detail-link-btn store-name-link" :title="fnEmpty(item.storeName)" @click="fnOpenStoreDetail(item)">
                                            {{ fnEmpty(item.storeName) }}
                                        </button>
                                    </td>
                                    <td>{{ fnStoreStatus(item.sStatus) }}</td>
                                    <td>{{ fnOpenStatus(item.isOpen) }}</td>
                                    <td>
                                        <button type="button" class="detail-link-btn" @click="fnOpenReview(item)">
                                            {{ fnEmpty(item.avgRating) }}
                                        </button>
                                    </td>
                                    <td>
                                        <button type="button" class="detail-link-btn" @click="fnOpenReservation(item)">
                                            {{ item.totalReservationCount }}건
                                            ({{ item.activeReservationCount }} / {{ item.cancelReservationCount }})
                                        </button>
                                    </td>
                                </tr>

                                <tr v-if="businessUserList.length === 0">
                                    <td colspan="7">조회된 사업자 회원이 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="admin-user-top-scroll">
                        <div class="admin-user-scroll-inner business-user-scroll-inner"></div>
                    </div>

                    <div class="admin-pagination" v-if="totalCount > 0">
                        <button type="button" class="page-btn" :disabled="currentPage === 1" @click="fnMovePage(currentPage - 1)">
                            이전
                        </button>

                        <button type="button"
                                class="page-btn"
                                v-for="page in pageList"
                                :key="page"
                                :class="{ active: currentPage === page }"
                                @click="fnMovePage(page)">
                            {{ page }}
                        </button>

                        <button type="button" class="page-btn" :disabled="currentPage === totalPage" @click="fnMovePage(currentPage + 1)">
                            다음
                        </button>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <div class="admin-user-modal-bg" v-if="modalOpen">
        <div class="admin-user-modal">
            <div class="admin-user-modal-header">
                <h3>{{ modalTitle }}</h3>
                <button type="button" class="admin-user-modal-close" @click="fnCloseModal">×</button>
            </div>

            <div class="admin-user-modal-body">
                <table class="approve-table" v-if="modalType === 'basic' && basicInfo">
                    <tbody>
                        <tr><th>사업자 아이디</th><td>{{ fnEmpty(basicInfo.sUserId) }}</td></tr>
                        <tr><th>대표자명</th><td>{{ fnEmpty(basicInfo.ceoName) }}</td></tr>
                        <tr>
                            <th>사업자 등록증</th>
                            <td>
                                <a
                                    v-if="basicInfo.bizFileName"
                                    class="file-link"
                                    :href="'/img/bizfile/' + basicInfo.bizFileName"
                                    target="_blank">
                                    {{ basicInfo.bizFileName }}
                                </a>
                                <span v-else>-</span>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <div class="admin-basic-edit-th">
                                    <span>사업자 유저 상태</span>
                                    <button type="button" class="admin-mini-btn" @click="fnEditBusinessUserStatus">수정</button>
                                </div>
                            </th>
                            <td>
                                <template v-if="businessUserStatusEditMode">
                                    <div class="admin-basic-edit-box">
                                        <select class="admin-basic-edit-select" v-model="editBusinessUserStatus">
                                            <option value="APR">승인</option>
                                            <option value="BAN">정지</option>
                                        </select>
                                        <button type="button" class="admin-mini-btn black" @click="fnUpdateBusinessUserStatus">확인</button>
                                    </div>
                                </template>
                                <template v-else>
                                    {{ fnBusinessUserStatus(basicInfo.uStatus) }}
                                </template>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div v-if="modalType === 'store' && storeInfo">
                    <table class="approve-table">
                        <tbody>
                            <tr><th>업체명</th><td>{{ fnEmpty(storeInfo.storeName) }}</td></tr>
                            <tr><th>카테고리</th><td>{{ fnStoreCategory(storeInfo.sCategory) }}</td></tr>
                            <tr><th>사업자번호</th><td>{{ fnEmpty(storeInfo.biznum) }}</td></tr>
                            <tr><th>은행명</th><td>{{ fnEmpty(storeInfo.accName) }}</td></tr>
                            <tr><th>계좌번호</th><td>{{ fnEmpty(storeInfo.accNo) }}</td></tr>
                            <tr><th>예금주</th><td>{{ fnEmpty(storeInfo.accHolder) }}</td></tr>
                            <tr>
                                <th>
                                    <div class="admin-basic-edit-th">
                                        <span>주소</span>
                                        <button type="button" class="admin-mini-btn" @click="fnOpenMap">지도보기</button>
                                    </div>
                                </th>
                                <td>{{ fnEmpty(storeInfo.sAddr) }} {{ fnEmpty(storeInfo.sFullAddr) }}</td>
                            </tr>
                            <tr>
                                <th>
                                    <div class="admin-basic-edit-th">
                                        <span>업체 상태</span>
                                        <button type="button" class="admin-mini-btn" @click="fnEditStoreStatus">수정</button>
                                    </div>
                                </th>
                                <td>
                                    <template v-if="storeStatusEditMode">
                                        <div class="admin-basic-edit-box">
                                            <select class="admin-basic-edit-select" v-model="editStoreStatus">
                                                <option value="AFF">제휴</option>
                                                <option value="GEN">가입</option>
                                            </select>
                                            <button type="button" class="admin-mini-btn black" @click="fnUpdateStoreStatus">확인</button>
                                        </div>
                                    </template>
                                    <template v-else>
                                        {{ fnStoreStatus(storeInfo.sStatus) }}
                                    </template>
                                </td>
                            </tr>
                            <tr><th>폐업 여부</th><td>{{ fnOpenStatus(storeInfo.isOpen) }}</td></tr>
                            <tr><th>예약 단위</th><td>{{ fnEmpty(storeInfo.slot) }}분</td></tr>
                            <tr><th>수용 인원</th><td>{{ fnEmpty(storeInfo.capacity) }}</td></tr>
                            <tr><th>오픈 시간</th><td>{{ fnEmpty(storeInfo.openTime) }}</td></tr>
                            <tr><th>마감 시간</th><td>{{ fnEmpty(storeInfo.closeTime) }}</td></tr>
                            <tr><th>브레이크 시작</th><td>{{ fnEmpty(storeInfo.breakStart) }}</td></tr>
                            <tr><th>브레이크 종료</th><td>{{ fnEmpty(storeInfo.breakEnd) }}</td></tr>
                            <tr><th>서브 제목</th><td>{{ fnEmpty(storeInfo.subTitle) }}</td></tr>
                            <tr><th>업체 설명</th><td>{{ fnEmpty(storeInfo.sContents) }}</td></tr>
                        </tbody>
                    </table>

                    <h4 class="admin-modal-subtitle">메뉴</h4>
                    <table class="admin-detail-table">
                        <thead>
                            <tr>
                                <th>메뉴명</th>
                                <th>가격</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in menuList" :key="item.menuNo">
                                <td>{{ fnEmpty(item.menuName) }}</td>
                                <td>{{ fnEmpty(item.menuPrice) }}</td>
                                <td>{{ fnMenuStatus(item.menuStatus) }}</td>
                            </tr>
                            <tr v-if="menuList.length === 0">
                                <td colspan="3">등록된 메뉴가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>

                    <h4 class="admin-modal-subtitle">업체 이미지</h4>
                    <div class="admin-store-image-grid" v-if="fileList.length > 0">
                        <div class="admin-store-image-card" v-for="item in fileList" :key="item.fileName">
                            <div class="admin-image-badge" v-if="item.isMain === 'Y'">대표 이미지</div>

                            <div class="admin-store-image-thumb">
                                <img :src="item.filePath + item.fileName" :alt="item.originName">
                            </div>

                            <div class="admin-store-image-name">{{ fnEmpty(item.originName) }}</div>
                        </div>
                    </div>
                    <div class="empty-box" v-else>등록된 이미지가 없습니다.</div>
                </div>

                <table class="admin-detail-table" v-if="modalType === 'review'">
                    <thead>
                        <tr>
                            <th>작성자</th>
                            <th>평점</th>
                            <th>리뷰 내용</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in detailList" :key="item.userId + '-' + item.cdate">
                            <td>{{ fnEmpty(item.userId) }}</td>
                            <td>{{ fnEmpty(item.rating) }}</td>
                            <td>{{ fnEmpty(item.rContents) }}</td>
                            <td>{{ fnEmpty(item.cdate) }}</td>
                        </tr>
                    </tbody>
                </table>

                <table class="admin-detail-table" v-if="modalType === 'report'">
                    <thead>
                        <tr>
                            <th>리뷰번호</th>
                            <th>처리상태</th>
                            <th>신고자</th>
                            <th>작성자</th>
                            <th>신고사유</th>
                            <th>일자</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in detailList" :key="item.reviewNo + '-' + item.reporterId">
                            <td>{{ fnEmpty(item.reviewNo) }}</td>
                            <td>{{ fnReportStatus(item.repStatus) }}</td>
                            <td>{{ fnEmpty(item.reporterId) }}</td>
                            <td>{{ fnEmpty(item.userId) }}</td>
                            <td>{{ fnEmpty(item.reportReason) }}</td>
                            <td>{{ fnEmpty(item.cdate) }}</td>
                        </tr>
                    </tbody>
                </table>

                <table class="admin-detail-table" v-if="modalType === 'reservation'">
                    <thead>
                        <tr>
                            <th>예약일</th>
                            <th>시작시간</th>
                            <th>종료시간</th>
                            <th>회원 아이디</th>
                            <th>예약상태</th>
                            <th>등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in detailList" :key="item.rsvNo">
                            <td>{{ fnEmpty(item.rsvDate) }}</td>
                            <td>{{ fnEmpty(item.rsvStartTime) }}</td>
                            <td>{{ fnEmpty(item.rsvEndTime) }}</td>
                            <td>{{ fnEmpty(item.userId) }}</td>
                            <td>{{ fnRsvStatus(item.rsvStatus) }}</td>
                            <td>{{ fnEmpty(item.cdate) }}</td>
                        </tr>
                    </tbody>
                </table>

                <div class="empty-box" v-if="(modalType === 'review' || modalType === 'report' || modalType === 'reservation') && detailList.length === 0">
                    조회된 내역이 없습니다.
                </div>
            </div>
        </div>
    </div>

    <div class="admin-map-modal-bg" v-if="mapOpen">
        <div class="admin-map-modal">
            <div class="admin-user-modal-header">
                <h3>지도보기</h3>
                <button type="button" class="admin-user-modal-close" @click="fnCloseMap">×</button>
            </div>
            <div class="admin-map-body">
                <div id="businessStoreMap"></div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
    const app = Vue.createApp({
        data() {
            return {
                keyword: "",
                sStatus: "",
                isOpen: "",
                sortType: "",
                businessUserList: [],
                currentPage: 1,
                pageSize: 10,
                totalCount: 0,

                modalOpen: false,
                modalTitle: "",
                modalType: "",
                basicInfo: null,
                storeInfo: null,
                menuList: [],
                fileList: [],
                detailList: [],

                mapOpen: false,
                businessUserStatusEditMode: false,
                storeStatusEditMode: false,
                editBusinessUserStatus: "",
                editStoreStatus: ""
            };
        },
        computed: {
            totalPage: function () {
                return Math.ceil(this.totalCount / this.pageSize);
            },

            pageList: function () {
                let list = [];
                let startPage = Math.floor((this.currentPage - 1) / 5) * 5 + 1;
                let endPage = Math.min(startPage + 4, this.totalPage);

                for (let i = startPage; i <= endPage; i++) {
                    list.push(i);
                }

                return list;
            }
        },
        methods: {
            fnBusinessUserList: function () {
                let self = this;

                $.ajax({
                    url: "/admin/businessUser/list.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        keyword: self.keyword,
                        sStatus: self.sStatus,
                        isOpen: self.isOpen,
                        sortType: self.sortType,
                        page: self.currentPage,
                        pageSize: self.pageSize
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            self.businessUserList = data.list || [];
                            self.totalCount = data.totalCount || 0;

                            self.$nextTick(function () {
                                self.fnSyncUserTableScroll();
                            });
                        } else {
                            alert(data.message || "사업자 회원 목록을 불러오지 못했습니다.");
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnOpenBasic: function (item) {
                this.fnOpenInfoModal("basic", "사업자 기본 정보", "/admin/businessUser/basic.dox", {
                    sUserId: item.sUserId
                });
            },

            fnOpenStoreDetail: function (item) {
                this.fnOpenInfoModal("store", "업체 상세", "/admin/businessUser/storeDetail.dox", {
                    storeNo: item.storeNo
                });
            },

            fnOpenReview: function (item) {
                this.fnOpenListModal("review", "리뷰 내역", "/admin/businessUser/reviewList.dox", {
                    storeNo: item.storeNo
                });
            },

            fnOpenReport: function (item) {
                this.fnOpenListModal("report", "신고 내역", "/admin/businessUser/reportList.dox", {
                    storeNo: item.storeNo
                });
            },

            fnOpenReservation: function (item) {
                this.fnOpenListModal("reservation", "예약 상세", "/admin/businessUser/reservationList.dox", {
                    storeNo: item.storeNo
                });
            },

            fnOpenInfoModal: function (type, title, url, param) {
                let self = this;

                self.modalOpen = true;
                self.modalType = type;
                self.modalTitle = title;
                self.basicInfo = null;
                self.storeInfo = null;
                self.menuList = [];
                self.fileList = [];
                self.detailList = [];

                $.ajax({
                    url: url,
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function (data) {
                        if (data.result === "success") {
                            if (type === "basic") {
                                self.basicInfo = data.info;
                            } else if (type === "store") {
                                self.storeInfo = data.info;
                                self.menuList = data.menuList || [];
                                self.fileList = data.fileList || [];
                            }
                        } else {
                            alert(data.message || "상세 정보를 불러오지 못했습니다.");
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnOpenListModal: function (type, title, url, param) {
                let self = this;

                self.modalOpen = true;
                self.modalType = type;
                self.modalTitle = title;
                self.basicInfo = null;
                self.storeInfo = null;
                self.menuList = [];
                self.fileList = [];
                self.detailList = [];

                $.ajax({
                    url: url,
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function (data) {
                        if (data.result === "success") {
                            self.detailList = data.list || [];
                        } else {
                            alert(data.message || "상세 내역을 불러오지 못했습니다.");
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnCloseModal: function () {
                this.modalOpen = false;
                this.modalTitle = "";
                this.modalType = "";
                this.basicInfo = null;
                this.storeInfo = null;
                this.menuList = [];
                this.fileList = [];
                this.detailList = [];
                this.mapOpen = false;
                this.businessUserStatusEditMode = false;
                this.storeStatusEditMode = false;
                this.editBusinessUserStatus = "";
                this.editStoreStatus = "";
            },

            fnOpenMap: function () {
                let self = this;

                if (!self.storeInfo || !self.storeInfo.lat || !self.storeInfo.lng) {
                    alert("지도 좌표가 없습니다.");
                    return;
                }

                self.mapOpen = true;

                self.$nextTick(function () {
                    kakao.maps.load(function () {
                        setTimeout(function () {
                            let container = document.getElementById("businessStoreMap");
                            let position = new kakao.maps.LatLng(self.storeInfo.lat, self.storeInfo.lng);

                            let map = new kakao.maps.Map(container, {
                                center: position,
                                level: 3
                            });

                            new kakao.maps.Marker({
                                position: position,
                                map: map
                            });

                            map.relayout();
                            map.setCenter(position);
                        }, 100);
                    });
                });
            },

            fnCloseMap: function () {
                this.mapOpen = false;
            },

            fnEmpty: function (value) {
                if (value === null || value === undefined || value === "") {
                    return "-";
                }
                return value;
            },

            fnShortId: function (value) {
                if (!value) {
                    return "-";
                }

                if (value.length > 7) {
                    return value.substring(0, 7) + "...";
                }

                return value;
            },

            fnBusinessUserStatus: function (status) {
                if (status === "BAN") return "회원 정지";
                if (status === "APR") return "승인";
                if (status === "PND") return "대기";
                if (status === "REJ") return "거부";
                if (status === "EXT") return "탈퇴";
                return this.fnEmpty(status);
            },

            fnStoreStatus: function (status) {
                if (status === "AFF") return "제휴";
                if (status === "GEN") return "가입";
                if (status === "EXT") return "외부";
                if (status === "PND") return "대기";
                if (status === "REJ") return "반려";
                return this.fnEmpty(status);
            },

            fnOpenStatus: function (status) {
                if (status === "Y") return "영업중";
                if (status === "N") return "폐업";
                return this.fnEmpty(status);
            },

            fnMenuStatus: function (status) {
                if (status === "Y") return "판매중";
                if (status === "N") return "판매 중지";
                return this.fnEmpty(status);
            },

            fnRsvStatus: function (status) {
                if (status === "WAI") return "대기";
                if (status === "CNF") return "확정";
                if (status === "FIN") return "완료";
                if (status === "CAN") return "취소";
                return this.fnEmpty(status);
            },

            fnReportStatus: function (status) {
                if (status === "ACC") return "승인";
                if (status === "REJ") return "반려";
                return this.fnEmpty(status);
            },

            fnSyncUserTableScroll: function () {
                let topScroll = document.querySelector(".admin-user-top-scroll");
                let scrollInner = document.querySelector(".admin-user-scroll-inner");
                let tableWrap = document.querySelector(".admin-user-table-wrap");
                let headWrap = document.querySelector(".admin-user-head-wrap");
                let bodyTable = document.querySelector(".admin-user-table-wrap .admin-user-table");
                let headTable = document.querySelector(".admin-user-head-table");

                if (!topScroll || !scrollInner || !tableWrap || !headWrap || !bodyTable || !headTable) {
                    return;
                }

                let tableWidth = bodyTable.scrollWidth;

                scrollInner.style.width = tableWidth + "px";
                headTable.style.width = tableWidth + "px";

                topScroll.onscroll = function () {
                    tableWrap.scrollLeft = topScroll.scrollLeft;
                    headWrap.scrollLeft = topScroll.scrollLeft;
                };
            },
            fnSearchBusinessUserList: function () {
                this.currentPage = 1;
                this.fnBusinessUserList();
            },

            fnMovePage: function (page) {
                if (page < 1 || page > this.totalPage) {
                    return;
                }

                this.currentPage = page;
                this.fnBusinessUserList();
            },

            fnStoreCategory: function (category) {
                if (category === "HOS") return "병원";
                if (category === "SAL") return "미용";
                if (category === "BRD") return "위탁시설";
                return this.fnEmpty(category);
            },

            fnEditBusinessUserStatus: function () {
                this.businessUserStatusEditMode = true;
                this.editBusinessUserStatus = this.basicInfo ? this.basicInfo.uStatus : "";
            },

            fnEditStoreStatus: function () {
                this.storeStatusEditMode = true;
                this.editStoreStatus = this.storeInfo ? this.storeInfo.sStatus : "";
            },

            fnUpdateBusinessUserStatus: function () {
                let self = this;

                if (!self.basicInfo || !self.basicInfo.sUserId) {
                    alert("사업자 정보가 없습니다.");
                    return;
                }

                $.ajax({
                    url: "/admin/businessUser/statusUpdate.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        sUserId: self.basicInfo.sUserId,
                        uStatus: self.editBusinessUserStatus
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            self.basicInfo.uStatus = self.editBusinessUserStatus;
                            self.businessUserStatusEditMode = false;
                            self.fnBusinessUserList();
                            alert("사업자 유저 상태가 변경되었습니다.");
                        } else {
                            alert(data.message || "사업자 유저 상태 변경에 실패했습니다.");
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnUpdateStoreStatus: function () {
                let self = this;

                if (!self.storeInfo || !self.storeInfo.storeNo) {
                    alert("업체 정보가 없습니다.");
                    return;
                }

                $.ajax({
                    url: "/admin/businessUser/storeStatusUpdate.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        storeNo: self.storeInfo.storeNo,
                        sStatus: self.editStoreStatus
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            self.storeInfo.sStatus = self.editStoreStatus;
                            self.storeStatusEditMode = false;
                            self.fnBusinessUserList();
                            alert("업체 상태가 변경되었습니다.");
                        } else {
                            alert(data.message || "업체 상태 변경에 실패했습니다.");
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },
        },
        mounted() {
            this.fnBusinessUserList();

            this.$nextTick(function () {
                this.fnSyncUserTableScroll();
            });
        }
    });

    app.mount("#app");
</script>

</body>
</html>