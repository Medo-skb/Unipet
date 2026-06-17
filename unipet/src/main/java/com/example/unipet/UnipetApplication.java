package com.example.unipet;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
//@EnableScheduling
public class UnipetApplication extends SpringBootServletInitializer {
	// 추가 코드
	@Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(UnipetApplication.class);
    }

	public static void main(String[] args) {
		SpringApplication.run(UnipetApplication.class, args);
	}

}
