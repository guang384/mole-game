# 打地鼠游戏实现教程

## 1. 教程概述

本教程将教你如何使用 HTML、CSS 和 JavaScript 实现一个完整的打地鼠游戏。你将学习到：
- 游戏界面的设计与布局
- 地鼠弹出与收回的动画效果
- 点击事件处理和分数计算
- 游戏状态管理（开始、暂停、重置）
- 动画效果的实现
- Docker 容器化部署

## 2. 项目准备

### 2.1 技术栈
- **HTML5**：页面结构
- **CSS3**：样式和动画
- **JavaScript (ES6+)**：游戏逻辑
- **Docker**：部署（可选）

### 2.2 文件结构
```
mole-game/
├── index.html    # 主游戏文件
└── Dockerfile    # Docker部署文件（可选）
```

## 3. 实现步骤

### 步骤 1：创建 HTML 基础结构

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>打地鼠游戏</title>
</head>
<body>
    <h1>打地鼠游戏</h1>

    <!-- 游戏信息 -->
    <div class="game-info">
        <div>分数: <span id="score">0</span></div>
        <div>时间: <span id="time">60</span>秒</div>
    </div>

    <!-- 游戏面板 -->
    <div class="game-board"></div>

    <!-- 控制按钮 -->
    <div class="controls">
        <select id="difficulty">
            <option value="easy">简单 (2秒)</option>
            <option value="medium" selected>中等 (1秒)</option>
            <option value="hard">困难 (0.5秒)</option>
        </select>
        <button id="start-btn">开始游戏</button>
        <button id="pause-btn" disabled>暂停</button>
        <button id="reset-btn">重置</button>
    </div>

    <!-- 游戏结束界面 -->
    <div class="game-over" id="game-over">
        <h2>游戏结束!</h2>
        <div>最终分数: <span id="final-score">0</span></div>
        <button onclick="closeGameOver()">再玩一次</button>
    </div>
</body>
</html>
```

### 步骤 2：添加 CSS 样式

```css
/* 全局样式 */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Arial', sans-serif;
    background-color: #8B4513; /* 棕色背景 */
    color: white;
    display: flex;
    flex-direction: column;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
}

h1 {
    margin-bottom: 20px;
    font-size: 2.5em;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
}

/* 游戏信息区 */
.game-info {
    display: flex;
    justify-content: space-between;
    width: 600px;
    margin-bottom: 20px;
    font-size: 1.2em;
    font-weight: bold;
}

/* 游戏面板 */
.game-board {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: repeat(3, 1fr);
    gap: 10px;
    width: 600px;
    height: 600px;
    background-color: #654321; /* 深棕色面板 */
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 20px rgba(0,0,0,0.5);
}

/* 地鼠洞 */
.hole {
    position: relative;
    background-color: #3E2723; /* 深棕色洞 */
    border-radius: 50%;
    overflow: hidden;
    cursor: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48"><rect x="8" y="8" width="32" height="32" fill="#8B4513" rx="4"/><rect x="16" y="20" width="16" height="12" fill="#654321"/><circle cx="24" cy="26" r="4" fill="black"/></svg>'), auto;
}

.hole::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 0;
    width: 100%;
    height: 100px;
    background-color: #8B4513;
    border-radius: 50%;
}

/* 地鼠 */
.mole {
    position: absolute;
    bottom: -100px; /* 初始隐藏在洞底 */
    left: 50%;
    transform: translateX(-50%);
    width: 80%;
    height: 80%;
    background-color: #D2B48C; /* 浅棕色地鼠 */
    border-radius: 50% 50% 0 0;
    transition: bottom 0.3s ease; /* 弹出/收回动画 */
    border: 2px solid #8B4513;
}

/* 地鼠面部特征 */
.mole::before { /* 左眼 */
    content: '';
    position: absolute;
    top: 25%;
    left: 35%;
    width: 12%;
    height: 12%;
    background-color: black;
    border-radius: 50%;
    border: 2px solid white;
}

.mole::after { /* 右眼 */
    content: '';
    position: absolute;
    top: 25%;
    right: 35%;
    width: 12%;
    height: 12%;
    background-color: black;
    border-radius: 50%;
    border: 2px solid white;
}

.mole div::before { /* 鼻子 */
    content: '';
    position: absolute;
    top: 40%;
    left: 50%;
    transform: translateX(-50%);
    width: 15%;
    height: 10%;
    background-color: pink;
    border-radius: 50%;
}

.mole div::after { /* 嘴巴 */
    content: '';
    position: absolute;
    top: 48%;
    left: 50%;
    transform: translateX(-50%);
    width: 20%;
    height: 8%;
    border-bottom: 2px solid black;
    border-radius: 50%;
}

/* 地鼠弹出状态 */
.mole.up {
    bottom: 0;
}

