package com.example.unipet.common;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class BizBlockInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession(false);

        if (session != null) {
            String role = (String) session.getAttribute("sessionRole");

            // 사업자 계정이면 접근 차단
            if ("BIZ".equals(role)) {

                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().write(
                    "<script>" +
                    "alert('사업자는 사용이 불가능한 페이지입니다.');" +
                    "location.href='" + request.getContextPath() + "/main.do';" +
                    "</script>"
                );
                response.getWriter().flush();

                return false;
            }
        }

        return true;
    }
}