#!/bin/bash
# Patch module & DRM (Xiaomi Compat)

echo "🩹 Menerapkan patch kompatibilitas untuk perangkat Xiaomi"
sed -i '/pr_warn.*disagrees about version of symbol.*/,+1 s/.*/return 1;/' kernel/module.c
sed -i '/^static int drm_atomic_check_valid_clones/,/^}/d' drivers/gpu/drm/drm_atomic_helper.c
sed -i '/ret = drm_atomic_check_valid_clones/,/return ret;/d' drivers/gpu/drm/drm_atomic_helper.c
echo "✅ Perbaikan selesai"