/* 地鼠被砸状态 */
.mole.whacked {
    animation: whacked 0.5s ease;
}

/* 锤子点击效果 */
.hole:active {
    cursor: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48"><rect x="8" y="12" width="32" height="32" fill="#8B4513" rx="4"/><rect x="16" y="24" width="16" height="12" fill="#654321"/><circle cx="24" cy="30" r="4" fill="black"/></svg>'), auto;
    animation: hammerHit 0.1s ease;
}

/* 锤子砸击动画 */
@keyframes hammerHit {
    0% { transform: scale(1) translateY(0); }
    50% { transform: scale(1.1) translateY(10px); }
    100% { transform: scale(1) translateY(0); }
}

/* 地鼠被砸动画 */
@keyframes whacked {
    0% { transform: translateX(-50%) scale(1); background-color: #D2B48C; }
    25% { transform: translateX(-50%) scale(1.2) rotate(10deg); background-color: #FF4500; }
    50% { transform: translateX(-50%) scale(1.1) rotate(-10deg); background-color: #FF6347; }
    75% { transform: translateX(-50%) scale(0.9) rotate(5deg); background-color: #FF6347; }
    100% { transform: translateX(-50%) scale(1); background-color: #D2B48C; }
}

/* 控制按钮 */
.controls {
    margin-top: 20px;
}

button {
    padding: 10px 20px;
    margin: 0 10px;
    font-size: 1.1em;
    font-weight: bold;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

button:hover {
    background-color: #45a049;
}

button:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
}

/* 游戏结束界面 */
.game-over {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.8);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    font-size: 2em;
    z-index: 1000;
    display: none; /* 默认隐藏 */
}
```

### 步骤 3：生成地鼠洞

在 CSS 之后、JavaScript 之前添加：

```html
<!-- 动态生成地鼠洞 -->
<script>
    const gameBoard = document.querySelector('.game-board');
    for (let i = 0; i < 9; i++) {
        const hole = document.createElement('div');
        hole.className = 'hole';
        hole.dataset.id = i;

        const mole = document.createElement('div');
        mole.className = 'mole';

        const moleFace = document.createElement('div');
        mole.appendChild(moleFace);

        hole.appendChild(mole);
        gameBoard.appendChild(hole);
    }
</script>
```

### 步骤 4：实现 JavaScript 游戏逻辑

```javascript
// 游戏状态变量
let score = 0;
let time = 60;
let gameRunning = false;
let gamePaused = false;
let moleTimer = null;
let gameTimer = null;
let difficulty = 'medium';

// DOM 元素
const scoreElement = document.getElementById('score');
const timeElement = document.getElementById('time');
const startBtn = document.getElementById('start-btn');
const pauseBtn = document.getElementById('pause-btn');
const resetBtn = document.getElementById('reset-btn');
const difficultySelect = document.getElementById('difficulty');
const gameOverElement = document.getElementById('game-over');
const finalScoreElement = document.getElementById('final-score');
const holes = document.querySelectorAll('.hole');

// 难度配置
const difficultyLevels = {
    easy: 2000,   // 地鼠持续时间（毫秒）
    medium: 1000,
    hard: 500
};

// 开始游戏
function startGame() {
    if (gameRunning && !gamePaused) return;

    if (gamePaused) {
        resumeGame();
        return;
    }

    gameRunning = true;
    gamePaused = false;
    startBtn.textContent = '继续';
    pauseBtn.disabled = false;
    difficultySelect.disabled = true;

    // 启动倒计时
    gameTimer = setInterval(() => {
        time--;
        timeElement.textContent = time;
        if (time <= 0) endGame();
    }, 1000);

    // 弹出第一个地鼠
    popMole();
}

// 继续游戏
function resumeGame() {
    gamePaused = false;
    pauseBtn.disabled = false;
    popMole();
}

// 暂停游戏
function pauseGame() {
    if (!gameRunning || gamePaused) return;

    gamePaused = true;
    pauseBtn.disabled = true;

    // 清除地鼠定时器
    if (moleTimer) {
        clearTimeout(moleTimer);
        moleTimer = null;
    }

    // 隐藏所有地鼠
    const upMoles = document.querySelectorAll('.mole.up');
    upMoles.forEach(mole => mole.classList.remove('up'));
}

// 重置游戏
function resetGame() {
    clearInterval(gameTimer);
    clearTimeout(moleTimer);

    // 重置状态
    gameRunning = false;
    gamePaused = false;
    score = 0;
    time = 60;
    difficulty = difficultySelect.value;

    // 更新 UI
    scoreElement.textContent = score;
    timeElement.textContent = time;
    startBtn.textContent = '开始游戏';
    pauseBtn.disabled = true;
    difficultySelect.disabled = false;
    gameOverElement.style.display = 'none';

    // 隐藏地鼠
    const upMoles = document.querySelectorAll('.mole.up');
    upMoles.forEach(mole => mole.classList.remove('up'));
}

// 弹出地鼠
function popMole() {
    if (!gameRunning || gamePaused) return;

    // 随机选择地鼠洞
    const randomHole = holes[Math.floor(Math.random() * holes.length)];
    const mole = randomHole.querySelector('.mole');

    // 弹出地鼠
    mole.classList.add('up');

    // 定时收回地鼠
    moleTimer = setTimeout(() => {
        mole.classList.remove('up');
        popMole(); // 递归调用，继续弹出
    }, difficultyLevels[difficulty]);
}

// 点击地鼠
function whackMole(e) {
    if (!gameRunning || gamePaused) return;

    const mole = e.target;
    if (mole.classList.contains('mole') && mole.classList.contains('up')) {
        // 触发被砸动画
        mole.classList.add('whacked');

        // 延迟隐藏地鼠
        setTimeout(() => {
            mole.classList.remove('up');
        }, 100);

        // 增加分数
        score++;
        scoreElement.textContent = score;

        // 清除当前地鼠定时器
        if (moleTimer) {
            clearTimeout(moleTimer);
            moleTimer = null;
        }

        // 移除动画类并继续游戏
        setTimeout(() => {
            mole.classList.remove('whacked');
            popMole();
        }, 500);
    }
}

// 结束游戏
function endGame() {
    gameRunning = false;
    gamePaused = false;

    clearInterval(gameTimer);
    clearTimeout(moleTimer);

    // 更新 UI
    startBtn.textContent = '开始游戏';
    pauseBtn.disabled = true;
    difficultySelect.disabled = false;

    // 隐藏地鼠
    const upMoles = document.querySelectorAll('.mole.up');
    upMoles.forEach(mole => mole.classList.remove('up'));

    // 显示游戏结束
    finalScoreElement.textContent = score;
    gameOverElement.style.display = 'flex';
}

// 关闭游戏结束界面
function closeGameOver() {
    gameOverElement.style.display = 'none';
    resetGame();
}

// 事件监听
startBtn.addEventListener('click', startGame);
pauseBtn.addEventListener('click', pauseGame);
resetBtn.addEventListener('click', resetGame);

// 为所有地鼠洞添加点击事件
holes.forEach(hole => {
    hole.addEventListener('click', whackMole);
});
```

### 步骤 5：测试游戏

1. 在浏览器中打开 `index.html`
2. 选择难度级别
3. 点击"开始游戏"
4. 点击弹出的地鼠得分

### 步骤 6：Docker 部署（可选）

创建 `Dockerfile`：

```dockerfile
FROM nginx:alpine

COPY --chown=nginx:nginx index.html /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

构建并运行：

```bash
docker build -t mole-game .
docker run -d -p 8080:80 --name mole-game-container mole-game
```

访问 `http://localhost:8080`

## 4. 核心技术点解析

### 4.1 地鼠弹出机制
- 使用 `setTimeout` 控制地鼠弹出时长
- 使用 `Math.random()` 随机选择地鼠洞
- 使用 CSS `transition` 实现平滑动画

### 4.2 游戏状态管理
- `gameRunning`：游戏是否正在进行
- `gamePaused`：游戏是否暂停
- `moleTimer`：地鼠弹出定时器
- `gameTimer`：游戏倒计时器

### 4.3 动画效果
- **过渡动画**：`transition: bottom 0.3s ease` 实现地鼠平滑弹出/收回
- **关键帧动画**：`@keyframes` 实现锤子砸击和地鼠被砸效果
- **动画触发**：通过添加/移除 CSS 类来触发动画

### 4.4 事件处理
- `addEventListener` 监听按钮点击和地鼠点击
- 事件委托：为父元素添加事件监听（虽然本例直接为地鼠洞添加）

## 5. 扩展功能建议

1. **音效系统**：为地鼠弹出、击中、游戏结束添加音效
2. **高分榜**：使用 localStorage 存储高分记录
3. **多种地鼠**：普通地鼠、黄金地鼠（加分更多）
4. **移动适配**：优化移动端界面和交互
5. **关卡系统**：随着分数增加提高难度
6. **视觉效果**：粒子效果、背景动画

## 6. 总结

通过本教程，你已经学习了如何使用 HTML、CSS 和 JavaScript 实现一个完整的打地鼠游戏。你掌握了：
- 游戏界面布局设计
- 动画效果的实现
- 游戏状态管理
- 事件处理和交互逻辑
- Docker 部署方法

这个项目是前端学习的良好实践，涵盖了 HTML、CSS 和 JavaScript 的核心概念，并结合了实际的游戏开发逻辑。

祝你学习愉快！🎮
