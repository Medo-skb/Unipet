package com.example.unipet.config;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.unipet.dao.ProductService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class CartInterceptor implements HandlerInterceptor {

    @Autowired
    private ProductService productService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {

        HttpSession session = request.getSession();
        String sessionId = (String) session.getAttribute("sessionId");

        int cartCount = 0;

        if (sessionId != null) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("userId", sessionId);

            HashMap<String, Object> resultMap = productService.getCartCount(map);

            if ("success".equals(resultMap.get("result"))) {
                cartCount = Integer.parseInt(String.valueOf(resultMap.get("cartCount")));
            }
        }

        session.setAttribute("cartCount", cartCount);

        return true;
    }
}