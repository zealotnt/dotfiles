#!/bin/bash

# Tên file lưu trữ hash (ẩn để gọn gàng)
MANIFEST=".checksums"

# Tự động chọn thuật toán: xxHash (nhanh) > md5sum (phổ biến)
if command -v xxh128sum &> /dev/null; then
    HASHER="xxh128sum"
elif command -v md5sum &> /dev/null; then
    HASHER="md5sum"
else
    echo "Lỗi: Không tìm thấy xxh128sum hoặc md5sum."
    exit 1
fi

echo "--- Đang quét folder bằng $HASHER ---"

# Khởi tạo Git nếu chưa có
if [ ! -d .git ]; then
    git init -q
    echo "*" > .gitignore
    echo "!$MANIFEST" >> .gitignore
    echo "!.gitignore" >> .gitignore
    echo "Đã khởi tạo Git repo ẩn."
fi

# Tạo danh sách hash, bỏ qua các file git và chính nó
find . -type f -not -path '*/.*' -exec $HASHER {} + > "$MANIFEST"

# Commit nếu có thay đổi
git add "$MANIFEST" .gitignore
if git diff --cached --quiet; then
    echo "Không có thay đổi nào so với lần check-in trước."
else
    git commit -m "Update integrity: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Đã lưu vết toàn vẹn mới thành công."
fi
