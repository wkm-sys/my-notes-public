# NX 2412 Simple Volume + Weight Report (ρ = 1 g/cm^3)
# Provided By Fukoto R&D

import NXOpen
import datetime

def main():
    the_session = NXOpen.Session.GetSession()
    the_ui = NXOpen.UI.GetUI()
    lw = the_session.ListingWindow
    lw.Open()

    work_part = the_session.Parts.Work

    # -------------------------
    # 1. 读取 MW_STOCK_SIZE
    # -------------------------
    attr_name = "MW_STOCK_SIZE"
    custom_name = "3d_Size="

    try:
        # 取到属性值
        attr_value = work_part.GetStringAttribute(attr_name)

        # 判断是不是表达式（典型形式：p+数字）
        if attr_value.startswith("p") and attr_value[1:].isdigit():
            try:
                expr = work_part.Expressions.FindObject(attr_value)
                final_value = str(expr.Value) + "mm"
                stock_str = f"{custom_name}{final_value}"
            except:
                stock_str = f"{custom_name}{attr_value} (未找到对应表达式)"
        else:
            # 普通字符串属性：分割并逐一加 mm
            parts = [p.strip() + "mm" for p in attr_value.split("x")]
            stock_str = f"{custom_name}{' x '.join(parts)}"

    except:
        stock_str = f"{custom_name}<未找到属性 {attr_name}>"

    # -------------------------
    # 2. 输出签名 + 文件名 + 3d_Size
    # -------------------------
    solids = [b for b in work_part.Bodies if b.IsSolidBody]

    lw.WriteLine("=== Provided By Fukoto R&D ===")
    lw.WriteLine(f"File_Name: {work_part.Leaf}")   # 第二行：文件名
    lw.WriteLine(stock_str)                        # 第三行：3d_Size

    if solids:
        # Get base units
        ucol = work_part.UnitCollection
        mass_units = [
            ucol.GetBase("Area"),
            ucol.GetBase("Volume"),
            ucol.GetBase("Mass"),
            ucol.GetBase("Length"),
        ]

        # Calculate mass properties
        mm = work_part.MeasureManager
        mb = mm.NewMassProperties(mass_units, 0.99, solids)

        # Volume (mm^3)
        volume_mm3 = mb.Volume

        # Weight (ρ = 1 g/cm^3)
        weight_g  = volume_mm3 / 1000.0         # mm^3 → cm^3 → g
        weight_kg = weight_g / 1000.0           # g → kg

        lw.WriteLine("=== Simple Volume + Weight Report ===")
        lw.WriteLine(f"Total volume: {volume_mm3:.2f} mm^3")
        lw.WriteLine(f"Weight (ρ=1 g/cm^3): {weight_g:.2f} g  (~ {weight_kg:.2f} kg)")
    else:
        lw.WriteLine("=== Simple Volume + Weight Report ===")
        lw.WriteLine("<未找到有效的实体>")

    # -------------------------
    # 3. 输出日期
    # -------------------------
    today = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    lw.WriteLine(f"=== Date: {today} ===")

    # -------------------------
    # 4. 弹窗显示
    # -------------------------
    the_ui.NXMessageBox.Show("Provided By Fukoto R&D",
                             NXOpen.NXMessageBox.DialogType.Information,
                             f"File_Name: {work_part.Leaf}\n{stock_str}\nDate: {today}")

if __name__ == "__main__":
    main()


def main():
    the_session = NXOpen.Session.GetSession()
    work_part = the_session.Parts.Work

    if work_part is None:
        the_session.ListingWindow.Open()
        the_session.ListingWindow.WriteLine("⚠ 没有打开的文件")
        return

    file_path = work_part.FullPath

    # 打开 NX 自带的 Listing Window（列表窗口），确保能看到输出
    lw = the_session.ListingWindow
    lw.Open()

    if file_path:
        lw.WriteLine("当前文件路径: " + file_path)
    else:
        lw.WriteLine("⚠ 当前部件还没有保存过，没有路径")

if __name__ == '__main__':
    main()
