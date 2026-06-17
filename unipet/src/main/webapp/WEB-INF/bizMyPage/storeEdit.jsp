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
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJavascriptKey}&libraries=services"></script>
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
                                <div class="info-value">{{storeInfo.breakStart ? storeInfo.breakStart : '없음'}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">브레이크 종료</div>
                                <div class="info-value">{{storeInfo.breakEnd ? storeInfo.breakEnd : '없음'}}</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">예약 단위</div>
                                <div class="info-value">{{storeInfo.slot}}분</div>
                            </div>
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
                                    <!-- <th>메뉴 카테고리</th>
                                    <th>설명</th> -->
                                    <th>가격</th>
                                    <!-- <th>소요시간</th> -->
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-if="menuList.length === 0">
                                    <td colspan="6" class="empty-text">등록된 메뉴가 없습니다.</td>
                                </tr>
                                <tr v-for="item in menuList" :key="item.menuNo">
                                    <td>{{item.menuName}}</td>
                                    <!-- <td>{{item.menuCategory}}</td>
                                    <td>{{item.menuInfo}}</td> -->
                                    <td>{{item.menuPrice}}</td>
                                    <!-- <td>{{item.reqTime}}분</td> -->
                                    <td>{{item.mStatusName ? item.mStatusName : (item.mStatus === 'Y' ? '판매중' : '판매중지')}}</td>
                                </tr>
                            </tbody>
                        </table>

                        <div class="section-btn-area">
                            <button type="button" class="edit-btn" @click="fnOpenMenuAddModal">
                                메뉴 추가
                            </button>

                            <button type="button" class="edit-btn" @click="fnEditMenu">
                                수정하기
                            </button>
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
                                    <div class="time-select-area">
                                        <select v-model="editStoreInfo.openAmpm" @change="fnApplyOpenParts">
                                            <option value="">선택</option>
                                            <option value="AM">오전</option>
                                            <option value="PM">오후</option>
                                        </select>

                                        <select v-model="editStoreInfo.openHour"
                                                @change="fnApplyOpenParts"
                                                :disabled="!editStoreInfo.openAmpm">
                                            <option value="">시간</option>
                                            <option v-for="hour in hourOptions" :key="'openHour_' + hour" :value="hour">
                                                {{ hour }}시
                                            </option>
                                        </select>

                                        <select v-model="editStoreInfo.openMinute"
                                                @change="fnApplyOpenParts"
                                                :disabled="!editStoreInfo.openHour">
                                            <option value="">분</option>
                                            <option v-for="minute in fnGetMinuteOptions()" :key="'openMinute_' + minute" :value="minute">
                                                {{ minute }}분
                                            </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <label>운영 종료시간</label>
                                    <div class="time-select-area">
                                        <select v-model="editStoreInfo.closeAmpm" @change="fnApplyCloseParts">
                                            <option value="">선택</option>
                                            <option value="AM">오전</option>
                                            <option value="PM">오후</option>
                                        </select>

                                        <select v-model="editStoreInfo.closeHour"
                                                @change="fnApplyCloseParts"
                                                :disabled="!editStoreInfo.closeAmpm">
                                            <option value="">시간</option>
                                            <option v-for="hour in hourOptions" :key="'closeHour_' + hour" :value="hour">
                                                {{ hour }}시
                                            </option>
                                        </select>

                                        <select v-model="editStoreInfo.closeMinute"
                                                @change="fnApplyCloseParts"
                                                :disabled="!editStoreInfo.closeHour">
                                            <option value="">분</option>
                                            <option v-for="minute in fnGetMinuteOptions()" :key="'closeMinute_' + minute" :value="minute">
                                                {{ minute }}분
                                            </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <label>브레이크 시작</label>
                                    <div class="time-select-area">
                                        <select v-model="editStoreInfo.breakStartAmpm"
                                                @change="fnApplyBreakStartParts"
                                                :disabled="!fnIsOpenCloseComplete()">
                                            <option value="">선택 안 함</option>
                                            <option value="AM">오전</option>
                                            <option value="PM">오후</option>
                                        </select>

                                        <select v-model="editStoreInfo.breakStartHour"
                                                @change="fnApplyBreakStartParts"
                                                :disabled="!editStoreInfo.breakStartAmpm">
                                            <option value="">시간</option>
                                            <option v-for="hour in fnGetBreakHourOptions('breakStart')"
                                                    :key="'startHour_' + hour"
                                                    :value="hour">
                                                {{ hour }}시
                                            </option>
                                        </select>

                                        <select v-model="editStoreInfo.breakStartMinute"
                                                @change="fnApplyBreakStartParts"
                                                :disabled="!editStoreInfo.breakStartHour">
                                            <option value="">분</option>
                                            <option v-for="minute in fnGetBreakMinuteOptions('breakStart')"
                                                    :key="'startMinute_' + minute"
                                                    :value="minute">
                                                {{ minute }}분
                                            </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <label>브레이크 종료</label>
                                    <div class="time-select-area">
                                        <select v-model="editStoreInfo.breakEndAmpm"
                                                @change="fnApplyBreakEndParts"
                                                :disabled="!editStoreInfo.breakStart">
                                            <option value="">선택 안 함</option>
                                            <option value="AM">오전</option>
                                            <option value="PM">오후</option>
                                        </select>

                                        <select v-model="editStoreInfo.breakEndHour"
                                                @change="fnApplyBreakEndParts"
                                                :disabled="!editStoreInfo.breakEndAmpm">
                                            <option value="">시간</option>
                                            <option v-for="hour in fnGetBreakHourOptions('breakEnd')"
                                                    :key="'endHour_' + hour"
                                                    :value="hour">
                                                {{ hour }}시
                                            </option>
                                        </select>

                                        <select v-model="editStoreInfo.breakEndMinute"
                                                @change="fnApplyBreakEndParts"
                                                :disabled="!editStoreInfo.breakEndHour">
                                            <option value="">분</option>
                                            <option v-for="minute in fnGetBreakMinuteOptions('breakEnd')"
                                                    :key="'endMinute_' + minute"
                                                    :value="minute">
                                                {{ minute }}분
                                            </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <label></label>
                                    <button type="button" class="nullbtn" @click="fnClearBreakTime">
                                        브레이크타임 없음
                                    </button>
                                </div>
<!-- 
                                <div class="form-row">
                                    <button type="button" class="nullbtn" @click="fnClearBreakTime">
                                        브레이크타임 없음
                                    </button>
                                </div> -->

                                <div class="form-row">
                                    <label>예약 단위</label>
                                    <select v-model="editStoreInfo.slot" @change="fnResetBreakTimeBySlot">
                                        <option :value="30">30분</option>
                                        <option :value="60">60분</option>
                                    </select>
                                    <label></label>
                                    <div class="input-guide-text">예약 단위는 고객이 예약할 수 있는 시간 간격입니다.</div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseStoreEditModal">취소</button>
                                <button type="button" class="save-btn" @click="fnSaveStoreInfo">저장</button>
                            </div>
                        </div>
                    </div>

                    <!-- 업체 메뉴 추가 모달 -->
                    <div v-if="showMenuAddModal" class="modal-overlay">
                        <div class="edit-modal-box large-modal">
                            <div class="modal-header">
                                <h2>업체 메뉴 추가</h2>
                                <button type="button" class="modal-close-btn" @click="fnCloseMenuAddModal">X</button>
                            </div>

                            <div class="modal-body">
                                <div class="menu-add-input-row">
                                    <div class="menu-add-input-box">
                                        <label>메뉴명</label>
                                        <input type="text"
                                            v-model="addMenuInput.menuName"
                                            placeholder="메뉴명을 입력하세요">
                                    </div>

                                    <div class="menu-add-input-box">
                                        <label>가격</label>
                                        <input type="number"
                                            v-model="addMenuInput.menuPrice"
                                            min="1000"
                                            placeholder="1000원 이상 입력하세요">
                                    </div>

                                    <button type="button" class="edit-btn menu-add-confirm-btn" @click="fnAddMenuToAddList">
                                        확인
                                    </button>
                                </div>

                                <table class="menu-edit-table">
                                    <thead>
                                        <tr>
                                            <th>메뉴명</th>
                                            <th>가격</th>
                                            <th>상태</th>
                                            <th>삭제</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr v-if="addMenuList.length === 0">
                                            <td colspan="4" class="empty-text">추가할 메뉴가 없습니다.</td>
                                        </tr>

                                        <tr v-for="(item, index) in addMenuList" :key="'addMenu_' + index">
                                            <td>{{ item.menuName }}</td>
                                            <td>{{ item.menuPrice }}원</td>
                                            <td>판매중</td>
                                            <td>
                                                <button type="button" class="menu-delete-btn" @click="fnRemoveAddMenu(index)">
                                                    삭제
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="menu-guide-text">
                                    추가된 메뉴는 판매중지 상태로 변경하거나 삭제는 가능하지만 메뉴명과 가격은 수정할 수 없습니다.
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseMenuAddModal">취소</button>
                                <button type="button" class="save-btn" @click="fnSaveAddMenuList">추가하기</button>
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
                                            <th>가격</th>
                                            <th>상태</th>
                                            <th>삭제</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr v-if="editMenuList.length === 0">
                                            <td colspan="4" class="empty-text">등록된 메뉴가 없습니다.</td>
                                        </tr>

                                        <tr v-for="item in editMenuList" :key="item.menuNo">
                                            <td>{{ item.menuName }}</td>
                                            <td>{{ item.menuPrice }}원</td>
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

                                <div class="menu-guide-text">
                                    삭제된 메뉴는 되돌릴 수 없습니다.
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
                    <!-- 주소 검색 팝업 -->
                    <div v-if="showPostcodeLayer" class="postcode-overlay">
                        <div class="postcode-popup-box">
                            <div class="postcode-popup-header">
                                <span>주소 검색</span>
                                <button type="button" class="postcode-close-btn" @click="fnClosePostcode">X</button>
                            </div>

                            <div id="postcodeWrap" class="postcode-wrap"></div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

    <!-- js 분리 -->
    <script>
        window.storeEditConfig = {
            sessionId: "${sessionScope.sessionId}"
        };
    </script>

    <script src="${pageContext.request.contextPath}/js/bizMyPage/storeEdit.js"></script>
</body>
</html>