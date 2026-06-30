package com.moenews.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.moenews.common.Result;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@RequiredArgsConstructor
public class AuthInterceptor implements HandlerInterceptor {
    private final JwtUtil jwtUtil;
    private final ObjectMapper objectMapper;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }
        String path = request.getRequestURI();
        boolean publicGet = "GET".equalsIgnoreCase(request.getMethod())
                && (path.equals("/api/categories") || path.equals("/api/news") || path.matches("/api/news/\\d+") || path.matches("/api/news/\\d+/comments"));
        boolean publicAuth = path.equals("/api/auth/register") || path.equals("/api/auth/login") || path.equals("/api/auth/logout");
        if (publicAuth || publicGet) {
            return true;
        }
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        try {
            LoginUser user = jwtUtil.parse(token);
            if (path.startsWith("/api/admin") && !"ADMIN".equals(user.getRole())) {
                write(response, Result.fail(403, "无后台访问权限"));
                return false;
            }
            UserContext.set(user);
            return true;
        } catch (Exception e) {
            write(response, Result.fail(401, "请先登录"));
            return false;
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        UserContext.clear();
    }

    private void write(HttpServletResponse response, Result<Void> result) throws Exception {
        response.setStatus(200);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}
