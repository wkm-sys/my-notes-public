import os
import sqlite3
import json
import time
import datetime
from PIL import Image
from PIL.ExifTags import TAGS
from tkinter import Tk, filedialog
import pillow_heif

pillow_heif.register_heif_opener()

# -----------------------------
# Helper: extract photo info
# -----------------------------
def get_photo_info(image_path):
    try:
        image = Image.open(image_path)
        width, height = image.size
        resolution = f"{width}x{height}"
        exif = image._getexif()
        if exif:
            exif_data = {TAGS.get(k, k): v for k, v in exif.items()}
            date = exif_data.get('DateTimeOriginal')
            camera = exif_data.get('Model')
        else:
            date = None
            camera = None
        return date, camera, resolution
    except Exception as e:
        print(f"Failed to process: {image_path}, Error: {e}")
        return None, None, None

# -----------------------------
# Module 1: Scan photos
# -----------------------------
def scan_photos():
    root = Tk()
    root.withdraw()
    scan_dir = filedialog.askdirectory(title="Select photo folder to scan")
    if not scan_dir:
        print("No directory selected. Returning to menu.")
        return

    db_file = os.path.join(scan_dir, 'photos.db')
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS photos (
        id INTEGER PRIMARY KEY,
        file_path TEXT UNIQUE,
        file_name TEXT,
        exif_date TEXT,
        exif_camera TEXT,
        resolution TEXT
    )
    ''')
    conn.commit()

    start_time = time.time()
    conn.execute("BEGIN")
    count = 0
    fail_count = 0

    for root_dir, dirs, files in os.walk(scan_dir):
        for f in files:
            if f.lower().endswith(('.jpg', '.jpeg', '.png', '.heic', '.heif')):
                full_path = os.path.abspath(os.path.join(root_dir, f))
                date, camera, resolution = get_photo_info(full_path)
                if date or camera or resolution:
                    try:
                        cursor.execute('''
                        INSERT INTO photos (file_path, file_name, exif_date, exif_camera, resolution)
                        VALUES (?, ?, ?, ?, ?)
                        ON CONFLICT(file_path) DO UPDATE SET
                            file_name=excluded.file_name,
                            exif_date=excluded.exif_date,
                            exif_camera=excluded.exif_camera,
                            resolution=excluded.resolution
                        ''', (full_path, f, date, camera, resolution))
                        count += 1
                        if count % 100 == 0:
                            print(f"{count} photos processed...")
                    except Exception as e:
                        fail_count += 1
                        print(f"Failed to write to database: {full_path}, Error: {e}")
                else:
                    fail_count += 1

    conn.commit()
    conn.close()
    elapsed = time.time() - start_time
    print(f"Scan completed in {elapsed:.2f} seconds")
    print(f"Successfully processed: {count}, Failed: {fail_count}. Database: {db_file}")

# -----------------------------
# Module 2: Export JSON
# -----------------------------
def export_json():
    root = Tk()
    root.withdraw()
    db_dir = filedialog.askdirectory(title="Select folder containing photos.db")
    if not db_dir:
        print("No directory selected. Returning to menu.")
        return None

    db_file = os.path.join(db_dir, 'photos.db')
    json_file = os.path.join(db_dir, 'photos.json')

    if not os.path.exists(db_file):
        print(f"Database not found: {db_file}")
        return None

    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()
    cursor.execute("SELECT file_path, file_name, exif_date, exif_camera, resolution FROM photos")
    rows = cursor.fetchall()
    conn.close()

    photos_list = []
    for row in rows:
        photos_list.append({
            "file_path": row[0],
            "file_name": row[1],
            "exif_date": row[2],
            "exif_camera": row[3],
            "resolution": row[4]
        })

    with open(json_file, 'w', encoding='utf-8') as f:
        json.dump(photos_list, f, indent=2)

    print(f"Export completed. JSON file: {json_file}")
    return json_file

# -----------------------------
# Module 3: Export HTML
# -----------------------------
def export_html():
    json_file = export_json()
    if not json_file:
        print("JSON export failed. Cannot generate HTML.")
        return

    # Custom file name or timestamp
    user_input = input("Enter HTML file name (without extension, leave empty for auto timestamp): ").strip()
    if user_input:
        html_file = os.path.join(os.path.dirname(json_file), f"{user_input}.html")
    else:
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        html_file = os.path.join(os.path.dirname(json_file), f"photos_{timestamp}.html")

    # Load JSON
    with open(json_file, 'r', encoding='utf-8') as f:
        photos = json.load(f)

    html_content = f'''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Photo Gallery</title>
<style>
body {{ font-family: Arial, sans-serif; background: #f0f0f0; }}
h1 {{ text-align: center; }}
.gallery {{ display: flex; flex-wrap: wrap; gap: 10px; padding: 10px; justify-content: center; }}
.photo {{ background: #fff; padding: 5px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); width: 220px; text-align: center; }}
.photo img {{ max-width: 200px; max-height: 200px; display: block; margin: 0 auto 5px auto; cursor: pointer; transition: transform 0.2s; }}
.photo img:hover {{ transform: scale(1.05); }}
.photo .info {{ font-size: 12px; color: #555; word-wrap: break-word; }}
</style>
</head>
<body>
<h1>My Photo Gallery</h1>
<div class="gallery" id="gallery"></div>
<script>
const gallery = document.getElementById('gallery');
const photos = {json.dumps(photos)};
photos.forEach(photo => {{
    const div = document.createElement('div');
    div.className = 'photo';
    div.innerHTML = `
        <img src="${{photo.file_path}}" alt="${{photo.file_name}}" onclick="window.open('${{photo.file_path}}','_blank')">
        <div class="info">
            <strong>${{photo.file_name}}</strong><br>
            ${{photo.exif_date or ''}} ${{photo.exif_camera or ''}}<br>
            ${{photo.resolution or ''}}
        </div>
    `;
    gallery.appendChild(div);
}});
</script>
</body>
</html>'''

    with open(html_file, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f"HTML gallery generated: {html_file}")

# -----------------------------
# Main menu
# -----------------------------
def main_menu():
    while True:
        print("\n=== Local Photo Manager ===")
        print("1. Scan Photos → Update Database")
        print("2. Export Database → photos.json")
        print("3. Export JSON → HTML Gallery")
        print("4. Exit")
        choice = input("Select an option (1-4): ").strip()
        if choice == '1':
            scan_photos()
        elif choice == '2':
            export_json()
        elif choice == '3':
            export_html()
        elif choice == '4':
            print("Exiting. Goodbye!")
            break
        else:
            print("Invalid choice. Please select 1, 2, 3, or 4.")

if __name__ == "__main__":
    main_menu()
