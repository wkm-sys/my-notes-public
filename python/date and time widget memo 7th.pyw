import tkinter as tk
from datetime import datetime
import os

# 星期英文缩写
weekday_map = {0:"Mon",1:"Tue",2:"Wed",3:"Thu",4:"Fri",5:"Sat",6:"Sun"}

elapsed_seconds = 0.0

last_clipboard = ""

def check_clipboard_path():
    global last_clipboard
    try:
        clip = root.clipboard_get().strip()
    except tk.TclError:
        clip = ""

    if clip != last_clipboard and os.path.exists(clip):
        widget = root.focus_get()
        if isinstance(widget, tk.Entry):
            widget.delete(0, tk.END)
            widget.insert(0, clip)
            last_clipboard = clip

    root.after(500, check_clipboard_path)

def get_week_number(dt):
    return dt.isocalendar()[1]

def reset_timer():
    global elapsed_seconds
    elapsed_seconds = 0.0

def open_path(entry):
    path = entry.get().strip()
    if os.path.exists(path):
        os.startfile(path)

def update_button_time():
    now = datetime.now()
    week_num = get_week_number(now)
    date_str = now.strftime("%Y-%m-%d")
    weekday_str = weekday_map[now.weekday()]
    time_str = now.strftime("%H:%M:%S")
    button_time.config(
        text=f"W{week_num:<2} | {date_str} | {weekday_str} | {time_str}",
        anchor="center"
    )
    root.after(1000, update_button_time)

def update_title_time():
    global elapsed_seconds
    elapsed_seconds += 0.1
    hours, rem = divmod(int(elapsed_seconds), 3600)
    minutes, seconds = divmod(rem, 60)
    tenths = int((elapsed_seconds - int(elapsed_seconds)) * 10)
    root.title(f"Desktop Memo Widget - Open {hours:02d}:{minutes:02d}:{seconds:02d}.{tenths}")
    root.after(100, update_title_time)

# 主窗口
root = tk.Tk()
root.title("Desktop Memo Widget")

win_width, win_height = 500, 350
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
x = (screen_width - win_width) // 2
y = (screen_height - win_height) // 2
root.geometry(f"{win_width}x{win_height}+{x}+{y}")
root.attributes("-topmost", True)

# ===== 顶部三行：Entry + Open =====
def make_path_row(parent):
    frame = tk.Frame(parent)
    frame.pack(padx=10, pady=2, fill=tk.X)

    entry = tk.Entry(frame, font=("Arial",16))
    entry.pack(side=tk.LEFT, fill=tk.X, expand=True)

    # 回车自动打开
    entry.bind("<Return>", lambda e: open_path(entry))

    btn = tk.Button(frame, text="Open", command=lambda: open_path(entry))
    btn.pack(side=tk.RIGHT, padx=5)

    return entry

entry1 = make_path_row(root)
entry2 = make_path_row(root)
entry3 = make_path_row(root)

# 中间时间按钮
button_time = tk.Button(root, font=("Arial",20), command=reset_timer)
button_time.pack(padx=10, pady=5, fill=tk.X)

# 多行备忘
text_memo = tk.Text(root, height=5, font=("Arial",16))
text_memo.pack(padx=10, pady=5, fill=tk.BOTH, expand=True)

update_button_time()
update_title_time()
check_clipboard_path()

root.mainloop()
