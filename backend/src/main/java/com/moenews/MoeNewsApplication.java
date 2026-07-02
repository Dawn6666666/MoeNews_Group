package com.moenews;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.moenews.mapper")
public class MoeNewsApplication {
    public static void main(String[] args) {
        SpringApplication.run(MoeNewsApplication.class, args);
    }
}
