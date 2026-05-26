<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 마이페이지 사이드바 -->
<aside class="user-sidebar">

    <!-- 사이드바 제목 -->
    <div class="sidebar-title">
        마이페이지
    </div>

    <!-- 메뉴 목록 -->
    <ul class="sidebar-menu">

        <!-- 홈 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage.do'">

                홈

            </button>
        </li>

        <!-- 구독관리 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage/subscription.do'">

                구독관리

            </button>
        </li>

        <!-- 커뮤니티 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage/community.do'">

                커뮤니티

            </button>
        </li>

        <!-- 주문내역 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage/order-list.do'">

                주문내역

            </button>
        </li>

        <!-- 예약내역 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage/reserve-list.do'">

                예약내역

            </button>
        </li>

        <!-- 반려동물 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage/pet-edit.do'">

                반려동물

            </button>
        </li>

        <!-- 건강관리 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage/pet-health.do'">

                반려동물 건강관리

            </button>
        </li>

        <!-- 포인트 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage/point-info.do'">

                포인트

            </button>
        </li>

        <!-- 쿠폰 -->
        <li class="menu-item">
            <button type="button"
                    onclick="location.href='/user/mypage/coupon-info.do'">

                쿠폰

            </button>
        </li>

    </ul>

</aside>