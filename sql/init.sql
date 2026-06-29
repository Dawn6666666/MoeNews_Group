CREATE DATABASE IF NOT EXISTS moenews DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE moenews;

DROP TABLE IF EXISTS news_comment;
DROP TABLE IF EXISTS news;
DROP TABLE IF EXISTS news_category;
DROP TABLE IF EXISTS user;

CREATE TABLE user (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(100) NOT NULL,
  nickname VARCHAR(50) NOT NULL,
  email VARCHAR(100) NULL,
  phone VARCHAR(20) NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'USER',
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted TINYINT NOT NULL DEFAULT 0,
  UNIQUE KEY uk_user_username (username),
  KEY idx_user_role (role),
  KEY idx_user_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE news_category (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NULL,
  sort INT NOT NULL DEFAULT 0,
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted TINYINT NOT NULL DEFAULT 0,
  UNIQUE KEY uk_category_name (name),
  KEY idx_category_status (status),
  KEY idx_category_sort (sort)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE news (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(150) NOT NULL,
  summary VARCHAR(500) NULL,
  content MEDIUMTEXT NOT NULL,
  cover_image VARCHAR(255) NULL,
  category_id BIGINT NOT NULL,
  author_id BIGINT NOT NULL,
  status TINYINT NOT NULL DEFAULT 0,
  view_count BIGINT NOT NULL DEFAULT 0,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_news_title (title),
  KEY idx_news_category (category_id),
  KEY idx_news_author (author_id),
  KEY idx_news_status (status),
  KEY idx_news_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE news_comment (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  news_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  content VARCHAR(500) NOT NULL,
  status TINYINT NOT NULL DEFAULT 1,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted TINYINT NOT NULL DEFAULT 0,
  KEY idx_comment_news (news_id),
  KEY idx_comment_user (user_id),
  KEY idx_comment_status (status),
  KEY idx_comment_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO user (username, password, nickname, role, status) VALUES
('admin', '$2a$10$j0R.JHtEqs5J37OxGzGO9OvDZeLTiOdCe95W.eAOuc3Fd8mDAUidC', '系统管理员', 'ADMIN', 1),
('user', '$2a$10$j0R.JHtEqs5J37OxGzGO9OvDZeLTiOdCe95W.eAOuc3Fd8mDAUidC', '普通用户', 'USER', 1);

INSERT INTO news_category (name, description, sort, status) VALUES
('校园新闻', '校园动态与通知', 10, 1),
('科技资讯', '科技行业新闻', 20, 1),
('生活周边', '生活服务与趣闻', 30, 1);

INSERT INTO news (title, summary, content, category_id, author_id, status, view_count) VALUES
('欢迎访问Moenews', 'MoeNews 是一个基于 Spring Boot + Vue 3 的新闻发布与管理系统，融汇二次元美学与现代前后端分离架构，旨在让新闻管理变得轻松、友好与高效。', '# 欢迎访问 MoeNews 萌系新闻发布与管理系统

> **"让每一条新闻都带着温度发布。"** —— MoeNews 品牌宣言

MoeNews 是一个融合了现代微服务设计思想与二次元萌系视觉美学的新闻发布与管理平台。它不仅是一项功能完备的业务系统，更是一次探索人性化交互与内容创作乐趣的尝试。

---

## 品牌释义与定位

为了打破传统企业级管理系统冰冷、沉闷的界面局限，MoeNews 在设计之初便赋予了其鲜明的品牌个性：

| 品牌部分 | 核心内涵 | 业务投射 |
| :--- | :--- | :--- |
| **Moe** | 日语“萌え”，象征可爱、亲和力、生命力与温暖感 | 采用柔和的配色方案、趣味微动效以及极具亲和力的交互反馈 |
| **News** | 新闻，代表系统核心的信息承载与发布功能 | 支持完整的 Markdown 正文、敏捷检索、多级分类与高拟真读者互动 |

合二为一，**MoeNews** 的宗旨就是 **“让新闻管理变得轻松愉悦且充满温度”**。我们致力于将枯燥的后台操作转化为一种舒适的内容创作与信息共享旅程。

---

## 核心设计理念

### 1. 二次元美学与高水准视觉体验
系统在色调选择上彻底规避了高饱和度、刺眼的传统红绿蓝配色，采用了柔和且兼具时尚感的冰粉、天蓝等渐变色系；在组件使用上，通过阴影微调与圆角优化，使之拥有极强的卡片流式美感。

### 2. 双端联动架构体系
MoeNews 采用前后端分离的主流技术路线进行构建：
- **后端**：基于 Java 开发语言，采用轻量级 Spring Boot 框架进行企业级业务解耦，确保数据接口的高并发处理能力与卓越的系统稳定性。
- **前端**：依托 Vue 3 进行高性能单页面构建，引入 Pinia 作为全局状态管理器，并借助 Naive UI 组件库实现快速、响应式的动态渲染。

### 3. 便捷高效的 Markdown 创作流
系统深度集成了 Markdown 编辑器，允许管理员在后台使用标准的排版语法轻松产出包含代码高亮、精美表格及业务流程图等在内的长文正文，大幅降低了排版编辑成本。

---

感谢您体验 MoeNews。无论是作为内容发布者还是普通读者，我们都希望能带给您轻松、友好且高效的数字内容交互新体验！', 1, 1, 1, 0);
