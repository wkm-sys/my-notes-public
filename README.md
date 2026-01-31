# 代码与笔记安全自查清单 (Security Check-list)

温馨提示:每次在提交代码或发布笔记前，记得识别并脱敏信息，确保符合安全规范。

可以在项目根目录建一个 .gitignore 文件。它能帮你自动过滤掉那些包含 API Key 的配置文件。

## 🛡️ 核心检查项 (Core Checks)

| **#** | **Check Item (English)** | **检查项 (中文)**                  | **Status** |
| ----- | ------------------------ | ----------------------------- | ---------- |
| 1     | **Credentials**          | 密码 / API Key / Token / Secret | ⬜          |
| 2     | **Identity**             | 真实邮箱地址或登录账号名                  | ⬜          |
| 3     | **User Path**            | 真实本地路径 (如 `C:\Users\abc\...`) | ⬜          |
| 4     | **Network**              | 内网 IP / 服务器名 / 内部 Host        | ⬜          |
| 5     | **Client/Project**       | 真实客户缩写或未公开项目名                 | ⬜          |
| 6     | **Runtime Logs**         | 直接粘贴的真实运行日志 (含上下文敏感信息)        | ⬜          |
| 7     | **Hardcoded URL**        | 带有内部端口或特定环境的硬编码链接             | ⬜          |
| 8     | **Comments**             | 包含吐槽或 TODO 备注的注释              | ⬜          |

---
# Notes & Reflections / 笔记与思考

> **声明 / Disclaimer**  
> - 这些总结只是我的个人思考与记录。  
>   **These summaries are only my personal thoughts and notes.**  
> - 对某些人来说，它们可能显得抽象或无意义；  
>   **For some, they may seem abstract or meaningless;**  
> - 对另一些人来说，它们或许正好带来启发。  
>   **For others, they may provide just the right inspiration.**  
> - 如果你觉得有用，那很好；如果没有，也没关系。  
>   **If you find them useful, that's great; if not, that's fine too.**

---

## 核心总结 / Core Summary

- 无论是语言、数学、操作系统还是认知本身，困境往往来自系统的自我指涉。  
  **Whether in language, mathematics, operating systems, or cognition itself, difficulties often arise from a system's self-reference.**

- 只有跳出，才能重构。  
  **Only by stepping outside can reconstruction happen.**

- 平台不是边界，思维才是。  
  **The platform is not the boundary — the mind is.**

- 工具只是达成目标的桥梁，而非终点。  
  **Tools are merely bridges toward goals, not the destination itself.**

  ## 目录 Index *(待扩展)*

- [Writer’s Illusion / 作家的错觉](./writers-illusion.md)
- [Guilt and AI / 使用 AI 写作的愧疚感](./Guilt_and_AI.md)
- [Mac 定时开关机被隐藏 / mac-schedule-hidden](./mac-schedule-hidden.md)
- [Geeks and DOS / 极客与 DOS](./geeks_and_dos.md)
- [Nightbrew / 夜酿](./Nightbrew.md)
- [My Lucky Domain Story / 后知后觉的幸运](my-lucky-domain.md)


*这些笔记由我书写，并在 AI 的协助下整理完成。*  
*These notes are written by me, with the assistance of AI in organizing them.*  


