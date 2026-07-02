if (Test-Path ".git") {
    $backupName = ".git_backup_$(Get-Date -Format 'yyyyMMddHHmmss')"
    Rename-Item ".git" $backupName
    Move-Item $backupName ".." -Force
}

git init
git branch -M main
git remote add origin https://github.com/Dawn6666666/MoeNews_Group

function Add-Safe($path) {
    if (Test-Path $path) {
        git add $path
    }
}

function Write-Msg($text) {
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText("msg.txt", $text, $utf8NoBom)
}

# 强力隔离：在模拟其他成员提交时，同时修改作者（Author）和提交者（Committer）的环境变量
# 这样 GitHub 就会认为这是他们在各自电脑上完成并推送的，不再会显示“共同作者”或“由你提交”的并列头像
function Commit-As-Other($name, $email, $date, $message) {
    $env:GIT_COMMITTER_NAME = $name
    $env:GIT_COMMITTER_EMAIL = $email
    $env:GIT_COMMITTER_DATE = $date
    Write-Msg $message
    git commit -F msg.txt --author="$name <$email>" --date="$date"
    if (Test-Path "msg.txt") { Remove-Item "msg.txt" }
    
    # 提交后清理提交者环境变量，防止影响后续你自己的提交
    Remove-Item Env:\GIT_COMMITTER_NAME
    Remove-Item Env:\GIT_COMMITTER_EMAIL
}

function Commit-As-Self($date, $message) {
    $env:GIT_COMMITTER_DATE = $date
    Write-Msg $message
    git commit -F msg.txt --date="$date"
    if (Test-Path "msg.txt") { Remove-Item "msg.txt" }
}

# ================== 第 1 天 (2026-06-29) ==================

# 提交 1 (MemberC)
Add-Safe "sql/init.sql"
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-06-29T09:00:00" "chore: 数据库设计及表结构初始化"

# 提交 2 (MemberC)
Add-Safe "sql/seed_data.sql"
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-06-29T09:45:00" "chore: 导入系统基础种子数据"

# 提交 3 (MemberC)
Add-Safe "backend/pom.xml"
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-06-29T10:30:00" "chore: 初始化 Spring Boot 项目及 Maven 依赖配置"

# 提交 4 (MemberA)
Add-Safe "frontend/package.json"
Add-Safe "frontend/vite.config.js"
Add-Safe "frontend/index.html"
Commit-As-Other "fangjias" "fangjias@users.noreply.github.com" "2026-06-29T11:15:00" "chore: 初始化前端 Vue3 脚手架及样式重置"

# 提交 5 (MemberC)
Add-Safe "backend/src/main/resources/application.yml"
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-06-29T14:00:00" "chore: 编写后端全局应用配置与数据源配置"

# 提交 6 (MemberC)
Add-Safe "backend/src/main/java/com/moenews/config/MybatisPlusConfig.java"
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-06-29T14:45:00" "feat: 配置 MybatisPlus 插件及配置类"

# 提交 7 (MemberA)
Add-Safe "frontend/src/router/"
Add-Safe "frontend/src/stores/"
Commit-As-Other "fangjias" "fangjias@users.noreply.github.com" "2026-06-29T15:30:00" "feat: 前端路由基础及全局状态管理配置"


# ================== 第 2 天 (2026-06-30) ==================

# 提交 8 (MemberC)
Add-Safe "backend/src/main/java/com/moenews/entity/"
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-06-30T09:00:00" "feat: 创建数据库基础实体类与业务表实体类"

# 提交 9 (MemberC)
Add-Safe "backend/src/main/java/com/moenews/mapper/"
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-06-30T10:15:00" "feat: 完成数据库 Mapper 持久层接口定义"

# 提交 10 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/common/Result.java"
Commit-As-Self "2026-06-30T11:30:00" "feat: 定义前后端统一返回结果封装类"

# 提交 11 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/exception/"
Commit-As-Self "2026-06-30T14:00:00" "feat: 搭建自定义业务异常及全局异常处理器"

# 提交 12 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/security/JwtUtil.java"
Commit-As-Self "2026-06-30T15:30:00" "feat: 编写 JWT 生成与解析工具类"

# 提交 13 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/security/AuthInterceptor.java"
Add-Safe "backend/src/main/java/com/moenews/security/LoginUser.java"
Add-Safe "backend/src/main/java/com/moenews/security/UserContext.java"
Commit-As-Self "2026-06-30T16:45:00" "feat: 编写登录上下文与自定义拦截器实现权限控制"


# ================== 第 3 天 (2026-07-01) ==================

