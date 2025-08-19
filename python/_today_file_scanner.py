# File: _today_file_scanner.py
# 功能: 扫描当天新增或修改的文件 (已移动到 python_scripts/ 目录)

import os
import time
from datetime import datetime
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

# ------------------------
# 功能: 扫描当天新增或修改的文件
# ------------------------
def scan_today_files(base_path, save_dir="D:\\Today_Files"):
    today = datetime.today().date()

    results = {}
    total_files = 0
    matched_files = 0

    # 统计文件总数（方便进度显示）
    for root, dirs, files in os.walk(base_path):
        total_files += len(files)

    processed = 0
    for root, dirs, files in os.walk(base_path):
        for file in files:
            processed += 1
            file_path = os.path.join(root, file)
            try:
                mtime = datetime.fromtimestamp(os.path.getmtime(file_path)).date()
                if mtime == today:
                    if root not in results:
                        results[root] = []
                    results[root].append(file)
                    matched_files += 1
            except Exception as e:
                pass

            # 显示百分比进度
            percent = (processed / total_files) * 100 if total_files else 100
            print(f"\r扫描进度: {percent:.2f}%", end="")

    print("\n扫描完成！")

    # 确保结果目录存在
    os.makedirs(save_dir, exist_ok=True)

    save_path = os.path.join(save_dir, "today_files.txt")

    # 写入结果（树形格式）
    with open(save_path, "w", encoding="utf-8") as f:
        f.write(f"今日新增或修改的文件 (保存路径: {save_path})\n\n")
        for root, files in results.items():
            f.write(f"{root}\\\n")
            for file in files:
                f.write(f"    {file}\n")
            f.write("\n")

    # 扫描结束后自动打开结果
    os.startfile(save_path)

    # 弹出可复制窗口（树形格式）
    show_copy_window(results)


# ------------------------
# 弹出可复制的结果窗口（树形格式）
# ------------------------
def show_copy_window(results):
    if not results:
        messagebox.showinfo("结果", "今日无新增或修改的文件。")
        return

    root = tk._default_root
    if root is None:
        root = tk.Tk()
        root.withdraw()

    win = tk.Toplevel(root)
    win.title("今日文件路径列表（可复制）")
    win.geometry("900x500")
    win.attributes("-topmost", True)

    frm = ttk.Frame(win)
    frm.pack(fill="both", expand=True, padx=8, pady=8)

    txt = tk.Text(frm, wrap="none")
    vsb = ttk.Scrollbar(frm, orient="vertical", command=txt.yview)
    hsb = ttk.Scrollbar(frm, orient="horizontal", command=txt.xview)
    txt.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)

    # 格式化结果为树形
    lines = []
    for root, files in results.items():
        lines.append(f"{root}\\")
        for file in files:
            lines.append(f"    {file}")
        lines.append("")

    text_content = "\n".join(lines)

    txt.insert("1.0", text_content)
    txt.grid(row=0, column=0, sticky="nsew")
    vsb.grid(row=0, column=1, sticky="ns")
    hsb.grid(row=1, column=0, sticky="ew")

    frm.rowconfigure(0, weight=1)
    frm.columnconfigure(0, weight=1)

    btnbar = ttk.Frame(win)
    btnbar.pack(fill="x", padx=8, pady=(0, 8))

    def copy_all():
        win.clipboard_clear()
        win.clipboard_append(text_content)

    ttk.Button(btnbar, text="复制全部", command=copy_all).pack(side="left")
    ttk.Button(btnbar, text="关闭", command=win.destroy).pack(side="right")

    win.mainloop()


# ------------------------
# 主入口: 弹窗选择目录
# ------------------------
if __name__ == "__main__":
    root = tk.Tk()
    root.withdraw()  # 隐藏主窗口
    path = filedialog.askdirectory(title="请选择要扫描的目录")
    if path:
        scan_today_files(path)
    else:
        print("未选择目录，程序已退出。")

