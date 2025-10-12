# 📌 Markdown 代码块语言标注总结
---
- [📌 Markdown 代码块语言标注总结](#-markdown-代码块语言标注总结)
  - [✅ 基本语法](#-基本语法)
  - [🧪 示例](#-示例)
  - [📚 常见语言标记](#-常见语言标记)
- [📌 Markdown Code Block Language Tag Summary](#-markdown-code-block-language-tag-summary)
  - [✅ Basic Syntax](#-basic-syntax)
  - [🧪 Examples](#-examples)
  - [📚 Common Language Tags](#-common-language-tags)


在 Markdown 中，可以通过在代码块的开头三个反引号后添加语言名称来标注代码类型并启用语法高亮。

---

## ✅ 基本语法

\`\`\`语言名称  
代码内容  
\`\`\`

---

## 🧪 示例

```bash
# Bash 或 Zsh 命令
ls -la
cd /usr/local
```

```python
# Python 示例
def greet():
    print("Hello, world!")
```

```json
{
  "name": "Copilot",
  "type": "AI"
}
```

---

## 📚 常见语言标记

| 语言类型   | 标记方式     |
|------------|--------------|
| Bash/Zsh   | `bash`       |
| Shell 脚本 | `sh`         |
| Python     | `python`     |
| JavaScript | `javascript` |
| JSON       | `json`       |
| YAML       | `yaml`       |
| HTML       | `html`       |
| CSS        | `css`        |
| Markdown   | `markdown`   |
| Dockerfile | `dockerfile` |

---

> ✅ 使用语言标记不仅能提升可读性，还能在支持的平台上启用语法高亮  
> ⚠️ 如果不指定语言，代码块将以纯文本显示，无高亮效果

---

# 📌 Markdown Code Block Language Tag Summary

In Markdown, you can specify the programming or scripting language for a code block by adding the language name immediately after the opening triple backticks. This enables syntax highlighting in supported editors and platforms.

---

## ✅ Basic Syntax

\`\`\`language  
Your code here  
\`\`\`

---

## 🧪 Examples

```bash
# Bash or Zsh commands
echo "Hello, world!"
ls -la
```

```python
# Python example
def greet():
    print("Hello, world!")
```

```json
{
  "name": "Copilot",
  "type": "AI"
}
```

---

## 📚 Common Language Tags

| Language       | Tag          |
|----------------|--------------|
| Bash / Zsh     | `bash`       |
| Shell Script   | `sh`         |
| Python         | `python`     |
| JavaScript     | `javascript` |
| JSON           | `json`       |
| YAML           | `yaml`       |
| HTML           | `html`       |
| CSS            | `css`        |
| Markdown       | `markdown`   |
| Dockerfile     | `dockerfile` |

---

> ✅ Using language tags improves readability and enables syntax highlighting  
> ⚠️ If no language is specified, the code block will render as plain text