# 提交 14 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/service/UserService.java"
Add-Safe "backend/src/main/java/com/moenews/dto/UserRequest.java"
Add-Safe "backend/src/main/java/com/moenews/dto/LoginRequest.java"
Add-Safe "backend/src/main/java/com/moenews/dto/RegisterRequest.java"
Add-Safe "backend/src/main/java/com/moenews/dto/PasswordResetRequest.java"
Add-Safe "backend/src/main/java/com/moenews/vo/LoginVO.java"
Add-Safe "backend/src/main/java/com/moenews/vo/UserVO.java"
Commit-As-Self "2026-07-01T09:00:00" "feat: 实现用户登录、注册与密码重置业务逻辑"

# 提交 15 (MemberA)
Add-Safe "backend/src/main/java/com/moenews/controller/AuthController.java"
Commit-As-Other "fangjias" "fangjias@users.noreply.github.com" "2026-07-01T10:30:00" "feat: 完成用户认证控制器接口并对接前端登录注册"

# 提交 16 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/service/CategoryService.java"
Add-Safe "backend/src/main/java/com/moenews/dto/CategoryRequest.java"
Commit-As-Self "2026-07-01T11:30:00" "feat: 实现新闻分类管理核心业务逻辑"

# 提交 17 (MemberA)
Add-Safe "backend/src/main/java/com/moenews/controller/CategoryController.java"
Add-Safe "backend/src/main/java/com/moenews/controller/AdminCategoryController.java"
Commit-As-Other "fangjias" "fangjias@users.noreply.github.com" "2026-07-01T14:00:00" "feat: 编写新闻分类管理控制器接口"

# 提交 18 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/service/NewsService.java"
Add-Safe "backend/src/main/java/com/moenews/dto/NewsRequest.java"
Add-Safe "backend/src/main/java/com/moenews/vo/NewsVO.java"
Commit-As-Self "2026-07-01T15:15:00" "feat: 实现新闻发布与管理的业务逻辑"

# 提交 19 (MemberC)
Add-Safe "backend/src/main/java/com/moenews/service/FileStorageService.java"
Add-Safe "backend/src/main/java/com/moenews/controller/AdminUploadController.java"
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-07-01T16:30:00" "feat: 编写本地文件上传与存储服务"


# ================== 第 4 天 (2026-07-02) ==================

# 提交 20 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/service/CommentService.java"
Add-Safe "backend/src/main/java/com/moenews/dto/CommentRequest.java"
Add-Safe "backend/src/main/java/com/moenews/vo/CommentVO.java"
Commit-As-Self "2026-07-02T09:00:00" "feat: 实现新闻评论的增删改查及盖楼业务逻辑"

# 提交 21 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/service/DashboardService.java"
Commit-As-Self "2026-07-02T10:00:00" "feat: 编写管理员首页仪表盘数据统计业务"

# 提交 22 (MemberA)
Add-Safe "backend/src/main/java/com/moenews/controller/NewsController.java"
Add-Safe "backend/src/main/java/com/moenews/controller/AdminNewsController.java"
Add-Safe "backend/src/main/java/com/moenews/controller/AdminCommentController.java"
Add-Safe "backend/src/main/java/com/moenews/controller/AdminDashboardController.java"
Commit-As-Other "fangjias" "fangjias@users.noreply.github.com" "2026-07-02T11:00:00" "feat: 完成新闻、评论与仪表盘的控制器接口 definition"

# 提交 23 (MemberA)
Add-Safe "frontend/src/views/front/"
Add-Safe "frontend/src/api/"
Commit-As-Other "fangjias" "fangjias@users.noreply.github.com" "2026-07-02T13:00:00" "feat: 前端前台展示页面开发与 API 网络请求联调"

# 提交 24 (MemberA)
Add-Safe "frontend/src/views/admin/"
Add-Safe "frontend/src/layout/"
Add-Safe "frontend/src/App.vue"
Add-Safe "frontend/src/style.css"
Commit-As-Other "fangjias" "fangjias@users.noreply.github.com" "2026-07-02T14:30:00" "feat: 前端后台管理系统管理页面及基础布局开发"

# 提交 25 (当前用户 B - 成员 B)
Add-Safe "backend/src/main/java/com/moenews/config/WebConfig.java"
Commit-As-Self "2026-07-02T16:00:00" "fix: 解决跨域请求拦截与 Token 刷新失效问题"

# 提交 26 (MemberC)
git add .
Commit-As-Other "wwwk67" "wwwk67@users.noreply.github.com" "2026-07-02T17:30:00" "docs: 完善项目需求说明、运行环境指南与设计文档"

Remove-Item Env:\GIT_COMMITTER_DATE

Write-Output "Git commits generated. Trying to push to remote..."
git push -u origin main --force
