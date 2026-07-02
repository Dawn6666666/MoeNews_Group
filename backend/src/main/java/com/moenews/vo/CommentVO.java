package com.moenews.vo;

import com.moenews.entity.NewsComment;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CommentVO {
    private Long id;
    private Long newsId;
    private String newsTitle;
    private Long userId;
    private String nickname;
    private String content;
    private Integer status;
    private LocalDateTime createTime;

    public static CommentVO of(NewsComment comment) {
        CommentVO vo = new CommentVO();
        vo.setId(comment.getId());
        vo.setNewsId(comment.getNewsId());
        vo.setUserId(comment.getUserId());
        vo.setContent(comment.getContent());
        vo.setStatus(comment.getStatus());
        vo.setCreateTime(comment.getCreateTime());
        return vo;
    }
}
