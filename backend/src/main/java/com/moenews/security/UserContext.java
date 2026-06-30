package com.moenews.security;

public class UserContext {
    private static final ThreadLocal<LoginUser> LOCAL = new ThreadLocal<>();

    public static void set(LoginUser user) {
        LOCAL.set(user);
    }

    public static LoginUser get() {
        return LOCAL.get();
    }

    public static Long userId() {
        LoginUser user = get();
        return user == null ? null : user.getId();
    }

    public static boolean isAdmin() {
        LoginUser user = get();
        return user != null && "ADMIN".equals(user.getRole());
    }

    public static void clear() {
        LOCAL.remove();
    }
}
