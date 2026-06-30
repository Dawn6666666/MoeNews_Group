package com.moenews.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("news")
public class News extends BaseEntity {
    private String title;
    private String summary;
    private String content;
    private String coverImage;
    private Long categoryId;
    private Long authorId;
    private Integer status;
    private Long viewCount;
}
