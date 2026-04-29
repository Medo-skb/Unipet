<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
        <!-- <link href="/css/user/usermypage.css" rel="stylesheet"> -->
        <link href="/css/user/usermypage2.css" rel="stylesheet">
        <title>마이페이지</title>
    </head>

    <body>
        <jsp:include page="/WEB-INF/header/header.jsp" />

        <div id="app">

            <div class="sidebar">
                <div class="menu" :class="{active: currentMenu==='userMyPage'}" @click="changeMenu('userMyPage')">
                    🏠<br>마이페이지</div>
                <div class="menu" :class="{active: currentMenu==='subscriptionPage'}"
                    @click="changeMenu('subscriptionPage')">💳<br>구독</div>
                <div class="menu" :class="{active: currentMenu==='communityPage'}" @click="changeMenu('communityPage')">
                    💬<br>커뮤니티</div>
                <div class="menu" :class="{active: currentMenu==='orderList'}" @click="changeMenu('orderList')">
                    🛒<br>주문내역</div>
                <div class="menu" :class="{active: currentMenu==='reserveList'}" @click="changeMenu('reserveList')">
                    📅<br>예약내역</div>
                <div class="menu" :class="{active: currentMenu==='petEdit'}" @click="changeMenu('petEdit')">🐶<br>반려동물
                </div>
                <div class="menu" :class="{active: currentMenu==='petMyPage'}" @click="changeMenu('petMyPage')">
                    💗<br>건강조회</div>
                <div class="menu" :class="{active: currentMenu==='petHealthPage'}" @click="changeMenu('petHealthPage')">
                    📝<br>건강기록</div>
                <div class="menu" :class="{active: currentMenu==='petVacPage'}" @click="changeMenu('petVacPage')">
                    💉<br>접종기록</div>
                <div class="menu" :class="{active: currentMenu==='petWeightPage'}" @click="changeMenu('petWeightPage')">
                    ⚖️<br>몸무게</div>
                <div class="menu" :class="{active: currentMenu==='pointInfo'}" @click="changeMenu('pointInfo')">
                    💰<br>포인트</div>
                <div class="menu" :class="{active: currentMenu==='couponInfo'}" @click="changeMenu('couponInfo')">
                    🎟️<br>쿠폰관리
                </div>
            </div>

            <div class="content">
                <div class="page-title">{{ pageTitle }}</div>
                <div class="page-inner">

                    <div v-if="currentMenu === 'userMyPage'">
                        <div class="mypage-dashboard">

                            <div class="dash-left">
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
                                                <button class="btn-gray" @click="openPwdModal">비밀번호 변경</button>
                                                <button class="btn-red" @click="deleteUser">회원 탈퇴</button>
                                            </div>
                                        </div>
                                    </div>

                                    <div v-if="openUserEditPanel" style="margin-top:16px;">
                                        <div class="grid-2">
                                            <div class="row"><label>이름</label><input type="text"
                                                    v-model="user.userName"></div>
                                            <div class="row"><label>닉네임</label><input type="text"
                                                    v-model="user.nickname"></div>
                                            <div class="row"><label>이메일</label><input type="text" v-model="user.email">
                                            </div>
                                            <div class="row"><label>전화번호</label><input type="text" v-model="user.phone">
                                            </div>
                                            <div class="row"><label>우편번호</label><input type="text"
                                                    v-model="user.zipcode"></div>
                                            <div class="row"><label>주소</label><input type="text"
                                                    v-model="user.userAddr"></div>
                                        </div>

                                        <div class="row">
                                            <label>상세주소</label>
                                            <input type="text" v-model="user.fullAddr">
                                        </div>

                                        <div class="btn-box">
                                            <button @click="updateUser">회원정보 저장</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="section-box">
                                    <div class="section-title">반려동물 프로필</div>

                                    <div class="pet-list">
                                        <div class="pet-card" v-for="pet in petList" :key="pet.petNo">
                                            <div class="pet-thumb">
                                                <div class="pet-avatar">{{ getPetInitial(pet.petName) }}</div>
                                            </div>
                                            <div class="pet-body">
                                                <div class="pet-name">{{ pet.petName }}</div>
                                                <div class="pet-info">
                                                    {{ pet.species || '' }}
                                                    {{ pet.birthdate ? ' · ' + getPetAge(pet.birthdate) + '살' : '' }}
                                                </div>
                                                <div class="pet-btns">
                                                    <button v-if="pet.isMain === 'Y'" class="pet-btn main gray"
                                                        disabled>대표 프로필</button>
                                                    <button v-else class="pet-btn main"
                                                        @click="changeMainPet(pet.petNo)">대표 프로필</button>
                                                    <button class="pet-btn edit"
                                                        @click="openEditPetModal(pet)">수정</button>
                                                    <button class="pet-btn delete"
                                                        @click="deletePet(pet.petNo)">삭제</button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="pet-add-card" @click="openAddPetModal">
                                            <div class="pet-add-plus">+</div>
                                            <div>프로필 추가</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="mini-dashboard">
                                    <div class="mini-panel">
                                        <div class="mini-panel-head">최근 예약 현황</div>
                                        <div class="mini-panel-body">
                                            <div v-if="reservationList.length === 0" class="empty-text">예약 내역이 없습니다.
                                            </div>

                                            <div class="main-reserve-item" v-for="item in reservationList.slice(0, 2)"
                                                :key="item.rsvNo">
                                                <div>
                                                    <div class="list-title">{{ item.rsvDate || '-' }}</div>
                                                    <div class="list-sub">{{ item.rsvStartTime || '-' }} ~ {{
                                                        item.rsvEndTime || '-' }}</div>
                                                </div>
                                                <div class="list-sub">
                                                    상태 :
                                                    <span class="status-badge"
                                                        :class="getReserveStatusClass(item.rsvStatus || item.RSV_STATUS)">
                                                        {{ getReservationStatusText(item.rsvStatus || item.RSV_STATUS)
                                                        }}
                                                    </span>
                                                </div>


                                            </div>

                                            <div class="btn-box">
                                                <button @click="changeMenu('reserveList')">예약 내역 보기</button>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mini-panel">
                                        <div class="mini-panel-head">최근 주문 내역</div>
                                        <div class="mini-panel-body">
                                            <div v-if="groupedOrderList.length === 0" class="empty-text">주문 내역이 없습니다.
                                            </div>

                                            <div class="main-order-item" v-for="group in groupedOrderList.slice(0, 2)"
                                                :key="group.orderNo">
                                                <div style="display:flex; gap:10px; align-items:center;">
                                                    <img class="order-img" :src="group.items && group.items.length > 0 && group.items[0].productImg 
                                                     ? group.items[0].productImg 
                                                          : '/img/no-image.png'" alt="상품이미지">
                                                    <div>
                                                        <div class="list-title">{{ group.orderDate || '-' }}</div>
                                                        <div class="list-sub">
                                                            {{ group.items[0]?.productName || '-' }}
                                                            <span v-if="group.items.length > 1">
                                                                외 {{ group.items.length - 1 }}건
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="status-badge"
                                                    :class="getDeliStatusClass(group.items[0]?.deliStatus || group.items[0]?.DELI_STATUS)">
                                                    {{ getDeliStatusText(group.items[0]?.deliStatus ||
                                                    group.items[0]?.DELI_STATUS) }}
                                                </div>
                                            </div>

                                            <div class="btn-box">
                                                <button @click="changeMenu('orderList')">주문 내역 보기</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="mini-action-grid">
                                    <div class="mini-action-card">
                                        <div class="section-title" style="margin-bottom:8px;">구독 관리</div>
                                        <div class="list-sub">현재 상태 : {{ subscriptionInfo.planName || '미구독' }}</div>
                                        <div class="list-sub">다음 결제일 : {{ subscriptionInfo.nextBillingDate || '-' }}
                                        </div>
                                        <div class="btn-box">
                                            <button class="small-btn" @click="changeMenu('subscriptionPage')">구독
                                                관리</button>
                                        </div>
                                    </div>

                                    <div class="mini-action-card">
                                        <div class="section-title" style="margin-bottom:8px;">커뮤니티 활동</div>
                                        <div class="list-sub">내 게시글 : {{ myPostList.length }}건</div>
                                        <div class="list-sub">내 댓글 : {{ myCommentList.length }}건</div>
                                        <div class="btn-box">
                                            <button class="small-btn" @click="changeMenu('communityPage')">내
                                                게시글</button>
                                            <button class="small-btn" @click="changeMenu('communityPage')">내 댓글</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="dash-right">
                                <div class="section-box">
                                    <div class="section-title">구독 이용 현황</div>
                                    <div class="subscription-box">
                                        <div class="sub-title">{{ subscriptionInfo.planName || '구독 정보 없음' }}</div>
                                        <div class="sub-date">다음 결제일: {{ subscriptionInfo.nextBillingDate || '-' }}
                                        </div>
                                        <div class="sub-state">상태: {{ subscriptionInfo.status || '미구독' }}</div>
                                        <button class="sub-btn" @click="changeMenu('subscriptionPage')">구독 관리</button>
                                    </div>
                                </div>

                                <div class="section-box">
                                    <div class="section-title">커뮤니티 정보</div>

                                    <div class="info-card">
                                        <div class="list-title">내 게시글</div>
                                        <div class="list-sub">총 {{ myPostList.length }}건</div>
                                        <div v-if="myPostList.length === 0" class="empty-text">작성한 게시글이 없습니다.</div>
                                        <div v-for="item in recentPostList.slice(0, 2)" :key="'post-' + item.id"
                                            class="list-item">
                                            <div class="list-title">{{ item.title }}</div>
                                            <div class="list-sub">{{ item.cdate }}</div>
                                        </div>
                                    </div>

                                    <div class="info-card">
                                        <div class="list-title">내 댓글</div>
                                        <div class="list-sub">총 {{ myCommentList.length }}건</div>
                                        <div v-if="myCommentList.length === 0" class="empty-text">작성한 댓글이 없습니다.</div>
                                        <div v-for="item in myCommentList.slice(0, 2)" :key="'comment-' + item.id"
                                            class="list-item">
                                            <div class="list-title">{{ item.content }}</div>
                                            <div class="list-sub">{{ item.cdate }}</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="section-box">
                                    <div class="section-title">빠른 이동</div>
                                    <div class="btn-box">
                                        <button @click="changeMenu('subscriptionPage')">구독 관리</button>
                                        <button @click="changeMenu('communityPage')">커뮤니티</button>
                                        <button @click="changeMenu('petEdit')">반려동물 관리</button>
                                        <button @click="changeMenu('petHealthPage')">건강기록</button>
                                        <button @click="changeMenu('petVacPage')">접종기록</button>
                                        <button @click="changeMenu('petWeightPage')">몸무게 관리</button>
                                    </div>
                                </div>

                                <div class="section-box">
                                    <div class="section-title">오늘의 요약</div>
                                    <div class="info-card">
                                        <div class="list-title">반려동물 수</div>
                                        <div class="list-sub">{{ petList.length }}마리</div>
                                    </div>
                                    <div class="info-card">
                                        <div class="list-title">최근 예약</div>
                                        <div class="list-sub">{{ reservationList.length }}건</div>
                                    </div>
                                    <div class="info-card">
                                        <div class="list-title">최근 주문</div>
                                        <div class="list-sub">{{ groupedOrderList.length }}건</div>
                                    </div>
                                    <div class="info-card">
                                        <div class="list-title">현재 포인트</div>
                                        <div class="list-sub">{{ Number(point || 0).toLocaleString() }} P</div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div v-if="currentMenu === 'subscriptionPage'">
                        <div class="section-box">
                            <div class="section-title">구독 관리</div>

                            <div class="info-card">
                                <div class="list-title">{{ subscriptionInfo.planName || '구독 정보 없음' }}</div>
                                <div class="list-sub">상태 : {{ subscriptionInfo.status || '-' }}</div>
                                <div class="list-sub">다음 결제일 : {{ subscriptionInfo.nextBillingDate || '-' }}</div>
                            </div>

                            <div class="grid-2">
                                <div class="info-card">
                                    <div class="list-title">자동결제 여부</div>
                                    <div class="list-sub">{{ subscriptionInfo.isAuto || '-' }}</div>
                                </div>
                                <div class="info-card">
                                    <div class="list-title">구독 금액</div>
                                    <div class="list-sub">{{ subscriptionInfo.subPrice ?
                                        Number(subscriptionInfo.subPrice).toLocaleString() + '원' : '-' }}</div>
                                </div>
                            </div>

                            <div class="btn-box">
                                <button class="small-btn btn-red" v-if="subscriptionInfo.status === '이용중'"
                                    @click="cancelSubscription">구독 해지</button>
                            </div>
                        </div>
                    </div>

                    <div v-if="currentMenu === 'communityPage'">
                        <div class="section-box">
                            <div class="section-header">
                                <div class="section-title" style="margin-bottom:0;">최근 내 게시글</div>
                                <button class="small-btn" @click="goCommunityPostList">전체 게시글 보기</button>
                            </div>

                            <div v-if="recentPostList.length === 0" class="empty-text">작성한 게시글이 없습니다.</div>

                            <div class="list-item" v-for="item in recentPostList" :key="'post-page-' + item.id">
                                <div class="list-title">{{ item.title }}</div>
                                <div class="list-sub">{{ item.cdate }}</div>
                            </div>
                        </div>

                        <div class="section-box">
                            <div class="section-title">내 댓글</div>

                            <div v-if="myCommentList.length === 0" class="empty-text">작성한 댓글이 없습니다.</div>

                            <div class="list-item" v-for="item in myCommentList" :key="'comment-page-' + item.id">
                                <div class="list-title">{{ item.content }}</div>
                                <div class="list-sub">{{ item.cdate }}</div>
                            </div>
                        </div>
                    </div>

                    <div v-if="currentMenu === 'communityPostList'">
                        <div class="section-box">
                            <div class="section-header">
                                <div class="section-title" style="margin-bottom:0;">내 전체 게시글</div>
                                <button class="small-btn" @click="changeMenu('communityPage')">커뮤니티로</button>
                            </div>

                            <div v-if="myPostList.length === 0" class="empty-text">작성한 게시글이 없습니다.</div>

                            <div class="list-item" v-for="item in myPostList" :key="'post-all-' + item.id">
                                <div class="list-title">{{ item.title }}</div>
                                <div class="list-sub">{{ item.cdate }}</div>
                            </div>
                        </div>
                    </div>
                    <div v-if="currentMenu === 'orderList'">
                        <div class="section-box">
                            <div class="section-title">쇼핑몰 주문 내역</div>
                            <!-- 정렬 선택 -->
                            <select v-model="orderSortType">
                                <option value="latest">최신순</option>
                                <option value="old">오래된순</option>
                                <option value="amountHigh">금액 높은순</option>
                                <option value="amountLow">금액 낮은순</option>
                                <option value="payStatus">결제상태순</option>
                                <option value="deliStatus">배송상태순</option>

                            </select>

                            <div v-if="groupedOrderList.length === 0" class="empty-text">
                                주문 내역이 없습니다.
                            </div>

                            <!-- 🔥 주문 리스트 -->
                            <div class="info-card" v-for="group in pagedOrderList" :key="group.orderNo"
                                style="margin-bottom:16px;">

                                <div
                                    style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
                                    <div class="list-title">
                                        주문일자 : {{ (group.orderDate || '').substring(0,16) }}
                                    </div>

                                    <button class="small-btn" @click="openOrderDetail(group)">
                                        상세보기
                                    </button>
                                </div>

                                <!-- 상품 리스트 -->
                                <div v-for="order in group.items"
                                    :key="order.orderDetailNo || order.orderNo + '-' + order.productNo"
                                    class="order-item">

                                    <img class="order-img" :src="order.productImg || '/img/no-image.png'">

                                    <div style="flex:1;">
                                        <div class="list-title">{{ order.productName || '-' }}</div>
                                        <div class="list-sub">수량 : {{ order.qty }}개</div>
                                        <div class="list-sub">금액 : {{ Number(order.price || 0).toLocaleString() }}원
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <!-- 🔥 페이징 (여기 위치 중요) -->
                            <div class="btn-box" v-if="orderTotalPage > 1">
                                <button class="small-btn" :disabled="orderPage === 1" @click="orderPage--">이전</button>
                                <span>{{ orderPage }} / {{ orderTotalPage }}</span>
                                <button class="small-btn" :disabled="orderPage === orderTotalPage"
                                    @click="orderPage++">다음</button>
                            </div>

                        </div>
                    </div>


                    <div v-if="currentMenu === 'orderDetail'">
                        <div class="section-box">
                            <div class="section-header">
                                <div class="section-title" style="margin-bottom:0;">주문 상세</div>
                                <button class="small-btn" @click="goOrderList()">주문목록으로</button>
                            </div>

                            <div class="info-card" style="margin-bottom:18px;">
                                <div class="list-sub">주문일자 : {{ selectedOrderGroup.orderDate }}</div>
                                <div class="list-sub">총 상품 수 : {{ selectedOrderGroup.items.length }}건</div>
                                <div class="btn-box">
                                    <button class="small-btn btn-red" v-if="canRefundOrderGroup(selectedOrderGroup)"
                                        @click="goRefundShopGroup(selectedOrderGroup)">
                                        주문 환불
                                    </button>
                                </div>
                            </div>


                            <div v-if="selectedOrderGroup.items.length === 0" class="empty-text">
                                주문 상세 내역이 없습니다.
                            </div>

                            <div class="info-card" v-for="order in selectedOrderGroup.items"
                                :key="'detail-' + (order.orderDetailNo || order.orderNo + '-' + order.productNo)">

                                <div class="order-item">
                                    <img class="order-img" :src="order.productImg || '/img/no-image.png'" alt="상품이미지">

                                    <div style="flex:1;">
                                        <div class="list-title">{{ order.productName || '-' }}</div>

                                        <div class="list-sub">수량 : {{ order.qty }}개</div>
                                        <div class="list-sub">금액 : {{ Number(order.price || 0).toLocaleString() }}원
                                        </div>

                                        <div class="list-status">
                                            결제상태 : {{ getPayStatusText(order.payStatus || order.PAY_STATUS) }}
                                        </div>

                                        <div class="list-status">
                                            배송상태 : {{ getDeliStatusText(order.deliStatus || order.DELI_STATUS) }}
                                        </div>


                                        <div class="btn-box">
                                            <button class="small-btn" v-if="canWriteReview(order)"
                                                @click="goReview(order)">
                                                상품리뷰 작성
                                            </button>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div v-if="currentMenu === 'reserveList'">
                        <div class="section-box">
                            <div class="section-title">예약 내역</div>
                            <!-- 정렬 선택 -->
                            <select v-model="rsvSortType">
                                <option value="latest">최신순</option>
                                <option value="old">오래된순</option>
                                <option value="timeAsc">시간 빠른순</option>
                                <option value="timeDesc">시간 늦은순</option>
                                <option value="status">예약상태순</option>
                            </select>

                            <div v-if="reservationAllList.length === 0" class="empty-text">
                                예약 내역이 없습니다.
                            </div>
                            <!-- 🔥 그룹 반복 -->
                            <div v-for="group in pagedReservationList" :key="group.date" style="margin-bottom:20px;">

                                <!-- 날짜 -->
                                <div class="section-title" style="font-size:17px; margin-bottom:10px;">
                                    {{ formatDate(group.date) }}
                                </div>

                                <!-- 예약 리스트 -->
                                <div class="info-card" v-for="item in group.items" :key="'all-' + item.rsvNo">

                                    <div style="display:flex; justify-content:space-between; gap:12px;">
                                        <div style="flex:1;">
                                            <div class="list-title">
                                                {{ item.rsvStartTime }} ~ {{ item.rsvEndTime }}
                                            </div>

                                            <div class="list-sub">예약처 : {{ item.storeName }}</div>
                                            <div class="list-sub">반려동물 : {{ item.petName }}</div>

                                            <div class="list-sub">
                                                상태 :
                                                <span class="status-badge"
                                                    :class="getReserveStatusClass(item.rsvStatus)">
                                                    {{ getReservationStatusText(item.rsvStatus) }}
                                                </span>
                                            </div>
                                        </div>

                                        <div class="btn-box">
                                            <button class="small-btn btn-red" v-if="canRefundRsv(item)"
                                                @click="goRefundRsv(item)">
                                                예약환불
                                            </button>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <!-- 🔥 페이징 -->
                            <div class="btn-box" v-if="rsvTotalPage > 1">
                                <button class="small-btn" :disabled="rsvPage === 1" @click="rsvPage--">이전</button>
                                <span>{{ rsvPage }} / {{ rsvTotalPage }}</span>
                                <button class="small-btn" :disabled="rsvPage === rsvTotalPage"
                                    @click="rsvPage++">다음</button>
                            </div>

                        </div>
                    </div>







                    <div v-if="currentMenu === 'petEdit'">
                        <div class="section-box">
                            <div class="section-header">
                                <div class="section-title" style="margin-bottom:0;">반려동물 프로필 관리</div>
                                <button class="small-btn" @click="openAddPetModal">프로필 추가</button>
                            </div>

                            <div class="pet-list">
                                <div class="pet-card" v-for="pet in petList" :key="'edit-' + pet.petNo">
                                    <div class="pet-thumb">
                                        <div class="pet-avatar">{{ getPetInitial(pet.petName) }}</div>
                                    </div>
                                    <div class="pet-body">
                                        <div class="pet-name">{{ pet.petName }}</div>
                                        <div class="pet-info">{{ pet.species || '' }}{{ pet.birthdate ? ' · ' +
                                            getPetAge(pet.birthdate) + '살' : '' }}</div>
                                        <div class="pet-btns">
                                            <button class="pet-btn edit" @click="openEditPetModal(pet)">수정</button>
                                            <button class="pet-btn delete" @click="deletePet(pet.petNo)">삭제</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>



                    <div v-if="currentMenu === 'petMyPage'">
                        <div class="section-box">
                            <div class="section-box">
                                <div class="section-title">반려동물 선택</div>

                                <div class="pet-list">
                                    <div class="pet-card" v-for="pet in petList" :key="'mypage-select-' + pet.petNo"
                                        :class="{ active: String(selectedPetNo) === String(pet.petNo) }"
                                        @click="selectPet(pet)">

                                        <div class="pet-thumb">
                                            <div class="pet-avatar">{{ getPetInitial(pet.petName) }}</div>
                                        </div>

                                        <div class="pet-body">
                                            <div class="pet-name">{{ pet.petName }}</div>
                                            <div class="pet-info">
                                                {{ pet.species || '' }}
                                                {{ pet.birthdate ? ' · ' + getPetAge(pet.birthdate) + '살' : '' }}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="section-title">건강 기록 조회</div>
                            <div v-if="healthList.length === 0" class="empty-text">건강 기록이 없습니다.</div>
                            <div class="info-card" v-for="item in healthList" :key="'h-' + item.id">
                                <div class="list-title">{{ item.title }}</div>
                                <div class="list-sub">기록일 : {{ formatDate(item.date) }}</div>
                                <div class="list-sub">내용 : {{ item.memo }}</div>
                            </div>
                        </div>

                        <div class="section-box">
                            <div class="section-title">접종 기록 조회</div>
                            <div v-if="vacList.length === 0" class="empty-text">접종 기록이 없습니다.</div>
                            <div class="info-card" v-for="item in vacList" :key="'v-' + item.id">
                                <div class="list-title">{{ item.name }}</div>

                                <div class="list-sub">반려동물 : {{ item.petName }}</div>
                                <div class="list-sub">접종일 : {{ formatDate(item.date) }}</div>
                                <div class="list-sub">다음 접종일 : {{ item.nextDate ? formatDate(item.nextDate) : '-' }}
                                </div>
                                <div class="list-sub">병원명 : {{ item.hospitalName || '-' }}</div>
                                <div class="list-sub">비고 : {{ item.memo || '-' }}</div>
                            </div>
                        </div>

                        <div class="section-box">
                            <div class="section-title">몸무게 기록 조회</div>
                            <div v-if="weightList.length === 0" class="empty-text">몸무게 기록이 없습니다.</div>
                            <div class="info-card" v-for="item in weightList" :key="'w-main-' + item.id">
                                <div class="list-title">{{ item.weight }} kg</div>

                                <div class="list-sub">반려동물 : {{ item.petName || '-' }}</div>
                                <div class="list-sub">기록일 : {{ formatDate(item.date) }}</div>
                            </div>
                        </div>
                    </div>
                    <div v-if="currentMenu === 'petHealthPage'">

                        <div class="section-box">
                            <div class="section-title">반려동물 선택</div>

                            <div class="pet-list">
                                <div class="pet-card" v-for="pet in petList" :key="'health-select-' + pet.petNo"
                                    :class="{ active: String(selectedPetNo) === String(pet.petNo) }"
                                    @click="selectPet(pet)">

                                    <div class="pet-thumb">
                                        <div class="pet-avatar">{{ getPetInitial(pet.petName) }}</div>
                                    </div>

                                    <div class="pet-body">
                                        <div class="pet-name">{{ pet.petName || '-' }}</div>
                                        <div class="pet-info">
                                            {{ pet.species || '' }}
                                            {{ pet.birthdate ? ' · ' + getPetAge(pet.birthdate) + '살' : '' }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="section-box">
                            <div class="section-title">건강 기록 등록</div>
                            <div class="row">
                                <label>제목</label>
                                <input type="text" v-model="healthForm.title">
                            </div>
                            <div class="row">
                                <label>기록일</label>
                                <input type="date" v-model="healthForm.date">
                            </div>
                            <div class="row">
                                <label>내용</label>
                                <textarea v-model="healthForm.memo"></textarea>
                            </div>
                            <div class="btn-box">
                                <button @click="saveHealthRecord">등록</button>
                            </div>
                        </div>
                        <div class="section-box">
                            <div class="section-title">건강 기록 목록</div>

                            <div v-if="healthList.length === 0" class="empty-text">
                                건강 기록이 없습니다.
                            </div>

                            <div class="info-card" v-for="item in healthList" :key="'health-' + item.id">
                                <div class="list-title">{{ item.title }}</div>
                                <div class="list-sub">반려동물 : {{ item.petName }}</div>
                                <div class="list-sub">기록일 : {{ formatDate(item.date) }}</div>
                                <div class="list-sub">내용 : {{ item.memo }}</div>
                            </div>
                        </div>
                    </div>


                    <div v-if="currentMenu === 'petVacPage'">

                        <!-- 반려동물 선택 -->
                        <div class="section-box">
                            <div class="section-title">반려동물 선택</div>

                            <div class="pet-list">
                                <div class="pet-card" v-for="pet in petList" :key="'vac-select-' + pet.petNo"
                                    :class="{ active: String(selectedPetNo) === String(pet.petNo) }"
                                    @click="selectPet(pet)">

                                    <div class="pet-thumb">
                                        <div class="pet-avatar">{{ getPetInitial(pet.petName) }}</div>
                                    </div>

                                    <div class="pet-body">
                                        <div class="pet-name">{{ pet.petName || '-' }}</div>
                                        <div class="pet-info">
                                            {{ pet.species || '' }}
                                            {{ pet.birthdate ? ' · ' + getPetAge(pet.birthdate) + '살' : '' }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 접종 기록 등록 -->
                        <div class="section-box">
                            <div class="section-title">접종 기록 등록</div>

                            <div class="row">
                                <label>백신명</label>
                                <input type="text" v-model="vacForm.name">
                            </div>

                            <div class="row">
                                <label>접종일</label>
                                <input type="date" v-model="vacForm.date">
                            </div>

                            <div class="row">
                                <label>다음 접종일</label>
                                <input type="date" v-model="vacForm.nextDate">
                            </div>

                            <div class="row">
                                <label>병원명</label>
                                <input type="text" v-model="vacForm.hospitalName">
                            </div>

                            <div class="row">
                                <label>비고</label>
                                <textarea v-model="vacForm.memo"></textarea>
                            </div>

                            <div class="btn-box">
                                <button @click="saveVacRecord">등록</button>
                            </div>
                        </div>

                        <!-- 접종 기록 목록 -->
                        <div class="section-box">
                            <div class="section-title">접종 기록 목록</div>

                            <div v-if="vacList.length === 0" class="empty-text">
                                접종 기록이 없습니다.
                            </div>

                            <div class="info-card" v-for="item in vacList" :key="'vac-' + item.id">
                                <div class="list-title">{{ item.name }}</div>

                                <div class="list-sub">반려동물 : {{ item.petName || '-' }}</div>
                                <div class="list-sub">접종일 : {{formatDate(item.date) }}</div>
                                <div class="list-sub">다음 접종일 :{{ item.nextDate ? formatDate(item.nextDate) : '-' }}
                                </div>
                                <div class="list-sub">병원명 : {{ item.hospitalName || '-' }}</div>
                                <div class="list-sub">비고 : {{ item.memo || '-' }}</div>

                                <div class="btn-box">
                                    <button class="btn-red" @click="deleteVaccine(item.id)">삭제</button>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div v-if="currentMenu === 'petWeightPage'">

                        <!-- ✅ 반려동물 선택 -->
                        <div class="section-box">
                            <div class="section-title">반려동물 선택</div>

                            <div class="pet-list">
                                <div class="pet-card" v-for="pet in petList" :key="'weight-select-' + pet.petNo"
                                    :class="{ active: String(selectedPetNo) === String(pet.petNo) }"
                                    @click="selectPet(pet)">

                                    <div class="pet-thumb">
                                        <div class="pet-avatar">{{ getPetInitial(pet.petName) }}</div>
                                    </div>

                                    <div class="pet-body">
                                        <div class="pet-name">{{ pet.petName || '-' }}</div>
                                        <div class="pet-info">
                                            {{ pet.species || '' }}
                                            {{ pet.birthdate ? ' · ' + getPetAge(pet.birthdate) + '살' : '' }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ✅ 몸무게 등록 -->
                        <div class="section-box">
                            <div class="section-title">몸무게 등록</div>

                            <div class="row">
                                <label>몸무게(kg)</label>
                                <input type="text" v-model="weightForm.weight">
                            </div>

                            <div class="row">
                                <label>기록일</label>
                                <input type="date" v-model="weightForm.date">
                            </div>

                            <div class="row">
                                <label>비고</label>
                                <textarea v-model="weightForm.memo"></textarea>
                            </div>

                            <div class="btn-box">
                                <button @click="saveWeightRecord">등록</button>
                            </div>
                        </div>

                        <!-- ✅ 차트 -->
                        <div class="section-box">
                            <div class="section-title">몸무게 변화 차트</div>
                            <div class="chart-wrap">
                                <canvas id="weightChart"></canvas>
                            </div>
                        </div>

                        <!-- ✅ 목록 -->
                        <div class="section-box">
                            <div class="section-title">몸무게 기록 목록</div>

                            <div v-if="weightList.length === 0" class="empty-text">
                                몸무게 기록이 없습니다.
                            </div>

                            <div class="info-card" v-for="item in weightList" :key="'w-' + item.id">
                                <div class="list-title">{{ item.weight }} kg</div>

                                <div class="list-sub">반려동물 : {{ item.petName || '-' }}</div>
                                <div class="list-sub">기록일 : {{ formatDate(item.date) }}</div>
                                <div class="list-sub">비고 : {{ item.memo || '-' }}</div>
                            </div>
                        </div>

                    </div>






                    <div v-if="currentMenu === 'couponInfo'">
                        <div class="section-box">
                            <div class="section-title">쿠폰 관리</div>

                            <div class="coupon-tabs">
                                <button class="small-btn" :class="{active: couponTab === 'ALL'}"
                                    @click="couponTab='ALL'">전체</button>
                                <button class="small-btn" :class="{active: couponTab === 'ABLE'}"
                                    @click="couponTab='ABLE'">사용가능</button>
                                <button class="small-btn" :class="{active: couponTab === 'USED'}"
                                    @click="couponTab='USED'">사용완료</button>
                                <button class="small-btn" :class="{active: couponTab === 'EXPIRED'}"
                                    @click="couponTab='EXPIRED'">만료</button>
                            </div>

                            <div v-if="filteredCouponList.length === 0" class="empty-text">
                                쿠폰이 없습니다.
                            </div>

                            <div class="info-card" v-for="coupon in filteredCouponList"
                                :key="coupon.couponNo || coupon.COUPON_NO">
                                <div style="display:flex; justify-content:space-between; align-items:center; gap:12px;">
                                    <div>
                                        <div class="list-title">
                                            {{ coupon.couponName || coupon.COUPON_NAME || '-' }}
                                        </div>

                                        <div class="list-sub">
                                            할인금액 :
                                            {{ Number(coupon.discountAmt || coupon.DISCOUNT_AMT ||
                                            0).toLocaleString()
                                            }}원
                                        </div>

                                        <div class="list-sub">
                                            유효기간 :
                                            {{ coupon.startDate || coupon.START_DATE || '-' }}
                                            ~
                                            {{ coupon.endDate || coupon.END_DATE || '-' }}
                                        </div>
                                    </div>

                                    <span class="status-badge" :class="getCouponStatusClass(coupon)">
                                        {{ getCouponStatusText(coupon) }}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div v-if="currentMenu === 'pointInfo'">
                        <div class="section-box">
                            <div class="section-title">포인트 관리</div>

                            <div class="info-card">
                                <div class="list-title">현재 보유 포인트</div>
                                <div class="list-sub" style="font-size:20px; font-weight:bold;">
                                    {{ Number(point || 0).toLocaleString() }} P
                                </div>
                            </div>

                            <div class="btn-box">
                                <button class="small-btn" @click="loadPointUseList">사용내역 조회</button>
                            </div>
                        </div>

                        <div class="section-box" v-if="showPointUseList">
                            <div class="section-title">포인트 사용내역</div>

                            <div v-if="pointUseList.length === 0" class="empty-text">
                                사용내역이 없습니다.
                            </div>

                            <div class="info-card" v-for="item in pointUseList" :key="item.pointNo || item.POINT_NO">
                                <div class="list-title">
                                    {{ Number(item.pointAmount || item.POINT_AMOUNT || 0).toLocaleString() }} P
                                </div>
                                <div class="list-sub">주문번호 : {{ item.ordNo || item.ORD_NO || '-' }}</div>
                                <div class="list-sub">날짜 : {{ item.cdate || item.CDATE || '-' }}</div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <div class="modal-wrap" v-if="showPetModal">
                <div class="modal-box">
                    <div class="modal-title">{{ petForm.petNo ? '반려동물 프로필 수정' : '반려동물 프로필 추가' }}</div>

                    <div class="row"><label>이름</label><input type="text" v-model="petForm.petName"></div>
                    <div class="row"><label>종</label><input type="text" v-model="petForm.species"></div>
                    <div class="row"><label>품종</label><input type="text" v-model="petForm.breed"></div>
                    <div class="row"><label>생년월일</label><input type="date" v-model="petForm.birthdate"></div>
                    <div class="row">
                        <label>성별</label>
                        <select v-model="petForm.gender">
                            <option value="">선택해주세요</option>
                            <option value="M">수컷</option>
                            <option value="F">암컷</option>
                        </select>
                    </div>

                    <div class="modal-btns">
                        <button type="button" class="btn-cancel" @click="closePetModal">취소</button>
                        <button type="button" class="btn-save" @click="savePet">저장</button>
                    </div>
                </div>
            </div>

            <div class="modal-wrap" v-if="showPwdModal">
                <div class="modal-box">
                    <div class="modal-title">비밀번호 변경</div>

                    <div class="row"><label>현재 비밀번호</label><input type="password" v-model="pwdForm.pwd"></div>
                    <div class="row"><label>새 비밀번호</label><input type="password" v-model="pwdForm.newPwd"></div>

                    <div class="modal-btns">
                        <button type="button" class="btn-cancel" @click="closePwdModal">취소</button>
                        <button type="button" class="btn-save" @click="changePassword">변경</button>
                    </div>
                </div>
            </div>
        </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        currentMenu: "userMyPage",
                        openUserEditPanel: false,

                        user: {
                            userName: "",
                            nickname: "",
                            email: "",
                            phone: "",
                            zipcode: "",
                            userAddr: "",
                            fullAddr: ""
                        },

                        petList: [],
                        reservationList: [],
                        reservationAllList: [],
                        orderList: [],
                        healthList: [],
                        vacList: [],
                        weightList: [],

                        subscriptionInfo: {
                            planName: "",
                            nextBillingDate: "",
                            status: "",
                            isAuto: "",
                            subPrice: ""
                        },

                        myPostList: [],
                        myCommentList: [],

                        selectedPetNo: "",
                        showPetModal: false,
                        showPwdModal: false,
                        weightChart: null,

                        selectedOrderGroup: {
                            orderNo: "",
                            orderDate: "",
                            items: []
                        },

                        selectedReservation: {},

                        petForm: {
                            petNo: "",
                            petName: "",
                            species: "",
                            breed: "",
                            birthdate: "",
                            gender: ""
                        },

                        pwdForm: {
                            pwd: "",
                            newPwd: ""
                        },

                        healthForm: {
                            title: "",
                            date: "",
                            memo: ""
                        },

                        vacForm: {
                            name: "",
                            date: "",
                            nextDate: "",
                            hospitalName: "",
                            memo: ""
                        },

                        weightForm: {
                            weight: "",
                            date: "",
                            memo: ""
                        },

                        point: 0,
                        pointUseList: [],
                        showPointUseList: false,

                        couponTab: "ALL",
                        couponList: [],
                        couponList: [],

                        // 주문 페이징
                        orderPage: 1,
                        orderPageSize: 10,

                        // 예약 페이징
                        rsvPage: 1,
                        rsvPageSize: 10,

                        //  주문 정렬 기준 (latest: 최신순 / old: 오래된순)
                        orderSortType: "latest",

                        //  예약 정렬 기준
                        rsvSortType: "latest",


                    };
                },

                computed: {
                    pageTitle() {
                        const map = {
                            userMyPage: "마이 페이지",
                            subscriptionPage: "구독 관리",
                            communityPage: "커뮤니티 활동",
                            communityPostList: "내 전체 게시글",
                            orderList: "주문 내역",
                            orderDetail: "주문 상세",
                            reserveList: "예약 내역",
                            reservationDetail: "예약 상세",
                            petEdit: "반려동물 관리",
                            petMyPage: "건강 조회",
                            petHealthPage: "건강 기록",
                            petVacPage: "접종 기록",
                            petWeightPage: "몸무게 관리",
                            pointInfo: "포인트 관리"
                        };
                        return map[this.currentMenu] || "마이페이지";
                    },


                    pagedOrderList() {
                        const start = (this.orderPage - 1) * this.orderPageSize;
                        const end = start + this.orderPageSize;
                        return this.groupedOrderList.slice(start, end);
                    },

                    orderTotalPage() {
                        return Math.ceil(this.groupedOrderList.length / this.orderPageSize);
                    },
                    groupedOrderList() {
                        const grouped = {};

                        // 주문번호 기준으로 상품들을 묶음
                        this.orderList.forEach(order => {
                            const orderNo = order.orderNo || "주문번호없음";
                            if (!grouped[orderNo]) grouped[orderNo] = [];
                            grouped[orderNo].push(order);
                        });

                        // 주문건 배열로 변환
                        let result = Object.keys(grouped).map(orderNo => {
                            const items = grouped[orderNo];

                            return {
                                orderNo: orderNo,
                                orderDate: items[0]?.orderDate || "",
                                items: items,

                                // 주문건 총 금액 계산
                                totalAmount: items.reduce((sum, item) => {
                                    return sum + Number(item.price || 0);
                                }, 0),

                                // 대표 결제상태 / 배송상태
                                payStatus: items[0]?.payStatus || items[0]?.PAY_STATUS || "",
                                deliStatus: items[0]?.deliStatus || items[0]?.DELI_STATUS || ""
                            };
                        });

                        // 선택한 정렬 기준 적용
                        result.sort((a, b) => {
                            if (this.orderSortType === "latest") {
                                return String(b.orderDate).localeCompare(String(a.orderDate));
                            }

                            if (this.orderSortType === "old") {
                                return String(a.orderDate).localeCompare(String(b.orderDate));
                            }

                            if (this.orderSortType === "amountHigh") {
                                return b.totalAmount - a.totalAmount;
                            }

                            if (this.orderSortType === "amountLow") {
                                return a.totalAmount - b.totalAmount;
                            }

                            if (this.orderSortType === "payStatus") {
                                return String(a.payStatus).localeCompare(String(b.payStatus));
                            }

                            if (this.orderSortType === "deliStatus") {
                                return String(a.deliStatus).localeCompare(String(b.deliStatus));
                            }

                            return 0;
                        });

                        return result;
                    },
                    groupedReservationList() {
                        const grouped = {};

                        // 예약 날짜 기준으로 묶음
                        this.reservationAllList.forEach(item => {
                            const date = item.rsvDate || item.RSV_DATE || item.rsv_date || "날짜 없음";
                            if (!grouped[date]) grouped[date] = [];
                            grouped[date].push(item);
                        });

                        // 날짜 그룹 배열로 변환
                        let result = Object.keys(grouped).map(date => ({
                            date: date,
                            items: grouped[date].sort((a, b) => {
                                const aTime = a.rsvStartTime || a.RSV_START_TIME || "";
                                const bTime = b.rsvStartTime || b.RSV_START_TIME || "";

                                // 시간 빠른순
                                if (this.rsvSortType === "timeAsc") {
                                    return String(aTime).localeCompare(String(bTime));
                                }

                                // 시간 늦은순
                                if (this.rsvSortType === "timeDesc") {
                                    return String(bTime).localeCompare(String(aTime));
                                }

                                // 예약상태순
                                if (this.rsvSortType === "status") {
                                    const aStatus = a.rsvStatus || a.RSV_STATUS || "";
                                    const bStatus = b.rsvStatus || b.RSV_STATUS || "";
                                    return String(aStatus).localeCompare(String(bStatus));
                                }

                                // 기본은 시간 빠른순
                                return String(aTime).localeCompare(String(bTime));
                            })
                        }));

                        // 날짜 정렬
                        result.sort((a, b) => {
                            if (this.rsvSortType === "old") {
                                return String(a.date).localeCompare(String(b.date));
                            }

                            // 기본 최신순
                            return String(b.date).localeCompare(String(a.date));
                        });

                        return result;
                    },
                    pagedReservationList() {
                        const start = (this.rsvPage - 1) * this.rsvPageSize;
                        const end = start + this.rsvPageSize;
                        return this.groupedReservationList.slice(start, end);
                    },

                    rsvTotalPage() {
                        return Math.ceil(this.groupedReservationList.length / this.rsvPageSize);
                    },


                    recentPostList() {
                        return [...this.myPostList]
                            .sort((a, b) => String(b.cdate || "").localeCompare(String(a.cdate || "")))
                            .slice(0, 3);
                    },

                    filteredCouponList() {
                        if (this.couponTab === "ALL") {
                            return this.couponList;
                        }

                        return this.couponList.filter(coupon => {
                            return this.getCouponStatus(coupon) === this.couponTab;
                        });
                    }
                },

                methods: {

                    pageChange(url, param) {
                        window.pageChange(url, param);

                    },
                    selectPet(pet) {
                        if (!pet || !pet.petNo) {
                            alert("반려동물 정보를 찾을 수 없습니다.");
                            return;
                        }

                        this.selectedPetNo = String(pet.petNo);

                        this.healthList = [];
                        this.vacList = [];
                        this.weightList = [];

                        if (this.currentMenu === "petHealthPage") {
                            this.loadHealthList();
                        }

                        if (this.currentMenu === "petVacPage") {
                            this.loadVaccineList();
                        }

                        if (this.currentMenu === "petWeightPage") {
                            this.loadWeightList();
                        }

                        if (this.currentMenu === "petMyPage") {
                            this.loadHealthList();
                            this.loadVaccineList();
                            this.loadWeightList();
                        }
                    },





                    changeMenu(menu) {
                        this.currentMenu = menu;

                        if (menu === "subscriptionPage") this.loadSubscriptionInfo();
                        if (menu === "communityPage" || menu === "communityPostList") {
                            this.loadMyPostList();
                            this.loadMyCommentList();
                        }
                        if (menu === "reserveList") this.loadReservationAllList();
                        if (menu === "orderList") this.loadOrderList();
                        if (menu === "petWeightPage") this.loadWeightList();
                        if (menu === "petHealthPage" || menu === "petMyPage") this.loadHealthList();
                        if (menu === "petVacPage" || menu === "petMyPage") this.loadVaccineList();

                        if (menu === "pointInfo") {
                            this.loadPointInfo();
                            this.showPointUseList = false;
                            this.pointUseList = [];
                        }
                        if (menu === "couponInfo") {
                            this.loadCouponList();
                            this.couponTab = "ALL";
                        }
                    },

                    goCommunityPostList() {
                        this.currentMenu = "communityPostList";
                        this.loadMyPostList();
                    },

                    goOrderList() {
                        this.currentMenu = "orderList";
                    },
                    canRefundOrderGroup(group) {
                        if (!group || !group.items || group.items.length === 0) return false;

                        return group.items.some(order => {
                            const deliStatus = String(order.deliStatus || order.DELI_STATUS || "").trim().toUpperCase();
                            const payStatus = String(order.payStatus || order.PAY_STATUS || "").trim().toUpperCase();

                            if (deliStatus === "CAN" || deliStatus === "CANCEL" || deliStatus === "CMP") {
                                return false;
                            }

                            if (payStatus === "CAN" || payStatus === "CANCEL" || payStatus === "FAL") {
                                return false;
                            }

                            return true;
                        });
                    },
                    goRefundShopGroup(group) {
                        if (!group || !group.orderNo) {
                            alert("환불에 필요한 주문 정보가 없습니다.");
                            return;
                        }

                        window.pageChange('/payment/refund-shop.do', {
                            orderNo: group.orderNo
                        });
                    },
                    canRefundRsv(item) {
                        if (!item) return false;

                        const status = String(item.rsvStatus || item.RSV_STATUS || "")
                            .trim()
                            .toUpperCase();

                        // 확정 예약만 환불 버튼 표시
                        return status === "CNF";
                    },

                    goRefundRsv(item) {
                        if (!item || !(item.rsvNo || item.RSV_NO)) {
                            alert("예약 정보가 없습니다.");
                            return;
                        }

                        window.pageChange('/payment/refund-rsv.do', {
                            rsvNo: item.rsvNo || item.RSV_NO
                        });
                    },



                    goReview(order) {
                        if (!order) return;

                        const productNo = order.productNo;
                        const orderNo = order.orderNo;

                        if (!productNo || !orderNo) {
                            console.log("리뷰 이동 데이터 오류", order);
                            alert("리뷰 작성에 필요한 주문 정보가 없습니다.");
                            return;
                        }

                        window.pageChange('/user/mypage/prd-review.do', {
                            productNo: order.productNo,
                            ordNo: order.orderNo   // ← 여기 유지 (DB는 orderNo지만 프론트는 ordNo로)
                        });
                    },


                    openOrderDetail(group) {
                        this.selectedOrderGroup = {
                            orderNo: group.orderNo,
                            orderDate: group.orderDate,
                            items: group.items
                        };
                        this.currentMenu = "orderDetail";
                    },
                    getPayStatusText(status) {
                        if (!status) return "-";
                        status = String(status).trim().toUpperCase();
                        switch (status) {
                            case "RDY": return "준비";
                            case "PAY": return "결제";
                            case "CANCEL": return "취소";
                            case "FAL": return "실패";
                            default: return status;
                        }
                    },

                    getPayStatusClass(status) {
                        if (!status) return "status-gray";

                        switch (status) {
                            case "RDY": return "status-orange";
                            case "PAY": return "status-blue";
                            case "CAN": return "status-red";
                            case "FAL": return "status-red";
                            default: return "status-gray";
                        }
                    },

                    getDeliStatusText(status) {
                        if (!status) return "-";

                        switch (status) {
                            case "RDY": return "배송준비";
                            case "SHP": return "배송중";
                            case "CMP": return "배송완료";
                            case "CAN": return "배송취소";
                            default: return status;
                        }
                    },

                    getDeliStatusClass(status) {
                        if (!status) return "status-gray";

                        switch (status) {
                            case "RDY": return "status-orange";
                            case "SHP": return "status-blue";
                            case "CMP": return "status-green";
                            default: return "status-gray";
                        }
                    },
                    canWriteReview(order) {
                        if (!order) return false;

                        const deliStatus = String(order.deliStatus || order.DELI_STATUS || "")
                            .trim()
                            .toUpperCase();

                        const reviewYn = String(order.reviewYn || order.REVIEW_YN || "N")
                            .trim()
                            .toUpperCase();

                        return deliStatus === "CMP" && reviewYn !== "Y";
                    },


                    openReservationDetail(item) {
                        this.selectedReservation = item;
                        this.currentMenu = "reservationDetail";
                    },
                    getReservationStatusText(status) {
                        if (!status) return "-";
                        status = String(status).trim().toUpperCase();

                        if (status === "CNF") return "확정";
                        if (status === "FIN") return "완료";
                        if (status === "CAN") return "취소";
                        if (status === "WAI") return "대기";

                        return status;
                    },




                    formatDate(dateStr) {
                        if (!dateStr || dateStr === "날짜 없음") return "-";

                        if (typeof dateStr === "string" && dateStr.length >= 10) {
                            return dateStr.substring(0, 10);
                        }

                        const date = new Date(dateStr);

                        if (isNaN(date.getTime())) return "-";

                        const year = date.getFullYear();
                        const month = ("0" + (date.getMonth() + 1)).slice(-2);
                        const day = ("0" + date.getDate()).slice(-2);

                        return `${year}-${month}-${day}`;
                    },

                    cancelSubscription() {
                        const self = this;
                        if (!confirm("정말 구독을 해지하시겠습니까?")) return;

                        $.ajax({
                            url: "/user/cancel-subscription.dox",
                            type: "POST",
                            success: function (data) {
                                alert(data.message || (data.result === "success" ? "구독이 해지되었습니다." : "구독 해지에 실패했습니다."));
                                if (data.result === "success") self.loadSubscriptionInfo();
                            },
                            error: function () {
                                alert("구독 해지 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    getOrderStatusClass(status) {
                        if (!status) return "status-gray";
                        if (status.includes("완료")) return "status-green";
                        if (status.includes("배송")) return "status-blue";
                        if (status.includes("대기")) return "status-orange";
                        return "status-gray";
                    },


                    getReserveStatusClass(status) {
                        if (!status) return "status-orange";

                        status = String(status).trim().toUpperCase(); // 🔥 핵심

                        if (status === "WAI") return "status-orange";
                        if (status === "CNF") return "status-blue";
                        if (status === "FIN") return "status-green";
                        if (status === "CAN") return "status-red";

                        return "status-gray";
                    },


                    loadMypage() {
                        const self = this;
                        $.ajax({
                            url: "/user/mypage.dox",
                            type: "POST",
                            success: function (data) {
                                if (data.result === "loginRequired") {
                                    alert("로그인 후 이용해주세요.");

                                    setTimeout(() => {
                                        window.pageChange("/user/login.do");
                                    }, 200);

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

                    loadSubscriptionInfo() {
                        const self = this;
                        $.ajax({
                            url: "/user/subscription-info.dox",
                            type: "POST",
                            success: function (data) {
                                if (data.result === "success" && data.subscriptionInfo) {
                                    self.subscriptionInfo = data.subscriptionInfo;
                                } else {
                                    self.subscriptionInfo = {};
                                }
                            },
                            error: function () {
                                self.subscriptionInfo = {};
                            }
                        });
                    },

                    loadMyPostList() {
                        const self = this;
                        $.ajax({
                            url: "/user/community-post-list.dox",
                            type: "POST",
                            success: function (data) {
                                self.myPostList = data.result === "success" ? (data.postList || []) : [];
                            },
                            error: function () {
                                self.myPostList = [];
                            }
                        });
                    },

                    loadMyCommentList() {
                        const self = this;
                        $.ajax({
                            url: "/user/community-comment-list.dox",
                            type: "POST",
                            success: function (data) {
                                self.myCommentList = data.result === "success" ? (data.commentList || []) : [];
                            },
                            error: function () {
                                self.myCommentList = [];
                            }
                        });
                    },

                    updateUser() {
                        const self = this;
                        $.ajax({
                            url: "/user/update-user.dox",
                            type: "POST",
                            data: self.user,
                            success: function (data) {
                                alert(data.message);
                            },
                            error: function () {
                                alert("회원정보 수정 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    openPwdModal() {
                        this.showPwdModal = true;
                    },

                    closePwdModal() {
                        this.showPwdModal = false;
                        this.pwdForm = { pwd: "", newPwd: "" };
                    },

                    changePassword() {
                        const self = this;
                        $.ajax({
                            url: "/user/check-password.dox",
                            type: "POST",
                            data: { pwd: self.pwdForm.pwd },
                            success: function (data) {
                                if (data.result !== "success") {
                                    alert(data.message);
                                    return;
                                }

                                $.ajax({
                                    url: "/user/change-pwd.dox",
                                    type: "POST",
                                    data: {
                                        pwd: self.pwdForm.pwd,
                                        newPwd: self.pwdForm.newPwd
                                    },
                                    success: function (data2) {
                                        alert(data2.message);
                                        if (data2.result === "success") self.closePwdModal();
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

                    deleteUser() {
                        if (!confirm("정말 탈퇴하시겠습니까?")) return;

                        $.ajax({
                            url: "/user/delete-user.dox",
                            type: "POST",
                            success: function (data) {
                                alert(data.message);
                                if (data.result === "success") location.href = "/user/login.do";
                            },
                            error: function () {
                                alert("회원 탈퇴 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    loadPetList() {
                        const self = this;
                        $.ajax({
                            url: "/user/pet-list.dox",
                            type: "POST",
                            success: function (data) {
                                if (data.result === "success") {
                                    self.petList = data.petList || [];
                                    const mainPet = self.petList.find(p => p.isMain === "Y");

                                    if (mainPet) self.selectedPetNo = String(mainPet.petNo);
                                    else if (self.petList.length > 0) self.selectedPetNo = String(self.petList[0].petNo);

                                    else self.selectedPetNo = "";

                                    if (self.selectedPetNo) {
                                        self.loadHealthList();
                                        self.loadWeightList();
                                        self.loadVaccineList();
                                    }
                                }
                            },
                            error: function () {
                                alert("반려동물 목록을 불러오지 못했습니다.");
                            }
                        });
                    },

                    getPetInitial(name) {
                        if (!name) return "P";
                        return name.substring(0, 1);
                    },

                    getPetAge(birthdate) {
                        if (!birthdate) return "";
                        const birth = new Date(birthdate);
                        const today = new Date();
                        let age = today.getFullYear() - birth.getFullYear();
                        const monthDiff = today.getMonth() - birth.getMonth();
                        const dayDiff = today.getDate() - birth.getDate();

                        if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) age--;
                        return age >= 0 ? age : 0;
                    },

                    openAddPetModal() {
                        this.petForm = { petNo: "", petName: "", species: "", breed: "", birthdate: "", gender: "" };
                        this.showPetModal = true;
                    },

                    openEditPetModal(pet) {
                        this.petForm = {
                            petNo: pet.petNo || "",
                            petName: pet.petName || "",
                            species: pet.species || "",
                            breed: pet.breed || "",
                            birthdate: pet.birthdate || "",
                            gender: pet.gender || ""
                        };
                        this.showPetModal = true;
                    },

                    closePetModal() {
                        this.showPetModal = false;
                    },

                    savePet() {
                        const self = this;
                        const url = self.petForm.petNo ? "/user/update-pet.dox" : "/user/add-pet.dox";

                        $.ajax({
                            url: url,
                            type: "POST",
                            data: self.petForm,
                            success: function (data) {
                                alert(data.message);
                                if (data.result === "success") {
                                    self.closePetModal();
                                    self.loadPetList();
                                }
                            },
                            error: function () {
                                alert("반려동물 저장 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    deletePet(petNo) {
                        const self = this;
                        if (!confirm("반려동물 정보를 삭제하시겠습니까?")) return;

                        $.ajax({
                            url: "/user/delete-pet.dox",
                            type: "POST",
                            data: { petNo: petNo },
                            success: function (data) {
                                alert(data.message);
                                if (data.result === "success") self.loadPetList();
                            },
                            error: function () {
                                alert("반려동물 삭제 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    changeMainPet(petNo) {
                        const self = this;
                        $.ajax({
                            url: "/user/change-main-pet.dox",
                            type: "POST",
                            data: { petNo: petNo },
                            success: function (data) {
                                alert(data.message);
                                if (data.result === "success") self.loadPetList();
                            },
                            error: function () {
                                alert("대표 프로필 변경 중 오류가 발생했습니다.");
                            }
                        });
                    },

                    loadReservationList() {
                        const self = this;
                        $.ajax({
                            url: "/user/reservation-list.dox",
                            type: "POST",
                            success: function (data) {
                                self.reservationList = data.result === "success" ? (data.reservationList || []) : [];
                            },
                            error: function () {
                                self.reservationList = [];
                                alert("예약 내역을 불러오지 못했습니다.");
                            }
                        });
                    },

                    loadReservationAllList() {
                        const self = this;
                        $.ajax({
                            url: "/user/reservation-all-list.dox",
                            type: "POST",
                            success: function (data) {
                                self.reservationAllList = data.result === "success" ? (data.reservationList || []) : [];
                            },
                            error: function () {
                                self.reservationAllList = [];
                                alert("전체 예약 내역을 불러오지 못했습니다.");
                            }
                        });
                    },

                    loadOrderList() {
                        const self = this;
                        $.ajax({
                            url: "/user/order-list.dox",
                            type: "POST",
                            success: function (data) {
                                self.orderList = data.result === "success" ? (data.orderList || []) : [];
                            },
                            error: function () {
                                self.orderList = [];
                                alert("주문 내역을 불러오지 못했습니다.");
                            }
                        });
                    },

                    loadHealthList() {
                        const self = this;
                        if (!self.selectedPetNo) return;

                        $.ajax({
                            url: "/user/health-list.dox",
                            type: "POST",
                            data: { petNo: self.selectedPetNo },
                            success: function (data) {
                                self.healthList = data.result === "success" ? (data.healthList || []) : [];
                            }
                        });
                    },

                    loadWeightList() {
                        const self = this;
                        if (!self.selectedPetNo) return;

                        $.ajax({
                            url: "/user/weight-list.dox",
                            type: "POST",
                            data: { petNo: self.selectedPetNo },
                            success: function (data) {
                                self.weightList = data.result === "success" ? (data.weightList || []) : [];
                                setTimeout(() => self.drawWeightChart(), 100);
                            }
                        });
                    },

                    loadVaccineList() {
                        const self = this;
                        if (!self.selectedPetNo) return;

                        $.ajax({
                            url: "/user/vaccine-list.dox",
                            type: "POST",
                            data: { petNo: self.selectedPetNo },
                            success: function (data) {
                                self.vacList = data.result === "success" ? (data.vaccineList || []) : [];
                            }
                        });
                    },
                    saveHealthRecord() {
                        const self = this;

                        if (!self.selectedPetNo) {
                            alert("반려동물을 선택해주세요.");
                            return;
                        }

                        $.ajax({
                            url: "/user/add-health.dox",
                            type: "POST",
                            data: {
                                petNo: self.selectedPetNo,
                                title: self.healthForm.title,
                                date: self.healthForm.date,
                                memo: self.healthForm.memo
                            },
                            success: function (data) {
                                alert(data.message);
                                if (data.result === "success") {
                                    self.healthForm = { title: "", date: "", memo: "" };
                                    self.loadHealthList();
                                }
                            }
                        });
                    },
                    saveVacRecord() {
                        const self = this;

                        if (!self.selectedPetNo) {
                            alert("반려동물을 선택해주세요.");
                            return;
                        }

                        $.ajax({
                            url: "/user/add-vaccine.dox",
                            type: "POST",
                            data: {
                                petNo: self.selectedPetNo,
                                name: self.vacForm.name,
                                date: self.vacForm.date,
                                nextDate: self.vacForm.nextDate,
                                hospitalName: self.vacForm.hospitalName,
                                memo: self.vacForm.memo
                            },
                            success: function (data) {
                                alert(data.message);
                                if (data.result === "success") {
                                    self.vacForm = { name: "", date: "", nextDate: "", hospitalName: "", memo: "" };
                                    self.loadVaccineList();
                                }
                            }
                        });
                    },







                    saveWeightRecord() {
                        const self = this;

                        if (!self.selectedPetNo) {
                            alert("반려동물을 선택해주세요.");
                            return;
                        }

                        $.ajax({
                            url: "/user/add-weight.dox",
                            type: "POST",
                            data: {
                                petNo: self.selectedPetNo,
                                weight: self.weightForm.weight,
                                date: self.weightForm.date,
                                memo: self.weightForm.memo
                            },
                            success: function (data) {
                                alert(data.message);
                                if (data.result === "success") {
                                    self.weightForm = { weight: "", date: "", memo: "" };
                                    self.loadWeightList();
                                }
                            }
                        });
                    },
                    drawWeightChart() {
                        const canvas = document.getElementById("weightChart");
                        if (!canvas) return;

                        const labels = this.weightList.map(item => item.date);
                        const values = this.weightList.map(item => Number(item.weight));

                        if (this.weightChart) {
                            this.weightChart.destroy();
                            this.weightChart = null;
                        }

                        this.weightChart = new Chart(canvas, {
                            type: "line",
                            data: {
                                labels: labels,
                                datasets: [{
                                    label: "몸무게 (kg)",
                                    data: values,
                                    fill: false,
                                    tension: 0.3,
                                    borderWidth: 2,
                                    pointRadius: 4,
                                    pointHoverRadius: 6
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: { display: true }
                                },
                                scales: {
                                    y: { beginAtZero: false }
                                }
                            }
                        });
                    },

                    loadPointInfo() {
                        const self = this;

                        $.ajax({
                            url: "/user/point-info.dox",
                            type: "POST",
                            dataType: "json",
                            success: function (res) {
                                if (res.result === true || res.result === "success") {
                                    if (res.info) self.point = res.info.point || res.info.POINT || 0;
                                    else self.point = res.point || 0;
                                } else {
                                    self.point = 0;
                                }
                            },
                            error: function () {
                                self.point = 0;
                                alert("포인트 조회 실패");
                            }
                        });
                    },

                    loadPointUseList() {
                        const self = this;

                        $.ajax({
                            url: "/user/point-use-list.dox",
                            type: "POST",
                            dataType: "json",
                            success: function (res) {
                                if (res.result === true || res.result === "success") {
                                    self.pointUseList = res.list || [];
                                } else if (Array.isArray(res)) {
                                    self.pointUseList = res;
                                } else {
                                    self.pointUseList = [];
                                }

                                self.showPointUseList = true;
                            },
                            error: function () {
                                self.pointUseList = [];
                                self.showPointUseList = true;
                                alert("포인트 사용내역 조회 실패");
                            }
                        });
                    },
                    loadCouponList() {
                        const self = this;

                        $.ajax({
                            url: "/user/coupon-list.dox",
                            type: "POST",
                            dataType: "json",
                            success: function (res) {
                                if (res.result === true || res.result === "success") {
                                    self.couponList = res.couponList || res.list || [];
                                } else {
                                    self.couponList = [];
                                }
                            },
                            error: function () {
                                self.couponList = [];
                                alert("쿠폰 조회 실패");
                            }
                        });
                    },
                    getCouponStatus(coupon) {
                        const status = coupon.cpStatus || coupon.CP_STATUS;
                        const endDate = coupon.endDate || coupon.EXP_DATE;

                        if (status === "USE") {
                            return "USED";
                        }

                        if (status === "EXP") {
                            return "EXPIRED";
                        }

                        if (endDate) {
                            const today = new Date();
                            const expireDate = new Date(endDate);

                            today.setHours(0, 0, 0, 0);
                            expireDate.setHours(0, 0, 0, 0);

                            if (expireDate < today) {
                                return "EXPIRED";
                            }
                        }

                        return "ABLE";
                    },


                    getCouponStatusText(coupon) {
                        const status = this.getCouponStatus(coupon);

                        if (status === "USED") return "사용완료";
                        if (status === "EXPIRED") return "만료";
                        return "사용가능";
                    },

                    getCouponStatusClass(coupon) {
                        const status = this.getCouponStatus(coupon);

                        if (status === "USED") return "status-gray";
                        if (status === "EXPIRED") return "status-red";
                        return "status-green";
                    }
                },

                mounted() {
                    this.loadMypage();
                    this.loadPetList();
                    this.loadReservationList();
                    this.loadReservationAllList();
                    this.loadOrderList();
                    this.loadSubscriptionInfo();
                    this.loadMyPostList();
                    this.loadMyCommentList();
                    this.loadPointInfo();

                    const trigger = sessionStorage.getItem("triggerFunction");
                    if (trigger === "openRsvList") {
                        this.changeMenu("reserveList");
                        sessionStorage.removeItem("triggerFunction");
                    } else if (trigger === "openOrdList") {
                        this.changeMenu("orderList");
                        sessionStorage.removeItem("triggerFunction");
                    }

                }
            });

            app.mount("#app");
        </script>
    </body>

    </html>