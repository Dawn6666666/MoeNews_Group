package com.moenews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.moenews.dto.CommentRequest;
import com.moenews.dto.PageQuery;
import com.moenews.entity.News;
import com.moenews.entity.NewsComment;
import com.moenews.entity.User;
import com.moenews.exception.BizException;
import com.moenews.mapper.NewsCommentMapper;
import com.moenews.security.UserContext;
import com.moenews.vo.CommentVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class CommentService extends ServiceImpl<NewsCommentMapper, NewsComment> {
    private final NewsService newsService;
    private final UserService userService;

    public IPage<CommentVO> pageAdmin(PageQuery query) {
        LambdaQueryWrapper<NewsComment> wrapper = new LambdaQueryWrapper<NewsComment>()
                .like(StringUtils.hasText(query.getKeyword()), NewsComment::getContent, query.getKeyword())
                .eq(query.getStatus() != null, NewsComment::getStatus, query.getStatus())
                .orderByDesc(NewsComment::getCreateTime);
        return page(new Page<>(query.getPage(), query.getSize()), wrapper).convert(this::enrich);
    }

    public IPage<CommentVO> pageFront(Long newsId, PageQuery query) {
        newsService.requireNews(newsId);
        return page(new Page<>(query.getPage(), query.getSize()),
                new LambdaQueryWrapper<NewsComment>()
                        .eq(NewsComment::getNewsId, newsId)
                        .eq(NewsComment::getStatus, 1)
                        .orderByDesc(NewsComment::getCreateTime)).convert(this::enrich);
    }

    public CommentVO create(Long newsId, CommentRequest request) {
        News news = newsService.requireNews(newsId);
        if (news.getStatus() != 1) {
            throw new BizException("只能评论已发布新闻");
        }
        NewsComment comment = new NewsComment();
        comment.setNewsId(newsId);
        comment.setUserId(UserContext.userId());
        comment.setContent(request.getContent());
        comment.setStatus(1);
        save(comment);
        return enrich(comment);
    }

    public void deleteOwn(Long id) {
        NewsComment comment = requireComment(id);
        if (!comment.getUserId().equals(UserContext.userId())) {
            throw new BizException(403, "只能删除自己的评论");
        }
        removeById(id);
    }

    public void deleteAdmin(Long id) {
        requireComment(id);
        removeById(id);
    }

    public void updateStatus(Long id, Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            throw new BizException("评论状态不合法");
        }
        NewsComment comment = requireComment(id);
        comment.setStatus(status);
        updateById(comment);
    }

    private NewsComment requireComment(Long id) {
        NewsComment comment = getById(id);
        if (comment == null) {
            throw new BizException("评论不存在");
        }
        return comment;
    }

    private CommentVO enrich(NewsComment comment) {
        CommentVO vo = CommentVO.of(comment);
        User user = userService.getById(comment.getUserId());
        News news = newsService.getById(comment.getNewsId());
        vo.setNickname(user == null ? null : user.getNickname());
        vo.setNewsTitle(news == null ? null : news.getTitle());
        return vo;
    }
}
