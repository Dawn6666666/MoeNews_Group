package com.moenews.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.Date;

@Component
public class JwtUtil {
    @Value("${moenews.jwt.secret}")
    private String secret;

    @Value("${moenews.jwt.expire}")
    private long expireSeconds;

    public String createToken(Long userId, String username, String role) {
        Instant now = Instant.now();
        return JWT.create()
                .withSubject(String.valueOf(userId))
                .withClaim("username", username)
                .withClaim("role", role)
                .withIssuedAt(Date.from(now))
                .withExpiresAt(Date.from(now.plusSeconds(expireSeconds)))
                .sign(Algorithm.HMAC256(secret));
    }

    public LoginUser parse(String token) {
        DecodedJWT jwt = JWT.require(Algorithm.HMAC256(secret)).build().verify(token);
        return new LoginUser(Long.valueOf(jwt.getSubject()), jwt.getClaim("username").asString(), jwt.getClaim("role").asString());
    }
}
