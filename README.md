# 打地鼠游戏 (Whack-a-Mole Game)

一个用 HTML、CSS 和 JavaScript 实现的经典打地鼠游戏，带有精美的动画效果和完整的游戏机制。

## 功能特性

### 🎮 游戏核心功能
- **9个地鼠洞**的3x3网格布局
- **三种难度级别**：
  - 简单模式：地鼠弹出2秒
  - 中等模式：地鼠弹出1秒
  - 困难模式：地鼠弹出0.5秒
- **完整游戏控制**：开始、暂停、重置
- **60秒倒计时**和实时分数统计
- **游戏结束界面**显示最终成绩

### ✨ 视觉与交互效果
- **锤子光标**：自定义SVG锤子形状鼠标指针
- **砸击动画**：点击时的锤子挥动效果
- **地鼠动画**：
  - 平滑的弹出/收回动画
  - 被砸中时的缩放、旋转和颜色变化效果
- **鲜明配色**：浅棕色地鼠配合黑色眼睛、粉色鼻子，视觉效果清晰

### 🐳 部署方式
- 使用 Docker + Nginx 进行容器化部署
- 支持端口映射，方便访问

## 项目结构

```
mole-game/
├── index.html    # 完整的游戏代码（HTML + CSS + JavaScript）
├── Dockerfile    # Docker 部署配置文件
└── README.md     # 项目说明文档
```

## 快速开始

### 本地运行

1. 克隆或下载项目
2. 直接在浏览器中打开 `index.html` 文件
3. 开始游戏！

### Docker 部署

1. 构建 Docker 镜像：
   ```bash
   docker build -t mole-game .
   ```

2. 运行 Docker 容器：
   ```bash
   docker run -d -p 8080:80 --name mole-game-container mole-game
   ```

3. 访问游戏：
   在浏览器中打开 `http://localhost:8080`

## 代码结构解析

### HTML 结构
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <!-- 元信息和样式 -->
</head>
<body>
    <h1>打地鼠游戏</h1>

    <!-- 游戏信息显示区 -->
    <div class="game-info">
        <div>分数: <span id="score">0</span></div>
        <div>时间: <span id="time">60</span>秒</div>
    </div>

    <!-- 游戏面板（9个地鼠洞） -->
    <div class="game-board">
        <div class="hole" data-id="0">
            <div class="mole">
                <div></div> <!-- 用于显示地鼠面部特征 -->
            </div>
        </div>
        <!-- 其他8个地鼠洞 -->
    </div>

    <!-- 游戏控制区 -->
    <div class="controls">
        <select id="difficulty">...</select>
        <button id="start-btn">开始游戏</button>
        <button id="pause-btn" disabled>暂停</button>
        <button id="reset-btn">重置</button>
    </div>

    <!-- 游戏结束界面 -->
    <div class="game-over" id="game-over">...</div>

    <!-- JavaScript 代码 -->
    <script>...</script>
</body>
</html>
```

### CSS 样式

主要分为以下几个部分：
- **全局样式**：重置默认样式、设置背景
- **游戏信息区样式**：分数和时间显示
- **游戏面板样式**：9个地鼠洞的网格布局
- **地鼠洞样式**：圆形洞、锤子光标
- **地鼠样式**：地鼠身体、面部特征（眼睛、鼻子、嘴巴）
- **动画效果**：锤子砸击动画、地鼠被砸动画

### JavaScript 逻辑

主要功能模块：
1. **游戏状态管理**：分数、时间、游戏状态
2. **DOM元素引用**：各种UI元素的获取
3. **难度配置**：不同难度的地鼠弹出时间
4. **游戏控制函数**：
   - `startGame()`：开始/继续游戏
   - `pauseGame()`：暂停游戏
   - `resetGame()`：重置游戏
   - `endGame()`：结束游戏
5. **地鼠控制函数**：
   - `popMole()`：随机弹出地鼠
   - `whackMole()`：处理点击地鼠事件
6. **事件监听**：按钮点击、地鼠点击

## 游戏机制说明

### 地鼠弹出逻辑
1. 使用 `setTimeout()` 定时弹出地鼠
2. 使用 `Math.random()` 随机选择地鼠洞
3. 根据难度级别设置不同的弹出持续时间

### 分数计算
- 每成功击中一个地鼠得1分
- 分数实时更新显示

### 时间管理
- 游戏总时长60秒
- 使用 `setInterval()` 进行倒计时
- 时间结束时自动结束游戏

### 动画处理
- 使用 CSS `transition` 实现平滑的弹出/收回效果
- 使用 CSS `@keyframes` 实现锤子砸击和地鼠被砸动画
- JavaScript 控制动画的触发和移除

## 学习价值

这个项目适合作为前端初学者的学习案例，涵盖了：
1. **HTML 基础**：元素结构、语义化标签
2. **CSS 进阶**：
   - Flexbox 和 Grid 布局
   - 自定义光标
   - 过渡动画（transition）
   - 关键帧动画（@keyframes）
   - 伪元素（::before, ::after）
   - SVG 数据 URI
3. **JavaScript 核心**：
   - DOM 操作
   - 事件监听
   - 定时器（setTimeout, setInterval）
   - 随机数生成
   - 游戏状态管理
4. **Docker 部署**：容器化应用的构建和运行

## 扩展建议

如果想进一步扩展这个项目，可以考虑：
1. 增加音效（弹出、击中、游戏结束）
2. 实现高分榜功能
3. 增加更多难度级别
4. 添加不同类型的地鼠（普通地鼠、奖励地鼠等）
5. 实现移动设备适配
6. 添加动画效果开关
7. 实现多人对战模式

## 许可证

本项目采用 MIT License，可自由使用和修改。

## 作者

由 Claude 生成并完善。
