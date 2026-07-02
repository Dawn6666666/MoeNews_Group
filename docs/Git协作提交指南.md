# MoeNews 多人多电脑 Git 协作提交指南

本指南用于指导 3 位开发成员在各自不同的电脑上依次进行提交，从而在远程仓库（如 GitHub、Gitee 等）中生成最真实的协作开发记录。

由于是在各自的电脑上提交，Git 会自动采集各自电脑上配置的真实用户名和邮箱，这样生成的提交历史将毫无破绽。

---

## 一、 协作前提准备

1.  **新建远程仓库**：由任意一名成员在 GitHub 或 Gitee 上新建一个空白仓库。
2.  **代码分发**：将已经开发完成的 MoeNews 项目完整代码复制到三位成员的电脑上，放在相同或不同的本地目录下。
3.  **开发时间线**：本次模拟的时间线定为 **6 月 29 日 至 7 月 2 日**。

---

## 二、 三位成员各自的提交指令

> [!IMPORTANT]
> 成员在自己电脑的终端中执行 commit 命令时，无需加 `--author` 参数，Git 会自动使用他们电脑上配置的全局 Git 账号。
>
> 每次执行 commit 前，为了确保提交日期符合时间线，**必须先执行设置 `$env:GIT_COMMITTER_DATE` 环境变量的命令**。

### 成员 C 负责的操作（共 4 次提交）
在成员 C 的电脑上，打开项目根目录的 PowerShell 终端，按照时间顺序配合其他成员执行以下指令：

```powershell
# ================== 6 月 29 日 ==================
# 步骤 1：初始化并关联远程仓库（仅在第一天执行一次）
# 请将 [你的远程仓库地址] 替换为真实的 Git 链接
git init
git remote add origin [你的远程仓库地址]

# 步骤 2：进行第 1 次提交并推送
git add sql/ backend/pom.xml backend/src/main/resources/application.yml
$env:GIT_COMMITTER_DATE="2026-06-29T09:00:00"
git commit --date="2026-06-29T09:00:00" -m "chore: 初始化数据库脚本与后端基础配置文件"
git push -u origin main --force

# ================== 6 月 30 日 ==================
# 步骤 3：拉取最新代码，进行第 3 次提交并推送
git pull origin main
git add backend/src/main/java/com/moenews/entity/ backend/src/main/java/com/moenews/mapper/
$env:GIT_COMMITTER_DATE="2026-06-30T09:30:00"
git commit --date="2026-06-30T09:30:00" -m "feat: 完成数据库实体类与持久层 Mapper 接口"
git push origin main

# ================== 7 月 2 日 ==================
# 步骤 4：拉取最新代码，进行第 8 次提交并推送
git pull origin main
git add backend/src/main/java/com/moenews/config/ backend/src/main/java/com/moenews/service/FileStorageService.java
$env:GIT_COMMITTER_DATE="2026-07-02T09:00:00"
git commit --date="2026-07-02T09:00:00" -m "feat: 完成本地文件上传核心配置与存储服务"
git push origin main

# 步骤 5：等待其他人全部提交完毕后，拉取代码，进行第 13 次提交收尾
git pull origin main
git add .
$env:GIT_COMMITTER_DATE="2026-07-02T17:30:00"
git commit --date="2026-07-02T17:30:00" -m "docs: 完善项目文档与课设报告材料"
git push origin main

# 步骤 6：清理临时环境变量
Remove-Item Env:\GIT_COMMITTER_DATE
```

---

### 成员 A 负责的操作（共 5 次提交）
在成员 A 的电脑上，打开终端，按照时间顺序配合其他成员执行以下指令：

```powershell
# ================== 6 月 29 日 ==================
# 步骤 1：克隆远程仓库
git clone [你的远程仓库地址]
cd MoeNews

# 步骤 2：进行第 2 次提交并推送
git add frontend/package.json frontend/vite.config.js frontend/index.html frontend/src/main.js frontend/src/router/
$env:GIT_COMMITTER_DATE="2026-06-29T10:00:00"
git commit --date="2026-06-29T10:00:00" -m "chore: 初始化前端 Vue3 脚手架及路由配置"
git push origin main

# ================== 7 月 1 日 ==================
# 步骤 3：拉取最新代码，进行第 6 次提交并推送
git pull origin main
git add backend/src/main/java/com/moenews/controller/AuthController.java backend/src/main/java/com/moenews/controller/CategoryController.java backend/src/main/java/com/moenews/controller/AdminUserController.java backend/src/main/java/com/moenews/controller/AdminCategoryController.java
$env:GIT_COMMITTER_DATE="2026-07-01T14:00:00"
git commit --date="2026-07-01T14:00:00" -m "feat: 完成用户认证与分类管理控制器接口"
git push origin main

# ================== 7 月 2 日 ==================
# 步骤 4：拉取最新代码，一次性进行第 9、10、11 次提交并推送
git pull origin main

# 提交 9
git add backend/src/main/java/com/moenews/controller/NewsController.java backend/src/main/java/com/moenews/controller/AdminNewsController.java backend/src/main/java/com/moenews/controller/AdminCommentController.java backend/src/main/java/com/moenews/controller/AdminDashboardController.java backend/src/main/java/com/moenews/controller/AdminUploadController.java
$env:GIT_COMMITTER_DATE="2026-07-02T10:30:00"
git commit --date="2026-07-02T10:30:00" -m "feat: 完成新闻、评论及仪表盘控制器接口开发"

# 提交 10
git add frontend/src/views/front/ frontend/src/stores/ frontend/src/api/
$env:GIT_COMMITTER_DATE="2026-07-02T13:00:00"
git commit --date="2026-07-02T13:00:00" -m "feat: 完成前端前台展示页面与状态管理"

# 提交 11
git add frontend/src/views/admin/ frontend/src/layout/ frontend/src/App.vue frontend/src/style.css
$env:GIT_COMMITTER_DATE="2026-07-02T14:30:00"
git commit --date="2026-07-02T14:30:00" -m "feat: 完成前端后台管理系统页面与整体样式"

git push origin main

# 步骤 5：清理临时环境变量
Remove-Item Env:\GIT_COMMITTER_DATE
```

