package com.easybytes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


@SpringBootApplication
//@EnableWebSecurity(debug = true)
public class EasyBankBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(EasyBankBackendApplication.class, args);
    }

}
