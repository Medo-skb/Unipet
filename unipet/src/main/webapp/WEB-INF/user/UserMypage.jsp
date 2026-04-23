<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #eef1f5;
            color: #333;
        }

        #app {
            width: 1320px;
            margin: 24px auto;
            display: flex;
            gap: 20px;
        }

        .sidebar {
            width: 110px;
            min-height: 1100px;
            background: linear-gradient(180deg, #57789a, #6f8faf);
            padding: 16px 10px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            align-items: center;
        }

        .menu {
            width: 86px;
            min-height: 58px;
            border-radius: 10px;
            background: rgba(255,255,255,0.10);
            color: #fff;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            line-height: 1.25;
            text-align: center;
            transition: 0.2s;
            padding: 8px 4px;
            font-size: 12px;
        }

        .menu:hover {
            background: rgba(255,255,255,0.20);
            transform: translateY(-2px);
        }

        .menu.active {
            background: rgba(255,255,255,0.28);
            border: 1px solid rgba(255,255,255,0.25);
        }

        .content {
            flex: 1;
            min-height: 1100px;
            background: #f6f7fb;
            border: 1px solid #d6dbe4;
            padding: 0;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            padding: 22px 24px;
            border-bottom: 1px solid #e2e5eb;
            background: #f6f7fb;
        }

        .page-inner {
            padding: 20px;
        }

        .section-box {
            background: #fff;
            border: 1px solid #dfe4ea;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 16px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.03);
        }

        .section-title {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 12px;
            color: #475467;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .row {
            margin-bottom: 12px;
        }

        .row label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 6px;
            color: #475467;
        }

        .row input,
        .row select,
        .row textarea {
            width: 100%;
            border: 1px solid #d0d7e2;
            border-radius: 8px;
            padding: 10px 12px;
            font-size: 14px;
            background: #fff;
        }

        .row input,
        .row select {
            height: 40px;
        }

        .row textarea {
            min-height: 90px;
            resize: vertical;
        }

        .btn-box {
            display: flex;
            gap: 8px;
            margin-top: 12px;
            flex-wrap: wrap;
        }

        .btn-box button,
        .small-btn {
            height: 36px;
            border: 1px solid #c6d0dd;
            border-radius: 8px;
            background: #eef4ff;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            padding: 0 14px;
            color: #445166;
        }

        .btn-gray {
            background: #eef1f4 !important;
            border-color: #c5ced8 !important;
        }

        .btn-red {
            background: #fff0f0 !important;
            border-color: #e0b3b3 !important;
        }

        .empty-text {
            color: #777;
            font-size: 13px;
            padding: 10px 4px;
        }

        .pet-list {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .pet-card {
            width: 150px;
            border: 1px solid #dde3ea;
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
            text-align: center;
        }

        .pet-thumb {
            height: 112px;
            background: linear-gradient(135deg, #f3f5f8, #e4ebf3);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .pet-avatar {
            width: 62px;
            height: 62px;
            border-radius: 50%;
            background: #8ba3ba;
            color: #fff;
            font-size: 24px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .pet-body {
            padding: 10px 8px 12px;
        }

        .pet-name {
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .pet-info {
            font-size: 12px;
            color: #666;
            min-height: 32px;
            margin-bottom: 8px;
            line-height: 1.4;
        }

        .pet-btns {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 6px;
        }

        .pet-btn {
            border: none;
            color: white;
            padding: 7px 10px;
            border-radius: 7px;
            font-size: 11px;
            font-weight: 700;
            cursor: pointer;
        }

        .pet-btn.main { background: #f29b38; }
        .pet-btn.main.gray { background: #c7cdd6; cursor: default; }
        .pet-btn.edit { background: #5d92d6; }
        .pet-btn.delete { background: #d56b6b; }

        .pet-add-card {
            width: 150px;
            min-height: 196px;
            border: 2px dashed #cfd6df;
            border-radius: 8px;
            background: #fafbfd;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #7d8b99;
            font-weight: 700;
            gap: 10px;
        }

        .pet-add-plus {
            font-size: 38px;
            line-height: 1;
        }

        .list-item {
            padding: 12px 4px;
            border-bottom: 1px solid #edf0f3;
        }

        .list-item:last-child {
            border-bottom: none;
        }

        .list-title {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .list-sub {
            font-size: 12px;
            color: #666;
            margin-bottom: 3px;
        }

        .list-status {
            font-size: 12px;
            font-weight: 700;
            color: #4e90dc;
        }

        .info-card {
            border: 1px solid #e1e6ed;
            border-radius: 8px;
            background: #fff;
            padding: 14px;
            margin-bottom: 10px;
        }

        .order-item {
            display: flex;
            gap: 14px;
            align-items: center;
            padding: 10px 0;
            border-top: 1px solid #eee;
        }

        .order-item:first-child {
            border-top: none;
            padding-top: 0;
        }

        .order-img {
            width: 72px;
            height: 72px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid #ddd;
            background: #f5f5f5;
        }

        .chart-wrap {
            width: 100%;
            height: 360px;
            position: relative;
        }

        .modal-wrap {
            display: flex;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.4);
            z-index: 999;
            align-items: center;
            justify-content: center;
        }

        .modal-box {
            width: 430px;
            background: white;
            border-radius: 14px;
            padding: 24px;
        }

        .modal-title {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #324455;
        }

        .modal-btns {
            display: flex;
            gap: 10px;
            margin-top: 18px;
        }

        .modal-btns button {
            flex: 1;
            height: 42px;
            border-radius: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 700;
            border: 2px solid #8ea8d8;
            background: #eef4ff;
            color: #2b2b2b;
        }

        .btn-cancel {
            background: #eef1f4 !important;
            border-color: #b8c3cf !important;
        }

        .btn-save {
            background: #fff2df !important;
            border-color: #f0bf74 !important;
        }

        .mypage-dashboard {
            display: grid;
            grid-template-columns: 1.55fr 1fr;
            gap: 16px;
        }

        .dash-left,
        .dash-right {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .profile-summary {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 16px;
            align-items: stretch;
        }

        .profile-photo-box {
            border: 1px solid #e1e6ed;
            border-radius: 8px;
            background: #fafbfd;
            min-height: 160px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #a1acb8;
            font-size: 13px;
            font-weight: 700;
        }

        .profile-info-box {
            border: 1px solid #e1e6ed;
            border-radius: 8px;
            padding: 14px;
            background: #fff;
        }

        .profile-info-row {
            display: flex;
            gap: 10px;
            margin-bottom: 8px;
            font-size: 13px;
        }

        .profile-info-label {
            width: 72px;
            color: #667085;
            font-weight: 700;
        }

        .mini-dashboard {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .mini-panel {
            border: 1px solid #e1e6ed;
            border-radius: 8px;
            background: #fff;
            overflow: hidden;
        }

        .mini-panel-head {
            background: #eff3f8;
            padding: 10px 12px;
            font-size: 13px;
            font-weight: 700;
            color: #4e5968;
            border-bottom: 1px solid #e1e6ed;
        }

        .mini-panel-body {
            padding: 12px;
        }

        .mini-action-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .mini-action-card {
            border: 1px solid #e1e6ed;
            border-radius: 8px;
            padding: 12px;
            background: #fff;
        }

        .subscription-box {
            border: 1px solid #e1e6ed;
            border-radius: 8px;
            padding: 16px;
            background: #fff;
        }

        .sub-title {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .sub-date {
            font-size: 13px;
            color: #667085;
            margin-bottom: 10px;
        }

        .sub-state {
            font-size: 13px;
            color: #445166;
            margin-bottom: 14px;
            font-weight: 700;
        }

        .sub-btn {
            width: 100%;
            height: 40px;
            border: none;
            border-radius: 8px;
            background: #4f91e6;
            color: #fff;
            font-weight: 700;
            cursor: pointer;
        }

        .main-order-item,
        .main-reserve-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-top: 1px solid #eef1f5;
        }

        .main-order-item:first-child,
        .main-reserve-item:first-child {
            border-top: none;
            padding-top: 0;
        }

        .status-badge {
            min-width: 74px;
            height: 26px;
            padding: 0 10px;
            border-radius: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            color: #fff;
        }

        .status-blue { background: #5f99e8; }
        .status-orange { background: #e9a643; }
        .status-green { background: #91b76b; }
        .status-gray { background: #9aa4b2; }

        @media (max-width: 1200px) {
            #app {
                width: 100%;
                padding: 0 12px;
            }

            .mypage-dashboard {
                grid-template-columns: 1fr;
            }

            .mini-dashboard,
            .mini-action-grid,
            .profile-summary {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div id="app">

    <div class="sidebar">
        <div class="menu" :class="{active: currentMenu==='userMyPage'}" @click="changeMenu('userMyPage')">🏠<br>마이페이지</div>
        <div class="menu" :class="{active: currentMenu==='subscriptionPage'}" @click="changeMenu('subscriptionPage')">💳<br>구독</div>
        <div class="menu" :class="{active: currentMenu==='communityPage'}" @click="changeMenu('communityPage')">💬<br>커뮤니티</div>
        <div class="menu" :class="{active: currentMenu==='orderList'}" @click="changeMenu('orderList')">🛒<br>주문내역</div>
        <div class="menu" :class="{active: currentMenu==='reserveList'}" @click="changeMenu('reserveList')">📅<br>예약내역</div>
        <div class="menu" :class="{active: currentMenu==='petEdit'}" @click="changeMenu('petEdit')">🐶<br>반려동물</div>
        <div class="menu" :class="{active: currentMenu==='petMyPage'}" @click="changeMenu('petMyPage')">💗<br>건강조회</div>
        <div class="menu" :class="{active: currentMenu==='petHealthPage'}" @click="changeMenu('petHealthPage')">📝<br>건강기록</div>
        <div class="menu" :class="{active: currentMenu==='petVacPage'}" @click="changeMenu('petVacPage')">💉<br>접종기록</div>
        <div class="menu" :class="{active: currentMenu==='petWeightPage'}" @click="changeMenu('petWeightPage')">⚖️<br>몸무게</div>
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
                                <div class="profile-photo-box">프로필 이미지</div>

                                <div class="profile-info-box">
                                    <div class="profile-info-row"><div class="profile-info-label">이름</div><div>{{ user.userName || '-' }}</div></div>
                                    <div class="profile-info-row"><div class="profile-info-label">닉네임</div><div>{{ user.nickname || '-' }}</div></div>
                                    <div class="profile-info-row"><div class="profile-info-label">이메일</div><div>{{ user.email || '-' }}</div></div>
                                    <div class="profile-info-row"><div class="profile-info-label">전화번호</div><div>{{ user.phone || '-' }}</div></div>
                                    <div class="profile-info-row"><div class="profile-info-label">주소</div><div>{{ user.userAddr || '-' }} {{ user.fullAddr || '' }}</div></div>

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
                                    <div class="row"><label>이름</label><input type="text" v-model="user.userName"></div>
                                    <div class="row"><label>닉네임</label><input type="text" v-model="user.nickname"></div>
                                    <div class="row"><label>이메일</label><input type="text" v-model="user.email"></div>
                                    <div class="row"><label>전화번호</label><input type="text" v-model="user.phone"></div>
                                    <div class="row"><label>우편번호</label><input type="text" v-model="user.zipcode"></div>
                                    <div class="row"><label>주소</label><input type="text" v-model="user.userAddr"></div>
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
                                            <button v-if="pet.isMain === 'Y'" class="pet-btn main gray" disabled>대표 프로필</button>
                                            <button v-else class="pet-btn main" @click="changeMainPet(pet.petNo)">대표 프로필</button>
                                            <button class="pet-btn edit" @click="openEditPetModal(pet)">수정</button>
                                            <button class="pet-btn delete" @click="deletePet(pet.petNo)">삭제</button>
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
                                    <div v-if="reservationList.length === 0" class="empty-text">예약 내역이 없습니다.</div>

                                    <div class="main-reserve-item" v-for="item in reservationList.slice(0, 2)" :key="item.rsvNo">
                                        <div>
                                            <div class="list-title">예약번호 {{ item.rsvNo || '-' }}</div>
                                            <div class="list-sub">{{ item.rsvDate || '-' }} {{ item.rsvStartTime || '-' }}</div>
                                        </div>
                                        <div class="status-badge" :class="getReserveStatusClass(item.rsvStatus)">
                                            {{ item.rsvStatus || '-' }}
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
                                    <div v-if="groupedOrderList.length === 0" class="empty-text">주문 내역이 없습니다.</div>

                                    <div class="main-order-item" v-for="group in groupedOrderList.slice(0, 2)" :key="group.orderNo">
                                        <div>
                                            <div class="list-title">주문번호 {{ group.orderNo || '-' }}</div>
                                            <div class="list-sub">{{ group.orderDate || '-' }}</div>
                                        </div>
                                        <div class="status-badge" :class="getOrderStatusClass(group.items[0]?.orderStatus)">
                                            {{ group.items[0]?.orderStatus || '-' }}
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
                                <div class="list-sub">다음 결제일 : {{ subscriptionInfo.nextBillingDate || '-' }}</div>
                                <div class="btn-box">
                                    <button class="small-btn" @click="changeMenu('subscriptionPage')">구독 관리</button>
                                </div>
                            </div>

                            <div class="mini-action-card">
                                <div class="section-title" style="margin-bottom:8px;">커뮤니티 활동</div>
                                <div class="list-sub">내 게시글 : {{ myPostList.length }}건</div>
                                <div class="list-sub">내 댓글 : {{ myCommentList.length }}건</div>
                                <div class="btn-box">
                                    <button class="small-btn" @click="changeMenu('communityPage')">내 게시글</button>
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
                                <div class="sub-date">다음 결제일: {{ subscriptionInfo.nextBillingDate || '-' }}</div>
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
                                <div v-for="item in recentPostList.slice(0, 2)" :key="'post-' + item.id" class="list-item">
                                    <div class="list-title">{{ item.title }}</div>
                                    <div class="list-sub">{{ item.cdate }}</div>
                                </div>
                            </div>

                            <div class="info-card">
                                <div class="list-title">내 댓글</div>
                                <div class="list-sub">총 {{ myCommentList.length }}건</div>
                                <div v-if="myCommentList.length === 0" class="empty-text">작성한 댓글이 없습니다.</div>
                                <div v-for="item in myCommentList.slice(0, 2)" :key="'comment-' + item.id" class="list-item">
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
                            <div class="info-card"><div class="list-title">반려동물 수</div><div class="list-sub">{{ petList.length }}마리</div></div>
                            <div class="info-card"><div class="list-title">최근 예약</div><div class="list-sub">{{ reservationList.length }}건</div></div>
                            <div class="info-card"><div class="list-title">최근 주문</div><div class="list-sub">{{ groupedOrderList.length }}건</div></div>
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
                            <div class="list-sub">{{ subscriptionInfo.subPrice ? Number(subscriptionInfo.subPrice).toLocaleString() + '원' : '-' }}</div>
                        </div>
                    </div>

                    <div class="btn-box">
                        <button class="small-btn btn-red"
                                v-if="subscriptionInfo.status === '이용중'"
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

                    <div v-if="groupedOrderList.length === 0" class="empty-text">주문 내역이 없습니다.</div>

                    <div class="info-card" v-for="group in groupedOrderList" :key="group.orderNo" style="margin-bottom:16px;">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
                            <div class="list-title" style="font-size:16px;">주문번호 : {{ group.orderNo }}</div>
                            <button class="small-btn" @click="openOrderDetail(group)">주문상세보기</button>
                        </div>

                        <div class="list-sub" style="margin-bottom:10px;">주문일자 : {{ group.orderDate }}</div>

                        <div v-for="order in group.items" :key="order.orderDetailNo || order.orderNo + '-' + order.productNo" class="order-item">
                            <img :src="order.productImage || 'https://via.placeholder.com/72x72?text=IMG'" alt="상품이미지" class="order-img">
                            <div style="flex:1;">
                                <div class="list-title">{{ order.productName || ('주문번호 ' + (order.orderNo || '-')) }}</div>
                                <div class="list-sub">주문번호 : {{ order.orderNo }}</div>
                                <div class="list-sub">수량 : {{ order.qty }}개</div>
                                <div class="list-sub">금액 : {{ order.price }}원</div>
                                <div class="list-status">상태 : {{ order.orderStatus }}</div>
                            </div>
                        </div>
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
                        <div class="list-title">주문번호 : {{ selectedOrderGroup.orderNo }}</div>
                        <div class="list-sub">주문일자 : {{ selectedOrderGroup.orderDate }}</div>
                        <div class="list-sub">총 상품 수 : {{ selectedOrderGroup.items.length }}건</div>
                    </div>

                    <div v-if="selectedOrderGroup.items.length === 0" class="empty-text">주문 상세 내역이 없습니다.</div>

                    <div class="info-card" v-for="order in selectedOrderGroup.items" :key="'detail-' + (order.orderDetailNo || order.orderNo + '-' + order.productNo)">
                        <div class="order-item">
                            <img :src="order.productImage || 'https://via.placeholder.com/72x72?text=IMG'" alt="상품이미지" class="order-img">
                            <div style="flex:1;">
                                <div class="list-title">{{ order.productName || ('주문번호 ' + (order.orderNo || '-')) }}</div>
                                <div class="list-sub">주문번호 : {{ order.orderNo }}</div>
                                <div class="list-sub">주문일자 : {{ order.orderDate }}</div>
                                <div class="list-sub">수량 : {{ order.qty }}개</div>
                                <div class="list-sub">금액 : {{ order.price }}원</div>
                                <div class="list-sub">배송추적 : {{ order.trackingNo || '-' }}</div>
                                <div class="list-status">상태 : {{ order.orderStatus }}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="currentMenu === 'reserveList'">
                <div class="section-box">
                    <div class="section-header">
                        <div class="section-title" style="margin-bottom:0;">예약 내역</div>
                        <button class="small-btn" @click="loadReservationAllList">새로고침</button>
                    </div>

                    <div v-if="reservationAllList.length === 0" class="empty-text">예약 내역이 없습니다.</div>

                    <div class="list-item" v-for="item in reservationAllList" :key="'all-' + item.rsvNo">
                        <div class="list-title">예약번호 : {{ item.rsvNo || '-' }}</div>
                        <div class="list-sub">예약일 : {{ item.rsvDate || '-' }}</div>
                        <div class="list-sub">시간 : {{ item.rsvStartTime || '-' }} ~ {{ item.rsvEndTime || '-' }}</div>
                        <div class="list-sub">매장번호 : {{ item.storeNo || '-' }}</div>
                        <div class="list-sub">반려동물번호 : {{ item.petNo || '-' }}</div>
                        <div class="list-sub">요청사항 : {{ item.request || '-' }}</div>
                        <div class="list-status">상태 : {{ item.rsvStatus || '-' }}</div>
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
                                <div class="pet-info">{{ pet.species || '' }}{{ pet.birthdate ? ' · ' + getPetAge(pet.birthdate) + '살' : '' }}</div>
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
                    <div class="section-title">건강 기록 조회</div>
                    <div v-if="healthList.length === 0" class="empty-text">건강 기록이 없습니다.</div>
                    <div class="info-card" v-for="item in healthList" :key="'h-' + item.id">
                        <div class="list-title">{{ item.title }}</div>
                        <div class="list-sub">기록일 : {{ item.date }}</div>
                        <div class="list-sub">내용 : {{ item.memo }}</div>
                    </div>
                </div>

                <div class="section-box">
                    <div class="section-title">접종 기록 조회</div>
                    <div v-if="vacList.length === 0" class="empty-text">접종 기록이 없습니다.</div>
                    <div class="info-card" v-for="item in vacList" :key="'v-' + item.id">
                        <div class="list-title">{{ item.name }}</div>
                        <div class="list-sub">접종일 : {{ item.date }}</div>
                        <div class="list-sub">다음 접종일 : {{ item.nextDate || '-' }}</div>
                        <div class="list-sub">병원명 : {{ item.hospitalName || '-' }}</div>
                        <div class="list-sub">비고 : {{ item.memo || '-' }}</div>
                    </div>
                </div>

                <div class="section-box">
                    <div class="section-title">몸무게 기록 조회</div>
                    <div v-if="weightList.length === 0" class="empty-text">몸무게 기록이 없습니다.</div>
                    <div class="info-card" v-for="item in weightList" :key="'w-main-' + item.id">
                        <div class="list-title">{{ item.weight }} kg</div>
                        <div class="list-sub">기록일 : {{ item.date }}</div>
                    </div>
                </div>
            </div>

            <div v-if="currentMenu === 'petHealthPage'">
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
                    <div v-if="healthList.length === 0" class="empty-text">건강 기록이 없습니다.</div>
                    <div class="info-card" v-for="item in healthList" :key="'health-' + item.id">
                        <div class="list-title">{{ item.title }}</div>
                        <div class="list-sub">기록일 : {{ item.date }}</div>
                        <div class="list-sub">내용 : {{ item.memo }}</div>
                    </div>
                </div>
            </div>

            <div v-if="currentMenu === 'petVacPage'">
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

                <div class="section-box">
                    <div class="section-title">접종 기록 목록</div>
                    <div v-if="vacList.length === 0" class="empty-text">접종 기록이 없습니다.</div>
                    <div class="info-card" v-for="item in vacList" :key="'vac-' + item.id">
                        <div class="list-title">{{ item.name }}</div>
                        <div class="list-sub">접종일 : {{ item.date }}</div>
                        <div class="list-sub">다음 접종일 : {{ item.nextDate || '-' }}</div>
                        <div class="list-sub">병원명 : {{ item.hospitalName || '-' }}</div>
                        <div class="list-sub">비고 : {{ item.memo || '-' }}</div>
                        <div class="btn-box">
                            <button class="btn-red" @click="deleteVaccine(item.id)">삭제</button>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="currentMenu === 'petWeightPage'">
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

                <div class="section-box">
                    <div class="section-title">일자별 몸무게 차트 그래프</div>
                    <div class="chart-wrap">
                        <canvas id="weightChart"></canvas>
                    </div>
                </div>

                <div class="section-box">
                    <div class="section-title">몸무게 기록 목록</div>
                    <div v-if="weightList.length === 0" class="empty-text">몸무게 기록이 없습니다.</div>
                    <div class="info-card" v-for="item in weightList" :key="'w-' + item.id">
                        <div class="list-title">{{ item.weight }} kg</div>
                        <div class="list-sub">기록일 : {{ item.date }}</div>
                        <div class="list-sub">비고 : {{ item.memo || '-' }}</div>
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
            }
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
                petEdit: "반려동물 관리",
                petMyPage: "건강 조회",
                petHealthPage: "건강 기록",
                petVacPage: "접종 기록",
                petWeightPage: "몸무게 관리"
            };
            return map[this.currentMenu] || "마이페이지";
        },

        groupedOrderList() {
            const grouped = {};

            this.orderList.forEach(order => {
                const orderNo = order.orderNo || "주문번호없음";
                if (!grouped[orderNo]) grouped[orderNo] = [];
                grouped[orderNo].push(order);
            });

            return Object.keys(grouped)
                .map(orderNo => ({
                    orderNo: orderNo,
                    orderDate: grouped[orderNo][0]?.orderDate || "",
                    items: grouped[orderNo]
                }))
                .sort((a, b) => {
                    if (a.orderDate === b.orderDate) {
                        return String(b.orderNo).localeCompare(String(a.orderNo));
                    }
                    return String(b.orderDate).localeCompare(String(a.orderDate));
                });
        },

        recentPostList() {
            return [...this.myPostList]
                .sort((a, b) => String(b.cdate || "").localeCompare(String(a.cdate || "")))
                .slice(0, 3);
        }
    },

    methods: {
        changeMenu(menu) {
            this.currentMenu = menu;

            if (menu === "subscriptionPage") {
                this.loadSubscriptionInfo();
            }

            if (menu === "communityPage" || menu === "communityPostList") {
                this.loadMyPostList();
                this.loadMyCommentList();
            }

            if (menu === "reserveList") {
                this.loadReservationAllList();
            }

            if (menu === "orderList") {
                this.loadOrderList();
            }

            if (menu === "petWeightPage") {
                this.loadWeightList();
            }

            if (menu === "petHealthPage" || menu === "petMyPage") {
                this.loadHealthList();
            }

            if (menu === "petVacPage" || menu === "petMyPage") {
                this.loadVaccineList();
            }
        },

        goCommunityPostList() {
            this.currentMenu = "communityPostList";
            this.loadMyPostList();
        },

        goOrderList() {
            this.currentMenu = "orderList";
        },

        openOrderDetail(group) {
            this.selectedOrderGroup = {
                orderNo: group.orderNo,
                orderDate: group.orderDate,
                items: group.items
            };
            this.currentMenu = "orderDetail";
        },

        cancelSubscription() {
            const self = this;

            if (!confirm("정말 구독을 해지하시겠습니까?")) return;

            $.ajax({
                url: "/user/cancel-subscription.dox",
                type: "POST",
                success: function(data) {
                    alert(data.message || (data.result === "success" ? "구독이 해지되었습니다." : "구독 해지에 실패했습니다."));
                    if (data.result === "success") {
                        self.loadSubscriptionInfo();
                    }
                },
                error: function() {
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
            if (!status) return "status-gray";
            if (status.includes("완료")) return "status-green";
            if (status.includes("대기")) return "status-orange";
            return "status-blue";
        },

        loadMypage() {
            const self = this;
            $.ajax({
                url: "/user/mypage.dox",
                type: "POST",
                success: function(data) {
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
                error: function() {
                    alert("마이페이지 정보를 불러오지 못했습니다.");
                }
            });
        },

        loadSubscriptionInfo() {
            const self = this;
            $.ajax({
                url: "/user/subscription-info.dox",
                type: "POST",
                success: function(data) {
                    if (data.result === "success" && data.subscriptionInfo) {
                        self.subscriptionInfo = {
                            planName: data.subscriptionInfo.planName || "",
                            nextBillingDate: data.subscriptionInfo.nextBillingDate || "",
                            status: data.subscriptionInfo.status || "",
                            isAuto: data.subscriptionInfo.isAuto || "",
                            subPrice: data.subscriptionInfo.subPrice || ""
                        };
                    } else {
                        self.subscriptionInfo = {
                            planName: "",
                            nextBillingDate: "",
                            status: "",
                            isAuto: "",
                            subPrice: ""
                        };
                    }
                },
                error: function() {
                    self.subscriptionInfo = {
                        planName: "",
                        nextBillingDate: "",
                        status: "",
                        isAuto: "",
                        subPrice: ""
                    };
                }
            });
        },

        loadMyPostList() {
            const self = this;
            $.ajax({
                url: "/user/community-post-list.dox",
                type: "POST",
                success: function(data) {
                    self.myPostList = data.result === "success" ? (data.postList || []) : [];
                },
                error: function() {
                    self.myPostList = [];
                }
            });
        },

        loadMyCommentList() {
            const self = this;
            $.ajax({
                url: "/user/community-comment-list.dox",
                type: "POST",
                success: function(data) {
                    self.myCommentList = data.result === "success" ? (data.commentList || []) : [];
                },
                error: function() {
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
                success: function(data) {
                    alert(data.message);
                },
                error: function() {
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
                success: function(data) {
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
                        success: function(data2) {
                            alert(data2.message);
                            if (data2.result === "success") {
                                self.closePwdModal();
                            }
                        },
                        error: function() {
                            alert("비밀번호 변경 중 오류가 발생했습니다.");
                        }
                    });
                },
                error: function() {
                    alert("비밀번호 확인 중 오류가 발생했습니다.");
                }
            });
        },

        deleteUser() {
            if (!confirm("정말 탈퇴하시겠습니까?")) return;

            $.ajax({
                url: "/user/delete-user.dox",
                type: "POST",
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        location.href = "/user/login.do";
                    }
                },
                error: function() {
                    alert("회원 탈퇴 중 오류가 발생했습니다.");
                }
            });
        },

        loadPetList() {
            const self = this;
            $.ajax({
                url: "/user/pet-list.dox",
                type: "POST",
                success: function(data) {
                    if (data.result === "success") {
                        self.petList = data.petList || [];

                        const mainPet = self.petList.find(p => p.isMain === 'Y');
                        if (mainPet) {
                            self.selectedPetNo = mainPet.petNo;
                        } else if (self.petList.length > 0) {
                            self.selectedPetNo = self.petList[0].petNo;
                        } else {
                            self.selectedPetNo = "";
                        }

                        if (self.selectedPetNo) {
                            self.loadHealthList();
                            self.loadWeightList();
                            self.loadVaccineList();
                        } else {
                            self.healthList = [];
                            self.weightList = [];
                            self.vacList = [];
                        }
                    } else {
                        self.petList = [];
                        self.selectedPetNo = "";
                        self.healthList = [];
                        self.weightList = [];
                        self.vacList = [];
                    }
                },
                error: function() {
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

            if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
                age--;
            }
            return age >= 0 ? age : 0;
        },

        openAddPetModal() {
            this.petForm = {
                petNo: "",
                petName: "",
                species: "",
                breed: "",
                birthdate: "",
                gender: ""
            };
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

            if (!self.petForm.petName) {
                alert("이름을 입력해주세요.");
                return;
            }

            if (!self.petForm.species) {
                alert("종을 입력해주세요.");
                return;
            }

            const url = self.petForm.petNo ? "/user/update-pet.dox" : "/user/add-pet.dox";

            $.ajax({
                url: url,
                type: "POST",
                data: self.petForm,
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.closePetModal();
                        self.loadPetList();
                    }
                },
                error: function() {
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
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.loadPetList();
                    }
                },
                error: function() {
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
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.loadPetList();
                    }
                },
                error: function() {
                    alert("대표 프로필 변경 중 오류가 발생했습니다.");
                }
            });
        },

        loadReservationList() {
            const self = this;
            $.ajax({
                url: "/user/reservation-list.dox",
                type: "POST",
                success: function(data) {
                    self.reservationList = data.result === "success" ? (data.reservationList || []) : [];
                },
                error: function() {
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
                success: function(data) {
                    self.reservationAllList = data.result === "success" ? (data.reservationList || []) : [];
                },
                error: function() {
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
                success: function(data) {
                    self.orderList = data.result === "success" ? (data.orderList || []) : [];
                },
                error: function() {
                    self.orderList = [];
                    alert("주문 내역을 불러오지 못했습니다.");
                }
            });
        },

        loadHealthList() {
            const self = this;
            if (!self.selectedPetNo) {
                self.healthList = [];
                return;
            }

            $.ajax({
                url: "/user/health-list.dox",
                type: "POST",
                data: { petNo: self.selectedPetNo },
                success: function(data) {
                    self.healthList = data.result === "success" ? (data.healthList || []) : [];
                },
                error: function() {
                    self.healthList = [];
                }
            });
        },

        loadWeightList() {
            const self = this;

            if (!self.selectedPetNo) {
                self.weightList = [];
                if (self.weightChart) {
                    self.weightChart.destroy();
                    self.weightChart = null;
                }
                return;
            }

            $.ajax({
                url: "/user/weight-list.dox",
                type: "POST",
                data: { petNo: self.selectedPetNo },
                success: function(data) {
                    if (data.result === "success") {
                        self.weightList = data.weightList || [];
                    } else {
                        self.weightList = [];
                    }

                    setTimeout(() => {
                        self.drawWeightChart();
                    }, 100);
                },
                error: function() {
                    self.weightList = [];
                    if (self.weightChart) {
                        self.weightChart.destroy();
                        self.weightChart = null;
                    }
                }
            });
        },

        loadVaccineList() {
            const self = this;
            if (!self.selectedPetNo) {
                self.vacList = [];
                return;
            }

            $.ajax({
                url: "/user/vaccine-list.dox",
                type: "POST",
                data: { petNo: self.selectedPetNo },
                success: function(data) {
                    self.vacList = data.result === "success" ? (data.vaccineList || []) : [];
                },
                error: function() {
                    self.vacList = [];
                }
            });
        },

        saveHealthRecord() {
            const self = this;

            if (!self.healthForm.title || !self.healthForm.date) {
                alert("제목과 날짜를 입력해주세요.");
                return;
            }

            if (!self.selectedPetNo) {
                alert("반려동물을 먼저 등록하거나 대표 반려동물을 선택해주세요.");
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
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.healthForm = { title: "", date: "", memo: "" };
                        self.loadHealthList();
                    }
                },
                error: function() {
                    alert("건강 기록 저장 중 오류가 발생했습니다.");
                }
            });
        },

        saveVacRecord() {
            const self = this;

            if (!self.vacForm.name || !self.vacForm.date) {
                alert("백신명과 날짜를 입력해주세요.");
                return;
            }

            if (!self.selectedPetNo) {
                alert("반려동물을 먼저 선택해주세요.");
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
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.vacForm = {
                            name: "",
                            date: "",
                            nextDate: "",
                            hospitalName: "",
                            memo: ""
                        };
                        self.loadVaccineList();
                    }
                },
                error: function() {
                    alert("백신 기록 저장 중 오류가 발생했습니다.");
                }
            });
        },

        deleteVaccine(vacNo) {
            const self = this;
            if (!confirm("백신 기록을 삭제하시겠습니까?")) return;

            $.ajax({
                url: "/user/delete-vaccine.dox",
                type: "POST",
                data: {
                    vacNo: vacNo,
                    petNo: self.selectedPetNo
                },
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.loadVaccineList();
                    }
                },
                error: function() {
                    alert("백신 기록 삭제 중 오류가 발생했습니다.");
                }
            });
        },

        saveWeightRecord() {
            const self = this;

            if (!self.weightForm.weight) {
                alert("몸무게를 입력해주세요.");
                return;
            }

            if (!self.selectedPetNo) {
                alert("반려동물을 먼저 등록하거나 대표 반려동물을 선택해주세요.");
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
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.weightForm = { weight: "", date: "", memo: "" };
                        self.loadWeightList();
                    }
                },
                error: function() {
                    alert("몸무게 저장 중 오류가 발생했습니다.");
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
    }
});

app.mount("#app");
</script>
</body>
</html>