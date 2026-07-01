package com.moenews.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UserRequest {
    private String username;
    private String password;

    @NotBlank(message = "昵称不能为空")
    private String nickname;

    private String email;
    private String phone;
    private String role;
    private Integer status;
}
