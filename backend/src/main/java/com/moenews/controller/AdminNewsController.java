package com.moenews.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.moenews.common.Result;
import com.moenews.dto.NewsRequest;
import com.moenews.dto.PageQuery;
import com.moenews.dto.StatusRequest;
import com.moenews.service.NewsService;
import com.moenews.vo.NewsVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/news")
@RequiredArgsConstructor
public class AdminNewsController {
    private final NewsService newsService;

    @GetMapping
    public Result<IPage<NewsVO>> list(PageQuery query) {
        return Result.ok(newsService.pageNews(query, false));
    }

    @GetMapping("/{id}")
    public Result<NewsVO> detail(@PathVariable Long id) {
        return Result.ok(newsService.detail(id, false));
    }

    @PostMapping
    public Result<NewsVO> create(@Valid @RequestBody NewsRequest request) {
        return Result.ok(newsService.create(request));
    }

    @PutMapping("/{id}")
    public Result<NewsVO> update(@PathVariable Long id, @Valid @RequestBody NewsRequest request) {
        return Result.ok(newsService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        newsService.delete(id);
        return Result.ok();
    }

    @PutMapping("/{id}/status")
    public Result<Void> status(@PathVariable Long id, @Valid @RequestBody StatusRequest request) {
        newsService.updateStatus(id, request.getStatus());
        return Result.ok();
    }
}
