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
                    <jsp:param name="activeMenu" value="userManage" />
                </jsp:include>

                <section class="admin-content">
                    <div class="content-card">
                        <h2>회원조회 및 관리</h2>
                        <div class="content-desc">일반 사용자 회원 정보와 활동 내역을 조회합니다.</div>

                        <div class="admin-search-box">
                            <select class="admin-search-select" v-model="userStatus" @change="fnUserList">
                                <option value="">전체 상태</option>
                                <option value="NOR">일반</option>
                                <option value="BAN">정지</option>
                                <option value="EXT">탈퇴</option>
                            </select>

                            <input
                                type="text"
                                class="admin-search-input"
                                v-model="keyword"
                                @keyup.enter="fnUserList"
                                placeholder="아이디, 이름, 닉네임 검색">
                            <button type="button" class="admin-search-btn" @click="fnUserList">검색</button>
                        </div>

                        <div class="admin-user-table-wrap">
                            <table class="admin-user-table">
                                <thead>
                                    <tr>
                                        <th>유저 아이디</th>
                                        <th>유저 상태</th>
                                        <th>기본 정보</th>
                                        <th>신고 누적 횟수</th>
                                        <th>반려동물</th>
                                        <th>구독 여부</th>
                                        <th>포인트</th>
                                        <th>쿠폰 내역</th>
                                        <th>주문 내역</th>
                                        <th>예약 내역</th>
                                        <th>리뷰 내역</th>
                                        <th>커뮤니티 내역</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in userList" :key="item.userId">
                                        <td>
                                            <div class="user-id-text" :title="item.userId">{{ fnShortId(item.userId) }}</div>
                                        </td>
                                        <td>
                                            {{ fnUserStatus(item.userStatus) }}
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenBasic(item)">상세보기</button>
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenReport(item)">
                                                {{ item.reportCount }}회
                                            </button>
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenPet(item)">
                                                상세보기
                                            </button>
                                        </td>
                                        <td>
                                            <button
                                                v-if="item.subscriptionYn === 'Y'"
                                                type="button"
                                                class="detail-link-btn"
                                                @click="fnOpenSubscription(item)">
                                                구독중
                                            </button>
                                            <span v-else>미구독</span>
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenPoint(item)">
                                                {{ item.pointTotal }}P
                                            </button>
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenCoupon(item)">
                                                상세보기
                                            </button>
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenOrder(item)">
                                                상세보기
                                            </button>
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenReservation(item)">
                                                상세보기
                                            </button>
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenReview(item)">
                                                상세보기
                                            </button>
                                        </td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnMoveCommunity(item)">
                                                상세보기
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="empty-box" v-if="userList.length === 0">
                            조회된 회원이 없습니다.
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
                            <tr><th>아이디</th><td>{{ fnEmpty(basicInfo.userId) }}</td></tr>
                            <tr><th>이메일</th><td>{{ fnEmpty(basicInfo.email) }}</td></tr>
                            <tr><th>이름</th><td>{{ fnEmpty(basicInfo.userName) }}</td></tr>
                            <tr><th>닉네임</th><td>{{ fnEmpty(basicInfo.nickname) }}</td></tr>
                            <tr><th>전화번호</th><td>{{ fnEmpty(basicInfo.phone) }}</td></tr>
                            <tr><th>주소</th><td>{{ fnEmpty(basicInfo.userAddr) }} {{ fnEmpty(basicInfo.fullAddr) }}</td></tr>
                            <tr><th>우편번호</th><td>{{ fnEmpty(basicInfo.zipcode) }}</td></tr>
                            <tr><th>소셜상태</th><td>{{ fnEmpty(basicInfo.socialtype) }}</td></tr>
                            <tr><th>유저 상태</th><td>{{ fnUserStatus(basicInfo.userStatus) }}</td></tr>
                            <tr><th>가입일</th><td>{{ fnEmpty(basicInfo.cdate) }}</td></tr>
                        </tbody>
                    </table>

                    <table class="approve-table" v-if="modalType === 'subscription' && subscriptionInfo">
                        <tbody>
                            <tr><th>시작일</th><td>{{ fnEmpty(subscriptionInfo.sDate) }}</td></tr>
                            <tr><th>종료일</th><td>{{ fnEmpty(subscriptionInfo.eDate) }}</td></tr>
                            <tr><th>다음 결제일</th><td>{{ fnEmpty(subscriptionInfo.nDate) }}</td></tr>
                            <tr><th>구독 금액</th><td>{{ fnEmpty(subscriptionInfo.subPrice) }}</td></tr>
                            <tr><th>구독 상태</th><td>{{ fnSubStatus(subscriptionInfo.subStatus) }}</td></tr>
                        </tbody>
                    </table>

                    <table class="admin-detail-table" v-if="modalType === 'pet'">
                        <thead>
                            <tr>
                                <th>반려동물명</th>
                                <th>종</th>
                                <th>품종</th>
                                <th>생일</th>
                                <th>성별</th>
                                <th>등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in detailList" :key="item.petNo">
                                <td>{{ fnEmpty(item.petName) }}</td>
                                <td>{{ fnEmpty(item.species) }}</td>
                                <td>{{ fnEmpty(item.breed) }}</td>
                                <td>{{ fnEmpty(item.birthdate) }}</td>
                                <td>{{ fnEmpty(item.gender) }}</td>
                                <td>{{ fnEmpty(item.cdate) }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <table class="admin-detail-table" v-if="modalType === 'point'">
                        <thead>
                            <tr>
                                <th>포인트</th>
                                <th>주문번호</th>
                                <th>리뷰번호</th>
                                <th>일자</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in detailList" :key="item.pointNo">
                                <td>{{ item.pointAmount === null ? '없음' : item.pointAmount }}</td>
                                <td>{{ item.ordNo === null ? '-' : item.ordNo }}</td>
                                <td>{{ item.reviewNo === null ? '-' : item.reviewNo }}</td>
                                <td>{{ fnEmpty(item.cdate) }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <table class="admin-detail-table" v-if="modalType === 'coupon'">
                        <thead>
                            <tr>
                                <th>쿠폰명</th>
                                <th>상태</th>
                                <th>사용일</th>
                                <th>만료일</th>
                                <th>발급일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in detailList" :key="item.ucpNo">
                                <td>{{ fnEmpty(item.couponName) }}</td>
                                <td>{{ fnCouponStatus(item.cpStatus) }}</td>
                                <td>{{ fnEmpty(item.useDate) }}</td>
                                <td>{{ fnEmpty(item.expDate) }}</td>
                                <td>{{ fnEmpty(item.cdate) }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <table class="admin-detail-table" v-if="modalType === 'order'">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>쿠폰번호</th>
                                <th>포인트번호</th>
                                <th>할인가</th>
                                <th>총금액</th>
                                <th>주문상태</th>
                                <th>배송상태</th>
                                <th>주소</th>
                                <th>주문일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in detailList" :key="item.ordNo">
                                <td>{{ item.ordNo }}</td>
                                <td>{{ item.couponNo === null ? '-' : item.couponNo }}</td>
                                <td>{{ item.pointNo === null || item.pointNo === 0 ? '-' : item.pointNo }}</td>
                                <td>{{ fnEmpty(item.disPrice) }}</td>
                                <td>{{ fnEmpty(item.totalPrice) }}</td>
                                <td>{{ fnOrdStatus(item.ordStatus) }}</td>
                                <td>{{ fnDeliStatus(item.deliStatus) }}</td>
                                <td>{{ fnEmpty(item.ordAddr) }}</td>
                                <td>{{ fnEmpty(item.ordDate) }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <table class="admin-detail-table" v-if="modalType === 'reservation'">
                        <thead>
                            <tr>
                                <th>예약일</th>
                                <th>시작</th>
                                <th>종료</th>
                                <th>업체명</th>
                                <th>반려동물</th>
                                <th>메뉴명</th>
                                <th>상태</th>
                                <th>등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in detailList" :key="item.rsvNo">
                                <td>{{ fnEmpty(item.rsvDate) }}</td>
                                <td>{{ fnEmpty(item.rsvStartTime) }}</td>
                                <td>{{ fnEmpty(item.rsvEndTime) }}</td>
                                <td>{{ fnEmpty(item.storeName) }}</td>
                                <td>{{ item.petNoObj === null ? '-' : item.petNoObj }}</td>
                                <td>{{ fnEmpty(item.menuName) }}</td>
                                <td>{{ fnRsvStatus(item.rsvStatus) }}</td>
                                <td>{{ fnEmpty(item.cdate) }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <table class="admin-detail-table" v-if="modalType === 'review'">
                        <thead>
                            <tr>
                                <th>업체명</th>
                                <th>상품명</th>
                                <th>평점</th>
                                <th>내용</th>
                                <th>작성일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in detailList" :key="item.reviewNo">
                                <td>{{ fnEmpty(item.storeName) }}</td>
                                <td>{{ fnEmpty(item.productName) }}</td>
                                <td>{{ fnEmpty(item.rating) }}</td>
                                <td>{{ fnEmpty(item.rContents) }}</td>
                                <td>{{ fnEmpty(item.cdate) }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <table class="admin-detail-table" v-if="modalType === 'report'">
                        <thead>
                            <tr>
                                <th>구분</th>
                                <th>신고자</th>
                                <th>신고 사유</th>
                                <th>대상 제목</th>
                                <th>대상 내용</th>
                                <th>신고일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in detailList" :key="index">
                                <td>{{ fnReportType(item.reportType) }}</td>
                                <td>{{ fnEmpty(item.reporterId) }}</td>
                                <td>{{ fnEmpty(item.reportReason) }}</td>
                                <td>{{ fnEmpty(item.targetTitle) }}</td>
                                <td>{{ fnEmpty(item.targetContent) }}</td>
                                <td>{{ fnEmpty(item.cdate) }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="empty-box" v-if="modalType !== 'basic' && modalType !== 'subscription' && detailList.length === 0">
                        조회된 상세 내역이 없습니다.
                    </div>
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
                    userStatus: "",
                    userList: [],

                    modalOpen: false,
                    modalTitle: "",
                    modalType: "",
                    basicInfo: null,
                    subscriptionInfo: null,
                    detailList: []
                };
            },
            methods: {
                fnUserList: function () {
                    let self = this;

                    $.ajax({
                        url: "/admin/user/list.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            keyword: self.keyword,
                            userStatus: self.userStatus
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.userList = data.list || [];
                            } else {
                                alert(data.message || "회원 목록을 불러오지 못했습니다.");
                            }
                        },
                        error: function () {
                            alert("서버 통신 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnOpenBasic: function (item) {
                    this.fnOpenInfoModal("basic", "기본 정보", "/admin/user/basic.dox", item.userId);
                },

                fnOpenSubscription: function (item) {
                    this.fnOpenInfoModal("subscription", "구독 상세", "/admin/user/subscription.dox", item.userId);
                },

                fnOpenPet: function (item) {
                    this.fnOpenListModal("pet", "반려동물 상세", "/admin/user/petList.dox", item.userId);
                },

                fnOpenPoint: function (item) {
                    this.fnOpenListModal("point", "포인트 상세", "/admin/user/pointList.dox", item.userId);
                },

                fnOpenCoupon: function (item) {
                    this.fnOpenListModal("coupon", "쿠폰 내역", "/admin/user/couponList.dox", item.userId);
                },

                fnOpenOrder: function (item) {
                    this.fnOpenListModal("order", "주문 내역", "/admin/user/orderList.dox", item.userId);
                },

                fnOpenReservation: function (item) {
                    this.fnOpenListModal("reservation", "예약 내역", "/admin/user/reservationList.dox", item.userId);
                },

                fnOpenReview: function (item) {
                    this.fnOpenListModal("review", "리뷰 내역", "/admin/user/reviewList.dox", item.userId);
                },

                fnOpenReport: function (item) {
                    this.fnOpenListModal("report", "신고 상세", "/admin/user/reportList.dox", item.userId);
                },

                fnOpenInfoModal: function (type, title, url, userId) {
                    let self = this;

                    self.modalOpen = true;
                    self.modalType = type;
                    self.modalTitle = title;
                    self.basicInfo = null;
                    self.subscriptionInfo = null;
                    self.detailList = [];

                    $.ajax({
                        url: url,
                        type: "POST",
                        dataType: "json",
                        data: {
                            userId: userId
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                if (type === "basic") {
                                    self.basicInfo = data.info;
                                } else if (type === "subscription") {
                                    self.subscriptionInfo = data.info;
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

                fnOpenListModal: function (type, title, url, userId) {
                    let self = this;

                    self.modalOpen = true;
                    self.modalType = type;
                    self.modalTitle = title;
                    self.basicInfo = null;
                    self.subscriptionInfo = null;
                    self.detailList = [];

                    $.ajax({
                        url: url,
                        type: "POST",
                        dataType: "json",
                        data: {
                            userId: userId
                        },
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
                    this.subscriptionInfo = null;
                    this.detailList = [];
                },

                fnMoveCommunity: function (item) {
                    window.open(
                        "/admin/userCommunity.do?userId=" + encodeURIComponent(item.userId),
                        "_blank"
                    );
                },

                fnEmpty: function (value) {
                    if (value === null || value === undefined || value === "") {
                        return "-";
                    }
                    return value;
                },

                fnUserStatus: function (status) {
                    if (status === "NOR") return "일반";
                    if (status === "BAN") return "정지";
                    if (status === "EXT") return "탈퇴";
                    return this.fnEmpty(status);
                },

                fnRsvStatus: function (status) {
                    if (status === "WAI") return "대기";
                    if (status === "CNF") return "확정";
                    if (status === "FIN") return "완료";
                    if (status === "CAN") return "취소";
                    return this.fnEmpty(status);
                },

                fnOrdStatus: function (status) {
                    if (status === "RDY") return "준비";
                    if (status === "PAY") return "결제";
                    if (status === "CAN") return "취소";
                    if (status === "FAL") return "실패";
                    return this.fnEmpty(status);
                },

                fnDeliStatus: function (status) {
                    if (status === "RDY") return "준비";
                    if (status === "SHP") return "배송중";
                    if (status === "CMP") return "완료";
                    if (status === "CAN") return "취소";
                    return this.fnEmpty(status);
                },

                fnCouponStatus: function (status) {
                    if (status === "RDY") return "미사용";
                    if (status === "USE") return "사용";
                    if (status === "EXP") return "만료";
                    return this.fnEmpty(status);
                },

                fnSubStatus: function (status) {
                    if (status === "Y") return "구독중";
                    if (status === "N") return "해지";
                    return this.fnEmpty(status);
                },

                fnReportType: function (type) {
                    if (type === "REVIEW") return "리뷰";
                    if (type === "BOARD") return "커뮤니티 글";
                    if (type === "COMMENT") return "커뮤니티 댓글";
                    return this.fnEmpty(type);
                },
                fnShortId: function (userId) {
                    if (!userId) {
                        return "-";
                    }

                    if (userId.length > 7) {
                        return userId.substring(0, 7) + "...";
                    }

                    return userId;
                },
                
            },
            mounted() {
                this.fnUserList();
            }
        });

        app.mount("#app");
    </script>
</body>
</html>