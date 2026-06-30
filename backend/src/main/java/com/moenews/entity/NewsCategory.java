package com.moenews.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("news_category")
public class NewsCategory extends BaseEntity {
    private String name;
    private String description;
    private Integer sort;
    private Integer status;
}
