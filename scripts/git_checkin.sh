#!/bin/bash

# 1. Khởi tạo Git nếu chưa có
if [ ! -d .git ]; then
    git init
    echo "Khởi tạo Git repo mới..."
fi

# 2. Tạo .gitignore để chỉ giữ lại manifest và script này
cat <<EOF > .gitignore
*
!manifest.xxh128
!git_checkin.sh
!git_integrity.sh
!.gitignore
EOF

# 3. Tính toán mã hash
HASHER="xxh128sum"
MANIFEST="manifest.xxh128"

echo "Đang quét file bằng $HASHER..."
find . -type f -not -path '*/.*' -not -name "$MANIFEST" -not -name ".gitignore" -not -name "*.sh" -exec $HASHER {} + > "$MANIFEST"

# 4. Git commit nếu có thay đổi
git add "$MANIFEST" .gitignore
git add *.sh 2>/dev/null || true
if git diff --cached --quiet; then
    echo "Không có thay đổi nào trong manifest."
else
    git commit -m "Update manifest: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Đã commit manifest mới thành công."
fi
