package com.moenews.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.moenews.common.Result;
import com.moenews.dto.CommentRequest;
import com.moenews.dto.PageQuery;
import com.moenews.service.CommentService;
import com.moenews.service.NewsService;
import com.moenews.vo.CommentVO;
import com.moenews.vo.NewsVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class NewsController {
    private final NewsService newsService;
    private final CommentService commentService;

    @GetMapping("/news")
    public Result<IPage<NewsVO>> list(PageQuery query) {
        return Result.ok(newsService.pageNews(query, true));
    }

    @GetMapping("/news/{id}")
    public Result<NewsVO> detail(@PathVariable Long id) {
        return Result.ok(newsService.detail(id, true));
    }

    @GetMapping("/news/{newsId}/comments")
    public Result<IPage<CommentVO>> comments(@PathVariable Long newsId, PageQuery query) {
        return Result.ok(commentService.pageFront(newsId, query));
    }

    @PostMapping("/news/{newsId}/comments")
    public Result<CommentVO> comment(@PathVariable Long newsId, @Valid @RequestBody CommentRequest request) {
        return Result.ok(commentService.create(newsId, request));
    }

    @DeleteMapping("/comments/{id}")
    public Result<Void> deleteOwnComment(@PathVariable Long id) {
        commentService.deleteOwn(id);
        return Result.ok();
    }
}
