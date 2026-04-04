#!/bin/bash

MANIFEST=".checksums"

# Tự động nhận diện Hasher từ file manifest
if [ ! -f "$MANIFEST" ]; then
    echo "Lỗi: Không tìm thấy file $MANIFEST. Hãy chạy 'checksum-checkin' trước."
    exit 1
fi

# Kiểm tra công cụ dựa trên file manifest
if grep -q "xxh128" "$MANIFEST" || command -v xxh128sum &> /dev/null; then
    HASHER="xxh128sum"
else
    HASHER="md5sum"
fi

echo "--- Đang kiểm tra sự toàn vẹn ($HASHER) ---"

# Chạy kiểm tra hash
tmp_report=$(mktemp)
$HASHER -c "$MANIFEST" > "$tmp_report" 2>&1

echo "-----------------------------------------------"
echo "KẾT QUẢ KIỂM TRA: $(pwd)"
echo "-----------------------------------------------"

# 1. File bị thay đổi nội dung
changed=$(grep "FAILED" "$tmp_report" | grep -v "open or read" | cut -d':' -f1)
[ -n "$changed" ] && echo -e "❌ BIẾN ĐỔI:\n$changed" || echo "✅ Nội dung: OK"

# 2. File bị xoá
missing=$(grep "FAILED open or read" "$tmp_report" | cut -d':' -f1)
[ -n "$missing" ] && echo -e "🗑️  ĐÃ XOÁ:\n$missing" || echo "✅ Số lượng: Đầy đủ"

# 3. File mới (chưa có trong manifest)
new_files=$(find . -type f -not -path '*/.*' | while read -r f; do
    clean="${f#./}"
    grep -qF "$clean" "$MANIFEST" || echo "$f"
done)
[ -n "$new_files" ] && echo -e "➕ FILE MỚI:\n$new_files" || echo "✅ File mới: Không có"

echo "-----------------------------------------------"

# --- HIỂN THỊ CẤU TRÚC THEO LEVEL ---
read -p "Xem cấu trúc folder? (y/N): " show
if [[ "$show" =~ ^[yY]$ ]]; then
    read -p "Nhập Level (1=mặc định, -1=tất cả): " lv
    lv=${lv:-1}
    echo -e "\n[CẤU TRÚC THƯ MỤC]"
    if [ "$lv" -eq -1 ]; then
        find . -not -path '*/.*'
    else
        find . -maxdepth "$((lv + 1))" -not -path '*/.*'
    fi
fi

rm "$tmp_report"
