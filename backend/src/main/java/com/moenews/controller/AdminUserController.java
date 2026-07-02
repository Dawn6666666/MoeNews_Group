package com.moenews.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.moenews.common.Result;
import com.moenews.dto.PageQuery;
import com.moenews.dto.PasswordResetRequest;
import com.moenews.dto.StatusRequest;
import com.moenews.dto.UserRequest;
import com.moenews.service.UserService;
import com.moenews.vo.UserVO;
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
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
public class AdminUserController {
    private final UserService userService;

    @GetMapping
    public Result<IPage<UserVO>> list(PageQuery query) {
        return Result.ok(userService.pageUsers(query));
    }

    @PostMapping
    public Result<UserVO> create(@Valid @RequestBody UserRequest request) {
        return Result.ok(userService.createUser(request));
    }

    @PutMapping("/{id}")
    public Result<UserVO> update(@PathVariable Long id, @Valid @RequestBody UserRequest request) {
        return Result.ok(userService.updateUser(id, request, false));
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        userService.deleteUser(id);
        return Result.ok();
    }

    @PutMapping("/{id}/status")
    public Result<Void> status(@PathVariable Long id, @Valid @RequestBody StatusRequest request) {
        userService.updateStatus(id, request.getStatus());
        return Result.ok();
    }

    @PutMapping("/{id}/password")
    public Result<Void> password(@PathVariable Long id, @Valid @RequestBody PasswordResetRequest request) {
        userService.resetPassword(id, request);
        return Result.ok();
    }
}
