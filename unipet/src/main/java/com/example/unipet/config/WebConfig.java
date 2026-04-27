package com.example.unipet.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
	@Autowired
    private CartInterceptor cartInterceptor;
	
	@Autowired
	private AdminInterceptor adminInterceptor;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/upload/**")
				.addResourceLocations("file:///C:/upload/");
	}
	
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(cartInterceptor)
                .addPathPatterns("/**");

		registry.addInterceptor(adminInterceptor)
				.addPathPatterns(
					"/admin.do",
					"/adminBiz.dox",
					"/editBizStatusApr.dox",
					"/editBizStatusRej.dox",
					"/getReservationReviewReportList.dox",
					"/getProductReviewReportList.dox",
					"/admin/report/**"
				)
				.excludePathPatterns(
					"/admin/login.do",
					"/admin/login.dox",
					"/admin/logout.do"
				);
    }
    
    
}