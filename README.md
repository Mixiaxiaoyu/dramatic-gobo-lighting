# Dramatic Gobo Lighting 中文说明

English version: [README.en.md](./README.en.md)

这是一个 Codex 技能，用来给已有图片或新生成图片加入戏剧性 gobo 投影打光。

仓库内容包含：

- 技能说明文件
- gobo 选择脚本
- 压缩优化后的素材库
- 基于标签的可控参数

支持的控制项包括：

- 背景是否锁定
- 光影角度是否随机
- 光影边缘软硬程度
- gobo 投影放大倍率

## 这个技能能做什么

它适合做这类效果：

- 窗格光影
- 百叶窗光影
- 植物叶影
- 水波反射光影
- 图形化线性投影
- 抽象破碎光影

它的核心目标不是改造主体造型，而是在尽量保留原图结构的前提下，重新设计画面的光影氛围。

## 目录结构

```text
dramatic-gobo-lighting/
├─ README.md                         ← 中文使用说明，仓库默认展示页
├─ README.en.md                      ← 英文版使用说明
├─ README.zh-CN.md                   ← 中文说明入口别名，兼容旧链接
├─ LICENSE                           ← GPL-3.0 许可证
├─ SKILL.md                          ← 技能主说明文件，供 Codex 调用
├─ agents/
│  └─ openai.yaml                    ← 技能代理配置文件
├─ references/
│  ├─ gobo-library.md                ← gobo 类型与素材参考说明
│  ├─ gobo-catalog.md                ← 完整 gobo 文件名清单
│  └─ gobo-name-quick-lookup.md      ← gobo 名字快捷查询
├─ scripts/
│  └─ select_gobo.ps1                ← 根据提示词选择 gobo 的脚本
└─ assets/
   ├─ examples/                      ← README 案例展示图
   │  ├─ case-01-plants-portrait.png
   │  ├─ case-02-window-perfume.png
   │  ├─ case-03-abstract-rock.png
   │  └─ case-04-blinds-fashion-red.png
   └─ gobos/
      ├─ abstract/                   ← 抽象破碎光影
      ├─ caustics/                   ← 水波反射光影
      ├─ lines/                      ← 线性/图形化投影
      ├─ plants/                     ← 植物叶影
      └─ windows/                    ← 窗格与百叶窗光影
```

## 安装

### 方式一：一行命令安装（推荐）

```bash
git clone https://github.com/Mixiaxiaoyu/dramatic-gobo-lighting.git ~/.codex/skills/dramatic-gobo-lighting
```

执行完成后，这个 skill 就会被安装到 Codex 的本地技能目录中。

### 方式二：把下面这段话直接发给 Codex

> 帮我安装 `dramatic-gobo-lighting` 这个 Codex skill，请按下面步骤做：
>
> 1. 确保 `~/.codex/skills/` 目录存在，不存在就创建。
> 2. 执行 `git clone https://github.com/Mixiaxiaoyu/dramatic-gobo-lighting.git ~/.codex/skills/dramatic-gobo-lighting`
> 3. 验证 `~/.codex/skills/dramatic-gobo-lighting/` 目录下能看到 `SKILL.md`、`assets/`、`references/`、`scripts/`。
> 4. 安装完成后告诉我已经装好了。后续我提到 gobo lighting、窗格光影、百叶窗光影、水波光影之类需求时，优先调用这个 skill。

把这段话直接复制给支持 shell 权限的 Codex 或 AI Agent，通常它就能自动完成安装。

### 方式三：手动安装

1. 克隆仓库到本地，或者下载 ZIP 后解压：

```bash
git clone https://github.com/Mixiaxiaoyu/dramatic-gobo-lighting.git
```

2. 把整个 `dramatic-gobo-lighting` 文件夹移动或复制到下面这个目录：

```text
~/.codex/skills/dramatic-gobo-lighting
```

Windows 常见路径示例：

```text
C:\Users\<你自己的用户名>\.codex\skills\dramatic-gobo-lighting
```

3. 安装完成后，确认目录下至少有这些内容：

```text
SKILL.md
assets/
references/
scripts/
```

