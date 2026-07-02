package com.moenews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.moenews.entity.News;
import com.moenews.entity.NewsCategory;
import com.moenews.entity.NewsComment;
import com.moenews.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class DashboardService {
    private final UserService userService;
    private final CategoryService categoryService;
    private final NewsService newsService;
    private final CommentService commentService;

    public Map<String, Long> statistics() {
        return Map.of(
                "userCount", userService.count(new LambdaQueryWrapper<User>()),
                "newsCount", newsService.count(new LambdaQueryWrapper<News>()),
                "categoryCount", categoryService.count(new LambdaQueryWrapper<NewsCategory>()),
                "commentCount", commentService.count(new LambdaQueryWrapper<NewsComment>()),
                "publishedNewsCount", newsService.count(new LambdaQueryWrapper<News>().eq(News::getStatus, 1)),
                "draftNewsCount", newsService.count(new LambdaQueryWrapper<News>().eq(News::getStatus, 0)),
                "offlineNewsCount", newsService.count(new LambdaQueryWrapper<News>().eq(News::getStatus, 2))
        );
    }
}
