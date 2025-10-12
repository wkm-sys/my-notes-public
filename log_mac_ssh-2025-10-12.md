# SSH + Docker + AppleScript + Homer 总结

> 提示词：给我.md格式的 尽量避免代码块围栏的嵌套（保证格式统一、命令可读、避免嵌套问题）

## 1. iPad SSH 的体验与优势

- **视觉舒适**：绿色字 + 青黑底，复古“黑客风”，眼睛看久了不累  
- **便携远程控制**：iPad 变成随身“控制台”，可管理局域网的 MacMini  
- **全功能操作**：Docker 容器、Alist、NeoVision、关机重启、锁屏都可以远程执行  

## 2. AppleScript + alias 的作用

- **自动化 Terminal 操作入口**：将系统操作、应用启动、组合脚本封装成 alias  
- **示例**：

  alias shutdownMac='osascript -e '\''tell app "System Events" to shut down'\'''
  
  alias lockMac='osascript -e '\''tell app "System Events" to keystroke "q" using {control down, command down}'\'''
  
  alias startWeb='docker start webserver'
  
  alias startAll='docker start $(docker ps -a -q)'

- **优点**：
  - 快捷、一条命令完成多步操作  
  - 可结合 SSH 或本地 Terminal 使用  
  - 类似 macOS 版的 AutoHotkey  

## 3. Docker 容器管理

- **查看容器**：

  docker ps -a           # 查看所有容器  
  docker ps               # 查看运行中容器  
  docker ps -a --filter "status=exited"  # 查看停止容器

- **启动容器**：

  docker start <container_name_or_id>         # 单个  
  docker start $(docker ps -a --filter "status=exited" -q)  # 启动所有停止容器

- **组合 alias**：
  - SSH + alias 可一条命令批量启动服务  
  - 无需依赖 Docker Desktop GUI  

## 4. Homer 与局域网/本地服务

- **Homer 可作为启动页**，整合：
  - 本地服务：MAMP、NeoVision、Alist  
  - 外部链接：YouTube、GitHub、Google Keep 等  
  - 结合脚本/alias 可以触发 Mac 系统操作或容器操作  

- **思路**：
  - Homer 本身不监控 Docker，但可以指向 HTML/JSON 页面显示容器状态  
  - 结合 SSH + alias，你可以完全在 Terminal 上管理服务，Homer 仅作快捷入口  

## 5. 核心理念

- SSH + Docker CLI = 远程、即时、轻量的容器控制  
- AppleScript + alias = Terminal 自动化 + 系统操作快捷入口  
- Homer = 可视化整合本地服务和外部链接的个人仪表盘  

- **组合使用**：你的 iPad 就成了随身控制台，无需依赖 GUI，即可随时管理 Mac、Docker 容器和本地服务  

### 总结一句话

通过 SSH + Docker CLI + AppleScript + alias + Homer，你建立了一个轻量、可远程操作、可可视化管理的个人控制台，既能随时启动/停止容器，也能控制系统操作，同时整合本地和外部服务。
