package com.moenews.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("news_comment")
public class NewsComment extends BaseEntity {
    private Long newsId;
    private Long userId;
    private String content;
    private Integer status;
}
