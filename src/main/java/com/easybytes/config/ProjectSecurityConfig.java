package com.easybytes.config;

import com.easybytes.filter.AuthoritiesLoggingAfterFilter;
import com.easybytes.filter.AuthoritiesLoggingAtFilter;
import com.easybytes.filter.CsrfCookieFilter;
import com.easybytes.filter.JWTTokenGeneratorFilter;
import com.easybytes.filter.JWTTokenValidatorFilter;
import com.easybytes.filter.RequestValidationBeforeFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.csrf.CsrfTokenRequestAttributeHandler;
import org.springframework.web.cors.CorsConfiguration;

import java.util.Collections;
import java.util.List;

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration // during the startup spring will scan for all the beans that we have defined in this class
public class ProjectSecurityConfig {

    @Bean
    SecurityFilterChain defaultSecurityFilterChain(HttpSecurity http) throws Exception {

        // CSRF TOKEN HANDLER
        // with this Spring Security is generating the CSRF token for you.
        CsrfTokenRequestAttributeHandler requestHandler = new CsrfTokenRequestAttributeHandler();
        // even if we don't mention this line, be default the handler is going to construct the same name
        requestHandler.setCsrfRequestAttributeName("_csrf");


        http
                // SESSION MANAGEMENT
                // SessionCreationPolicy.STATELESS tells Spring Security to not generate and JSESSIONIDs
                // and HTTP sessions
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                // CORS
                .cors(corsCustomizer -> corsCustomizer.configurationSource(request -> {
                    CorsConfiguration configuration = new CorsConfiguration();
                    configuration.setAllowedOrigins(Collections.singletonList("http://localhost:4200"));
                    configuration.setAllowedMethods(List.of("*"));
                    configuration.setAllowCredentials(true);
                    configuration.setAllowedHeaders(List.of("*"));
                    // we need to send the generated JWT tokens to the UI app
                    // the JWT token will be sent to the UI app with the help of this response header
                    // since we want to expose a header to the UI app
                    // we need to let the browser know that we are going to send this response header in order to accept it
                    // without the Authorization header, the UI app cannot read the JWT token
                    // and cannot send it back to the BE whenever is trying to make a request post initial login
                    // since we are trying to expose a header from BE app to a different UI app, which is hosted in a different domain,
                    // we need to make sure we're mentioning this
                    // we didn't do the same for the CSRF token header because that is a framework provided header
                    // and the framework is going to take care of that internally
                    // but here Authorization header is a custom header
                    configuration.setExposedHeaders(List.of("Authorization"));
                    // telling that the browser can remember these configurations up to 1h,
                    // it is going to cache these details up to 1h
                    // usually, in prod, we can set this for 24h or 30d, based on the prod deployment cycle.
                    configuration.setMaxAge(3600L);
                    return configuration;
                }))

                // CSRF
                // These are public APIs and we don't need to handle CSRF attacks because there is no sensitive information
                // we don't need to add /notices here because it is a GET request
                // with .httpOnlyFalse() we are telling to the Spring security
                // to create a CSRF cookie with a configuration as HttpOnlyFalse
                // so that my JavaScript code deployed inside the angular application can read the cookie value.
                .csrf(csrf -> csrf.csrfTokenRequestHandler(requestHandler)
                        .ignoringRequestMatchers("/contact", "/register")
                        .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()))
                // execute CsrfCookieFilter after the BasicAuthenticationFilter
                // only after the BasicAuthenticationFilter the login operation will complete
                // and the csrf token will be generated
                // and the crsf token will be persisted in the response with the help of CsrfCookieFilter
                .addFilterAfter(new CsrfCookieFilter(), BasicAuthenticationFilter.class)
                // add validation filter before the authentication
                .addFilterBefore(new RequestValidationBeforeFilter(), BasicAuthenticationFilter.class)
                // add filter at the same position as authentication filter
                .addFilterAt(new AuthoritiesLoggingAtFilter(), BasicAuthenticationFilter.class)
                // add auth logging filter after the authentication
                .addFilterAfter(new AuthoritiesLoggingAfterFilter(), BasicAuthenticationFilter.class)
                // we inject this filter in the spring security filter chain
                // we want this filter to be executed post successful authentication
                .addFilterAfter(new JWTTokenGeneratorFilter(), BasicAuthenticationFilter.class)
                // this custom filter will get executed before the actual authentication validation by spring security
                .addFilterBefore(new JWTTokenValidatorFilter(), BasicAuthenticationFilter.class)

                // AUTHORIZATION
                .authorizeHttpRequests(requests -> requests
                        .requestMatchers("/myAccount").hasRole("USER")
                        .requestMatchers("/myBalance").authenticated()
                        .requestMatchers("/myLoans").authenticated()
                        .requestMatchers("/myCards").hasRole("USER")
                        .requestMatchers("/user").authenticated()
                        .requestMatchers("/notices", "/contact", "/register").permitAll())
                .formLogin(withDefaults())
                .httpBasic(withDefaults());
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}
