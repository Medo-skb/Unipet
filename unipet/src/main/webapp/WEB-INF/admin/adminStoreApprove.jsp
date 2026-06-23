<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJavascriptKey}"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" v-cloak>
        <div class="container-main">
            <div class="admin-wrap">

                <jsp:include page="/WEB-INF/admin/adminSidebar.jsp">
                    <jsp:param name="activeMenu" value="storeApprove" />
                </jsp:include>

                <section class="admin-content">
                    <div class="content-card">
                        <h2>사업자 입점 승인 관리</h2>
                        <div class="content-desc">승인 대기 중인 사업자 목록입니다.</div>

                        <div class="approve-list" v-if="approveList && approveList.length > 0">
                            <div class="approve-card" v-for="item in approveList" :key="item.storeNo">
                                <table class="approve-table">
                                    <tbody>
                                        <tr>
                                            <th>사업자 아이디</th>
                                            <td>{{ item.sUserId }}</td>
                                        </tr>
                                        <tr>
                                            <th>대표자명</th>
                                            <td>{{ item.ceoName }}</td>
                                        </tr>
                                        <tr>
                                            <th>업체명</th>
                                            <td>{{ item.storeName }}</td>
                                        </tr>
                                        <tr>
                                            <th>업종</th>
                                            <td>{{ fnCategoryName(item.sCategory) }}</td>
                                        </tr>
                                        <tr>
                                            <th>주소</th>
                                            <td>
                                                <button type="button" class="address-link" @click="fnOpenMap(item)">
                                                    {{ fnFullAddress(item) }}
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>사업자 등록증</th>
                                            <td>
                                                <button
                                                    v-if="item.bizFileName"
                                                    type="button"
                                                    class="file-link"
                                                    @click="fnBizFilePreview(item)">
                                                    {{ item.bizFileName }}
                                                </button>
                                                <span v-else>사업자 등록증 파일이 없습니다.</span>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="approve-card-actions">
                                    <button type="button" class="admin-action-btn reject-btn" @click="fnOpenRejectModal(item)">
                                        반려
                                    </button>
                                    <button type="button" class="admin-action-btn approve-btn" @click="fnOpenApproveModal(item)">
                                        승인
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="empty-box" v-if="approveList.length === 0">
                            승인 대기 중인 사업자가 없습니다.
                        </div>
                    </div>
                </section>
            </div>
        </div>

        <div class="map-modal-bg" v-if="mapModalOpen">
            <div class="map-modal">
                <div class="map-modal-header">
                    <h3>{{ mapTarget ? mapTarget.storeName : '' }} 위치</h3>
                    <button type="button" class="map-modal-close" @click="fnCloseMap">×</button>
                </div>

                <div class="map-address">
                    {{ fnFullAddress(mapTarget) }}
                </div>

                <div id="kakaoMap" class="kakao-map"></div>
            </div>
        </div>
        <!-- 사업자 승인 모달 -->
        <div class="approve-modal-bg" v-if="approveModalOpen">
            <div class="approve-modal">
                <div class="approve-modal-header">
                    <h3>사업자 승인</h3>
                    <button type="button" class="approve-modal-close" @click="fnCloseApproveModal">×</button>
                </div>

                <div class="approve-modal-body">
                    <div class="approve-info-row">
                        <span class="approve-info-label">업체명</span>
                        <span>{{ approveTarget ? approveTarget.storeName : '' }}</span>
                    </div>

                    <label class="approve-input-label" for="bizNum">사업자 번호</label>
                    <input
                        id="bizNum"
                        type="text"
                        class="approve-input"
                        v-model="bizNum"
                        placeholder="사업자 번호를 입력하세요.">
                </div>

                <div class="approve-modal-footer">
                    <button type="button" class="admin-action-btn cancel-btn" @click="fnCloseApproveModal">취소</button>
                    <button type="button" class="admin-action-btn approve-btn" @click="fnApprove" :disabled="isApproving">
                        {{ isApproving ? '승인 처리 중...' : '승인' }}
                    </button>
                </div>
            </div>
        </div>
        <!-- 사업자 반려 모달 -->
        <div class="reject-modal-bg" v-if="rejectModalOpen">
            <div class="reject-modal">
                <div class="reject-modal-header">
                    <h3>사업자 반려</h3>
                    <button type="button" class="reject-modal-close" @click="fnCloseRejectModal">×</button>
                </div>

                <div class="reject-modal-body">
                    <div class="reject-info-row">
                        <span class="reject-info-label">업체명</span>
                        <span>{{ rejectTarget ? rejectTarget.storeName : '' }}</span>
                    </div>

                    <label class="reject-input-label" for="rejReason">반려 사유</label>
                    <textarea
                        id="rejReason"
                        class="reject-textarea"
                        v-model="rejReason"
                        placeholder="반려 사유를 입력하세요."></textarea>
                </div>

                <div class="reject-modal-footer">
                    <button type="button" class="admin-action-btn cancel-btn" @click="fnCloseRejectModal">취소</button>
                    <button type="button" class="admin-action-btn reject-btn" @click="fnReject" :disabled="isRejecting">
                        {{ isRejecting ? '반려 처리 중...' : '반려' }}
                    </button>
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
                approveList: [],

                mapModalOpen: false,
                mapTarget: null,
                map: null,

                approveModalOpen: false,
                approveTarget: null,
                bizNum: "",
                isApproving: false,

                rejectModalOpen: false,
                rejectTarget: null,
                rejReason: "",
                isRejecting: false
            };
        },
        methods: {
            fnBizList: function () {
                let self = this;

                $.ajax({
                    url: "/adminBiz.dox",
                    dataType: "json",
                    type: "POST",
                    data: {},
                    success: function (data) {
                        if (data.result === "success") {
                            self.approveList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnCategoryName: function (category) {
                if (category === "HOS") {
                    return "병원";
                }
                if (category === "SAL") {
                    return "미용실";
                }
                if (category === "BRD") {
                    return "위탁시설";
                }
                return category;
            },

            fnOpenMap: function (item) {
                let self = this;

                if (!item.lat || !item.lng) {
                    alert("위치 정보가 없습니다.");
                    return;
                }

                self.mapTarget = item;
                self.mapModalOpen = true;

                self.$nextTick(function () {
                    let lat = parseFloat(item.lat);
                    let lng = parseFloat(item.lng);

                    let mapContainer = document.getElementById("kakaoMap");
                    let markerPosition = new kakao.maps.LatLng(lat, lng);

                    let mapOption = {
                        center: markerPosition,
                        level: 3
                    };

                    self.map = new kakao.maps.Map(mapContainer, mapOption);

                    let marker = new kakao.maps.Marker({
                        position: markerPosition
                    });

                    marker.setMap(self.map);

                    setTimeout(function () {
                        self.map.relayout();
                        self.map.setCenter(markerPosition);
                    }, 100);
                });
            },

            fnCloseMap: function () {
                let self = this;

                self.mapModalOpen = false;
                self.mapTarget = null;
                self.map = null;
            },
            fnFullAddress: function (item) {
                if (!item) {
                    return "";
                }

                let sAddr = item.sAddr || "";
                let sFullAddr = item.sFullAddr || "";

                return (sAddr + " " + sFullAddr).trim();
            },
            fnBizFilePreview: function (item) {
                if (!item.bizFileName) {
                    alert("사업자 등록증 파일이 없습니다.");
                    return;
                }

                window.open("/img/bizfile/" + item.bizFileName, "_blank");
            },
            fnOpenRejectModal: function (item) {
                let self = this;

                self.rejectTarget = item;
                self.rejReason = "";
                self.rejectModalOpen = true;
            },

            fnCloseRejectModal: function () {
                let self = this;

                self.rejectModalOpen = false;
                self.rejectTarget = null;
                self.rejReason = "";
                self.isRejecting = false;
            },

            fnReject: function () {
                let self = this;

                if (self.isRejecting) {
                    return;
                }

                if (!self.rejectTarget) {
                    alert("반려할 업체 정보가 없습니다.");
                    return;
                }

                if (!self.rejReason.trim()) {
                    alert("반려 사유를 입력해주세요.");
                    return;
                }

                let message = "업체명: " + self.rejectTarget.storeName
                    + "\n반려 사유: " + self.rejReason.trim()
                    + "\n\n반려하시겠습니까?";

                if (!confirm(message)) {
                    return;
                }

                self.isRejecting = true;

                $.ajax({
                    url: "/editBizStatusRej.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: self.rejectTarget.storeNo,
                        sUserId: self.rejectTarget.sUserId,
                        rejReason: self.rejReason.trim()
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("반려되었습니다.");
                            self.fnCloseRejectModal();
                            self.fnBizList();
                        } else {
                            self.isRejecting = false;
                            alert(data.message || "반려 처리 중 오류가 발생했습니다.");
                        }
                    },
                    error: function () {
                        self.isRejecting = false;
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },
            fnOpenApproveModal: function (item) {
                let self = this;

                self.approveTarget = item;
                self.bizNum = "";
                self.approveModalOpen = true;
            },
            fnCloseApproveModal: function () {
                let self = this;

                self.approveModalOpen = false;
                self.approveTarget = null;
                self.bizNum = "";
                self.isApproving = false;
            },
            fnApprove: function () {
                let self = this;

                if (self.isApproving) {
                    return;
                }

                if (!self.approveTarget) {
                    alert("승인할 업체 정보가 없습니다.");
                    return;
                }

                if (!self.bizNum.trim()) {
                    alert("사업자 번호를 입력해주세요.");
                    return;
                }

                let message = "업체명: " + self.approveTarget.storeName
                    + "\n사업자번호: " + self.bizNum.trim()
                    + "\n\n승인하시겠습니까?";

                if (!confirm(message)) {
                    return;
                }

                self.isApproving = true;

                $.ajax({
                    url: "/editBizStatusApr.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: self.approveTarget.storeNo,
                        sUserId: self.approveTarget.sUserId,
                        bizNum: self.bizNum.trim()
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("승인되었습니다.");
                            self.fnCloseApproveModal();
                            self.fnBizList();
                        } else {
                            self.isApproving = false;
                            alert(data.message || "승인 처리 중 오류가 발생했습니다.");
                        }
                    },
                    error: function () {
                        self.isApproving = false;
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            }
        },
        mounted() {
            let self = this;
            self.fnBizList();
        }
    });

    app.mount('#app');
</script>
