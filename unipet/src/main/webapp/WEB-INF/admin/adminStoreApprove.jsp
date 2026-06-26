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

                        <div class="admin-approve-table-wrap admin-list-fixed-area" v-if="approveList && approveList.length > 0">
                            <table class="admin-user-table admin-approve-table">
                                <thead>
                                    <tr>
                                        <th>사업자 아이디</th>
                                        <th>사업자 번호</th>
                                        <th>사업자 등록증</th>
                                        <th>대표자명</th>
                                        <th>업체명</th>
                                        <th>업종</th>
                                        <th>주소</th>
                                        <th>승인/반려</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in pagedApproveList" :key="item.storeNo">
                                        <td>{{ item.sUserId }}</td>
                                        <td>{{ fnEmpty(item.biznum) }}</td>
                                        <td>
                                            <button
                                                v-if="item.bizFileName"
                                                type="button"
                                                class="detail-link-btn"
                                                @click="fnBizFilePreview(item)">
                                                보기
                                            </button>
                                            <span v-else>-</span>
                                        </td>
                                        <td>{{ item.ceoName }}</td>
                                        <td>{{ item.storeName }}</td>
                                        <td>{{ fnCategoryName(item.sCategory) }}</td>
                                        <td>
                                            <button type="button" class="detail-link-btn address-cell-btn" @click="fnOpenMap(item)">
                                                {{ fnFullAddress(item) }}
                                            </button>
                                        </td>
                                        <td>
                                            <button type="button" class="btn-approve-reject" @click="fnOpenBizStatusModal(item)">
                                                승인/반려
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="empty-box" v-if="approveList.length === 0">
                            승인 대기 중인 사업자가 없습니다.
                        </div>

                        <div class="admin-pagination" v-if="approveList.length > 0">
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
                <!-- 사업자 승인/반려 선택 모달 -->
                <div class="biz-status-modal-bg" v-if="bizStatusModalOpen">
                    <div class="biz-status-modal">
                        <div class="biz-status-modal-header">
                            <h3>사업자 승인/반려</h3>
                            <button type="button" class="biz-status-modal-close" @click="fnCloseBizStatusModal">×</button>
                        </div>

                        <div class="biz-status-modal-body">
                            <div class="biz-status-row">
                                <span class="biz-status-label">업체명</span>
                                <span>{{ bizStatusTarget ? bizStatusTarget.storeName : '' }}</span>
                            </div>

                            <div class="biz-status-row">
                                <span class="biz-status-label">사업자 번호</span>
                                <span>{{ bizStatusTarget ? fnEmpty(bizStatusTarget.biznum) : '-' }}</span>
                            </div>

                            <div class="input-group">
                                <label>반려 사유</label>
                                <textarea
                                    class="biz-status-reason"
                                    v-model="rejReason"
                                    placeholder="반려할 경우 사유를 입력해주세요."></textarea>
                            </div>

                            <div class="biz-status-message">
                                승인하시겠습니까?
                                승인 시 반려 사유는 저장되지 않습니다.
                            </div>
                        </div>

                        <div class="biz-status-modal-footer">
                            <button type="button" class="modal-cancel-btn" @click="fnCloseBizStatusModal">
                                취소
                            </button>
                            <button type="button" class="btn-reject" @click="fnRejectBizStatus" :disabled="isProcessingBizStatus">
                                반려
                            </button>
                            <button type="button" class="btn-approve" @click="fnApproveBizStatus" :disabled="isProcessingBizStatus">
                                승인
                            </button>
                        </div>
                    </div>
                </div>
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
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                approveList: [],
                currentPage: 1,
                pageSize: 10,

                mapModalOpen: false,
                mapTarget: null,
                map: null,

                bizStatusModalOpen: false,
                bizStatusTarget: null,
                rejReason: "",
                isProcessingBizStatus: false
            };
        },
        computed: {
            totalPage: function () {
                return Math.ceil(this.approveList.length / this.pageSize);
            },

            pageList: function () {
                let list = [];
                let startPage = Math.floor((this.currentPage - 1) / 5) * 5 + 1;
                let endPage = Math.min(startPage + 4, this.totalPage);

                for (let i = startPage; i <= endPage; i++) {
                    list.push(i);
                }

                return list;
            },

            pagedApproveList: function () {
                let start = (this.currentPage - 1) * this.pageSize;
                let end = start + this.pageSize;

                return this.approveList.slice(start, end);
            }
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

                            if (self.currentPage > self.totalPage) {
                                self.currentPage = self.totalPage || 1;
                            }
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

            fnEmpty: function (value) {
                if (value === null || value === undefined || value === "") {
                    return "-";
                }
                return value;
            },

            fnMovePage: function (page) {
                if (page < 1 || page > this.totalPage) {
                    return;
                }

                this.currentPage = page;

            },

            fnBizFilePreview: function (item) {
                if (!item.bizFileName) {
                    alert("사업자 등록증 파일이 없습니다.");
                    return;
                }

                window.open("/img/bizfile/" + item.bizFileName, "_blank");
            },

            fnOpenBizStatusModal: function (item) {
                if (!item) {
                    alert("처리할 업체 정보가 없습니다.");
                    return;
                }

                this.bizStatusTarget = item;
                this.rejReason = "";
                this.bizStatusModalOpen = true;
            },

            fnCloseBizStatusModal: function () {
                this.bizStatusModalOpen = false;
                this.bizStatusTarget = null;
                this.rejReason = "";
                this.isProcessingBizStatus = false;
            },

            fnApproveBizStatus: function () {
                let self = this;
                let item = self.bizStatusTarget;

                if (self.isProcessingBizStatus) {
                    return;
                }

                if (!item) {
                    alert("승인할 업체 정보가 없습니다.");
                    return;
                }

                if (!item.biznum) {
                    alert("사업자번호가 없습니다.");
                    return;
                }

                self.isProcessingBizStatus = true;

                $.ajax({
                    url: "/editBizStatusApr.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: item.storeNo,
                        sUserId: item.sUserId,
                        bizNum: item.biznum
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("승인되었습니다.");
                            self.fnCloseBizStatusModal();
                            self.fnBizList();
                        } else {
                            self.isProcessingBizStatus = false;
                            alert(data.message || "승인 처리 중 오류가 발생했습니다.");
                        }
                    },
                    error: function () {
                        self.isProcessingBizStatus = false;
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnRejectBizStatus: function () {
                let self = this;
                let item = self.bizStatusTarget;

                if (self.isProcessingBizStatus) {
                    return;
                }

                if (!item) {
                    alert("반려할 업체 정보가 없습니다.");
                    return;
                }

                if (!self.rejReason || self.rejReason.trim() === "") {
                    alert("반려 사유를 입력해주세요.");
                    return;
                }

                self.isProcessingBizStatus = true;

                $.ajax({
                    url: "/editBizStatusRej.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: item.storeNo,
                        sUserId: item.sUserId,
                        rejReason: self.rejReason.trim()
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("반려되었습니다.");
                            self.fnCloseBizStatusModal();
                            self.fnBizList();
                        } else {
                            self.isProcessingBizStatus = false;
                            alert(data.message || "반려 처리 중 오류가 발생했습니다.");
                        }
                    },
                    error: function () {
                        self.isProcessingBizStatus = false;
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            }
        },
        mounted() {
            let self = this;
            self.fnBizList();

            self.$nextTick(function () {
                self.fnSyncApproveTableScroll();
            });
        }
    });

    app.mount('#app');
</script>
