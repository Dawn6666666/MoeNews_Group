---
name: Sweet Moe Candy
colors:
  primary: "#FF6B8B"
  secondary: "#4EA8DE"
  accent: "#FF8E3C"
  background: "#FCF8FC"
  text-main: "#2D3748"
  text-muted: "#718096"
  border-color: "#F5E6F3"
typography:
  h1:
    fontFamily: Outfit
    fontSize: 36px
    fontWeight: 800
    lineHeight: 1.2
    letterSpacing: -0.02em
  body-md:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: 400
    lineHeight: 1.6
rounded:
  sm: 8px
  md: 16px
  lg: 24px
  full: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 48px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "#FFFFFF"
    rounded: "{rounded.sm}"
  card:
    backgroundColor: "#FFFFFF"
    rounded: "{rounded.md}"
---

## Overview

本设计系统采用奶油糖果萌系二次元风格，旨在为二次元新闻平台提供充满青春朝气、轻盈精致的视觉与阅读体验。该风格主要服务于热爱二次元文化的年轻群体，既强调生动的二次元配色与温润可爱的微阴影，又保证了长文排版的高可读性。

## Colors

色彩组合以温和甜美的粉蓝色调为基准，辅以充满能量的橙色进行行动指引。

- **Primary (#FF6B8B):** 蜜桃粉，作为系统品牌色与主要行动点色，代表青春活泼。
- **Secondary (#4EA8DE):** 晴空蓝，用于中性信息强调、链接以及次要状态反馈。
- **Accent (#FF8E3C):** 活力橙，用于强烈的焦点按钮提示与鼠标悬浮高亮状态。
- **Background (#FCF8FC):** 奶油薰衣草粉白，温润且柔和，可有效缓解长时间阅读文字带来的眼部疲劳。
- **Text Main (#2D3748):** 深石墨灰，相比纯黑色更显高级与平易近人。
- **Text Muted (#718096):** 浅灰蓝，用于辅助元数据、边角说明与失效状态文本。
- **Border Color (#F5E6F3):** 柔粉紫灰，用于极轻量化且精细的卡片边框。

## Typography

字形方面采用英文与中文的和谐搭配：

- **H1 标题:** 使用 Outfit 字体，配合 800 的特粗字重和紧凑的字距，带来现代海报式的力量感与萌系可爱感。
- **正文:** 使用 Inter 字体，配合 1.6 的舒适行高，确保文章正文段落的可读性与流畅感。

## Layout

布局采用网格系统与流式容器结合的方式。前台主页面采用类似于便当盒网格的紧凑混合布局，各个区块间使用 16px 或 24px 的间隙，并通过卡片内部的 20px-24px 内边距（Padding）来构建稳固的视觉秩序。

## Elevation & Depth

本系统不推荐使用过于沉重、高对比度的深色投影，而是采用非常轻盈、透气的浅粉紫色弥散投影来塑造悬浮感，使界面层级轻盈且自然。

## Shapes

所有交互元素、输入框以及普通卡片面板均采用大圆角设计，圆角半径范围为 8px 至 24px，传递出友好、亲切的萌系设计语言。

## Components

- **button-primary:** 主色按钮使用蜜桃粉背景配白色文字，圆角为 8px，在悬浮时进行轻微缩放。
- **card:** 卡片背景为白色，四角配置 16px 圆角，伴随浅粉紫色弥散阴影。

## Do's and Don'ts

- 务必保持全局圆角语言的统一，避免在同一页面混用直角与大圆角。
- 务必保持核心交互文字与背景之间符合可访问性对比度要求。
- 绝不能使用刺眼饱和的荧光色作为大面积背景色。
- 绝不能混用超过三种以上的不同字体。
