package com.moenews.controller;

import com.moenews.common.Result;
import com.moenews.dto.LoginRequest;
import com.moenews.dto.RegisterRequest;
import com.moenews.dto.UserRequest;
import com.moenews.security.UserContext;
import com.moenews.service.AuthService;
import com.moenews.service.UserService;
import com.moenews.vo.LoginVO;
import com.moenews.vo.UserVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;
    private final UserService userService;

    @PostMapping("/register")
    public Result<UserVO> register(@Valid @RequestBody RegisterRequest request) {
        return Result.ok(authService.register(request));
    }

    @PostMapping("/login")
    public Result<LoginVO> login(@Valid @RequestBody LoginRequest request) {
        return Result.ok(authService.login(request));
    }

    @PostMapping("/logout")
    public Result<Void> logout() {
        return Result.ok();
    }

    @GetMapping("/me")
    public Result<UserVO> me() {
        return Result.ok(authService.me());
    }

    @PutMapping("/me")
    public Result<UserVO> updateMe(@Valid @RequestBody UserRequest request) {
        return Result.ok(userService.updateUser(UserContext.userId(), request, true));
    }
}
