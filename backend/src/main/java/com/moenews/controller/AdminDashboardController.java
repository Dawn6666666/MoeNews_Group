package com.moenews.controller;

import com.moenews.common.Result;
import com.moenews.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/admin/dashboard")
@RequiredArgsConstructor
public class AdminDashboardController {
    private final DashboardService dashboardService;

    @GetMapping("/statistics")
    public Result<Map<String, Long>> statistics() {
        return Result.ok(dashboardService.statistics());
    }
}
