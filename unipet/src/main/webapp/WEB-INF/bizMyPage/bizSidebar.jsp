<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="biz-sidebar">
    <div class="sidebar-title">사업자 마이페이지</div>

    <ul class="sidebar-menu">
        <c:choose>
            <c:when test="${applyOnlyMenu eq 'Y'}">
                <li class="menu-item ${param.activeMenu eq 'apply' ? 'active' : ''}">
                    <a href="/biz/apply.do">사업자 신청</a>
                </li>
            </c:when>

            <c:otherwise>
                <li class="menu-item ${param.activeMenu eq 'home' ? 'active' : ''}">
                    <a href="/biz/MyPage.do">홈</a>
                </li>

                <li class="menu-item ${param.activeMenu eq 'storeEdit' ? 'active' : ''}">
                    <a href="/biz/storeEdit.do">내 정보 및 업체 정보 수정</a>
                </li>

                <li class="menu-item ${param.activeMenu eq 'reservation' ? 'active' : ''}">
                    <a href="/biz/reservation.do">예약 현황</a>
                </li>

                <li class="menu-item ${param.activeMenu eq 'review' ? 'active' : ''}">
                    <a href="/biz/review.do">리뷰 관리</a>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</aside>