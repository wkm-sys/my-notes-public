import os
import sqlite3
import time
from PIL import Image
from PIL.ExifTags import TAGS
from tkinter import Tk, filedialog
import pillow_heif

# Register HEIC support
pillow_heif.register_heif_opener()

# Popup to select scan directory
root = Tk()
root.withdraw()
SCAN_DIR = filedialog.askdirectory(title="Select photo folder")
if not SCAN_DIR:
    print("No directory selected. Exiting program.")
    exit()

# Database file inside scan directory
DB_FILE = os.path.join(SCAN_DIR, 'photos.db')

# Create database and table
conn = sqlite3.connect(DB_FILE)
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

# Extract EXIF info and resolution
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

# Start timing
start_time = time.time()

# Begin transaction for batch
conn.execute("BEGIN")

count = 0
fail_count = 0

for root_dir, dirs, files in os.walk(SCAN_DIR):
    for f in files:
        if f.lower().endswith(('.jpg', '.jpeg', '.png', '.heic', '.heif')):
            full_path = os.path.abspath(os.path.join(root_dir, f))
            date, camera, resolution = get_photo_info(full_path)
            if date is not None or camera is not None or resolution is not None:
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

                    # Progress feedback every 100 photos
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
print(f"Successfully processed: {count} photos, Failed: {fail_count} photos. Database updated: {DB_FILE}")
