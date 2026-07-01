package com.moenews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.moenews.dto.NewsRequest;
import com.moenews.dto.PageQuery;
import com.moenews.entity.News;
import com.moenews.entity.NewsCategory;
import com.moenews.entity.User;
import com.moenews.exception.BizException;
import com.moenews.mapper.NewsMapper;
import com.moenews.security.UserContext;
import com.moenews.vo.NewsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class NewsService extends ServiceImpl<NewsMapper, News> {
    private final CategoryService categoryService;
    private final UserService userService;

    public IPage<NewsVO> pageNews(PageQuery query, boolean frontOnly) {
        LambdaQueryWrapper<News> wrapper = new LambdaQueryWrapper<News>()
                .like(StringUtils.hasText(query.getKeyword()), News::getTitle, query.getKeyword())
                .eq(query.getCategoryId() != null, News::getCategoryId, query.getCategoryId())
                .eq(frontOnly, News::getStatus, 1)
                .eq(!frontOnly && query.getStatus() != null, News::getStatus, query.getStatus())
                .orderByDesc(News::getCreateTime);
        return page(new Page<>(query.getPage(), query.getSize()), wrapper).convert(news -> enrich(NewsVO.of(news), !frontOnly));
    }

    public NewsVO detail(Long id, boolean front) {
        News news = requireNews(id);
        if (front && news.getStatus() != 1) {
            throw new BizException("新闻不存在或未发布");
        }
        if (front) {
            // 前台详情访问时增加浏览量，列表接口不增加，避免翻页造成虚高。
            news.setViewCount(news.getViewCount() + 1);
            updateById(news);
        }
        return enrich(NewsVO.of(news), true);
    }

    public NewsVO create(NewsRequest request) {
        validateStatus(request.getStatus());
        categoryService.requireEnabled(request.getCategoryId());
        News news = new News();
        fill(news, request);
        news.setAuthorId(UserContext.userId());
        news.setViewCount(0L);
        save(news);
        return enrich(NewsVO.of(news), true);
    }

    public NewsVO update(Long id, NewsRequest request) {
        validateStatus(request.getStatus());
        categoryService.requireEnabled(request.getCategoryId());
        News news = requireNews(id);
        fill(news, request);
        updateById(news);
        return enrich(NewsVO.of(news), true);
    }

    public void updateStatus(Long id, Integer status) {
        validateStatus(status);
        News news = requireNews(id);
        news.setStatus(status);
        updateById(news);
    }

    public void delete(Long id) {
        requireNews(id);
        removeById(id);
    }

    public long countByCategory(Long categoryId) {
        return count(new LambdaQueryWrapper<News>().eq(News::getCategoryId, categoryId));
    }

    public News requireNews(Long id) {
        News news = getById(id);
        if (news == null) {
            throw new BizException("新闻不存在");
        }
        return news;
    }

    private void fill(News news, NewsRequest request) {
        news.setTitle(request.getTitle());
        news.setSummary(request.getSummary());
        news.setContent(request.getContent());
        news.setCoverImage(request.getCoverImage());
        news.setCategoryId(request.getCategoryId());
        news.setStatus(request.getStatus());
    }

    private NewsVO enrich(NewsVO vo, boolean includeContent) {
        NewsCategory category = categoryService.getById(vo.getCategoryId());
        User author = userService.getById(vo.getAuthorId());
        vo.setCategoryName(category == null ? null : category.getName());
        vo.setAuthorName(author == null ? null : author.getNickname());
        if (!includeContent) {
            vo.setContent(null);
        }
        return vo;
    }

    private void validateStatus(Integer status) {
        if (status == null || status < 0 || status > 2) {
            throw new BizException("新闻状态不合法");
        }
    }
}
