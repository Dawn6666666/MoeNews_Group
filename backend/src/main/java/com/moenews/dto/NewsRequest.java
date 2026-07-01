package com.moenews.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class NewsRequest {
    @NotBlank(message = "新闻标题不能为空")
    private String title;
    private String summary;

    @NotBlank(message = "新闻正文不能为空")
    private String content;
    private String coverImage;

    @NotNull(message = "新闻分类不能为空")
    private Long categoryId;

    @NotNull(message = "新闻状态不能为空")
    private Integer status;
}
