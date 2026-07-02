package com.moenews.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.moenews.common.Result;
import com.moenews.dto.PageQuery;
import com.moenews.dto.StatusRequest;
import com.moenews.service.CommentService;
import com.moenews.vo.CommentVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/comments")
@RequiredArgsConstructor
public class AdminCommentController {
    private final CommentService commentService;

    @GetMapping
    public Result<IPage<CommentVO>> list(PageQuery query) {
        return Result.ok(commentService.pageAdmin(query));
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        commentService.deleteAdmin(id);
        return Result.ok();
    }

    @PutMapping("/{id}/status")
    public Result<Void> status(@PathVariable Long id, @Valid @RequestBody StatusRequest request) {
        commentService.updateStatus(id, request.getStatus());
        return Result.ok();
    }
}
