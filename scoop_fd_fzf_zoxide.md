📂项目：Win11 终端瞬移与PowerShell环境重建

**标签：** `#Toolchain` `#Workflow` `#PowerShell` `#Michael_Custom`

### 1. 核心神器安装 (Scoop)

在第二台设备上，确保已使用 PowerShell，并安装 Scoop，然后一键安装以下工具：

PowerShell

```
# fd: 代替 dir/ls，负责超快搜索
# fzf: 模糊过滤利器，负责选择
# zoxide: 路径记忆专家，负责日常跳转
scoop install fd fzf zoxide
```

---

### 2. 自动化配置文件 ($PROFILE)

这是实现“定制化 Everything”的灵魂。

- **查找路径：** 在 PowerShell 输入 `notepad $PROFILE`。
    
- **新建命令（若不存在）：** `New-Item -Path $PROFILE -Type File -Force`。
    

**必存脚本：**

PowerShell

```
# 1. 初始化 zoxide (让 z 让 z / zi 等命令在当前 PowerShell 会话中生效)
Invoke-Expression (& {zoxide init powershell | Out-String})

# 2. Michael 定制版 wd (Work Directory) 瞬移函数
function wd { 
    # 在指定根目录下只搜目录 (--type d)，通过 fzf 筛选
    $target = fd . D:\work --type d | fzf --prompt="📂 瞬移至工作目录 > " --height=40% --layout=reverse --border
    
    # 如果选中了路径，则调用系统默认资源管理器打开 (ii)
    if ($target) {
        ii "$target"
    }
}
```

- 查找配置文件：`notepad $PROFILE`
    
- 若文件不存在，执行：`New-Item -Path $PROFILE -Type File -Force`
---

### 3. 系统权限放行

新机第一次运行脚本若提示执行策略限制，可在 PowerShell 中运行一次：

PowerShell

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---
