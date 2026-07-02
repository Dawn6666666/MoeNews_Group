package com.moenews.dto;

import lombok.Data;

@Data
public class PageQuery {
    private long page = 1;
    private long size = 10;
    private String keyword;
    private Long categoryId;
    private String role;
    private Integer status;
}
