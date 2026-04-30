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
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=본인_JAVASCRIPT_KEY&libraries=services"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bizMyPage/bizCommon.css">
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="biz-page-wrap">
            <div class="biz-page-container">

                <aside class="biz-sidebar">
                    <div class="sidebar-title">사업자 마이페이지</div>

                    <ul class="sidebar-menu">
                        <li class="menu-item">
                            <a href="/biz/MyPage.do">홈</a>
                        </li>
                        <li class="menu-item active">
                            <a href="/biz/storeEdit.do">내 정보 및 업체 정보 수정</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/reservation.do">예약 현황</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/review.do">리뷰 관리</a>
                        </li>
                    </ul>
                </aside>

                <section class="biz-content store-edit-page">
                    <div class="content-header">
                        <h1>내 정보 및 업체 정보 수정</h1>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>기본 정보</h2>
                        </div>

                        <div class="info-list">
                            <div class="info-row">
                                <div class="info-label">아이디</div>
                                <div class="info-value">{{userInfo.sUserId}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">대표자명</div>
                                <div class="info-value">{{userInfo.ceoName}}</div>
                            </div>
                        </div>

                        <div class="section-btn-area">
                            <button type="button" class="edit-btn" @click="fnEditMyInfo">수정하기</button>
                            <button type="button" class="edit-btn danger-btn" @click="fnRequestWithdraw">회원 탈퇴</button>
                        </div>
                    </div>

                    <div v-if="!hasApprovedStore" class="content-section">
                        <div class="empty-text" style="white-space: pre-line;">
                            {{ approvedStoreMessage }}
                        </div>

                        <div class="section-btn-area" v-if="storeInfo.sStatus === 'REJ'">
                            <button type="button" class="edit-btn" @click="fnEditRejectedStore">
                                업체 정보 수정
                            </button>
                        </div>
                    </div>

                    <!-- 업체 이미지 -->
                    <div class="content-section" v-if="hasApprovedStore">
                        <div class="section-header">
                            <h2>업체 이미지</h2>
                        </div>

                        <div class="image-section-wrap">
                            <div class="image-guide-text">
                                <div>이미지는 최대 4개까지 등록할 수 있습니다. 대표 이미지는 1개만 설정할 수 있습니다.</div>
                               <div>이미지 사이즈는 250px * 250px 사이즈를 권장합니다. 그 외 사이즈는 이미지가 잘릴 수 있습니다.</div>
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
                                    <input type="file" id="storeImageFile" class="hidden-file" accept="image/*" @change="fnUploadImage">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 업체 소개 -->
                    <div class="content-section" v-if="hasApprovedStore">
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
                                <div class="info-value">
                                    {{ storeInfo.isOpen === 'Y' ? '영업중' : '폐업' }}
                                </div>
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
                            <!-- <div class="info-row">
                                <div class="info-label">휴무일</div>
                                <div class="info-value">{{storeInfo.offDay}}</div>
                            </div> -->
                            <!-- <div class="info-row">
                                <div class="info-label">환불정책</div>
                                <div class="info-value full-text">{{storeInfo.refundPolicy}}</div>
                            </div> -->
                        </div>

                        <div class="section-btn-area">
                            <button type="button" class="edit-btn" @click="fnEditStoreInfo">수정하기</button>
                        </div>
                    </div>

                    <!-- 업체 메뉴 -->
                    <div class="content-section" v-if="hasApprovedStore">
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
                                    <td>{{item.reqTime}}분</td>
                                    <td>{{item.mStatusName ? item.mStatusName : (item.mStatus === 'Y' ? '판매중' : '판매중지')}}</td>
                                </tr>
                            </tbody>
                        </table>

                        <div class="section-btn-area">
                            <button type="button" class="edit-btn" @click="fnEditMenu">수정하기</button>
                        </div>
                    </div>

                    <!-- 내 정보 수정 모달 -->
                    <div v-if="showMyInfoEditModal" class="modal-overlay">
                        <div class="edit-modal-box">
                            <div class="modal-header">
                                <h2>내 정보 수정</h2>
                                <button type="button" class="modal-close-btn" @click="fnCloseMyInfoModal">X</button>
                            </div>

                            <div class="modal-body">
                                <div class="form-row">
                                    <label>아이디</label>
                                    <div class="inline-input-area">
                                        <input type="text"
                                            v-model="editUserInfo.sUserId"
                                            @input="fnResetIdCheck"
                                            :readonly="isIdChecked">

                                        <button type="button"
                                                class="line-btn"
                                                @click="fnCheckBizUserId"
                                                :disabled="isIdChecked">
                                            {{ isIdChecked ? '확인완료' : '중복확인' }}
                                        </button>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <label>새 비밀번호</label>
                                    <input type="password" v-model="editUserInfo.sUserPwd" placeholder="새 비밀번호를 입력하세요">
                                </div>

                                <div class="form-row">
                                    <label>비밀번호 확인</label>
                                    <input type="password" v-model="editUserInfo.sUserPwdConfirm" placeholder="비밀번호를 다시 입력하세요">
                                </div>

                                <div class="form-row">
                                    <label>대표자명</label>
                                    <input type="text" v-model="editUserInfo.ceoName" readonly>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseMyInfoModal">취소</button>
                                <button type="button" class="save-btn" @click="fnSaveMyInfo">저장</button>
                            </div>
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
                                    <select v-model="editStoreInfo.isOpen">
                                        <option value="Y">영업중</option>
                                        <option value="N">폐업</option>
                                    </select>
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
                                    <div class="inline-input-area">
                                        <input type="text" v-model="editStoreInfo.sAddr" readonly>
                                        <button type="button" class="line-btn" @click="fnOpenPostcode">
                                            주소검색
                                        </button>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <label>상세주소</label>
                                    <input type="text" v-model="editStoreInfo.sFullAddr">
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
                                    <select v-model="editStoreInfo.capacity">
                                        <option v-for="num in capacityOptions" :key="num" :value="num">
                                            {{ num }}명
                                        </option>
                                    </select>
                                </div>

                                <div class="form-row">
                                    <label>예약 마감 시간</label>

                                    <div class="cutoff-input-area">
                                        <span>예약</span>
                                        <input type="number"
                                            v-model="editStoreInfo.cutoff"
                                            min="1"
                                            max="72"
                                            @input="fnCheckCutoff">
                                        <span>시간 전 * 1시간부터 72시간까지만 설정 가능합니다.</span>
                                    </div>
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

                                <!-- <div class="form-row">
                                    <label>휴무일</label>
                                    <input type="text" v-model="editStoreInfo.offDay">
                                </div> -->

                                <!-- <div class="form-row">
                                    <label>환불정책</label>
                                    <textarea v-model="editStoreInfo.refundPolicy"></textarea>
                                </div> -->
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseStoreEditModal">취소</button>
                                <button type="button" class="save-btn" @click="fnSaveStoreInfo">저장</button>
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
                                            <th>삭제</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="item in editMenuList" :key="item.menuNo">
                                            <td><input type="text" v-model="item.menuName"></td>
                                            <td><input type="text" v-model="item.menuCategory"></td>
                                            <td><input type="text" v-model="item.menuInfo"></td>
                                            <td><input type="number" v-model="item.menuPrice"></td>
                                            <td>
                                                <select v-model="item.reqTime">
                                                    <option :value="30">30분</option>
                                                    <option :value="60">60분</option>
                                                    <option :value="90">90분</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select v-model="item.mStatus">
                                                    <option value="Y">판매중</option>
                                                    <option value="N">판매중지</option>
                                                </select>
                                            </td>
                                            <td>
                                                <button type="button" class="menu-delete-btn" @click="fnRemoveMenu(item)">
                                                    삭제
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <div class="section-btn-area">
                                    <button type="button" class="menu-add-btn" @click="fnAddMenu">
                                        메뉴 추가
                                    </button>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseMenuEditModal">취소</button>
                                <button type="button" class="save-btn" @click="fnSaveMenuList">저장</button>
                            </div>
                        </div>
                    </div>

                    <!-- 반려 업체 재신청 수정 모달 -->
                    <div v-if="showRejectedStoreEditModal" class="modal-overlay">
                        <div class="edit-modal-box">
                            <div class="modal-header">
                                <h2>반려 업체 정보 수정</h2>
                                <button type="button" class="modal-close-btn" @click="fnCloseRejectedStoreModal">X</button>
                            </div>

                            <div class="modal-body">
                                <div class="form-row">
                                    <label>업체명</label>
                                    <input type="text" v-model="editStoreInfo.storeName">
                                </div>

                                <div class="form-row">
                                    <label>업종</label>
                                    <input type="text" v-model="editStoreInfo.sCategory">
                                </div>

                                <div class="form-row">
                                    <label>사업자번호</label>
                                    <input type="text" v-model="editStoreInfo.biznum">
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
                                    <div class="inline-input-area">
                                        <input type="text" v-model="editStoreInfo.sAddr" readonly>
                                        <button type="button" class="line-btn" @click="fnOpenPostcode">
                                            주소검색
                                        </button>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <label>상세주소</label>
                                    <input type="text" v-model="editStoreInfo.sFullAddr">
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseRejectedStoreModal">취소</button>
                                <button type="button" class="save-btn" @click="fnSaveRejectedStore">재신청</button>
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
                userInfo: {
                    sUserId: "",
                    ceoName: ""
                },
                hasApprovedStore: true,
                approvedStoreMessage: "",
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
                    refundPolicy: "",
                    sStatus: "",
                    rejReason: ""
                },
                fileList: [],
                menuList: [],

                showStoreEditModal: false,
                showMenuEditModal: false,
                showRejectedStoreEditModal: false,

                editStoreInfo: {
                    storeNo: "",
                    storeName: "",
                    sCategory: "",
                    biznum: "",
                    lat: "",
                    lng: "",
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

                editMenuList: [],
                deleteMenuNoList: [],
                capacityOptions: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],

                showMyInfoEditModal: false,
                isIdChecked: false,
                
                editUserInfo: {
                    sUserId: "",
                    ceoName: ""
                },

                isIdChecked: false,
                
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
        fnCheckApprovedStore: function() {
            let self = this;

            $.ajax({
                url: "/getApprovedStore.dox",
                type: "POST",
                dataType: "json",
                data: {
                    sUserId: "${sessionScope.sessionId}"
                },
                success: function(data) {
                if (data.result === "success" && data.list && data.list.length > 0) {
                    self.storeInfo = data.list[0];

                    if (self.storeInfo.sStatus === "GEN" || self.storeInfo.sStatus === "AFF") {
                            self.hasApprovedStore = true;
                            self.approvedStoreMessage = "";
                            self.fnGetStoreInfo();
                            self.fnGetFileList();
                            self.fnGetMenuList();
                        } else {
                            self.hasApprovedStore = false;
                            self.fileList = [];
                            self.menuList = [];

                            if (self.storeInfo.sStatus === "REJ") {
                                self.approvedStoreMessage = "사업자 승인이 반려되었습니다.";

                                if (self.storeInfo.rejReason) {
                                    self.approvedStoreMessage += "\n반려 사유: " + self.storeInfo.rejReason;
                                }
                            } else if (self.storeInfo.sStatus === "PND") {
                                self.approvedStoreMessage = "사업자 승인 대기중입니다.";
                            } else {
                                self.approvedStoreMessage = "승인된 업체가 없습니다.";
                            }
                        }
                    } else {
                        self.hasApprovedStore = false;
                        self.approvedStoreMessage = "승인된 업체가 없습니다.";

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
                            capacity: "",
                            cutoff: "",
                            openTime: "",
                            closeTime: "",
                            breakStart: "",
                            breakEnd: "",
                            offDay: "",
                            refundPolicy: "",
                            sStatus: "",
                            rejReason: ""
                        };

                        self.fileList = [];
                        self.menuList = [];
                    }
                },
                error: function() {
                    alert("승인된 업체 확인 중 오류가 발생했습니다.");
                }
            });
        },

            fnRequestWithdraw: function() {
                let self = this;

                if (!confirm("정말 회원 탈퇴 하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/biz/withdrawRequest.dox",
                    type: "POST",
                    dataType: "json",
                    data: {},
                    success: function(data) {
                        alert(data.message);

                        if (data.success) {
                            location.href = "/main.do";
                        }
                    },
                    error: function() {
                        alert("회원 탈퇴 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnOpenTimePicker: function(refName) {
                let self = this;
                let target = self.$refs[refName];

                if (target && typeof target.showPicker === "function") {
                    target.showPicker();
                } else if (target) {
                    target.focus();
                }
            },

            fnGetMyInfo: function () {
                let self = this;
                let param = {
                    sUserId: "${sessionScope.sessionId}"
                };

                $.ajax({
                    url: "/getBizUserInfo.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.info) {
                            self.userInfo = data.info;
                        } else {
                            self.userInfo = {
                                sUserId: "",
                                ceoName: "",
                                email: "",
                                phone: ""
                            };
                        }
                    },
                    error: function () {
                        alert("내 정보 조회에 실패했습니다.");
                    }
                });
            },

            fnGetStoreInfo: function() {
                let self = this;
                let param = {
                    sUserId: "${sessionScope.sessionId}"
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
                    sUserId: "${sessionScope.sessionId}"
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
                    sUserId: "${sessionScope.sessionId}"
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

            fnEditRejectedStore: function() {
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

                self.showRejectedStoreEditModal = true;
            },

            fnCloseRejectedStoreModal: function() {
                let self = this;
                self.showRejectedStoreEditModal = false;
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

                self.deleteMenuNoList = [];

                self.editMenuList = self.menuList.map(function(item) {
                    return {
                        menuNo: item.menuNo,
                        storeNo: self.storeInfo.storeNo,
                        menuName: item.menuName,
                        menuCategory: item.menuCategory,
                        menuInfo: item.menuInfo,
                        menuPrice: item.menuPrice,
                        reqTime: Number(item.reqTime),
                        mStatus: item.mStatus
                    };
                });

                self.showMenuEditModal = true;
            },

            fnRemoveMenu: function(item) {
                let self = this;

                if (!confirm("이 메뉴를 삭제하시겠습니까?")) {
                    return;
                }

                if (item.menuNo && Number(item.menuNo) !== 0) {
                    self.deleteMenuNoList.push(Number(item.menuNo));
                }

                self.editMenuList = self.editMenuList.filter(menu => menu !== item);
            },

            fnCloseMenuEditModal: function() {
                let self = this;
                self.showMenuEditModal = false;
            },

            fnAddMenu: function() {
                let self = this;

                self.editMenuList.push({
                    menuNo: "",
                    menuName: "",
                    menuCategory: "",
                    menuInfo: "",
                    menuPrice: "",
                    reqTime: 30,
                    mStatus: "Y",
                    storeNo: self.storeInfo.storeNo
                });
            },

            fnSetMainImage: function(fileNo) {
                let self = this;

                $.ajax({
                    url: "/biz/store/image/main.dox",
                    type: "POST",
                    dataType: "json",
                    data: { fileNo: fileNo },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("대표 이미지가 설정되었습니다.");
                            self.fnGetFileList();
                        } else {
                            alert(data.message || "대표 이미지 설정에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("서버 오류가 발생했습니다.");
                    }
                });
            },

            fnDeleteImage: function(fileNo) {
                let self = this;

                if (!confirm("이미지를 삭제하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/biz/store/image/delete.dox",
                    type: "POST",
                    dataType: "json",
                    data: { fileNo: fileNo },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("삭제되었습니다.");
                            self.fnGetFileList(); // 리스트 다시 불러오기
                        } else {
                            alert(data.message || "삭제 실패");
                        }
                    },
                    error: function() {
                        alert("서버 오류");
                    }
                });
            },

            fnUploadImage: function (event) {
                let self = this;
                const file = event.target.files[0];

                if (!file) {
                    return;
                }

                if (!self.storeInfo.storeNo) {
                    alert("업체 정보가 아직 없습니다. 새로고침 후 다시 시도해주세요.");
                    event.target.value = "";
                    return;
                }

                if (self.fileList.length >= 4) {
                    alert("이미지는 최대 4개까지 등록할 수 있습니다.");
                    event.target.value = "";
                    return;
                }

                if (!file.type.startsWith("image/")) {
                    alert("이미지 파일만 업로드할 수 있습니다.");
                    event.target.value = "";
                    return;
                }

                let formData = new FormData();
                formData.append("file", file);
                formData.append("storeNo", self.storeInfo.storeNo);
                formData.append("sUserId", "${sessionScope.sessionId}");

                $.ajax({
                    url: "/biz/store/image/upload.dox",
                    type: "POST",
                    dataType: "json",
                    data: formData,
                    processData: false,
                    contentType: false,
                    enctype: "multipart/form-data",
                    success: function (data) {
                        if (data.result === "success") {
                            alert("이미지가 등록되었습니다.");
                            event.target.value = "";
                            self.fnGetFileList();   // 이미지 목록 다시 조회
                        } else {
                            alert(data.message || "이미지 등록에 실패했습니다.");
                            event.target.value = "";
                        }
                    },
                    error: function () {
                        alert("업로드 중 오류가 발생했습니다.");
                        event.target.value = "";
                    }
                });
            },

            fnSaveRejectedStore: function() {
                let self = this;

                let param = {
                    storeNo: self.editStoreInfo.storeNo,
                    storeName: self.editStoreInfo.storeName,
                    sCategory: self.editStoreInfo.sCategory,
                    biznum: self.editStoreInfo.biznum,
                    accName: self.editStoreInfo.accName,
                    accNo: self.editStoreInfo.accNo,
                    accHolder: self.editStoreInfo.accHolder,
                    sAddr: self.editStoreInfo.sAddr,
                    sFullAddr: self.editStoreInfo.sFullAddr,
                    lat: self.editStoreInfo.lat || null,
                    lng: self.editStoreInfo.lng || null
                };

                $.ajax({
                    url: "/biz/store/reapply.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.result === "success") {
                            alert("재신청되었습니다.");
                            self.fnCloseRejectedStoreModal();
                            self.fnCheckApprovedStore();
                        } else {
                            alert(data.message || "재신청에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("재신청 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSaveStoreInfo: function() {
                let self = this;

                if (!self.editStoreInfo.cutoff || self.editStoreInfo.cutoff < 1 || self.editStoreInfo.cutoff > 72) {
                    alert("예약 마감 시간은 1~72 사이의 숫자만 입력할 수 있습니다.");
                    return;
                }

                let param = {
                    storeNo: self.editStoreInfo.storeNo,
                    isOpen: self.editStoreInfo.isOpen,
                    accName: self.editStoreInfo.accName,
                    accNo: self.editStoreInfo.accNo,
                    accHolder: self.editStoreInfo.accHolder,
                    sAddr: self.editStoreInfo.sAddr,
                    sFullAddr: self.editStoreInfo.sFullAddr,
                    subTitle: self.editStoreInfo.subTitle,
                    sContents: self.editStoreInfo.sContents,
                    capacity: self.editStoreInfo.capacity,
                    openTime: self.editStoreInfo.openTime,
                    closeTime: self.editStoreInfo.closeTime,
                    breakStart: self.editStoreInfo.breakStart,
                    breakEnd: self.editStoreInfo.breakEnd,
                    offDay: self.editStoreInfo.offDay,
                    refundPolicy: self.editStoreInfo.refundPolicy,
                    lat: self.editStoreInfo.lat || null,
                    lng: self.editStoreInfo.lng || null
                };

                let saveUrl = self.storeInfo.sStatus === "REJ"
                    ? "/biz/store/reapply.dox"
                    : "/biz/store/update.dox";

                $.ajax({
                    url: saveUrl,
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.result === "success") {
                            alert("업체 정보가 수정되었습니다.");
                            self.fnCloseStoreEditModal();
                            self.fnGetStoreInfo();
                        } else {
                            alert(data.message || "업체 정보 수정에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("업체 정보 수정 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSaveMenuList: function() {
                let self = this;
                let sendList = self.editMenuList.map(item => ({
                    ...item,
                    menuNo: Number(item.menuNo || 0),
                    storeNo: Number(item.storeNo || self.storeInfo.storeNo),
                    menuPrice: Number(item.menuPrice || 0),
                    reqTime: Number(item.reqTime || 0)
                }));

                $.ajax({
                    url: "/biz/store/menu/update.dox",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify({
                        menuList: sendList,
                        deleteMenuNoList: self.deleteMenuNoList
                    }),
                    success: function(data) {
                        if (data.result === "success") {
                            alert("업체 메뉴가 수정되었습니다.");
                            self.fnCloseMenuEditModal();
                            self.fnGetMenuList();
                        } else {
                            alert(data.message || "업체 메뉴 수정에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("업체 메뉴 수정 중 오류가 발생했습니다.");
                    }
                });
            },

            fnEditMyInfo: function() {
                let self = this;

                self.editUserInfo = {
                    sUserId: self.userInfo.sUserId,
                    ceoName: self.userInfo.ceoName,
                    sUserPwd: "",
                    sUserPwdConfirm: ""
                };

                self.isIdChecked = false;
                self.showMyInfoEditModal = true;
            },

            fnResetIdCheck: function() {
                this.isIdChecked = false;
            },

            fnCheckBizUserId: function() {
                let self = this;
                let param = {
                    sUserId: self.editUserInfo.sUserId,
                };

                if (!self.editUserInfo.sUserId) {
                    alert("아이디를 입력해주세요.");
                    return;
                }

                $.ajax({
                    url: "/checkBizUserId.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.result === "success") {
                            if (data.exists) {
                                alert("이미 사용 중인 아이디입니다.");
                                self.isIdChecked = false;
                            } else {
                                alert("사용 가능한 아이디입니다.");
                                self.isIdChecked = true;
                            }
                        } else {
                            alert(data.message || "중복 확인에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("중복 확인 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSaveMyInfo: function() {
                let self = this;

                if (!self.editUserInfo.sUserId) {
                    alert("아이디를 입력해주세요.");
                    return;
                }

                if (self.editUserInfo.sUserId !== self.userInfo.sUserId && !self.isIdChecked) {
                    alert("아이디 중복 확인을 해주세요.");
                    return;
                }

                if (!self.editUserInfo.sUserPwd) {
                    alert("새 비밀번호를 입력해주세요.");
                    return;
                }

                if (!self.editUserInfo.sUserPwdConfirm) {
                    alert("비밀번호 확인을 입력해주세요.");
                    return;
                }

                if (self.editUserInfo.sUserPwd !== self.editUserInfo.sUserPwdConfirm) {
                    alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                    return;
                }

                let param = {
                    sUserId: self.editUserInfo.sUserId,
                    sUserPwd: self.editUserInfo.sUserPwd
                };

                $.ajax({
                    url: "/biz/user/update.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.result === "success") {
                            alert("내 정보가 수정되었습니다.");
                            self.fnCloseMyInfoModal();
                            self.fnGetMyInfo();
                        } else {
                            alert(data.message || "내 정보 수정에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("내 정보 수정 중 오류가 발생했습니다.");
                    }
                });
            },

            fnCloseMyInfoModal: function() {
                let self = this;

                self.showMyInfoEditModal = false;
                self.isIdChecked = false;

                self.editUserInfo = {
                    sUserId: "",
                    ceoName: "",
                    sUserPwd: "",
                    sUserPwdConfirm: ""
                };
            },

            fnOpenPostcode: function() {
                let self = this;

                new daum.Postcode({
                    oncomplete: function(data) {
                        let address = data.roadAddress || data.address;

                        self.editStoreInfo.sAddr = address;
                        self.editStoreInfo.sFullAddr = "";
                        self.editStoreInfo.lat = null;
                        self.editStoreInfo.lng = null;

                        let geocoder = new kakao.maps.services.Geocoder();

                        geocoder.addressSearch(address, function(result, status) {
                            if (status === kakao.maps.services.Status.OK) {
                                self.editStoreInfo.lng = result[0].x;
                                self.editStoreInfo.lat = result[0].y;
                            }
                        });
                    }
                }).open({
                    popupName: "postcodePopup"
                });
            },

            fnCheckCutoff: function() {
                let self = this;

                if (self.editStoreInfo.cutoff < 1) {
                    self.editStoreInfo.cutoff = 1;
                }

                if (self.editStoreInfo.cutoff > 72) {
                    self.editStoreInfo.cutoff = 72;
                }
            },

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnGetMyInfo();
            self.fnCheckApprovedStore();
        }
    });

    app.mount('#app');
</script>