<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<aside class="customer-sidebar">
    <div class="customer-sidebar-title">고객 센터</div>

    <ul class="customer-sidebar-menu">
        <!-- <li class="customer-menu-item ${param.activeMenu == 'chatbot' ? 'active' : ''}">
            <a href="/unipet/chatbot.do">Chatbot</a>
        </li> -->
        <li class="customer-menu-item ${param.activeMenu == 'inquiry' ? 'active' : ''}">
            <a href="/unipet/customer/inquiry.do">홈페이지 문의</a>
        </li>
        <li class="customer-menu-item ${param.activeMenu == 'history' ? 'active' : ''}">
            <a href="/unipet/customer/history.do">문의 내역</a>
        </li>
    </ul>
</aside>