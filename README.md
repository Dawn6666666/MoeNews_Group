# MoeNews 新闻发布与管理系统

MoeNews 是一个基于 Spring Boot 和 Vue 3 的新闻发布与管理系统，包含前台新闻浏览、用户登录注册、评论发布，以及后台用户、分类、新闻、评论、上传和统计管理功能。

本项目用于 Java 企业级开发课程设计，采用前后端分离架构。

## 技术栈

后端：

- Spring Boot 3.2.4
- Spring Web
- Spring Validation
- MyBatis-Plus
- MySQL 8.0
- JWT
- BCrypt
- Lombok

前端：

- Vue 3
- Vite
- Vue Router
- Pinia
- Axios
- Naive UI
- md-editor-v3

## 项目结构

```text
MoeNews
├── backend              后端 Spring Boot 项目
├── frontend             前端 Vue 3 + Vite 项目
├── sql                  数据库初始化脚本
├── docs                 课程设计任务书及补充文档
├── uploads              本地上传目录，运行时生成，不提交 Git
├── 需求文档.md
└── 环境信息.md
```

## 主要功能

- 用户注册、登录、退出、获取当前用户信息
- JWT 登录认证和自定义拦截器权限控制
- 前台新闻列表、搜索、分类筛选、新闻详情
- Markdown 新闻正文展示
- 登录用户发表评论、删除自己的评论
- 后台用户管理、启用禁用、重置密码
- 后台新闻分类管理
- 后台新闻发布、编辑、上下架、删除
- 后台评论查询、显示隐藏、删除
- 新闻封面图片上传
- 后台首页统计

## 快速启动

### 1. 初始化数据库

确保 MySQL 8.0 已启动，然后执行：

```powershell
& 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe' --default-character-set=utf8mb4 -uroot -p114514 -e "source D:/Code/IDEA/MoeNews/sql/init.sql"
```

默认数据库名为 `moenews`。

#### 1.1 导入高拟真演示测试数据（推荐用于答辩演示）

如果需要为列表分页、模糊检索、分类筛选及评论系统快速填充 124 篇极具校园氛围的测试数据，请在执行完数据库初始化后运行：

```powershell
& 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe' --default-character-set=utf8mb4 -uroot -p114514 -e "source D:/Code/IDEA/MoeNews/sql/seed_data.sql"
```

该脚本包含 124 篇真实排版的新闻（涵盖代码块、Mermaid 流程图、表格与 189 张轮询封面）以及多轮拟真的读者评论。首篇置顶新闻为项目品牌与技术选型介绍，非常适合答辩现场展示。

### 2. 启动后端

```powershell
cd D:\Code\IDEA\MoeNews\backend
& 'D:\Jetbrains\IntelliJ IDEA 2025.2.4\plugins\maven\lib\maven3\bin\mvn.cmd' spring-boot:run
```

后端地址：

```text
http://localhost:8080
```

### 3. 启动前端

```powershell
cd D:\Code\IDEA\MoeNews\frontend
npm.cmd install
npm.cmd run dev
```

前端地址：

```text
http://127.0.0.1:5173
```

## 默认账号

| 角色 | 用户名 | 密码 |
| --- | --- | --- |
| 管理员 | admin | 123456 |
| 普通用户 | user | 123456 |

## 验证命令

后端编译：

```powershell
cd D:\Code\IDEA\MoeNews\backend
& 'D:\Jetbrains\IntelliJ IDEA 2025.2.4\plugins\maven\lib\maven3\bin\mvn.cmd' -DskipTests compile
```

前端构建：

```powershell
cd D:\Code\IDEA\MoeNews\frontend
npm.cmd run build
```

## 运行说明

- 上传文件保存在 `uploads/` 目录。
- 数据库只保存图片访问路径，不保存图片二进制内容。
- 前端通过 `http://localhost:8080/api` 请求后端接口。
- 后台接口路径以 `/api/admin` 开头，仅管理员可访问。
- 普通用户可以访问新闻列表、新闻详情、评论列表，登录后可以发表评论和删除自己的评论。
