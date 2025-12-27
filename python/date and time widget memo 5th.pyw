import tkinter as tk
from datetime import datetime

# 星期英文缩写
weekday_map = {0:"Mon",1:"Tue",2:"Wed",3:"Thu",4:"Fri",5:"Sat",6:"Sun"}

# 窗口打开计时器
elapsed_seconds = 0.0  # 支持小数秒

def get_week_number(dt):
    return dt.isocalendar()[1]

def reset_timer():
    global elapsed_seconds
    elapsed_seconds = 0.0  # 重置计时器

def update_button_time():
    """更新中间按钮时间（1秒刷新）"""
    now = datetime.now()
    week_num = get_week_number(now)
    date_str = now.strftime("%Y-%m-%d")
    weekday_str = weekday_map[now.weekday()]
    time_str = now.strftime("%H:%M:%S")
    button_time.config(text=f"W{week_num:<2} | {date_str} | {weekday_str} | {time_str}", anchor="center")
    root.after(1000, update_button_time)  # 每秒刷新

def update_title_time():
    """更新标题栏计时器（0.1秒刷新）"""
    global elapsed_seconds
    elapsed_seconds += 0.1
    hours, rem = divmod(int(elapsed_seconds), 3600)
    minutes, seconds = divmod(rem, 60)
    tenths = int((elapsed_seconds - int(elapsed_seconds)) * 10)
    root.title(f"Desktop Memo Widget - Open {hours:02d}:{minutes:02d}:{seconds:02d}.{tenths}")
    root.after(100, update_title_time)  # 每0.1秒刷新

# 创建主窗口
root = tk.Tk()
root.title("Desktop Memo Widget")
font_size = 20

# 窗口大小与居中
win_width, win_height = 500, 350
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
x = (screen_width - win_width) // 2
y = (screen_height - win_height) // 2
root.geometry(f"{win_width}x{win_height}+{x}+{y}")
root.attributes("-topmost", True)  # 始终在最前

# 顶部三个独立单行输入
entry1 = tk.Entry(root, font=("Arial",16)); entry1.pack(padx=10,pady=2,fill=tk.X)
entry2 = tk.Entry(root, font=("Arial",16)); entry2.pack(padx=10,pady=2,fill=tk.X)
entry3 = tk.Entry(root, font=("Arial",16)); entry3.pack(padx=10,pady=2,fill=tk.X)

# 中间按钮显示时间并可点击重置计时器
button_time = tk.Button(root, font=("Arial", font_size), command=reset_timer)
button_time.pack(padx=10, pady=5, fill=tk.X)

# 临时多行备忘录
text_memo = tk.Text(root, height=5, font=("Arial",16))
text_memo.pack(padx=10, pady=5, fill=tk.BOTH, expand=True)

# 启动刷新
update_button_time()  # 每秒刷新中间按钮时间
update_title_time()   # 每0.1秒刷新标题栏计时器

root.mainloop()
