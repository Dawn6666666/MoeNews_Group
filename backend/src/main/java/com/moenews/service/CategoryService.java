package com.moenews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.moenews.dto.CategoryRequest;
import com.moenews.dto.PageQuery;
import com.moenews.entity.News;
import com.moenews.entity.NewsCategory;
import com.moenews.exception.BizException;
import com.moenews.mapper.NewsCategoryMapper;
import com.moenews.mapper.NewsMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class CategoryService extends ServiceImpl<NewsCategoryMapper, NewsCategory> {
    private final NewsMapper newsMapper;

    public IPage<NewsCategory> pageCategories(PageQuery query) {
        return page(new Page<>(query.getPage(), query.getSize()),
                new LambdaQueryWrapper<NewsCategory>()
                        .like(StringUtils.hasText(query.getKeyword()), NewsCategory::getName, query.getKeyword())
                        .eq(query.getStatus() != null, NewsCategory::getStatus, query.getStatus())
                        .orderByAsc(NewsCategory::getSort)
                        .orderByDesc(NewsCategory::getCreateTime));
    }

    public NewsCategory create(CategoryRequest request) {
        ensureNameUnique(request.getName(), null);
        NewsCategory category = new NewsCategory();
        fill(category, request);
        save(category);
        return category;
    }

    public NewsCategory update(Long id, CategoryRequest request) {
        NewsCategory category = requireCategory(id);
        ensureNameUnique(request.getName(), id);
        fill(category, request);
        updateById(category);
        return category;
    }

    public void delete(Long id) {
        requireCategory(id);
        // 分类下已有新闻时拒绝删除，避免后台误删后新闻失去分类归属。
        Long newsCount = newsMapper.selectCount(new LambdaQueryWrapper<News>().eq(News::getCategoryId, id));
        if (newsCount > 0) {
            throw new BizException("分类下存在新闻，不能删除");
        }
        removeById(id);
    }

    public void updateStatus(Long id, Integer status) {
        validateStatus(status);
        NewsCategory category = requireCategory(id);
        category.setStatus(status);
        updateById(category);
    }

    public NewsCategory requireEnabled(Long id) {
        NewsCategory category = requireCategory(id);
        if (category.getStatus() == 0) {
            throw new BizException("分类已禁用");
        }
        return category;
    }

    public NewsCategory requireCategory(Long id) {
        NewsCategory category = getById(id);
        if (category == null) {
            throw new BizException("分类不存在");
        }
        return category;
    }

    private void ensureNameUnique(String name, Long excludeId) {
        NewsCategory exists = getOne(new LambdaQueryWrapper<NewsCategory>().eq(NewsCategory::getName, name));
        if (exists != null && !exists.getId().equals(excludeId)) {
            throw new BizException("分类名称已存在");
        }
    }

    private void fill(NewsCategory category, CategoryRequest request) {
        validateStatus(request.getStatus());
        category.setName(request.getName());
        category.setDescription(request.getDescription());
        category.setSort(request.getSort() == null ? 0 : request.getSort());
        category.setStatus(request.getStatus());
    }

    private void validateStatus(Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            throw new BizException("分类状态不合法");
        }
    }
}
