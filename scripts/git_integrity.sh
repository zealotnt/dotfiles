#!/bin/bash

# Cấu hình thuật toán: xxh128sum (nhanh nhất), hoặc md5sum/sha1sum
HASHER="xxh128sum"
MANIFEST="manifest.xxh128"

# Kiểm tra công cụ checksum
if ! command -v $HASHER &> /dev/null; then
    echo "Lỗi: Không tìm thấy $HASHER. Hãy cài đặt (brew/apt install xxhash) hoặc đổi HASHER trong script thành md5sum."
    exit 1
fi

if [ ! -f "$MANIFEST" ]; then
    echo "Lỗi: Không tìm thấy $MANIFEST. Hãy chạy git_checkin.sh trước."
    exit 1
fi

echo "--- Đang kiểm tra sự toàn vẹn bằng $HASHER (Background) ---"

# Chạy kiểm tra mã hash
tmp_report=$(mktemp)
$HASHER -c "$MANIFEST" > "$tmp_report" 2>&1 &
wait $!

# Quét file hiện tại để tìm file mới
tmp_current=$(mktemp)
find . -type f -not -path '*/.*' -not -name "$MANIFEST" -not -name ".gitignore" -not -name "*.sh" > "$tmp_current"

echo "-----------------------------------------------"
echo "BÁO CÁO SỰ TOÀN VẸN DỮ LIỆU"
echo "-----------------------------------------------"

# 1. File bị THAY ĐỔI
changed=$(grep "FAILED" "$tmp_report" | grep -v "open or read" | cut -d':' -f1)
[ -n "$changed" ] && echo -e "[!] FILE BỊ THAY ĐỔI:\n$changed" || echo "[OK] Không có file bị đổi."

# 2. File bị XOÁ
missing=$(grep "FAILED open or read" "$tmp_report" | cut -d':' -f1)
[ -n "$missing" ] && echo -e "[!] FILE ĐÃ BỊ XOÁ:\n$missing" || echo "[OK] Không có file bị mất."

# 3. File MỚI
new_files=""
while IFS= read -r file; do
    clean_path="${file#./}"
    if ! grep -qF "$clean_path" "$MANIFEST"; then
        new_files+="$file"$'\n'
    fi
done < "$tmp_current"
[ -n "$new_files" ] && echo -e "[+] FILE MỚI PHÁT SINH:\n$new_files" || echo "[OK] Không có file mới."

echo "-----------------------------------------------"

# --- HỎI THÔNG TIN CHI TIẾT ---
read -p "Xem cấu trúc chi tiết? (y/N): " show_detail
if [[ "$show_detail" =~ ^[yY]$ ]]; then
    read -p "Nhập độ sâu (Level) muốn xem (mặc định 1, nhập -1 để xem tất cả): " depth
    depth=${depth:-1}

    echo -e "\n[CHI TIẾT CẤU TRÚC - LEVEL $depth]"
    echo "Tổng số file: $(wc -l < "$tmp_current")"

    # Xử lý tham số depth cho lệnh find hoặc tree
    if [ "$depth" -eq -1 ]; then
        find . -not -path '*/.*' -not -name "*.sh" -not -name "$MANIFEST"
    else
        find . -maxdepth "$((depth + 1))" -not -path '*/.*' -not -name "*.sh" -not -name "$MANIFEST"
    fi
fi

rm "$tmp_report" "$tmp_current"

