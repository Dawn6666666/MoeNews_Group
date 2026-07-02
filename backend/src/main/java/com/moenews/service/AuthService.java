package com.moenews.service;

import com.moenews.dto.LoginRequest;
import com.moenews.dto.RegisterRequest;
import com.moenews.dto.UserRequest;
import com.moenews.entity.User;
import com.moenews.exception.BizException;
import com.moenews.security.JwtUtil;
import com.moenews.security.UserContext;
import com.moenews.vo.LoginVO;
import com.moenews.vo.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserService userService;
    private final JwtUtil jwtUtil;

    public UserVO register(RegisterRequest request) {
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new BizException("两次密码不一致");
        }
        UserRequest userRequest = new UserRequest();
        userRequest.setUsername(request.getUsername());
        userRequest.setPassword(request.getPassword());
        userRequest.setNickname(request.getNickname());
        userRequest.setRole("USER");
        userRequest.setStatus(1);
        return userService.createUser(userRequest);
    }

    public LoginVO login(LoginRequest request) {
        User user = userService.findByUsername(request.getUsername());
        if (user == null || !userService.passwordEncoder().matches(request.getPassword(), user.getPassword())) {
            throw new BizException("用户名或密码错误");
        }
        if (user.getStatus() == 0) {
            throw new BizException("账号已被禁用");
        }
        String token = jwtUtil.createToken(user.getId(), user.getUsername(), user.getRole());
        return new LoginVO(token, UserVO.of(user));
    }

    public UserVO me() {
        return UserVO.of(userService.requireUser(UserContext.userId()));
    }
}
