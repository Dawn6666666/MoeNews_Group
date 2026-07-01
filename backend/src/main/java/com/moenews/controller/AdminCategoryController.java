package com.moenews.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.moenews.common.Result;
import com.moenews.dto.CategoryRequest;
import com.moenews.dto.PageQuery;
import com.moenews.dto.StatusRequest;
import com.moenews.entity.NewsCategory;
import com.moenews.service.CategoryService;
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
@RequestMapping("/api/admin/categories")
@RequiredArgsConstructor
public class AdminCategoryController {
    private final CategoryService categoryService;

    @GetMapping
    public Result<IPage<NewsCategory>> list(PageQuery query) {
        return Result.ok(categoryService.pageCategories(query));
    }

    @PostMapping
    public Result<NewsCategory> create(@Valid @RequestBody CategoryRequest request) {
        return Result.ok(categoryService.create(request));
    }

    @PutMapping("/{id}")
    public Result<NewsCategory> update(@PathVariable Long id, @Valid @RequestBody CategoryRequest request) {
        return Result.ok(categoryService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        categoryService.delete(id);
        return Result.ok();
    }

    @PutMapping("/{id}/status")
    public Result<Void> status(@PathVariable Long id, @Valid @RequestBody StatusRequest request) {
        categoryService.updateStatus(id, request.getStatus());
        return Result.ok();
    }
}
