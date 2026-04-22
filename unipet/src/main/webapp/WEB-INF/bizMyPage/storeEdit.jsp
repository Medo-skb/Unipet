<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bizMyPage/bizCommon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bizMyPage/storeEdit.css">
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="biz-page-wrap">
            <div class="biz-page-container">

                <aside class="biz-sidebar">
                    <div class="sidebar-title">나의 업체관리</div>

                    <ul class="sidebar-menu">
                        <li class="menu-item">
                            <a href="/biz/MyPage.do">홈</a>
                        </li>
                        <li class="menu-item active">
                            <a href="/biz/storeEdit.do">업체 정보 수정</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/myInfo.do">내 정보 수정</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/reservation.do">예약 현황</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/review.do">리뷰 관리</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/sales.do">매출 현황</a>
                        </li>
                    </ul>
                </aside>

                <section class="biz-content store-edit-page">
                    <div class="content-header">
                        <h1>업체 정보 수정</h1>
                    </div>

                    <!-- 업체 이미지 -->
                    <div class="content-section">
                        <div class="section-header">
                            <h2>업체 이미지</h2>
                        </div>

                        <div class="image-section-wrap">
                            <div class="image-guide-text">
                                이미지는 최대 4개까지 등록할 수 있습니다. 대표 이미지는 1개만 설정할 수 있습니다.
                            </div>

                            <div class="store-image-grid">
                                <div class="store-image-card" v-for="file in fileList" :key="file.fileNo">
                                    <div class="image-badge" v-if="file.isMain === 'Y'">대표 이미지</div>

                                    <div class="store-image-thumb">
                                        <img :src="file.filePath + file.fileName" :alt="file.originName">
                                    </div>

                                    <div class="store-image-name">{{file.originName}}</div>

                                    <div class="image-btn-area">
                                        <button type="button" class="line-btn"
                                            v-if="file.isMain !== 'Y'"
                                            @click="fnSetMainImage(file.fileNo)">
                                            대표 이미지 설정
                                        </button>

                                        <button type="button" class="line-btn danger-btn"
                                            @click="fnDeleteImage(file.fileNo)">
                                            삭제
                                        </button>
                                    </div>
                                </div>

                                <div class="store-image-add-card" v-if="fileList.length < 4">
                                    <label for="storeImageFile" class="image-add-label">
                                        <span class="plus-text">+</span>
                                        <span>이미지 등록</span>
                                    </label>
                                    <input type="file" id="storeImageFile" class="hidden-file" @change="fnUploadImage">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 업체 소개 -->
                    <div class="content-section">
                        <div class="section-header">
                            <h2>업체 정보</h2>
                        </div>

                        <div class="info-list">
                            <div class="info-row">
                                <div class="info-label">업체명</div>
                                <div class="info-value">{{storeInfo.storeName}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">카테고리</div>
                                <div class="info-value">
                                    {{
                                        storeInfo.sCategory === 'SAL' ? '미용' :
                                        storeInfo.sCategory === 'HOS' ? '병원' :
                                        storeInfo.sCategory === 'BRD' ? '위탁시설' :
                                        storeInfo.sCategory
                                    }}
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">사업자번호</div>
                                <div class="info-value">{{storeInfo.biznum}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">영업여부</div>
                                <div class="info-value">{{storeInfo.isOpen}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">은행명</div>
                                <div class="info-value">{{storeInfo.accName}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">계좌번호</div>
                                <div class="info-value">{{storeInfo.accNo}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">예금주</div>
                                <div class="info-value">{{storeInfo.accHolder}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">주소</div>
                                <div class="info-value">{{storeInfo.sAddr}} {{storeInfo.sFullAddr}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">소개 소제목</div>
                                <div class="info-value">{{storeInfo.subTitle}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">업체 소개글</div>
                                <div class="info-value full-text">{{storeInfo.sContents}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">동시 수용 가능 인원</div>
                                <div class="info-value">{{storeInfo.capacity}}명</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">예약 마감 시간</div>
                                <div class="info-value">예약 {{storeInfo.cutoff}}시간 전</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">운영 시작시간</div>
                                <div class="info-value">{{storeInfo.openTime}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">운영 종료시간</div>
                                <div class="info-value">{{storeInfo.closeTime}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">브레이크 시작</div>
                                <div class="info-value">{{storeInfo.breakStart}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">브레이크 종료</div>
                                <div class="info-value">{{storeInfo.breakEnd}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">휴무일</div>
                                <div class="info-value">{{storeInfo.offDay}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">환불정책</div>
                                <div class="info-value full-text">{{storeInfo.refundPolicy}}</div>
                            </div>
                        </div>

                        <div class="section-btn-area">
                            <button type="button" class="edit-btn" @click="fnEditStoreInfo">수정하기</button>
                        </div>
                    </div>

                    <!-- 업체 메뉴 -->
                    <div class="content-section">
                        <div class="section-header">
                            <h2>업체 메뉴</h2>
                        </div>

                        <table class="menu-table">
                            <thead>
                                <tr>
                                    <th>메뉴명</th>
                                    <th>메뉴 카테고리</th>
                                    <th>설명</th>
                                    <th>가격</th>
                                    <th>소요시간</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="menuList.length === 0">
                                    <td colspan="6" class="empty-text">등록된 메뉴가 없습니다.</td>
                                </tr>
                                <tr v-for="item in menuList" :key="item.menuNo">
                                    <td>{{item.menuName}}</td>
                                    <td>{{item.menuCategory}}</td>
                                    <td>{{item.menuInfo}}</td>
                                    <td>{{item.menuPrice}}</td>
                                    <td>{{item.reqTime}}</td>
                                    <td>{{item.mStatusName ? item.mStatusName : (item.mStatus === 'Y' ? '판매중' : '판매중지')}}</td>
                                </tr>
                            </tbody>
                        </table>

                        <div class="section-btn-area">
                            <button type="button" class="edit-btn" @click="fnEditMenu">수정하기</button>
                        </div>
                    </div>

                    <!-- 업체 소개 수정 모달 -->
                    <div v-if="showStoreEditModal" class="modal-overlay">
                        <div class="edit-modal-box">
                            <div class="modal-header">
                                <h2>업체 정보 수정</h2>
                                <button type="button" class="modal-close-btn" @click="fnCloseStoreEditModal">X</button>
                            </div>

                            <div class="modal-body">
                                <div class="form-row">
                                    <label>업체명</label>
                                    <input type="text" v-model="editStoreInfo.storeName" readonly>
                                </div>

                                <div class="form-row">
                                    <label>카테고리</label>
                                    <input type="text" v-model="editStoreInfo.sCategory" readonly>
                                </div>

                                <div class="form-row">
                                    <label>사업자번호</label>
                                    <input type="text" v-model="editStoreInfo.biznum" readonly>
                                </div>

                                <div class="form-row">
                                    <label>영업여부</label>
                                    <input type="text" v-model="editStoreInfo.isOpen">
                                </div>

                                <div class="form-row">
                                    <label>은행명</label>
                                    <input type="text" v-model="editStoreInfo.accName">
                                </div>

                                <div class="form-row">
                                    <label>계좌번호</label>
                                    <input type="text" v-model="editStoreInfo.accNo">
                                </div>

                                <div class="form-row">
                                    <label>예금주</label>
                                    <input type="text" v-model="editStoreInfo.accHolder">
                                </div>

                                <div class="form-row">
                                    <label>주소</label>
                                    <input type="text" v-model="editStoreInfo.sAddr" readonly>
                                </div>

                                <div class="form-row">
                                    <label>상세주소</label>
                                    <input type="text" v-model="editStoreInfo.sFullAddr" readonly>
                                </div>

                                <div class="form-row">
                                    <label>소개 소제목</label>
                                    <input type="text" v-model="editStoreInfo.subTitle">
                                </div>

                                <div class="form-row">
                                    <label>업체 소개글</label>
                                    <textarea v-model="editStoreInfo.sContents"></textarea>
                                </div>

                                <div class="form-row">
                                    <label>동시 수용 가능 인원</label>
                                    <input type="text" v-model="editStoreInfo.capacity">
                                </div>

                                <div class="form-row">
                                    <label>예약 마감 시간</label>
                                    <input type="text" v-model="editStoreInfo.cutoff" readonly>
                                </div>

                                <div class="form-row">
                                    <label>운영 시작시간</label>
                                    <input type="time" v-model="editStoreInfo.openTime" ref="openTimeInput" @click="fnOpenTimePicker('openTimeInput')">
                                </div>

                                <div class="form-row">
                                    <label>운영 종료시간</label>
                                    <input type="time" v-model="editStoreInfo.closeTime" ref="closeTimeInput" @click="fnOpenTimePicker('closeTimeInput')">
                                </div>

                                <div class="form-row">
                                    <label>브레이크 시작</label>
                                    <input type="time" v-model="editStoreInfo.breakStart" ref="breakStartInput" @click="fnOpenTimePicker('breakStartInput')">
                                </div>

                                <div class="form-row">
                                    <label>브레이크 종료</label>
                                    <input type="time" v-model="editStoreInfo.breakEnd" ref="breakEndInput" @click="fnOpenTimePicker('breakEndInput')">
                                </div>

                                <div class="form-row">
                                    <label>휴무일</label>
                                    <input type="text" v-model="editStoreInfo.offDay">
                                </div>

                                <div class="form-row">
                                    <label>환불정책</label>
                                    <textarea v-model="editStoreInfo.refundPolicy"></textarea>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseStoreEditModal">취소</button>
                                <button type="button" class="save-btn">저장</button>
                            </div>
                        </div>
                    </div>

                    <!-- 업체 메뉴 수정 모달 -->
                    <div v-if="showMenuEditModal" class="modal-overlay">
                        <div class="edit-modal-box large-modal">
                            <div class="modal-header">
                                <h2>업체 메뉴 수정</h2>
                                <button type="button" class="modal-close-btn" @click="fnCloseMenuEditModal">X</button>
                            </div>

                            <div class="modal-body">
                                <table class="menu-edit-table">
                                    <thead>
                                        <tr>
                                            <th>메뉴명</th>
                                            <th>메뉴 카테고리</th>
                                            <th>설명</th>
                                            <th>가격</th>
                                            <th>소요시간</th>
                                            <th>상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="item in editMenuList" :key="item.menuNo">
                                            <td><input type="text" v-model="item.menuName"></td>
                                            <td><input type="text" v-model="item.menuCategory"></td>
                                            <td><input type="text" v-model="item.menuInfo"></td>
                                            <td><input type="text" v-model="item.menuPrice"></td>
                                            <td><input type="text" v-model="item.reqTime"></td>
                                            <td>
                                                <select v-model="item.mStatus">
                                                    <option value="Y">판매중</option>
                                                    <option value="N">판매중지</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseMenuEditModal">취소</button>
                                <button type="button" class="save-btn">저장</button>
                            </div>
                        </div>
                    </div>

                </section>
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
                storeInfo: {
                    storeNo: "",
                    storeName: "",
                    sCategory: "",
                    biznum: "",
                    isOpen: "",
                    accName: "",
                    accNo: "",
                    accHolder: "",
                    sAddr: "",
                    sFullAddr: "",
                    subTitle: "",
                    sContents: "",
                    capacity: "",
                    cutoff: "",
                    openTime: "",
                    closeTime: "",
                    breakStart: "",
                    breakEnd: "",
                    offDay: "",
                    refundPolicy: ""
                },
                fileList: [],
                menuList: [],

                showStoreEditModal: false,
                showMenuEditModal: false,

                editStoreInfo: {
                    storeNo: "",
                    storeName: "",
                    sCategory: "",
                    biznum: "",
                    isOpen: "",
                    accName: "",
                    accNo: "",
                    accHolder: "",
                    sAddr: "",
                    sFullAddr: "",
                    subTitle: "",
                    sContents: "",
                    capacity: "",
                    cutoff: "",
                    openTime: "",
                    closeTime: "",
                    breakStart: "",
                    breakEnd: "",
                    offDay: "",
                    refundPolicy: ""
                },

                editMenuList: []

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnOpenTimePicker: function(refName) {
                let self = this;
                let target = self.$refs[refName];

                if (target && typeof target.showPicker === "function") {
                    target.showPicker();
                } else if (target) {
                    target.focus();
                }
            },

            fnGetStoreInfo: function() {
                let self = this;
                let param = {
                    sUserId: "test1234"
                };

                $.ajax({
                    url: "/getBizStoreList.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.list && data.list.length > 0) {
                            self.storeInfo = data.list[0];
                        } else {
                            self.storeInfo = {
                                storeNo: "",
                                storeName: "",
                                sCategory: "",
                                biznum: "",
                                isOpen: "",
                                accName: "",
                                accNo: "",
                                accHolder: "",
                                sAddr: "",
                                sFullAddr: "",
                                subTitle: "",
                                sContents: "",
                                openTime: "",
                                closeTime: "",
                                breakStart: "",
                                breakEnd: "",
                                offDay: "",
                                refundPolicy: ""
                            };
                        }
                    },
                    error: function() {
                        alert("업체 정보를 불러오는데 실패했습니다.");
                    }
                });
            },

            fnGetFileList: function() {
                let self = this;
                let param = {
                    sUserId: "test1234"
                };

                $.ajax({
                    url: "/getBizImgList.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.list) {
                            self.fileList = data.list;
                        } else {
                            self.fileList = [];
                        }
                    },
                    error: function() {
                        alert("이미지 정보를 불러오는데 실패했습니다.");
                    }
                });
            },

            fnGetMenuList: function() {
                let self = this;
                let param = {
                    sUserId: "test1234"
                };

                $.ajax({
                    url: "/getBizStoreMenuList.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.list) {
                            self.menuList = data.list;
                        } else {
                            self.menuList = [];
                        }
                    },
                    error: function() {
                        alert("업체 메뉴 정보를 불러오는데 실패했습니다.");
                    }
                });
            },

            fnEditStoreInfo: function() {
                let self = this;

                self.editStoreInfo = {
                    storeNo: self.storeInfo.storeNo,
                    storeName: self.storeInfo.storeName,
                    sCategory: self.storeInfo.sCategory,
                    biznum: self.storeInfo.biznum,
                    isOpen: self.storeInfo.isOpen,
                    accName: self.storeInfo.accName,
                    accNo: self.storeInfo.accNo,
                    accHolder: self.storeInfo.accHolder,
                    sAddr: self.storeInfo.sAddr,
                    sFullAddr: self.storeInfo.sFullAddr,
                    subTitle: self.storeInfo.subTitle,
                    sContents: self.storeInfo.sContents,
                    capacity: self.storeInfo.capacity,
                    cutoff: self.storeInfo.cutoff,
                    openTime: self.storeInfo.openTime,
                    closeTime: self.storeInfo.closeTime,
                    breakStart: self.storeInfo.breakStart,
                    breakEnd: self.storeInfo.breakEnd,
                    offDay: self.storeInfo.offDay,
                    refundPolicy: self.storeInfo.refundPolicy
                };

                self.showStoreEditModal = true;
            },

            fnCloseStoreEditModal: function() {
                let self = this;
                self.showStoreEditModal = false;
            },

            fnEditMenu: function() {
                let self = this;

                self.editMenuList = self.menuList.map(function(item) {
                    return {
                        menuNo: item.menuNo,
                        menuName: item.menuName,
                        menuCategory: item.menuCategory,
                        menuInfo: item.menuInfo,
                        menuPrice: item.menuPrice,
                        reqTime: item.reqTime,
                        mStatus: item.mStatus
                    };
                });

                self.showMenuEditModal = true;
            },

            fnCloseMenuEditModal: function() {
                let self = this;
                self.showMenuEditModal = false;
            },

            fnSetMainImage: function(fileNo) {
                alert("대표 이미지 설정 기능 연결 예정");
            },

            fnDeleteImage: function(fileNo) {
                alert("이미지 삭제 기능 연결 예정");
            },

            fnUploadImage: function(event) {
                let self = this;
                let files = event.target.files;

                if (!files || files.length === 0) {
                    return;
                }

                if (self.fileList.length >= 4) {
                    alert("이미지는 최대 4개까지 등록할 수 있습니다.");
                    return;
                }

                alert("이미지 업로드 기능 연결 예정");
            }


        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnGetFileList()
            self.fnGetStoreInfo();
            self.fnGetMenuList();
        }
    });

    app.mount('#app');
</script>