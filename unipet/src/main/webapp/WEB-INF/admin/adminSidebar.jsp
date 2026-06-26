<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<aside class="admin-sidebar">
    <div class="sidebar-title">관리자 페이지</div>

    <ul class="sidebar-menu">
        <li class="menu-item ${param.activeMenu eq 'userManage' ? 'active' : ''}">
            <a href="/admin/userManage.do">회원 조회 및 관리</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'businessUserManage' ? 'active' : ''}">
            <a href="/admin/businessUserManage.do">사업자 회원 조회 및 관리</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'storeApprove' ? 'active' : ''}">
            <a href="/admin/storeApprove.do">사업자 입점 승인 관리</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'report' ? 'active' : ''}">
            <a href="/admin/report.do">커뮤니티 및 리뷰 신고 관리</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'qnaAnswer' ? 'active' : ''}">
            <a href="/admin/qnaAnswer.do">문의 답변 관리</a>
        </li>

        <li class="menu-item ${param.activeMenu eq 'productManage' ? 'active' : ''}">
            <a href="/admin/productManage.do">상품 등록 및 관리</a>
        </li>
    </ul>
</aside>