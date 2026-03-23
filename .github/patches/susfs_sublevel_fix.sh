#!/bin/bash
# Adapted from WildKernels susfs-patches
VERSION=$1

SUBLEVEL=$(grep "^SUBLEVEL =" Makefile | awk '{print $3}')
echo "🛠️ Extracted SUBLEVEL: $SUBLEVEL"
echo "🛠️ Target Android/Kernel Version Context: $VERSION"

SUSFS_VERSION=$(cat $GITHUB_WORKSPACE/.github/patches/susfs4ksu/gki-$VERSION/include/linux/susfs.h | grep -E '^#define SUSFS_VERSION' | cut -d' ' -f3 | sed 's/"//g')
echo "🛠️ Target SuSFS Version: $SUSFS_VERSION"

if [ -z "$SUSFS_VERSION" ]; then
  SUSFS_VERSION="1.5.5"
fi

PATCH_DIR="$GITHUB_WORKSPACE/.github/patches/susfs_fix_patches/v${SUSFS_VERSION}"

if [[ "$VERSION" == *"android12-5.10"* ]]; then
  if [[ "$SUBLEVEL" -le 209 ]]; then
    sed -i -e 's/goto show_pad;/return 0;/' ./fs/proc/task_mmu.c || true
  fi
  if [[ "$SUBLEVEL" -le 117 ]]; then
    cp $PATCH_DIR/a12-5.10/fdinfo.c.patch ./ || true
    patch -p1 < fdinfo.c.patch || true
  fi
  if [[ "$SUBLEVEL" -le 43 ]]; then
    cp $PATCH_DIR/a12-5.10/base.c.patch ./ || true
    patch -p1 < base.c.patch || true
  fi
elif [[ "$VERSION" == *"android14-6.1"* ]]; then
  cp $PATCH_DIR/a14-6.1/base.c.patch ./ || true
  patch -p1 < base.c.patch || true
  if [[ "$SUBLEVEL" -le 75 ]]; then
    sed -i -e 's/goto show_pad;/return 0;/' ./fs/proc/task_mmu.c || true
  fi
elif [[ "$VERSION" == *"android15-6.6"* ]]; then
  if [[ "$SUBLEVEL" -le 92 ]]; then
    cp $PATCH_DIR/a15-6.6/base.c.patch ./ || true
    patch -p1 < base.c.patch || true
  fi
  if [[ "$SUBLEVEL" -le 58 ]]; then
    cp $PATCH_DIR/a15-6.6/task_mmu.c.patch ./ || true
    patch -p1 < task_mmu.c.patch || true
  fi
fi

echo "✅ SuSFS Sublevel Fixes applied (if applicable)."
