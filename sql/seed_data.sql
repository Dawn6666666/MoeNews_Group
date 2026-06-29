-- MoeNews 补充测试数据脚本
-- 使用前请先执行 sql/init.sql 创建数据库和基础表。
-- 本脚本可重复执行：每次执行会先清理上一轮由 seed_ 用户发表的所有测试数据及相应分类。

USE moenews;

SET NAMES utf8mb4;
SET @seed_password = '$2a$10$j0R.JHtEqs5J37OxGzGO9OvDZeLTiOdCe95W.eAOuc3Fd8mDAUidC';

-- 先清理旧测试数据，避免多次执行后数据重复。
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE news_comment;
TRUNCATE TABLE news;
TRUNCATE TABLE news_category;
SET FOREIGN_KEY_CHECKS = 1;

DELETE FROM user
WHERE username LIKE 'seed_%';

-- 用户数据：覆盖管理员、普通用户、启用、禁用等场景。
INSERT INTO user (username, password, nickname, email, phone, role, status, create_time, update_time) VALUES
('seed_admin_ops', @seed_password, '运营管理员', 'ops@moenews.test', '13800001001', 'ADMIN', 1, DATE_SUB(NOW(), INTERVAL 80 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('seed_admin_audit', @seed_password, '审核管理员', 'audit@moenews.test', '13800001002', 'ADMIN', 1, DATE_SUB(NOW(), INTERVAL 70 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('seed_admin_disabled', @seed_password, '停用管理员', 'disabled-admin@moenews.test', '13800001003', 'ADMIN', 0, DATE_SUB(NOW(), INTERVAL 60 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('seed_user_01', @seed_password, '晨间读者', 'reader01@moenews.test', '13800002001', 'USER', 1, DATE_SUB(NOW(), INTERVAL 55 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('seed_user_02', @seed_password, '校园观察员', 'reader02@moenews.test', '13800002002', 'USER', 1, DATE_SUB(NOW(), INTERVAL 53 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('seed_user_03', @seed_password, '技术同学', 'reader03@moenews.test', '13800002003', 'USER', 1, DATE_SUB(NOW(), INTERVAL 51 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('seed_user_04', @seed_password, '社团小编', 'reader04@moenews.test', '13800002004', 'USER', 1, DATE_SUB(NOW(), INTERVAL 49 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('seed_user_05', @seed_password, '图书馆常客', 'reader05@moenews.test', '13800002005', 'USER', 1, DATE_SUB(NOW(), INTERVAL 47 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('seed_user_06', @seed_password, '竞赛达人', 'reader06@moenews.test', '13800002006', 'USER', 1, DATE_SUB(NOW(), INTERVAL 45 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY)),
('seed_user_07', @seed_password, '实习记录者', 'reader07@moenews.test', '13800002007', 'USER', 1, DATE_SUB(NOW(), INTERVAL 43 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),
('seed_user_08', @seed_password, '摄影爱好者', 'reader08@moenews.test', '13800002008', 'USER', 1, DATE_SUB(NOW(), INTERVAL 41 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY)),
('seed_user_09', @seed_password, '运动打卡人', 'reader09@moenews.test', '13800002009', 'USER', 1, DATE_SUB(NOW(), INTERVAL 39 DAY), DATE_SUB(NOW(), INTERVAL 9 DAY)),
('seed_user_10', @seed_password, '后勤体验官', 'reader10@moenews.test', '13800002010', 'USER', 1, DATE_SUB(NOW(), INTERVAL 37 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
('seed_user_11', @seed_password, '毕业生代表', 'reader11@moenews.test', '13800002011', 'USER', 1, DATE_SUB(NOW(), INTERVAL 35 DAY), DATE_SUB(NOW(), INTERVAL 11 DAY)),
('seed_user_12', @seed_password, '夜读同学', 'reader12@moenews.test', '13800002012', 'USER', 1, DATE_SUB(NOW(), INTERVAL 33 DAY), DATE_SUB(NOW(), INTERVAL 12 DAY)),
('seed_user_disabled_01', @seed_password, '禁用读者一号', 'disabled01@moenews.test', '13800002901', 'USER', 0, DATE_SUB(NOW(), INTERVAL 31 DAY), DATE_SUB(NOW(), INTERVAL 13 DAY)),
('seed_user_disabled_02', @seed_password, '禁用读者二号', 'disabled02@moenews.test', '13800002902', 'USER', 0, DATE_SUB(NOW(), INTERVAL 29 DAY), DATE_SUB(NOW(), INTERVAL 14 DAY));

-- 分类数据：覆盖启用、禁用、排序、专题类目等场景。
INSERT INTO news_category (name, description, sort, status, create_time, update_time) VALUES
('校园', '校园通知、院系动态、迎新毕业等内容', 101, 1, DATE_SUB(NOW(), INTERVAL 45 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('科技', '软件、硬件、人工智能与实验室成果', 102, 1, DATE_SUB(NOW(), INTERVAL 44 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('社团', '学生社团、讲座、志愿活动与文化节', 103, 1, DATE_SUB(NOW(), INTERVAL 43 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('就业', '招聘、实习、校友经验和职业发展', 104, 1, DATE_SUB(NOW(), INTERVAL 42 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('竞赛', '学科竞赛、创新创业和获奖资讯', 105, 1, DATE_SUB(NOW(), INTERVAL 41 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('生活', '食堂、宿舍、交通、服务与校园生活', 106, 1, DATE_SUB(NOW(), INTERVAL 40 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY)),
('公告', '系统公告、维护通知和重要提醒', 107, 1, DATE_SUB(NOW(), INTERVAL 39 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),
('人物', '教师、学生、校友人物故事', 108, 1, DATE_SUB(NOW(), INTERVAL 38 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY)),
('学术', '前沿学术报告、科研成果、名师风采', 109, 1, DATE_SUB(NOW(), INTERVAL 37 DAY), DATE_SUB(NOW(), INTERVAL 9 DAY)),
('文体', '校园体育赛事、艺术节、十佳歌手等', 110, 1, DATE_SUB(NOW(), INTERVAL 36 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),
('风光', '校园四季美景、摄影作品、打卡攻略', 111, 1, DATE_SUB(NOW(), INTERVAL 35 DAY), DATE_SUB(NOW(), INTERVAL 11 DAY)),
('实践', '社会实践、三下乡、志愿服务活动记录', 112, 1, DATE_SUB(NOW(), INTERVAL 34 DAY), DATE_SUB(NOW(), INTERVAL 12 DAY)),
('归档', '历史归档分类，当前禁用', 201, 0, DATE_SUB(NOW(), INTERVAL 33 DAY), DATE_SUB(NOW(), INTERVAL 13 DAY)),
('测试禁用', '用于验证禁用分类不能发布新闻', 202, 0, DATE_SUB(NOW(), INTERVAL 32 DAY), DATE_SUB(NOW(), INTERVAL 14 DAY));

DROP TEMPORARY TABLE IF EXISTS seed_news_blueprint;
CREATE TEMPORARY TABLE seed_news_blueprint (
  category_name VARCHAR(50) NOT NULL,
  author_username VARCHAR(50) NOT NULL,
  title VARCHAR(150) NOT NULL,
  summary VARCHAR(500) NOT NULL,
  status TINYINT NOT NULL,
  view_count BIGINT NOT NULL,
  days_ago INT NOT NULL,
  detail_content TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 新闻数据：status 0=草稿，1=已发布，2=已下架。覆盖多个分类、作者、时间和浏览量。
INSERT INTO seed_news_blueprint (category_name, author_username, title, summary, status, view_count, days_ago, detail_content) VALUES
-- 校园 (12篇)
('校园', 'admin', '欢迎访问Moenews', 'MoeNews 是一个基于 Spring Boot + Vue 3 的新闻发布与管理系统，融汇二次元美学与现代前后端分离架构，旨在让新闻管理变得轻松、友好与高效。', 1, 9853, 0, '# 欢迎访问 MoeNews 萌系新闻发布与管理系统

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

感谢您体验 MoeNews。无论是作为内容发布者还是普通读者，我们都希望能带给您轻松、友好且高效的数字内容交互新体验！'),
('校园', 'admin', '校园迎新服务站正式开放', '迎新服务站提供报到指引、校园地图、宿舍咨询和志愿者协助。', 1, 328, 1, NULL),
('校园', 'seed_admin_ops', '图书馆延长晚间开放时间', '图书馆将在考试周期间延长开放时间，方便学生复习。', 1, 286, 2, NULL),
('校园', 'seed_admin_ops', '教学楼空调检修安排', '后勤部门将分区域开展教学楼空调检修，请师生留意通知。', 1, 142, 3, NULL),
('校园', 'seed_admin_audit', '校园一卡通服务升级草稿', '一卡通系统升级方案仍在整理中，暂不对外发布。', 0, 18, 4, NULL),
('校园', 'seed_admin_audit', '旧版校历通知已下架', '旧版校历通知已被新版安排替换。', 2, 91, 20, NULL),
('校园', 'admin', '第十届校园读书节开幕式举行', '图书馆策划了名师导读、经典诵读、好书互换等一系列精彩活动。', 1, 310, 4, NULL),
('校园', 'seed_admin_ops', '绿色校园：低碳出行倡议书', '学校鼓励广大师生多步行、骑共享单车，共同营造绿色低碳的校园环境。', 1, 220, 5, NULL),
('校园', 'admin', '新学期第一课：校领导深入课堂听课调研', '校领导一行深入教学一线，与同学们同上一堂课，并对教学设施及授课质量进行调研。', 1, 340, 2, NULL),
('校园', 'seed_admin_audit', '我校举行 2026 年青年骨干教师座谈会', '座谈会围绕学科建设、人才培养、教学改革等议题展开了广泛的交流与探讨。', 1, 270, 3, NULL),
('校园', 'seed_admin_ops', '关于启用新版校园综合服务门户的通知', '为了提供更加便捷的一站式业务办理，新版校园门户即日起上线试运行。', 1, 410, 4, NULL),
('校园', 'admin', '我校顺利通过省教育厅教学水平评估', '评估专家组对我校近年来的教学质量、师资力量和实践平台给予了高度评价。', 1, 560, 5, NULL),

-- 科技 (11篇)
('科技', 'admin', 'AI 实验室发布首个校园智能助手', '由我校 AI 实验室自主研发的智慧校园助理“MoeBot”今日正式上线内测，支持课程查询、场馆预约及常见问题解答。', 1, 512, 1, '# AI 实验室发布首个校园智能助手

由我校人工智能实验室自主研发的智慧校园助理 **MoeBot** 今日正式开启首批体验官内测。作为一款专为校园场景打造的智能助手，它能够无缝对接学校各方信息系统，为师生提供智能化、即时化的咨询与导引服务。

## 核心功能一览

* **智能排课与日程查询**：绑定学号后，一句话即可查询当日课程、教室位置及考试安排。
* **公共资源预约助手**：支持通过对话查询图书馆空闲座位、体育场馆预订情况，并直接完成预约。
* **校园百科即时解答**：涵盖报销流程、选课规则、宿管联系方式等上万条校园常见问题。

## 技术架构与特色

MoeBot 基于最新的检索增强生成技术构建，确保回答内容的时效性与准确性。实验室团队针对校园特定语料进行了深度微调。

以下是 MoeBot 后端的核心消息处理接口示例代码：

```python
def handle_user_message(user_id: str, message: str) -> str:
    # 检索本地校园知识库
    context = retriever.search_knowledge(message)
    # 结合大模型生成准确回复
    reply = llm.generate_response(user_id, message, context)
    return reply
```

欢迎广大师生关注实验室官方公众号参与内测申请，共同为“智慧校园”建设出谋划策！'),
('科技', 'seed_admin_ops', '软件工程课程项目展示', '多个课程项目集中展示，覆盖 Web、移动端和数据分析方向。', 1, 448, 2, NULL),
('科技', 'seed_admin_audit', '校园网络 IPv6 优化完成', '校园网络完成 IPv6 访问优化，部分区域访问速度提升。', 1, 377, 3, NULL),
('科技', 'admin', '服务器维护窗口草稿', '服务器维护时间仍待确认，暂存为草稿。', 0, 34, 5, NULL),
('科技', 'seed_admin_ops', '旧版实验室预约入口下架', '旧版预约入口已迁移到新版统一平台。', 2, 123, 28, NULL),
('科技', 'admin', '高性能计算中心完成二期扩容', '计算中心新增数十台 GPU 算力节点，为全校科研团队提供更强算力支撑。', 1, 390, 3, NULL),
('科技', 'seed_admin_audit', '大学生创客空间入驻项目路演', '创客空间举办新项目路演，多个学生团队展示了在物联网与无人机领域的创意产品。', 1, 410, 4, NULL),
('科技', 'admin', '我校团队在国际机器人挑战赛中荣获佳绩', '由计算机学院学生组成的团队，在自动避障与抓取任务中表现突出，摘得银奖。', 1, 490, 2, NULL),
('科技', 'seed_admin_ops', '软件工程专业通过教育部工程教育专业认证', '这标志着我校软件工程人才培养质量已达到国际实质等效的工程教育标准。', 1, 520, 3, NULL),
('科技', 'seed_admin_audit', '网络空间安全学院举行个人信息安全科普展', '活动通过案例展示、现场演示等方式，向师生普及密码安全与防范网络诈骗常识。', 1, 310, 4, NULL),
('科技', 'admin', '关于推进校园科研数据共享平台建设的探讨', '各学科带头人建言献策，旨在打通数据壁垒，提升科研数据的使用效能。', 1, 240, 5, NULL),

-- 社团 (11篇)
('社团', 'seed_admin_ops', '社团招新周活动预告', '社团招新周将在中心广场举行，覆盖文艺、体育、公益等方向。', 1, 263, 2, NULL),
('社团', 'seed_admin_audit', '摄影社校园影展开展', '摄影社展出校园四季主题作品，欢迎师生参观。', 1, 234, 4, NULL),
('社团', 'admin', '志愿服务队周末活动', '志愿服务队将开展社区服务和图书整理活动。', 1, 198, 5, NULL),
('社团', 'seed_admin_ops', '社团活动场地申请草稿', '场地申请规则仍在审核，暂不发布。', 0, 25, 6, NULL),
('社团', 'seed_admin_audit', '过期讲座报名链接下架', '讲座报名已结束，相关链接下架。', 2, 88, 30, NULL),
('社团', 'admin', '传统文化社团游园会活动预告', '汉服社、琴社、书法社等十余个传统文化社团联合打造古风体验游园会。', 1, 280, 3, NULL),
('社团', 'seed_admin_ops', '红十字会应急救护知识培训举行', '校红十字会开展心肺复苏及包扎急救实操培训，提升学生自救互救能力。', 1, 340, 5, NULL),
('社团', 'seed_admin_audit', '青年志愿者协会开展敬老院关爱老人活动', '志愿者为老人送去生活慰问品，并为他们整理房间、陪伴聊天、辅导手机使用。', 1, 410, 1, NULL),
('社团', 'admin', '吉他社举办“仲夏之夜”草地音乐节', '多支校园乐队在北区操场激情献唱，现场气氛热烈，吸引了数百名师生观赏。', 1, 620, 2, NULL),
('社团', 'seed_admin_ops', '辩论协会举行“思辨杯”辩论赛决赛', '双方辩手围绕“人工智能发展对就业的利弊”这一热门辩题展开了精彩交锋。', 1, 490, 3, NULL),
('社团', 'seed_admin_audit', '心理协会举办“放飞心灵”涂鸦减压体验活动', '活动鼓励同学们用画笔倾诉情绪，在创作中释放学习与生活的压力。', 1, 350, 4, NULL),

-- 就业 (11篇)
('就业', 'seed_admin_audit', '2026 届毕业生秋季联合双选会安排指南', '本次双选会吸引了超过 200 家知名企业参会，涵盖 IT、金融、制造等多个行业，特此发布参会指引。', 1, 621, 1, '# 2026 届毕业生秋季联合双选会安排指南

为促进 2026 届毕业生充分高质量就业，学校招生就业处联合省人才市场，定于下周举办秋季首场大型联合双选会。以下为本次双选会的关键信息与参会建议：

## 活动基本信息

* **时间**：2026年7月5日（周日）09:00 - 16:00
* **地点**：学校新体育馆主馆及副馆
* **规模**：参会企业约 **220家**，提供岗位超过 3000 个

## 参会建议流程

```mermaid
graph TD
    A[准备多份纸质简历] --> B[体育馆入口凭学生证安检]
    B --> C[扫描现场二维码查看企业展位分布]
    C --> D[前往目标展位沟通面谈]
    D --> E[意向登记及初试安排]
```

## 注意事项

1. **着装规范**：建议穿着得体，给面试官留下良好的第一印象。
2. **简历准备**：根据不同岗位的要求，针对性调整简历内容，现场设有“简历诊断区”提供专业指导。
3. **安全第一**：听从现场志愿者引导，避免发生拥挤。

祝各位毕业生前程似锦，顺利拿到心仪的录用信！'),
('就业', 'admin', '校友分享实习转正经验', '校友从简历准备、面试节奏和项目复盘三个角度分享经验。', 1, 470, 2, NULL),
('就业', 'seed_admin_ops', '简历门诊预约开放', '就业指导中心开放简历门诊预约，为学生提供一对一修改建议。', 1, 398, 3, NULL),
('就业', 'seed_admin_audit', '企业宣讲会排期草稿', '企业宣讲会排期仍在确认，暂不发布。', 0, 42, 5, NULL),
('就业', 'admin', '过期招聘信息下架', '相关招聘岗位已截止投递。', 2, 176, 18, NULL),
('就业', 'admin', '选调生备考经验分享交流会', '优秀校友应邀返校分享国家公务员与各省选调生的备考策略与职场体悟。', 1, 490, 2, NULL),
('就业', 'seed_admin_ops', '知名制造企业专场宣讲会安排', '数家大型先进制造企业联合举行本校专场引才宣讲会。', 1, 310, 6, NULL),
('就业', 'seed_admin_audit', '我校与本地知名科技园区签署人才战略协议', '双方将在毕业生实习基地建设、订单式培养等方向开展长期深度合作。', 1, 380, 2, NULL),
('就业', 'admin', '招生就业处举办基层就业项目政策宣讲会', '宣讲会详细解读了三支一扶、西部计划等基层服务项目的报考条件及待遇保障。', 1, 410, 3, NULL),
('就业', 'seed_admin_ops', '知名互联网企业校招负责人分享简历敲门砖', '从HR视角剖析了简历常见雷区，为大三和大四同学提出了实用修改建议。', 1, 540, 4, NULL),
('就业', 'seed_admin_audit', '校友企业联合招聘会在大学生活动中心举办', '共有三十余家校友企业提供涵盖各专业的研发、管理等五百个工作岗位。', 1, 480, 5, NULL),

-- 竞赛 (11篇)
('竞赛', 'admin', '程序设计竞赛报名启动', '程序设计竞赛报名启动，支持个人和团队报名。', 1, 534, 1, NULL),
('竞赛', 'seed_admin_ops', '创新创业训练项目立项', '创新创业训练项目完成评审，多支团队获得立项。', 1, 409, 3, NULL),
('竞赛', 'seed_admin_audit', '数学建模赛前培训安排', '赛前培训将围绕建模方法、论文写作和工具使用展开。', 1, 366, 4, NULL),
('竞赛', 'admin', '竞赛获奖名单复核草稿', '获奖名单仍在复核，暂不发布。', 0, 51, 6, NULL),
('竞赛', 'seed_admin_ops', '旧版报名规则下架', '旧版竞赛报名规则已由新版替代。', 2, 115, 24, NULL),
('竞赛', 'seed_admin_audit', '数学竞赛国赛我校学子喜报频传', '在刚刚落下帷幕的全国大学生数学竞赛中，我校参赛选手荣获多项一等奖。', 1, 520, 2, NULL),
('竞赛', 'admin', '智能汽车竞赛校内选拔赛开赛', '本届智能汽车竞赛校内选拔赛在体育馆副馆拉开帷幕，共有20支队伍同场竞技。', 1, 388, 4, NULL),
('竞赛', 'seed_admin_ops', '大学生数学建模竞赛校内选拔赛题解析会', '指导教师团队针对校内赛经典赛题进行深度剖析，讲授建模思路与论文写作方法。', 1, 310, 3, NULL),
('竞赛', 'seed_admin_audit', '我校学子在全国英语演讲大赛中斩获特等奖', '经过主题演讲和即兴问答环节的激烈较量，我校选手凭借流利的口语脱颖而出。', 1, 460, 4, NULL),
('竞赛', 'admin', '创新创业孵化基地举行入驻团队年度考核', '评审专家对入驻团队的商业前景、项目进度及答辩表现进行了综合考评。', 1, 390, 5, NULL),
('竞赛', 'seed_admin_ops', '关于开展第十一届挑战杯作品征集工作的通知', '为了遴选优秀作品参加省赛，学校即日起面向全校开展创意与科技项目征集。', 1, 410, 6, NULL),

-- 生活 (11篇)
('生活', 'seed_admin_ops', '食堂新增自助结算通道', '食堂新增自助结算通道，减少高峰期排队时间。', 1, 289, 2, NULL),
('生活', 'seed_admin_audit', '宿舍热水系统维护提醒', '宿舍热水系统将在夜间维护，请同学提前做好安排。', 1, 256, 3, NULL),
('生活', 'admin', '校园巴士运行时间调整', '校园巴士工作日早晚高峰增加班次。', 1, 331, 4, NULL),
('生活', 'seed_admin_ops', '失物招领系统优化草稿', '失物招领系统优化方案仍在测试。', 0, 39, 7, NULL),
('生活', 'seed_admin_audit', '临时维修通知下架', '临时维修已完成，通知下架。', 2, 109, 16, NULL),
('生活', 'seed_admin_ops', '校园快递驿站高峰期服务优化', '快递驿站通过增设自助出库终端，极大缓解了下课期间的排队压力。', 1, 360, 2, NULL),
('生活', 'admin', '校医院夏季防暑降温健康宣教', '校医院提醒广大师生注意防暑降温，运动后及时补充电解质水分。', 1, 240, 4, NULL),
('生活', 'seed_admin_audit', '后勤处开展食堂食品安全专项大检查', '检查组对食材采购台账、后厨卫生、餐具消毒等关键环节进行了逐一排查。', 1, 310, 2, NULL),
('生活', 'seed_admin_ops', '关于南区宿舍区增设智能充电桩的公告', '为解决电瓶车充电安全隐患，南区各宿舍楼下已安装并启用共享充电桩。', 1, 420, 3, NULL),
('生活', 'admin', '校园绿化升级：樱花大道景观补栽工作完成', '绿化部门对干枯树木进行了清理，并补栽了多株优质樱花苗木。', 1, 290, 4, NULL),
('生活', 'seed_admin_audit', '校医院发布夏季常见传染病预防健康提示', '针对夏季多发肠道疾病，校医院向广大师生科普了科学饮食与卫生习惯。', 1, 350, 5, NULL),

-- 公告 (11篇)
('公告', 'admin', '关于调整 2026 年夏季作息时间的通知', '为保证教学工作顺利进行，结合日照时间变化，学校决定自 7 月 1 日起调整作息时间。', 1, 187, 1, '# 关于调整 2026 年夏季作息时间的通知

各院、系、各部门、直属单位：

结合夏季日照时间增长的实际情况，为合理安排师生教学与作息时间，经学校研究决定，自 **2026年7月1日** 起，开始执行夏季作息时间。现将调整后的作息时间表公布如下：

## 夏季作息时间对照表

| 作息环节 | 时间安排 | 说明 |
| :--- | :--- | :--- |
| **起床** | 06:30 | 宿舍楼大门开启 |
| **上午第一节课** | 08:00 - 08:45 | 请提前10分钟进教室 |
| **上午第二节课** | 08:50 - 09:35 | |
| **大课间/广播操**| 09:35 - 10:05 | 鼓励师生前往操场锻炼 |
| **午休/午餐** | 12:00 - 14:00 | 食堂高峰期建议错峰就餐 |
| **下午第一节课** | 14:30 - 15:15 | 下午上课时间整体推迟30分钟 |
| **熄灯** | 23:00 | 宿舍楼实行晚间门禁 |

请各教学单位认真做好教学计划调整对接工作，后勤保障部门做好班车、食堂及教学楼自习室的运营时间同步微调。

校长办公室  
2026年6月27日'),
('公告', 'seed_admin_ops', '账号安全提醒', '请用户定期检查密码安全，不要向他人泄露登录信息。', 1, 233, 2, NULL),
('公告', 'seed_admin_audit', '图片上传规范说明', '新闻封面建议使用横向图片，文件大小不超过 2MB。', 1, 202, 3, NULL),
('公告', 'admin', '后台菜单调整草稿', '后台菜单调整方案仍在评估。', 0, 44, 5, NULL),
('公告', 'seed_admin_ops', '旧维护公告下架', '旧维护公告已过期，下架归档。', 2, 70, 25, NULL),
('公告', 'admin', '关于开展教学区消防演练的通知', '为提升师生防火防灾意识，保卫处定于本周四在第一教学楼开展消防演习。', 1, 450, 1, NULL),
('公告', 'seed_admin_audit', '主教学楼弱电井维护断网公告', '因弱电井例行维护检修，主教学楼网络将短暂中断30分钟。', 1, 210, 3, NULL),
('公告', 'admin', '关于 2026 年暑期放假及值班安排的通知', '学校公布了暑期放假时间、安全检查要求以及各部门暑期值班电话表。', 1, 520, 1, NULL),
('公告', 'seed_admin_ops', '关于主教学楼电梯例行安全检测暂停使用的通知', '为保障电梯运行安全，特种设备检测院定于本周五对电梯进行年检。', 1, 280, 2, NULL),
('公告', 'seed_admin_audit', '关于开展校园消防安全隐患大排查的通知', '学校安全工作委员会将深入实验室、宿舍、食堂开展地毯式安全检查。', 1, 390, 3, NULL),
('公告', 'admin', '关于做好夏季防汛防台风安全防御工作的通知', '气象部门预警有强降雨，学校要求各部门落实防汛物资并排查排水管道。', 1, 330, 4, NULL),

-- 人物 (9篇)
('人物', 'seed_admin_audit', '优秀校友专访：从校园社团到创业先锋', '本期人物专访，我们邀请到了我校 2020 届毕业生张明，分享他从计算机社团社长到科技公司创始人的奋斗历程。', 1, 390, 2, '# 优秀校友专访：从校园社团到创业先锋

> “在大学里，最宝贵的财富不是你拿到了多少分，而是你勇于尝试过多少种可能。” 
> —— 2020届优秀毕业生、极客科技创始人张明

本期《校园人物》栏目带大家走近张明。作为曾经的“校园明星程序员”，他在校期间曾担任计算机协会会长，带领团队斩获多项国家级学科竞赛一等奖。

## 从协会的一行代码开始

谈及创业的起点，张明坦言这起源于协会里一次帮同学们解决“选课卡顿”的开源项目尝试。正是那个项目让他意识到，技术只有转化为服务用户的产品，才能产生真正的价值。

## 给学弟学妹的几点建议

1. **筑牢专业基石**：专业课是内功，算法和数据结构决定了能走多远。
2. **多参与实践**：不要只做理论推导，多动手写代码、做项目。
3. **培养团队协作**：现在的软件开发不是单兵作战，沟通和合作至关重要。

如今，张明创立的极客科技已完成 B 轮融资，业务涵盖工业物联网与智能制造。他表示，公司将持续对母校提供实习绿色通道，欢迎各位技术扎实的学弟学妹加盟。'),
('人物', 'admin', '青年教师课堂观察', '青年教师围绕课程设计和课堂互动分享教学心得。', 1, 342, 4, NULL),
('人物', 'seed_admin_ops', '校友创业访谈', '校友讲述从校园项目到创业团队的成长过程。', 1, 421, 6, NULL),
('人物', 'admin', '教学名师：潜心教书育人的科研行者', '本期名师风采带大家认识化学学院的李教授，听他讲述教书育人三十载的感悟。', 1, 430, 3, NULL),
('人物', 'seed_admin_audit', '退役大学生士兵：戎装虽褪本色不改', '分享我校三位退役复学大学生士兵的励志故事，展现他们从军营到校园的青春担当。', 1, 410, 5, NULL),
('人物', 'admin', '十佳大学生风采：在奉献中绽放青春的志愿者', '报道了我校优秀青年志愿者的先进事迹，讲述他累计服务时长超五百小时的故事。', 1, 390, 2, NULL),
('人物', 'seed_admin_audit', '青年科研先锋：把研究写在祖国大地上的年轻教授', '讲述了我校微电子学院青年教授在关键核心芯片研发中的攻关历程。', 1, 470, 3, NULL),
('人物', 'seed_admin_ops', '三好学生标兵：用自律与坚持书写奋斗人生的学霸', '分享了她连续三年绩点专业第一、斩获多项国家级竞赛奖项的秘诀。', 1, 520, 4, NULL),
('人物', 'admin', '校友风采：深耕新能源行业的实干开拓者', '讲述了我校2012届优秀校友在储能与光伏电池研发领域的创业与奋斗足迹。', 1, 380, 5, NULL),

-- 学术 (9篇)
('学术', 'admin', '高水平学术报告：大语言模型的未来趋势', '本期前沿学术讲座邀请到了行业知名专家，共同探讨生成式 AI 以及大语言模型的最新研究成果与未来演进方向。', 1, 620, 1, '# 高水平学术报告：大语言模型的未来趋势

为了给广大师生提供一个了解前沿科技的窗口，信息科学与技术学院本周特邀国际著名 AI 学者开展主题为“大语言模型的演进与下一代通用智能”的学术报告。

## 报告信息

* **报告人**：周教授（博士生导师）
* **时间**：2026年7月3日（周五） 15:00 - 17:00
* **地点**：学术报告厅一号厅
* **内容概要**：本次报告将重点探讨大语言模型（LLM）的参数扩展极限、检索增强生成（RAG）技术的最新研究进展以及具身智能的未来结合趋势。

## 大语言模型演进阶段

1. **预训练阶段**：通过海量无监督数据进行词语预测，学习通用世界知识。
2. **微调阶段（SFT）**：基于人类高质量问答对进行指令对齐，使模型可对话。
3. **强化学习对齐（RLHF）**：根据人类偏好反馈进行强化学习，确保模型生成安全且符合人类逻辑的回答。

以下是大模型在处理简单推理时的注意力机制加权伪代码展示：

```python
import numpy as np

def scaled_dot_product_attention(query, key, value):
    # 计算注意力得分
    matmul_qk = np.matmul(query, key.T)
    # 缩放因子
    d_k = query.shape[-1]
    scaled_attention_logits = matmul_qk / np.sqrt(d_k)
    # 进行 Softmax 归一化
    attention_weights = softmax(scaled_attention_logits)
    # 加权输出
    output = np.matmul(attention_weights, value)
    return output, attention_weights
```

欢迎广大对计算机视觉、自然语言处理和人工智能方向感兴趣的本科生、研究生和教师前往现场交流。'),
('学术', 'seed_admin_audit', '重点实验室科研成果在国际顶刊发表', '我校先进材料实验室在纳米催学剂领域取得突破，研究成果已在国际顶级学术期刊在线发表。', 1, 310, 4, NULL),
('学术', 'admin', '年度杰出青年学者评选结果公示', '经过院系推荐与专家严格评审，学校公布了本年度十位杰出青年学者名单并开始公示。', 1, 480, 5, NULL),
('学术', 'seed_admin_ops', '研究生学术论坛投稿指南', '为促进研究生学术交流，第八届研究生学术论坛面向全校师生开展征稿，特发布指南。', 0, 12, 6, NULL),
('学术', 'admin', '上学期学术沙龙录像回顾下架', '因沙龙视频版权及平台空间清理，上学期的学术讲座回顾视频已下架归档。', 2, 70, 30, NULL),
('学术', 'seed_admin_audit', '学术报告：超导材料的前沿突破与产业前景', '材料科学与工程学院特邀国家杰出青年基金获得者，为师生带来超导前沿讲座。', 1, 410, 1, NULL),
('学术', 'admin', '我校与省社科院联合举办城市可持续发展论坛', '论坛聚焦城市低碳转型、智慧治理等主题，多位专家发表了前沿学术观点。', 1, 380, 2, NULL),
('学术', 'seed_admin_ops', '年度国家自然科学基金项目申报动员会召开', '科研处总结了往年立项情况，并邀请评审专家分享了基金申报书的撰写经验。', 1, 490, 3, NULL),
('学术', 'admin', '关于举办学术道德与科研诚信专题讲座的通知', '讲座旨在规范研究生学术行为，树立严谨的科研诚信与学术规范风尚。', 1, 320, 4, NULL),

-- 文体 (9篇)
('文体', 'seed_admin_ops', '“青春杯”校园足球联赛决赛打响', '经过近一个月的激烈角逐，本届“青春杯”足球赛决赛将于明晚在东区体育场开战。', 1, 540, 1, NULL),
('文体', 'seed_admin_audit', '校合唱团在省级艺术展演中荣获一等奖', '我校大学生合唱团凭借出色的和声与舞台表现，荣获省级大学生艺术展演声乐组一等奖。', 1, 430, 2, NULL),
('文体', 'admin', '校园十佳歌手大赛报名开始', '备受瞩目的校园十佳歌手大赛海选阶段正式启动，欢迎各位热爱音乐的同学报名参赛，展现青春风采！', 1, 680, 3, '# 校园十佳歌手大赛报名开始

用音乐诠释青春，用歌声点亮梦想。由校团委、校学生会主办的 **“音你而来，梦想启航”** 2026年校园十佳歌手大赛海选报名通道于今日正式开启！无论你擅长流行、美声、摇滚还是说唱，这都是属于你的舞台。

## 赛事日程规划

| 比赛阶段 | 举办时间 | 地点 | 说明 |
| :--- | :--- | :--- | :--- |
| **海选阶段** | 7月10日 - 7月12日 | 大学生活动中心多功能厅 | 自备30秒无伴奏试唱 |
| **复赛阶段** | 7月18日 | 校园大礼堂 | 完整伴奏歌曲演唱，评委打分 |
| **十佳争霸赛** | 7月26日（晚） | 田径运动场 | 户外音乐会形式，决出前三强 |

## 报名参与流程

```mermaid
graph TD
    A[扫描海报二维码下载报名表] --> B[填写参赛曲目及个人信息]
    B --> C[将报名表和伴奏文件发送至学生会邮箱]
    C --> D[现场签到并获取参赛号码牌]
    D --> E[海选试唱展示]
```

## 参赛要求

* 参赛对象为我校全体在籍本科生及研究生，可以个人或组合形式参赛。
* 演唱歌曲内容要求健康向上，风格不限。
* 鼓励原创曲目，原创作品在复赛和决赛中将获得额外加分。

舞台已准备就绪，只等你的声音。快来开启属于你的音乐璀璨之旅吧！'),
('文体', 'seed_admin_ops', '文体活动中心器材借用须知草稿', '校体育部拟对体育器材借用规则进行升级，方案仍在征求意见中。', 0, 18, 5, NULL),
('文体', 'seed_admin_audit', '上届运动会精彩瞬间相册下架', '上届运动会的官方相册及精彩镜头集锦已完成归档下架。', 2, 110, 40, NULL),
('文体', 'admin', '我校在省大学生羽毛球锦标赛中包揽双冠', '男子单打和混合双打选手不畏强手，在决赛中逆转取胜，双双捧杯。', 1, 470, 1, NULL),
('文体', 'seed_admin_ops', '校园文化艺术节开幕式晚会精彩上演', '晚会汇聚了舞蹈、器乐、小品等多种艺术形式，生动展现了我校学子的青春朝气。', 1, 620, 2, NULL),
('文体', 'seed_admin_audit', '校青年交响乐团新年音乐会排练有序进行', '交响乐团利用课余时间加紧排练，力求在年底为师生呈现一场视听宴。', 1, 380, 3, NULL),
('文体', 'admin', '关于举办首届校园迷你马拉松比赛的通知', '为倡导健康生活，体育部定于下月在环校干道举办 5 公里迷你马拉松。', 1, 410, 4, NULL),

-- 风光 (9篇)
('风光', 'admin', '春华秋实：镜头下的校园四季风光', '摄影协会举办“校园四季”摄影作品展，用镜头记录晨曦、落叶、白雪与繁花，展现别样的校园之美。', 1, 890, 1, '# 春华秋实：镜头下的校园四季风光

> “我们常常在校园的道路上步履匆匆，却忽略了身边每一次日落与晨光的交替。”
> —— 摄影协会会长

摄影协会在本学期筹办了“校园四季”主题摄影展。社员们用镜头捕捉了那些熟悉角落的别样美丽。以下是本次摄影展精选的四个镜头画面说明：

## 四季镜头精选

1. **春之繁樱**  
   每年三月，行政楼前的樱花大道迎来盛开期。落樱如雪，吸引了无数同学在此驻足。镜头捕捉到了微风拂过时，樱花瓣落在长椅上的静谧瞬间。
   
2. **夏之浓荫**  
   炎炎夏日，林荫道上高大的梧桐树连成一片天然的绿色华盖。阳光穿透树叶的缝隙，洒下斑驳的光影，正午的校园巴士穿行其中，极具生活感。
   
3. **秋之银杏**  
   秋天的图书馆广场是金色的。两旁挺拔的银杏树落叶铺满地面，宛如一条金色的地毯。镜头下，同学们在金色秋景中读书的画面充满了人文气息。
   
4. **冬之晨曦**  
   寒冬的早晨，初升的暖阳给教学楼披上一层淡淡的金纱。微风吹散湖面上的薄雾，岸边的枯荷与远处的拱桥在镜头中构成了一幅水墨画。

摄影展目前正在教学主楼一楼大厅展出，展出将持续至本周五，欢迎广大师生前往观展。'),
('风光', 'seed_admin_ops', '晨曦中的图书馆：静谧与书香的交织', '清晨第一缕阳光洒在图书馆的落地窗前，用镜头记录同学们晨读的身影。', 1, 420, 3, NULL),
('风光', 'seed_admin_audit', '校园地标建筑历史与打卡攻略', '为方便新生更快了解校园底蕴，校史馆整理了校园十大地标性历史建筑的打卡攻略。', 1, 610, 5, NULL),
('风光', 'admin', '校园樱花季摄影展征集草稿', '摄影协会拟于明年三月举办春季樱花主题影展，策划方案仍在初审中。', 0, 25, 7, NULL),
('风光', 'seed_admin_audit', '去年秋日落叶景观通知下架', '随着冬季到来，去年关于保留秋日落叶景观不扫的通知正式完成下架。', 2, 80, 50, NULL),
('风光', 'admin', '雨后校园：倒影中的几何美学与静谧诗意', '摄影社团分享了一组雨后校园照片，积水中的倒影将地标建筑渲染得如梦似幻。', 1, 380, 1, NULL),
('风光', 'seed_admin_ops', '镜湖晚霞：夕阳余晖下波光粼粼的校园画卷', '傍晚的镜湖旁是师生散步的热门地，夕阳金辉与成群的白鹭构成绝美风景。', 1, 470, 2, NULL),
('风光', 'seed_admin_audit', '探秘校史馆：触摸百年办学历程的历史年轮', '新校史馆以丰富的图文和老物件，向师生徐徐展开学校的发展印记。', 1, 510, 3, NULL),
('风光', 'admin', '林荫深处：夏季阳光穿透杉树林的光斑画作', '后山杉树林是校园的天然氧吧，清晨阳光洒下的丁达尔光效极具艺术美感。', 1, 430, 4, NULL),

-- 实践 (9篇)
('实践', 'seed_admin_ops', '暑期社会实践“三下乡”出征仪式举行', '我校百余支社会实践团队代表齐聚一堂，举行暑期大中专学生志愿者“三下乡”出征授旗仪式。', 1, 470, 1, NULL),
('实践', 'seed_admin_audit', '爱心支教志愿服务队日常纪实', '校青协支教队走访山区小学，开展为期一个月的文化知识和安全宣教支教活动。', 1, 380, 2, NULL),
('实践', 'admin', '社区科普志愿活动顺利开展', '物理与电子学院青年志愿者深入周边社区，为青少年开展妙趣横生的科普互动实验。', 1, 290, 4, NULL),
('实践', 'seed_admin_ops', '志愿服务时长核对指南草稿', '为了保障毕业生志愿服务时长认定准确，校团委正起草时长核准流程，草稿暂不公布。', 0, 15, 6, NULL),
('实践', 'seed_admin_audit', '往年优秀社会实践报告汇编下架', '因系统版本迭代，旧版社会实践优秀报告合集入口已于本周下架。', 2, 95, 45, NULL),
('实践', 'seed_admin_ops', '我校举行暑期社会实践成果汇报交流展示会', '多支优秀团队代表通过PPT展示和短视频，分享了他们在乡村振兴中的调研成果。', 1, 430, 1, NULL),
('实践', 'admin', '“科普大篷车”社会实践队走进偏远山区小学', '实践队带去了趣味物理实验器材，为留守儿童开展了一场生动的科学启蒙课。', 1, 390, 2, NULL),
('实践', 'seed_admin_audit', '美丽中国行：生态环境守护实践队调研实录', '实践队围绕湿地保护与河道水质，在沿海省市开展了为期两周的生态科考。', 1, 480, 3, NULL),
('实践', 'admin', '关于评选年度社会实践先进个人与优秀团队的通知', '为表彰在社会实践中表现突出的师生，校团委决定即日起启动评选工作。', 1, 310, 4, NULL),

-- 归档与测试 (2篇)
('归档', 'admin', '归档分类历史新闻', '该新闻用于验证禁用分类和下架新闻在后台的展示效果。', 2, 96, 60, NULL),
('测试禁用', 'seed_admin_audit', '禁用分类草稿新闻', '该草稿用于验证禁用分类相关数据不会进入前台。', 0, 12, 61, NULL);

INSERT INTO news (
  title,
  summary,
  content,
  cover_image,
  category_id,
  author_id,
  status,
  view_count,
  create_time,
  update_time
)
SELECT
  b.title,
  b.summary,
  COALESCE(b.detail_content, CONCAT(
    '# ', b.title, '\n\n',
    b.summary, '\n\n',
    '## 校园观察与实地报道\n\n',
    '针对本次事件，记者团队进行了深入的实地采访与信息收集。相关负责教师及同学在受访时表示，本项举措不仅优化了原先繁杂的纸质办理流程，为日常的校园生活和学习科研带来了极大便利，也极大缩短了申请周期，显著提高了校园服务的响应速度。\n\n',
    '### 核心看点与建设方向\n\n',
    '1. **无纸化一站式办理**：系统全面对接智慧平台，所有申请流转全自动化。\n',
    '2. **响应反馈全面加速**：相关职能部门承诺在首个工作日内对用户的反馈信息予以受理。\n',
    '3. **过程公开透明**：师生可通过 MoeNews 客户端实时掌握最新办理进度。\n\n',
    '- 分类：', b.category_name, '\n',
    '- 供稿：', u.nickname, '\n\n',
    '下一步，项目组将持续跟踪用户体验反馈，根据师生的使用习惯进行针对性的功能迭代与交互微调，持续构建高品质、有温度的智慧化校园服务生态。'
  )) AS content,
  NULL AS cover_image,
  c.id AS category_id,
  u.id AS author_id,
  b.status,
  b.view_count,
  DATE_SUB(NOW(), INTERVAL b.days_ago DAY),
  DATE_SUB(NOW(), INTERVAL b.days_ago DAY)
FROM seed_news_blueprint b
JOIN news_category c ON c.name COLLATE utf8mb4_unicode_ci = b.category_name COLLATE utf8mb4_unicode_ci
JOIN user u ON u.username COLLATE utf8mb4_unicode_ci = b.author_username COLLATE utf8mb4_unicode_ci;

-- 通过递增分配独特的封面图片，使每篇新闻展现不同的排版视觉效果
SET @cover_index := 0;
UPDATE news 
SET cover_image = CONCAT('/uploads/temp/cover_', (@cover_index := (@cover_index % 189) + 1), '.jpg')
WHERE id > 0;

DROP TEMPORARY TABLE IF EXISTS seed_comment_blueprint;
CREATE TEMPORARY TABLE seed_comment_blueprint (
  username VARCHAR(50) NOT NULL,
  content VARCHAR(500) NOT NULL,
  status TINYINT NOT NULL,
  hour_offset INT NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 评论数据：为所有已发布种子新闻生成多条评论，覆盖显示和隐藏状态。
INSERT INTO seed_comment_blueprint (username, content, status, hour_offset) VALUES
('seed_user_01', '内容阐述得非常清楚，很适合在日常演示和评审时进行展示。', 1, 1),
('seed_user_02', '这个优化方案很贴近实际，希望能够尽快在全校范围内推广！', 1, 2),
('seed_user_03', '已仔细阅读，正文的 Markdown 标题分层和公式排版都非常完美。', 1, 3),
('seed_user_04', '这是一条测试用的干扰评论，主要用于在后台管理控制台检验敏感言论隐藏功能。', 0, 4),
('seed_user_05', '有了丰富的测试数据支持，列表翻页和分类检索的交互体验流畅了许多。', 1, 5);

INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT
  n.id,
  u.id,
  cb.content,
  cb.status,
  DATE_ADD(n.create_time, INTERVAL cb.hour_offset HOUR),
  DATE_ADD(n.create_time, INTERVAL cb.hour_offset HOUR)
FROM news n
JOIN seed_comment_blueprint cb
JOIN user u ON u.username COLLATE utf8mb4_unicode_ci = cb.username COLLATE utf8mb4_unicode_ci
WHERE n.status = 1;

-- 针对特定爆款新闻，追加更多高仿真的互动评论数据
-- 1. 夏季作息时间调整通知的评论
INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '下午第一节课推迟到两点半太赞了，中午有充裕的时间午休了。', 1, DATE_ADD(n.create_time, INTERVAL 30 MINUTE), DATE_ADD(n.create_time, INTERVAL 30 MINUTE)
FROM news n, user u WHERE n.title = '关于调整 2026 年夏季作息时间的通知' AND u.username = 'seed_user_06';

INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '请问图书馆的闭馆时间也会随之推迟半小时吗？', 1, DATE_ADD(n.create_time, INTERVAL 45 MINUTE), DATE_ADD(n.create_time, INTERVAL 45 MINUTE)
FROM news n, user u WHERE n.title = '关于调整 2026 年夏季作息时间的通知' AND u.username = 'seed_user_07';

INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '回楼上，公告说后勤和自习室会做同步微调，应该也是推迟的。', 1, DATE_ADD(n.create_time, INTERVAL 60 MINUTE), DATE_ADD(n.create_time, INTERVAL 60 MINUTE)
FROM news n, user u WHERE n.title = '关于调整 2026 年夏季作息时间的通知' AND u.username = 'seed_user_08';

-- 2. 智能助理发布新闻的评论
INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '今天体验了内测，MoeBot 查空课表非常快，强烈推荐体验下！', 1, DATE_ADD(n.create_time, INTERVAL 20 MINUTE), DATE_ADD(n.create_time, INTERVAL 20 MINUTE)
FROM news n, user u WHERE n.title = 'AI 实验室发布首个校园智能助手' AND u.username = 'seed_user_01';

INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '感觉这个可以对接一下宿舍电费查询接口，那就更方便了。', 1, DATE_ADD(n.create_time, INTERVAL 35 MINUTE), DATE_ADD(n.create_time, INTERVAL 35 MINUTE)
FROM news n, user u WHERE n.title = 'AI 实验室发布首个校园智能助手' AND u.username = 'seed_user_02';

INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '楼上想法很实用，刚才反馈给实验室的同学了，据说下一阶段就会规划接入。', 1, DATE_ADD(n.create_time, INTERVAL 50 MINUTE), DATE_ADD(n.create_time, INTERVAL 50 MINUTE)
FROM news n, user u WHERE n.title = 'AI 实验室发布首个校园智能助手' AND u.username = 'seed_user_03';

-- 3. 大语言模型学术报告的评论
INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '讲座可以打卡记学术积分吗？需要带学术讲座卡吗？', 1, DATE_ADD(n.create_time, INTERVAL 30 MINUTE), DATE_ADD(n.create_time, INTERVAL 30 MINUTE)
FROM news n, user u WHERE n.title = '高水平学术报告：大语言模型的未来趋势' AND u.username = 'seed_user_05';

INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '回楼上，通知上说现场扫码签到，不需要带纸质卡了。', 1, DATE_ADD(n.create_time, INTERVAL 45 MINUTE), DATE_ADD(n.create_time, INTERVAL 45 MINUTE)
FROM news n, user u WHERE n.title = '高水平学术报告：大语言模型的未来趋势' AND u.username = 'seed_user_06';

-- 4. 十佳歌手报名开始的评论
INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '太棒了，今年的决赛居然在田径场户外办！非常有夏日音乐会的感觉！', 1, DATE_ADD(n.create_time, INTERVAL 15 MINUTE), DATE_ADD(n.create_time, INTERVAL 15 MINUTE)
FROM news n, user u WHERE n.title = '校园十佳歌手大赛报名开始' AND u.username = 'seed_user_08';

INSERT INTO news_comment (news_id, user_id, content, status, create_time, update_time)
SELECT n.id, u.id, '请问海选的清唱限时30秒是只能唱一小段副歌吗？', 1, DATE_ADD(n.create_time, INTERVAL 25 MINUTE), DATE_ADD(n.create_time, INTERVAL 25 MINUTE)
FROM news n, user u WHERE n.title = '校园十佳歌手大赛报名开始' AND u.username = 'seed_user_09';

DROP TEMPORARY TABLE IF EXISTS seed_news_blueprint;
DROP TEMPORARY TABLE IF EXISTS seed_comment_blueprint;

-- 补齐系统初始管理员与普通用户的可选字段，保证数据库全局各字段无 NULL 空值，以实现高标准答辩成品效果
UPDATE user SET email = 'admin@moenews.test', phone = '13800000001' WHERE username = 'admin';
UPDATE user SET email = 'user@moenews.test', phone = '13800000002' WHERE username = 'user';
UPDATE news SET cover_image = '/uploads/temp/cover_183.jpg' WHERE id = 1;

-- 执行结果统计，便于确认导入规模。
SELECT 'seed_users' AS item, COUNT(*) AS total FROM user WHERE username LIKE 'seed_%'
UNION ALL
SELECT 'categories', COUNT(*) FROM news_category WHERE name IN ('校园', '科技', '社团', '就业', '竞赛', '生活', '公告', '人物', '学术', '文体', '风光', '实践', '归档', '测试禁用')
UNION ALL
SELECT 'news', COUNT(*) FROM news WHERE author_id IN (SELECT id FROM user WHERE username LIKE 'seed_%') OR id = 1
UNION ALL
SELECT 'comments', COUNT(*) FROM news_comment;
