package com.example.unipet.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

@Configuration
@EnableWebSecurity // 기존에 쓰시던 어노테이션 살림
public class SecurityConfig {

	// 1. 비밀번호 암호화 기계 등록 (이게 있어야 회원가입/로그인 에러 안 남!)
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	// 2. 방화벽 설정 (더블 슬래시, 세미콜론 허용)
	@Bean
	public HttpFirewall allowDoubleSlashFirewall() {
		StrictHttpFirewall firewall = new StrictHttpFirewall();
		firewall.setAllowUrlEncodedDoubleSlash(true);
		firewall.setAllowSemicolon(true);
		return firewall;
	}

	// 3. ★ 핵심: 만들어둔 방화벽을 시큐리티에 진짜로 적용 (기존 코드에 없던 부분)
	@Bean
	public WebSecurityCustomizer webSecurityCustomizer() {
		return web -> web.httpFirewall(allowDoubleSlashFirewall());
	}

	// 4. 시큐리티 필터 체인 (기본 기능 다 끄고 모든 권한 활짝 열기)
	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http.authorizeHttpRequests(auth -> auth.anyRequest().permitAll()).csrf(csrf -> csrf.disable())
				.formLogin(form -> form.disable()).httpBasic(basic -> basic.disable());

		return http.build();
	}
}