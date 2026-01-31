import NXOpen
import re
import os

def main():
    the_session = NXOpen.Session.GetSession()
    lw = the_session.ListingWindow
    lw.Open()

    work_part = the_session.Parts.Work

    if work_part is None:
        lw.WriteLine("⚠ 没有打开的文件")
        return

    file_path = work_part.FullPath

    if file_path:
        # 正则清理：删除最后一个 \ 及其后的文件名
        folder_path = re.sub(r"\\[^\\]+$", "", file_path)

        lw.WriteLine("完整路径：\n")
        lw.WriteLine("")
        lw.WriteLine(file_path)
        lw.WriteLine("")
        lw.WriteLine("目录路径：\n")
        lw.WriteLine("")
        lw.WriteLine(folder_path)
        os.startfile(folder_path)
    else:
        lw.WriteLine("⚠ 当前部件还没有保存过，没有路径")

if __name__ == "__main__":
    main()