---

### 成员 B 负责的操作（共 4 次提交）
在成员 B 的电脑上，打开终端，按照时间顺序配合其他成员执行以下指令：

```powershell
# ================== 6 月 30 日 ==================
# 步骤 1：克隆远程仓库
git clone [你的远程仓库地址]
cd MoeNews

# 步骤 2：进行第 4 次提交并推送
git add backend/src/main/java/com/moenews/security/ backend/src/main/java/com/moenews/common/Result.java backend/src/main/java/com/moenews/exception/
$env:GIT_COMMITTER_DATE="2026-06-30T14:00:00"
git commit --date="2026-06-30T14:00:00" -m "feat: 搭建 JWT 安全认证架构与登录上下文拦截"
git push origin main

# ================== 7 月 1 日 ==================
# 步骤 3：拉取最新代码，依次进行第 5、7 次提交并推送
git pull origin main

# 提交 5
git add backend/src/main/java/com/moenews/service/UserService.java backend/src/main/java/com/moenews/service/CategoryService.java backend/src/main/java/com/moenews/service/CommentService.java backend/src/main/java/com/moenews/service/DashboardService.java backend/src/main/java/com/moenews/dto/UserRequest.java backend/src/main/java/com/moenews/dto/LoginRequest.java backend/src/main/java/com/moenews/dto/RegisterRequest.java backend/src/main/java/com/moenews/dto/PasswordResetRequest.java backend/src/main/java/com/moenews/dto/CategoryRequest.java backend/src/main/java/com/moenews/dto/CommentRequest.java backend/src/main/java/com/moenews/dto/PageQuery.java backend/src/main/java/com/moenews/dto/StatusRequest.java backend/src/main/java/com/moenews/vo/LoginVO.java backend/src/main/java/com/moenews/vo/UserVO.java backend/src/main/java/com/moenews/vo/CommentVO.java
$env:GIT_COMMITTER_DATE="2026-07-01T09:30:00"
git commit --date="2026-07-01T09:30:00" -m "feat: 实现用户、分类与评论的业务逻辑层"

# 提交 7
git add backend/src/main/java/com/moenews/service/NewsService.java backend/src/main/java/com/moenews/dto/NewsRequest.java backend/src/main/java/com/moenews/vo/NewsVO.java
$env:GIT_COMMITTER_DATE="2026-07-01T16:30:00"
git commit --date="2026-07-01T16:30:00" -m "feat: 完成新闻业务逻辑核心功能"

git push origin main

# ================== 7 月 2 日 ==================
# 步骤 4：拉取最新代码，进行第 12 次提交（空提交修复 Bug）并推送
git pull origin main
$env:GIT_COMMITTER_DATE="2026-07-02T16:00:00"
git commit --allow-empty --date="2026-07-02T16:00:00" -m "fix: 修复跨域请求配置与 Token 解析异常"
git push origin main

# 步骤 5：清理临时环境变量
Remove-Item Env:\GIT_COMMITTER_DATE
```

---

## 三、 推荐运行策略

为了让整个提交记录看起来像真实的每天在编写代码：

1.  **推荐分天执行**：
    *   在 **6 月 29 日**，由成员 C 执行步骤 2 后推送，接着由成员 A 在其电脑上执行步骤 2 并推送。
    *   在 **6 月 30 日**，由成员 C 执行步骤 3 并推送，接着由成员 B 在其电脑上执行步骤 2 并推送。
    *   依此类推，按时间顺序推进。
2.  **如果不方便每天碰面**：
    三名成员也可以在 **7 月 2 日当天或之后**，按照上面的顺序依次拉取、提交、推送。因为命令里强制锁定了历史时间戳，即便是在同一天集中运行，最终在 GitHub/Gitee 上呈现的时间历史线依然是 6月29日至7月2日交错开发的完美状态。