4. 如果你想顺手做一次本地测试，也可以在仓库根目录执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\select_gobo.ps1 -Brief "moody noir portrait with blind shadows"
```

## 提示词固定标签

你可以直接把这些标签写进用户提示词里，技能会优先识别它们。

### 1. 背景控制

```text
@gobo-bg: lock
@gobo-bg: free
@gobo-bg: auto
```

- `lock`
  - 锁住背景颜色、背景层次和整体背景结构。
  - 适合品牌背景、3D 渲染图、UI 图、复杂主体。

- `free`
  - 允许背景为了氛围变得更暗、更暖、更冷，或者更有戏剧性。
  - 适合海报感、情绪感更强的图。

- `auto`
  - 由技能自动判断。
  - 默认会优先照顾稳定性。

### 2. 光影角度控制

```text
@gobo-angle: fixed
@gobo-angle: random
@gobo-angle: auto
```

- `fixed`
  - 使用更稳定、更保守的投影角度和落点。
  - 适合产品图、复杂 3D 图、信息密集的画面。

- `random`
  - 每次尝试都让光源方向和投影位置做受控随机。
  - 适合找灵感、快速试不同气质。

- `auto`
  - 由技能自动选择。

### 3. 光影边缘软硬程度

```text
@gobo-edge: crisp
@gobo-edge: soft
@gobo-edge: diffuse
@gobo-edge: soft*2
@gobo-edge: diffuse*2
@gobo-edge: auto
```

- `crisp`
  - 边缘硬，黑白交界更清晰。
  - 适合强烈阳光感、百叶窗感、建筑感。

- `soft`
  - 轻微软化边缘，但仍然保留清楚的图案识别。

- `diffuse`
  - 更明显的柔化，边界会更雾、更松。

- `soft*2`
  - 比普通 `soft` 再软一档。

- `diffuse*2`
  - 比普通 `diffuse` 再软一档。
  - 适合你之前测试过的那种更柔和的过渡。

- `auto`
  - 由技能自动判断。

### 4. 投影放大倍率

```text
@gobo-scale: 0.75
@gobo-scale: 1.0
@gobo-scale: 1.5
@gobo-scale: 2.0
@gobo-scale: 2.5
```

这个参数控制的不是图片分辨率，而是 gobo 投影在画面里“看起来有多大”。

- 值越大
  - 图案越大
  - 重复越少
  - 更容易只出现在局部区域

- 值越小
  - 图案越密
  - 重复越多
  - 更容易铺满更大范围

### 5. 手动指定 gobo

```text
@gobo-file: GSG_Gobos_Windows_Blinds_07.jpg
@gobo-file: GSG_Gobos_Caustics_Caustics_02.jpg
```

请直接从 [references/gobo-catalog.md](./references/gobo-catalog.md) 里复制精确文件名。

只要这个标签存在，它就会覆盖自动 gobo 选择，直接强制使用这张参考图。

快捷查询入口：

- [gobo 名字快捷查询](./references/gobo-name-quick-lookup.md)
- [完整 gobo 文件名清单](./references/gobo-catalog.md)

## 案例展示

下面这 4 张图就是这个 skill 的典型使用方向，分别对应植物叶影、窗格光影、抽象破碎光影和百叶窗光影。

### 案例 1：植物叶影人像

适合方向：`Plants / Palm`

![植物叶影人像](./assets/examples/case-01-plants-portrait.png)

### 案例 2：窗格光影产品图

适合方向：`Windows / Window`

![窗格光影产品图](./assets/examples/case-02-window-perfume.png)

### 案例 3：抽象破碎光影静物

适合方向：`Abstract`

![抽象破碎光影静物](./assets/examples/case-03-abstract-rock.png)

### 案例 4：百叶窗光影时尚人像

适合方向：`Windows / Blinds`

![百叶窗光影时尚人像](./assets/examples/case-04-blinds-fashion-red.png)

## 推荐用法示例

### 图生图 / 用户上传图片

#### 保持背景完全不变

```text
@gobo-bg: lock @gobo-angle: fixed @gobo-edge: soft
给这张渲染图加上戏剧性的窗格投影光，但保持背景完全不变。
```

#### 允许背景更有氛围

```text
@gobo-bg: free @gobo-angle: fixed @gobo-edge: diffuse
给这张图加上更电影感的窗影，并允许背景氛围变暗一点。
```

#### 让 gobo 只影响局部区域

```text
@gobo-bg: free @gobo-angle: fixed @gobo-edge: soft @gobo-scale: 2.0
加一个更大的局部窗影，让光只落在画面一侧。
```

#### 每次都尝试不同光位

```text
@gobo-bg: lock @gobo-angle: random @gobo-edge: soft
在保持主体稳定的前提下，尝试不同的 gobo 光位。
```

#### 手动指定某一张 gobo

```text
@gobo-bg: lock @gobo-angle: fixed @gobo-file: GSG_Gobos_Windows_Blinds_07.jpg
对上传的渲染图使用这一张指定的百叶窗 gobo，并保持背景不变。
```

### 文生图 / 不上传原图

#### 生成百叶窗时尚人像

```text
@gobo-bg: free @gobo-angle: fixed @gobo-edge: crisp
一个电影感时尚人像，人物站在偏暗的酒店房间里，墙面和肩膀上有清晰的百叶窗投影，强烈阳光，低环境光，高级时尚大片氛围。
```

#### 生成更柔和的植物叶影美妆图

```text
@gobo-bg: free @gobo-angle: random @gobo-edge: diffuse
一张干净的美妆人像，脸部和背景上有柔和的热带植物叶影，午后暖阳，通透高光，高级护肤广告质感。
```

#### 生成局部大窗影的产品图

```text
@gobo-bg: free @gobo-angle: fixed @gobo-edge: soft @gobo-scale: 2.0
一只高端香水瓶放在石质底座上，只有画面一侧被大面积局部窗影照亮，阴影优雅，奢侈品静物摄影风格。
```

#### 生成柔和水波光的场景

```text
@gobo-bg: free @gobo-angle: random @gobo-edge: diffuse*2
一个雕塑感护肤瓶置于阳光洒入的 spa 空间中，墙面和台面上有非常柔和的水波反射光影，空气微湿，整体安静而高级。
```

#### 文生图时手动指定某一张 gobo

```text
@gobo-bg: free @gobo-angle: fixed @gobo-file: GSG_Gobos_Caustics_Caustics_02.jpg
一个高端护肤瓶置于安静的 spa 房间中，整体光影严格参考这张指定的水波 gobo，墙面出现柔和反射光，高级静奢氛围。
```

## 默认行为

如果用户没有写任何固定标签，技能会按下面的默认逻辑处理：

```text
@gobo-bg: auto
@gobo-angle: auto
@gobo-edge: auto
@gobo-scale: 1.0
```

其中：

- 复杂图片会优先偏向保守和稳定
- 简单图片会允许更明显的气氛变化
- 整体依然是 preservation-first，也就是优先保护原图主体、布局、材质和可识别元素
