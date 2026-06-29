<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<aside class="user-sidebar">
    <div class="sidebar-title">마이페이지</div>

    <ul class="sidebar-menu">
        <li class="menu-item ${param.activeMenu eq 'home' ? 'active' : ''}">
            <a href="/user/mypage.do">홈</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'subscription' ? 'active' : ''}">
            <a href="/user/mypage/subscription.do">구독관리</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'community' ? 'active' : ''}">
            <a href="/user/mypage/community.do">커뮤니티</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'order' ? 'active' : ''}">
            <a href="/user/mypage/order-list.do">주문내역</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'reserve' ? 'active' : ''}">
            <a href="/user/mypage/reserve-list.do">예약내역</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'pet' ? 'active' : ''}">
            <a href="/user/mypage/pet-edit.do">반려동물</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'health' ? 'active' : ''}">
            <a href="/user/mypage/pet-health.do">반려동물 건강관리</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'point' ? 'active' : ''}">
            <a href="/user/mypage/point-info.do">포인트</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'coupon' ? 'active' : ''}">
            <a href="/user/mypage/coupon-info.do">쿠폰</a>
        </li>
    </ul>
</aside>