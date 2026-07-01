package com.moenews.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.moenews.dto.PageQuery;
import com.moenews.dto.PasswordResetRequest;
import com.moenews.dto.UserRequest;
import com.moenews.entity.User;
import com.moenews.exception.BizException;
import com.moenews.mapper.UserMapper;
import com.moenews.security.UserContext;
import com.moenews.vo.UserVO;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class UserService extends ServiceImpl<UserMapper, User> {
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public User findByUsername(String username) {
        return getOne(new LambdaQueryWrapper<User>().eq(User::getUsername, username));
    }

    public IPage<UserVO> pageUsers(PageQuery query) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<User>()
                .like(StringUtils.hasText(query.getKeyword()), User::getUsername, query.getKeyword())
                .eq(StringUtils.hasText(query.getRole()), User::getRole, query.getRole())
                .eq(query.getStatus() != null, User::getStatus, query.getStatus())
                .orderByDesc(User::getCreateTime);
        return page(new Page<>(query.getPage(), query.getSize()), wrapper).convert(UserVO::of);
    }

    public UserVO createUser(UserRequest request) {
        if (!StringUtils.hasText(request.getUsername())) {
            throw new BizException("用户名不能为空");
        }
        if (!StringUtils.hasText(request.getPassword())) {
            throw new BizException("密码不能为空");
        }
        if (findByUsername(request.getUsername()) != null) {
            throw new BizException("用户名已存在");
        }
        validateRoleAndStatus(request.getRole(), request.getStatus());
        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        fillEditable(user, request);
        save(user);
        return UserVO.of(user);
    }

    public UserVO updateUser(Long id, UserRequest request, boolean selfOnly) {
        User user = requireUser(id);
        if (selfOnly && !id.equals(UserContext.userId())) {
            throw new BizException(403, "只能修改自己的资料");
        }
        user.setNickname(request.getNickname());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        if (!selfOnly) {
            validateRoleAndStatus(request.getRole(), request.getStatus());
            user.setRole(request.getRole());
            user.setStatus(request.getStatus());
        }
        updateById(user);
        return UserVO.of(user);
    }

    public void deleteUser(Long id) {
        if (id.equals(UserContext.userId())) {
            throw new BizException("管理员不能删除当前登录账号");
        }
        requireUser(id);
        removeById(id);
    }

    public void updateStatus(Long id, Integer status) {
        if (id.equals(UserContext.userId()) && status == 0) {
            throw new BizException("不能禁用当前登录账号");
        }
        validateStatus(status);
        User user = requireUser(id);
        user.setStatus(status);
        updateById(user);
    }

    public void resetPassword(Long id, PasswordResetRequest request) {
        User user = requireUser(id);
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        updateById(user);
    }

    public User requireUser(Long id) {
        User user = getById(id);
        if (user == null) {
            throw new BizException("用户不存在");
        }
        return user;
    }

    public BCryptPasswordEncoder passwordEncoder() {
        return passwordEncoder;
    }

    private void fillEditable(User user, UserRequest request) {
        user.setNickname(request.getNickname());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setRole(StringUtils.hasText(request.getRole()) ? request.getRole() : "USER");
        user.setStatus(request.getStatus() == null ? 1 : request.getStatus());
    }

    private void validateRoleAndStatus(String role, Integer status) {
        if (!"ADMIN".equals(role) && !"USER".equals(role)) {
            throw new BizException("用户角色不合法");
        }
        validateStatus(status);
    }

    private void validateStatus(Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            throw new BizException("状态值不合法");
        }
    }
}
