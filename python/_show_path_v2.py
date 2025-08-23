import ctypes
try:
    ctypes.windll.shcore.SetProcessDpiAwareness(1)  # 让程序对 DPI 敏感
except Exception:
    pass


import tkinter as tk
from tkinter import filedialog, font
import os, json

CONFIG_FILE = "config.json"

def load_config():
    return json.load(open(CONFIG_FILE, "r", encoding="utf-8")) if os.path.exists(CONFIG_FILE) else {}

def save_config(cfg):
    json.dump(cfg, open(CONFIG_FILE, "w", encoding="utf-8"), ensure_ascii=False, indent=2)

def select_path(btn_id):
    path = filedialog.askopenfilename()
    if path:
        config[btn_id] = path
        save_config(config)
        buttons[btn_id].config(text=os.path.basename(path))

def show_path(btn_id):
    path = config.get(btn_id, "")
    if path:
        folder, filename = os.path.split(path)
        text_path.delete("1.0", tk.END)
        text_path.insert(tk.END, folder)
        text_file.delete("1.0", tk.END)
        text_file.insert(tk.END, filename)

root = tk.Tk()
root.title("路径展示器")

root.geometry("770x220")   # 宽，高


# 设置全局字体更小
default_font = font.nametofont("TkDefaultFont")
default_font.configure(size=9)

config = load_config()
buttons = {}

frame_btns = tk.Frame(root)
frame_btns.pack(side=tk.TOP, pady=3)

for i in range(1, 6):
    btn_id = f"btn{i}"
    text = os.path.basename(config.get(btn_id, f"选择路径 {i}"))
    btn = tk.Button(frame_btns, text=text, width=12, height=1,  # 缩小宽度和高度
                    command=lambda b=btn_id: show_path(b))
    btn.grid(row=0, column=i-1, padx=3)
    btn.bind("<Button-3>", lambda e, b=btn_id: select_path(b))
    buttons[btn_id] = btn

# 路径文本框
tk.Label(root, text="路径：").pack(anchor="w")
text_path = tk.Text(root, height=1, width=50, font=("Consolas", 9))
text_path.pack(padx=5, pady=3)

# 文件名文本框
tk.Label(root, text="文件名：").pack(anchor="w")
text_file = tk.Text(root, height=1, width=50, font=("Consolas", 9))
text_file.pack(padx=5, pady=3)

root.mainloop()
