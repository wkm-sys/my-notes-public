# 为什么苹果把定时开关机藏起来了？  
# Why Did Apple Hide Scheduled Power On/Off?

在新版 macOS 中，图形界面的「定时开关机」被移除，只能通过终端实现。  
In newer macOS versions, the graphical “Scheduled Power On/Off” option was removed; you must use Terminal.

这让人不禁发问：**普通用户难道不配拥有这个功能吗？**  
This naturally begs the question: **Do ordinary users not deserve this feature?**

好消息是，功能还在，只是“藏”在命令行工具 `pmset` 里。  
The good news: the capability still exists—it’s just “hidden” in the `pmset` command-line tool.

---

## 使用 `pmset` 设置定时任务  
## Use `pmset` to Schedule Tasks

下面是最常用的三个操作：  
Here are the three most common operations:

### 每天早上 06:30 自动开机或唤醒  
### Wake or Power On Every Day at 06:30
```bash
sudo pmset repeat wakeorpoweron MTWRFSU 06:30:00
```

### 每天晚上 23:00 自动关机  
### Shut Down Every Day at 23:00
```bash
sudo pmset repeat shutdown MTWRFSU 23:00:00
```

### 取消所有已设置的定时  
### Cancel All Scheduled Tasks
```bash
sudo pmset repeat cancel
```

---

## 参数速读  
## Parameter Quick Read

- `wakeorpoweron`：开机或唤醒（视机型与当前电源状态而定）。  
- `wakeorpoweron`: power on or wake (depends on model and power state).

- `shutdown`：关机。  
- `shutdown`: shut down.

- `MTWRFSU`：周一到周日；也可用子集如 `MTWRF`（工作日）或 `SU`（周末）。  
- `MTWRFSU`: Monday–Sunday; subsets like `MTWRF` (weekdays) or `SU` (weekend) are valid.

- `06:30:00`：24 小时制时间（`HH:MM[:SS]`）。  
- `06:30:00`: 24-hour time (`HH:MM[:SS]`).

---

## 查看与校验  
## Inspect and Verify

查看当前计划的任务：  
View currently scheduled tasks:
```bash
pmset -g sched
```

立即执行一次以测试唤醒：  
Trigger a quick test wake:
```bash
pmset schedule wakeorpoweron "2025-08-19 14:00:00"
```

---

## 常见坑与小贴士  
## Common Gotchas & Tips

- **需要管理员权限**：若未加 `sudo` 可能报 “Operation not permitted”。  
- **Admin required**: without `sudo` you may see “Operation not permitted”.

- **从完全关机并不总能“自动开机”**：部分机型更可靠的是“睡眠→定时唤醒”。  
- **Full power-on isn’t guaranteed**: on some models it’s more reliable to schedule a wake from sleep.

- **请接通电源**：笔记本建议接电；台式机掉电会影响定时。  
- **Stay plugged in**: laptops should be on AC; power loss can break schedules on desktops.

- **合盖可能阻止唤醒**：笔记本合盖有时不会按计划亮屏。  
- **Closed lid may block wake**: some laptops won’t wake with the lid closed.

- **与其他电源/睡眠策略冲突**：若有第三方电源管理或配置描述文件，优先排查冲突。  
- **Conflicts happen**: third-party power tools or profiles can override `pmset`.

---

## 一点黑色幽默  
## A Touch of Dark Humor

如果你抱怨它被“藏”得太深，工程师可能会说：**“这不是 bug，这是 feature。”**  
If you complain it’s hidden too well, an engineer might say: **“It’s not a bug—it’s a feature.”**

但对真正需要的人来说，**我们只是想要一个好用又可见的开关。**  
For those who truly need it, **we just want a useful, visible switch.**
