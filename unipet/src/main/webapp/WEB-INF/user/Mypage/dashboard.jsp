<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

        <link href="/css/user/usermypage.css" rel="stylesheet">

        <title>UNIPET - 홈</title>
    </head>

    <body>
        <jsp:include page="/WEB-INF/header/header.jsp" />

        <div id="app" class="user-page-wrap" v-cloak>
            <div class="user-page-container">

                <!-- 사이드바 직접 삽입 -->
                <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp" />


                <main class="user-content">
                    <div class="content-header">
                        <h1>홈</h1>
                    </div>

                    <div class="page-inner">
                        <div class="mypage-dashboard dashboard-new">

                            <!-- 왼쪽 영역 : 내 프로필 + 반려동물 프로필 -->
                            <div class="dash-left">

                                <!-- 내 프로필 -->
                                <div class="section-box">
                                    <div class="section-title">내 프로필</div>

                                    <div class="profile-summary">
                                        <div class="profile-info-box">
                                            <div class="profile-info-row">
                                                <div class="profile-info-label">이름</div>
                                                <div>{{ user.userName || '-' }}</div>
                                            </div>
                                            <div class="profile-info-row">
                                                <div class="profile-info-label">닉네임</div>
                                                <div>{{ user.nickname || '-' }}</div>
                                            </div>
                                            <div class="profile-info-row">
                                                <div class="profile-info-label">이메일</div>
                                                <div>{{ user.email || '-' }}</div>
                                            </div>
                                            <div class="profile-info-row">
                                                <div class="profile-info-label">전화번호</div>
                                                <div>{{ user.phone || '-' }}</div>
                                            </div>
                                            <div class="profile-info-row">
                                                <div class="profile-info-label">주소</div>
                                                <div>{{ user.userAddr || '-' }} {{ user.fullAddr || '' }}</div>
                                            </div>

                                            <div class="btn-box" style="margin-top:14px;">
                                                <button @click="openUserEditPanel = !openUserEditPanel">
                                                    {{ openUserEditPanel ? '수정 닫기' : '회원정보 수정' }}
                                                </button>
                                                <button class="btn-gray" @click="fnOpenPwdModal">비밀번호 변경</button>
                                                <button class="btn-red" @click="fnDeleteUser">회원 탈퇴</button>
                                            </div>
                                        </div>
                                    </div>

                                    <div v-if="openUserEditPanel" style="margin-top:16px;">
                                        <div class="grid-2">
                                            <div class="row">
                                                <label>이름</label>
                                                <input type="text" v-model="user.userName">
                                            </div>
                                            <div class="row">
                                                <label>닉네임</label>
                                                <input type="text" v-model="user.nickname">
                                            </div>
                                            <div class="row">
                                                <label>이메일</label>
                                                <input type="text" v-model="user.email">
                                            </div>
                                            <div class="row">
                                                <label>전화번호</label>
                                                <input type="text" v-model="user.phone">
                                            </div>
                                        </div>

                                        <div class="row">
                                            <label>우편번호</label>
                                            <div style="display:flex; gap:10px;">
                                                <input type="text" v-model="user.zipcode" readonly
                                                    placeholder="우편번호 찾기를 이용해주세요">
                                                <button type="button" class="small-btn" @click="fnOpenAddressSearch">주소
                                                    변경</button>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <label>주소</label>
                                            <input type="text" v-model="user.userAddr" readonly>
                                        </div>

                                        <div class="row">
                                            <label>상세주소</label>
                                            <input type="text" v-model="user.fullAddr" id="detailAddress"
                                                placeholder="상세주소를 입력해주세요">
                                        </div>

                                        <div class="btn-box">
                                            <button @click="fnUpdateUser">회원정보 저장</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- 반려동물 프로필 -->
                                <div class="section-box">
                                    <div class="section-title">반려동물 프로필</div>

                                    <div v-if="petList.length === 0" class="empty-text">
                                        등록된 반려동물이 없습니다.
                                    </div>

                                    <div class="pet-list">
                                        <div class="pet-card" v-for="pet in petList" :key="pet.petNo" :class="{
                                            'main-pet-card': String(pet.isMain || pet.IS_MAIN).trim().toUpperCase() === 'Y'
                                            }">

                                            <div class="pet-thumb">
                                                <div class="pet-avatar">
                                                    <img :src="fnGetPetImage(pet)" alt="펫이미지">
                                                </div>
                                            </div>

                                            <div class="pet-body">
                                                <div class="pet-name">
                                                    {{ pet.petName || pet.PET_NAME || '-' }}

                                                    <span v-if="(pet.isMain || pet.IS_MAIN) === 'Y'" class="main-badge">
                                                        대표동물
                                                    </span>

                                                    <span v-else class="change-main-badge"
                                                        @click.stop="fnChangeMainPet(pet.petNo || pet.PET_NO)">
                                                        대표로 변경
                                                    </span>
                                                </div>

                                                <div class="pet-sub-btn-row">
                                                    <button class="pet-btn edit"
                                                        @click="fnOpenEditPetModal(pet)">수정</button>
                                                    <button class="pet-btn delete"
                                                        @click="fnDeletePet(pet.petNo)">삭제</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <!-- 오른쪽 영역 : 최근 주문 + 최근 예약 + 포인트 / 쿠폰 -->
                            <div class="dash-right">

                                <!-- 최근 주문 내역 -->
                                <div class="section-box">
                                    <div class="section-title">최근 주문 내역</div>

                                    <div v-if="groupedOrderList.length === 0" class="empty-text">
                                        주문 내역이 없습니다.
                                    </div>

                                    <div class="main-order-item" v-for="group in groupedOrderList.slice(0, 2)"
                                        :key="group.orderNo">
                                        <div class="main-order-left">
                                            <img class="order-img"
                                                :src="group.items && group.items.length > 0 && group.items[0].productImg ? group.items[0].productImg : '/img/no-image.png'"
                                                alt="상품이미지">

                                            <div class="main-order-info">
                                                <div class="list-title">{{ (group.orderDate || '').substring(0, 10)
                                                    }}
                                                </div>
                                                <div class="list-sub">{{ (group.orderDate || '').substring(11, 16)
                                                    }}
                                                </div>
                                                <div class="list-sub order-product-name">
                                                    {{ group.items[0]?.productName || '-' }}
                                                    <span v-if="group.items.length > 1">
                                                        외 {{ group.items.length - 1 }}건
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="status-badge"
                                            :class="fnGetDeliStatusClass(group.items[0]?.deliStatus || group.items[0]?.DELI_STATUS)">
                                            {{ fnGetDeliStatusText(group.items[0]?.deliStatus ||
                                            group.items[0]?.DELI_STATUS) }}
                                        </div>
                                    </div>

                                    <div class="btn-box">
                                        <button @click="fnChangeMenu('orderList')">주문 내역 보기</button>
                                    </div>
                                </div>

                                <!-- 최근 예약 현황 -->
                                <div class="section-box">
                                    <div class="section-title">최근 예약 현황</div>

                                    <div v-if="reservationList.length === 0" class="empty-text">
                                        예약 내역이 없습니다.
                                    </div>

                                    <div class="main-reserve-item" v-for="item in reservationList.slice(0, 2)"
                                        :key="item.rsvNo">
                                        <div class="reserve-store-name">
                                            {{ item.storeName || item.STORE_NAME || '업체명 없음' }}
                                        </div>

                                        <div>
                                            <div class="list-title">{{ item.rsvDate || '-' }}</div>
                                            <div class="list-sub">
                                                {{ item.rsvStartTime || '-' }} ~ {{ item.rsvEndTime || '-' }}
                                            </div>
                                        </div>

                                        <div class="list-sub reserve-status-box">
                                            상태 :
                                            <span class="reserve-status-text"
                                                :class="fnGetReserveStatusClass(item.rsvStatus || item.RSV_STATUS)">
                                                {{ fnGetReservationStatusText(item.rsvStatus || item.RSV_STATUS) }}
                                            </span>
                                        </div>
                                    </div>

                                    <div class="btn-box">
                                        <button @click="fnChangeMenu('reserveList')">예약 내역 보기</button>
                                    </div>
                                </div>

                                <!-- 포인트 / 쿠폰 -->
                                <div class="section-box">
                                    <div class="section-title">포인트 / 쿠폰</div>

                                    <div class="point-flex">
                                        <div class="item" @click="fnChangeMenu('pointInfo')" style="cursor:pointer;">
                                            <div class="label">포인트</div>
                                            <div class="value">{{ Number(point || 0).toLocaleString() }} P</div>
                                        </div>

                                        <div class="item" @click="fnChangeMenu('couponInfo')" style="cursor:pointer;">
                                            <div class="label">쿠폰</div>
                                            <div class="value">{{ usableCouponCount }} 장</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 아래 전체 영역 : 커뮤니티 정보 -->
                            <div class="section-box community-wide-section">
                                <div class="section-title">커뮤니티 정보</div>

                                <div class="community-summary">
                                    <div class="community-stat-card">
                                        <div class="community-icon">✏️</div>
                                        <div>
                                            <div class="community-label">내 게시글</div>
                                            <div class="community-value">{{ myPostList.length }}건</div>
                                        </div>
                                    </div>

                                    <div class="community-stat-card">
                                        <div class="community-icon">💬</div>
                                        <div>
                                            <div class="community-label">내 댓글</div>
                                            <div class="community-value">{{ myCommentList.length }}건</div>
                                        </div>
                                    </div>

                                    <div class="community-stat-card">
                                        <div class="community-icon">📝</div>
                                        <div>
                                            <div class="community-label">최근 게시글</div>
                                            <div class="community-value">{{ recentPostList.length }}건</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="community-recent-list">
                                    <div class="community-recent-box">
                                        <div class="list-title">최근 내 게시글</div>

                                        <div v-if="myPostList.length === 0" class="empty-text">
                                            작성한 게시글이 없습니다.
                                        </div>

                                        <div v-for="item in recentPostList.slice(0, 2)" :key="'post-' + item.id"
                                            class="list-item">
                                            <div class="post-title"
                                                @click="fnGoPostDetail(item.boardNo || item.BOARD_NO || item.id)">
                                                [{{ item.boardName }}] {{ item.title }}
                                            </div>
                                            <div class="list-sub">{{ fnFormatDateTime(item.cdate) }}</div>
                                        </div>
                                    </div>

                                    <div class="community-recent-box">
                                        <div class="list-title">최근 내 댓글</div>

                                        <div v-if="myCommentList.length === 0" class="empty-text">
                                            작성한 댓글이 없습니다.
                                        </div>

                                        <div v-for="item in myCommentList.slice(0, 2)" :key="'comment-' + item.id"
                                            class="list-item">
                                            <div class="list-title post-title"
                                                @click="fnGoPostDetail(item.boardNo || item.BOARD_NO || item.id)"
                                                style="cursor:pointer;">
                                                [{{ item.boardName }}] {{ item.content }}
                                            </div>
                                            <div class="list-sub">{{ fnFormatDateTime(item.cdate) }}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </main>
            </div>

            <!-- 반려동물 모달 -->
            <div class="modal-wrap" v-if="showPetModal">
                <div class="modal-box">
                    <div class="modal-title">
                        {{ petForm.petNo ? '반려동물 프로필 수정' : '반려동물 프로필 추가' }}
                    </div>

                    <div class="row">
                        <label>이름</label>
                        <input type="text" v-model="petForm.petName">
                    </div>

                    <div class="row">
                        <label>종</label>
                        <input type="text" v-model="petForm.species">
                    </div>

                    <div class="row">
                        <label>품종</label>
                        <input type="text" v-model="petForm.breed">
                    </div>

                    <div class="row">
                        <label>생년월일</label>
                        <input type="date" v-model="petForm.birthdate">
                    </div>

                    <div class="row">
                        <label>성별</label>
                        <select v-model="petForm.gender">
                            <option value="">선택해주세요</option>
                            <option value="M">수컷</option>
                            <option value="F">암컷</option>
                            <option value="N">중성화</option>
                        </select>
                    </div>

                    <div class="modal-btns">
                        <button class="btn-cancel" @click="fnClosePetModal">취소</button>
                        <button class="btn-save" @click="fnSavePet">저장</button>
                    </div>
                </div>
            </div>

            <!-- 비밀번호 모달 -->
            <div class="modal-wrap" v-if="showPwdModal">
                <div class="modal-box">
                    <div class="modal-title">비밀번호 변경</div>

                    <div class="row">
                        <label>현재 비밀번호</label>
                        <input type="password" v-model="pwdForm.pwd">
                    </div>

                    <div class="row">
                        <label>새 비밀번호</label>
                        <input type="password" v-model="pwdForm.newPwd">
                    </div>

                    <div class="modal-btns">
                        <button class="btn-cancel" @click="fnClosePwdModal">취소</button>
                        <button class="btn-save" @click="fnChangePassword">변경</button>
                    </div>
                </div>
            </div>

        </div>

        <jsp:include page="/WEB-INF/footer/footer.jsp" />
    </body>

    </html>

    <script>


        const app = Vue.createApp({
            data() {
                return {
                    // 회원 정보
                    user: {
                        userName: "",
                        nickname: "",
                        email: "",
                        phone: "",
                        zipcode: "",
                        userAddr: "",
                        fullAddr: ""
                    },

                    // 회원정보 수정 영역 열림 여부
                    openUserEditPanel: false,

                    // 목록 데이터
                    petList: [],
                    reservationList: [],
                    orderList: [],
                    myPostList: [],
                    myCommentList: [],
                    couponList: [],

                    // 포인트
                    point: 0,

                    // 모달 표시 여부
                    showPetModal: false,
                    showPwdModal: false,

                    // 반려동물 등록/수정 폼
                    petForm: {
                        petNo: "",
                        petName: "",
                        species: "",
                        breed: "",
                        birthdate: "",
                        gender: ""
                    },

                    // 비밀번호 변경 폼
                    pwdForm: {
                        pwd: "",
                        newPwd: ""
                    }
                };
            },
            computed: {

                // 사용 가능한 쿠폰 개수
                usableCouponCount() {

                    return this.couponList.filter(coupon => {

                        return this.fnGetCouponStatus(coupon) === "ABLE";

                    }).length;

                },

                // 주문번호 기준으로 주문 묶기
                groupedOrderList() {

                    const grouped = {};

                    this.orderList.forEach(order => {

                        const orderNo = order.orderNo || "주문번호없음";

                        if (!grouped[orderNo]) {

                            grouped[orderNo] = [];

                        }

                        grouped[orderNo].push(order);

                    });

                    return Object.keys(grouped).map(orderNo => {

                        return {

                            orderNo: orderNo,
                            orderDate: grouped[orderNo][0]?.orderDate || "",
                            items: grouped[orderNo]

                        };

                    });

                },

                // 최근 게시글 3개
                recentPostList() {

                    return [...this.myPostList]
                        .sort((a, b) => {

                            return String(b.cdate || "")
                                .localeCompare(String(a.cdate || ""));

                        })
                        .slice(0, 3);

                }

            },



            methods: {
                // 메뉴 이동
                fnChangeMenu: function (menu) {

                    const urlMap = {

                        dashboard: "/user/mypage.do",
                        subscription: "/user/mypage/subscription.do",
                        community: "/user/mypage/community.do",
                        orderList: "/user/mypage/order-list.do",
                        reserveList: "/user/mypage/reserve-list.do",
                        petEdit: "/user/mypage/pet-edit.do",
                        petHealth: "/user/mypage/pet-health.do",
                        pointInfo: "/user/mypage/point-info.do",
                        couponInfo: "/user/mypage/coupon-info.do"

                    };

                    location.href = urlMap[menu] || "/user/mypage.do";

                },

                // page-change.js 공통 이동 함수
                fnPageChange: function (url, param) {
                    window.pageChange(url, param || {});
                },

                // 마이페이지 회원 정보 조회
                fnLoadMypage: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/user/mypage.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result === "loginRequired") {
                                alert("로그인 후 이용해주세요.");
                                location.href = "/user/login.do";
                                return;
                            }

                            if (data.result === "success" && data.userInfo) {
                                self.user = {
                                    userName: data.userInfo.userName || "",
                                    nickname: data.userInfo.nickname || "",
                                    email: data.userInfo.email || "",
                                    phone: data.userInfo.phone || "",
                                    zipcode: data.userInfo.zipcode || "",
                                    userAddr: data.userInfo.userAddr || "",
                                    fullAddr: data.userInfo.fullAddr || ""
                                };
                            }
                        },
                        error: function () {
                            alert("마이페이지 정보를 불러오지 못했습니다.");
                        }
                    });
                },

                // 반려동물 목록 조회
                fnLoadPetList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/user/pet-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.petList = data.result === "success"
                                ? (data.petList || []).sort((a, b) => {
                                    const aMain = String(a.isMain || a.IS_MAIN).trim().toUpperCase() === "Y";
                                    const bMain = String(b.isMain || b.IS_MAIN).trim().toUpperCase() === "Y";

                                    return Number(bMain) - Number(aMain);
                                })
                                : [];
                        },
                        error: function () {
                            self.petList = [];
                        }
                    });
                },

                // 최근 예약 목록 조회
                fnLoadReservationList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/user/reservation-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.reservationList = data.result === "success"
                                ? (data.reservationList || [])
                                : [];
                        },
                        error: function () {
                            self.reservationList = [];
                        }
                    });
                },

                // 주문 목록 조회
                fnLoadOrderList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/user/order-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.orderList = data.result === "success"
                                ? (data.orderList || [])
                                : [];
                        },
                        error: function () {
                            self.orderList = [];
                        }
                    });
                },

                // 내가 쓴 게시글 조회
                fnLoadMyPostList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/user/community-post-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.myPostList = data.result === "success"
                                ? (data.postList || [])
                                : [];
                        },
                        error: function () {
                            self.myPostList = [];
                        }
                    });
                },

                // 내가 쓴 댓글 조회
                fnLoadMyCommentList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/user/community-comment-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.myCommentList = data.result === "success"
                                ? (data.commentList || [])
                                : [];
                        },
                        error: function () {
                            self.myCommentList = [];
                        }
                    });
                },

                // 현재 포인트 조회
                fnLoadPointInfo: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/user/point-info.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result === "success") {
                                self.point =
                                    data.point
                                    || data.totalPoint
                                    || data.info?.point
                                    || data.info?.POINT
                                    || 0;
                            } else {
                                self.point = 0;
                            }
                        },
                        error: function () {
                            self.point = 0;
                        }
                    });
                },

                // 쿠폰 목록 조회
                fnLoadCouponList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/user/coupon-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.couponList = data.result === "success"
                                ? (data.couponList || [])
                                : [];
                        },
                        error: function () {
                            self.couponList = [];
                        }
                    });
                },

                // 회원정보 저장
                fnUpdateUser: function () {
                    let self = this;

                    $.ajax({
                        url: "/user/update-user.dox",
                        dataType: "json",
                        type: "POST",
                        data: self.user,
                        success: function (data) {
                            alert(data.message || "회원정보가 수정되었습니다.");
                            self.fnLoadMypage();
                        },
                        error: function () {
                            alert("회원정보 수정 중 오류가 발생했습니다.");
                        }
                    });
                },

                // 주소 검색 열기
                fnOpenAddressSearch: function () {
                    let self = this;

                    new daum.Postcode({
                        oncomplete: function (data) {
                            self.user.zipcode = data.zonecode;
                            self.user.userAddr = data.address;

                            setTimeout(function () {
                                const detail = document.getElementById("detailAddress");
                                if (detail) {
                                    detail.focus();
                                }
                            }, 100);
                        }
                    }).open();
                },

                // 비밀번호 모달 열기
                fnOpenPwdModal: function () {
                    this.showPwdModal = true;
                },

                // 비밀번호 모달 닫기
                fnClosePwdModal: function () {
                    this.showPwdModal = false;
                    this.pwdForm = {
                        pwd: "",
                        newPwd: ""
                    };
                },

                // 비밀번호 변경
                fnChangePassword: function () {
                    let self = this;

                    if (!self.pwdForm.pwd || !self.pwdForm.newPwd) {
                        alert("비밀번호를 입력해주세요.");
                        return;
                    }

                    $.ajax({
                        url: "/user/check-password.dox",
                        dataType: "json",
                        type: "POST",
                        data: {
                            pwd: self.pwdForm.pwd
                        },
                        success: function (data) {
                            if (data.result !== "success") {
                                alert(data.message || "현재 비밀번호가 일치하지 않습니다.");
                                return;
                            }

                            $.ajax({
                                url: "/user/change-pwd.dox",
                                dataType: "json",
                                type: "POST",
                                data: {
                                    pwd: self.pwdForm.pwd,
                                    newPwd: self.pwdForm.newPwd
                                },
                                success: function (data2) {
                                    alert(data2.message || "비밀번호가 변경되었습니다.");

                                    if (data2.result === "success") {
                                        self.fnClosePwdModal();
                                    }
                                },
                                error: function () {
                                    alert("비밀번호 변경 중 오류가 발생했습니다.");
                                }
                            });
                        },
                        error: function () {
                            alert("비밀번호 확인 중 오류가 발생했습니다.");
                        }
                    });
                },

                // 회원 탈퇴
                fnDeleteUser: function () {
                    const confirmText = prompt("회원 탈퇴를 진행하시려면 '탈퇴 확인' 이라고 입력해주세요.");

                    if (confirmText !== "탈퇴 확인") {
                        alert("입력한 문구가 일치하지 않아 탈퇴가 취소되었습니다.");
                        return;
                    }

                    $.ajax({
                        url: "/user/delete-user.dox",
                        dataType: "json",
                        type: "POST",
                        data: {},
                        success: function (data) {
                            alert(data.message || "처리되었습니다.");

                            if (data.result === "success") {
                                location.href = "/user/login.do";
                            }
                        },
                        error: function () {
                            alert("회원 탈퇴 중 오류가 발생했습니다.");
                        }
                    });
                },

                // 반려동물 수정 모달 열기
                fnOpenEditPetModal: function (pet) {
                    this.petForm = Object.assign({}, pet);
                    this.showPetModal = true;
                },

                // 반려동물 모달 닫기
                fnClosePetModal: function () {
                    this.showPetModal = false;
                    this.petForm = {
                        petNo: "",
                        petName: "",
                        species: "",
                        breed: "",
                        birthdate: "",
                        gender: ""
                    };
                },

                // 반려동물 저장
                fnSavePet: function () {
                    let self = this;

                    const url = self.petForm.petNo
                        ? "/user/update-pet.dox"
                        : "/user/add-pet.dox";

                    $.ajax({
                        url: url,
                        dataType: "json",
                        type: "POST",
                        data: self.petForm,
                        success: function (data) {
                            alert(data.message || "저장되었습니다.");

                            if (data.result === "success") {
                                self.fnClosePetModal();
                                self.fnLoadPetList();
                            }
                        },
                        error: function () {
                            alert("반려동물 저장 중 오류가 발생했습니다.");
                        }
                    });
                },

                // 반려동물 삭제
                fnDeletePet: function (petNo) {
                    let self = this;

                    if (!confirm("삭제하시겠습니까?")) {
                        return;
                    }

                    $.ajax({
                        url: "/user/delete-pet.dox",
                        dataType: "json",
                        type: "POST",
                        data: {
                            petNo: petNo
                        },
                        success: function (data) {
                            alert(data.message || "삭제되었습니다.");
                            self.fnLoadPetList();
                        },
                        error: function () {
                            alert("반려동물 삭제 중 오류가 발생했습니다.");
                        }
                    });
                },

                // 대표 반려동물 변경
                fnChangeMainPet: function (petNo) {

                    let self = this;

                    if (!confirm("선택한 반려동물을 대표동물로 변경하시겠습니까?")) {
                        return;
                    }

                    $.ajax({
                        url: "/user/change-main-pet.dox",
                        dataType: "json",
                        type: "POST",
                        data: {
                            petNo: petNo
                        },
                        success: function (data) {

                            if (data.result === "success") {

                                alert("대표동물이 변경되었습니다.");

                                self.fnLoadPetList();

                            } else {

                                alert(data.message || "대표동물 변경에 실패했습니다.");

                            }

                        },
                        error: function () {
                            alert("대표동물 변경 중 오류가 발생했습니다.");
                        }
                    });

                },


                // 게시글 상세 이동
                fnGoPostDetail: function (boardNo) {
                    window.pageChange("/community/detail.do", {
                        boardNo: boardNo
                    });
                },

                // 쿠폰 상태 계산
                fnGetCouponStatus: function (coupon) {
                    const status = String(coupon.cpStatus || coupon.CP_STATUS || "").toUpperCase();
                    const endDate = coupon.endDate || coupon.END_DATE;

                    if (status === "USED") {
                        return "USED";
                    }

                    if (endDate && new Date(endDate) < new Date()) { return "EXPIRED"; } return "ABLE";
                }, // 펫 이미지
                fnGetPetImage: function (pet) {

                    if (pet.petImg) {
                        return pet.petImg;
                    }

                    if (pet.species === '고양이') {
                        return '/img/user/pet/cat.png';
                    }

                    if (pet.species === '강아지') {
                        return '/img/user/pet/dog.png';
                    }

                    if (pet.species === '조류') {
                        return '/img/user/pet/bird.png';
                    }

                    if (pet.species === '어류') {
                        return '/img/user/pet/fish.png';
                    }

                    return '/img/user/pet/etc.png';
                },

                // 날짜 시간 표시
                fnFormatDateTime: function (dateStr) {
                    if (!dateStr) {
                        return "-";
                    }

                    let str = String(dateStr).replace("T", " ");

                    if (str.length >= 16) {
                        return str.substring(0, 16);
                    }

                    return str;
                },

                // 예약 상태 표시
                fnGetReservationStatusText: function (status) {
                    status = String(status || "").trim().toUpperCase();

                    if (status === "WAI") return "대기";
                    if (status === "CNF") return "확정";
                    if (status === "FIN") return "완료";
                    if (status === "CAN") return "취소";

                    return status || "-";
                },

                // 예약 상태 CSS
                fnGetReserveStatusClass: function (status) {
                    status = String(status || "").trim().toUpperCase();

                    if (status === "WAI") return "status-orange";
                    if (status === "CNF") return "status-blue";
                    if (status === "FIN") return "status-green";
                    if (status === "CAN") return "status-red";

                    return "status-gray";
                },

                // 배송 상태 표시
                fnGetDeliStatusText: function (status) {
                    status = String(status || "").trim().toUpperCase();

                    if (status === "RDY") return "배송준비";
                    if (status === "SHP") return "배송중";
                    if (status === "CMP") return "배송완료";
                    if (status === "CAN") return "배송취소";

                    return status || "-";
                },

                // 배송 상태 CSS
                fnGetDeliStatusClass: function (status) {
                    status = String(status || "").trim().toUpperCase();

                    if (status === "RDY") return "status-orange";
                    if (status === "SHP") return "status-blue";
                    if (status === "CMP") return "status-green";
                    if (status === "CAN") return "status-red";

                    return "status-gray";
                }
            },

            mounted() {
                let self = this;

                // 페이지 시작 시 필요한 데이터 조회
                self.fnLoadMypage();
                self.fnLoadPetList();
                self.fnLoadReservationList();
                self.fnLoadOrderList();
                self.fnLoadMyPostList();
                self.fnLoadMyCommentList();
                self.fnLoadPointInfo();
                self.fnLoadCouponList();
            }
        });

        app.mount("#app");
    </script>