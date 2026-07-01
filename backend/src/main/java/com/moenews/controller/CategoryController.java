package com.moenews.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.moenews.common.Result;
import com.moenews.entity.NewsCategory;
import com.moenews.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {
    private final CategoryService categoryService;

    @GetMapping
    public Result<List<NewsCategory>> enabledCategories() {
        return Result.ok(categoryService.list(new LambdaQueryWrapper<NewsCategory>()
                .eq(NewsCategory::getStatus, 1)
                .orderByAsc(NewsCategory::getSort)));
    }
}
