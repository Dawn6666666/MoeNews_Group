package com.moenews.vo;

import com.moenews.entity.News;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NewsVO {
    private Long id;
    private String title;
    private String summary;
    private String content;
    private String coverImage;
    private Long categoryId;
    private String categoryName;
    private Long authorId;
    private String authorName;
    private Integer status;
    private Long viewCount;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    public static NewsVO of(News news) {
        NewsVO vo = new NewsVO();
        vo.setId(news.getId());
        vo.setTitle(news.getTitle());
        vo.setSummary(news.getSummary());
        vo.setContent(news.getContent());
        vo.setCoverImage(news.getCoverImage());
        vo.setCategoryId(news.getCategoryId());
        vo.setAuthorId(news.getAuthorId());
        vo.setStatus(news.getStatus());
        vo.setViewCount(news.getViewCount());
        vo.setCreateTime(news.getCreateTime());
        vo.setUpdateTime(news.getUpdateTime());
        return vo;
    }
}
