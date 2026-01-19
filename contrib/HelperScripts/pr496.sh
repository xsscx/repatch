###############################################################
#
## Copyright (©) 2025 International Color Consortium. 
##                 All rights reserved. 
##                 https://color.org
#
# Last Modified: 19-JAN-2026 1500Z by David Hoyt
# Intent: Unix PR496 Repro
# 
#
#
#  URL https://github.com/InternationalColorConsortium/iccDEV
#
#
#
# Run: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/iccDEV/refs/heads/research/contrib/HelperScripts/pr496.sh)"
#
#
###############################################################

echo "=== Build PR496 ==="
git clone https://github.com/InternationalColorConsortium/iccDEV.git
cd iccDEV/Build
git fetch origin pull/496/head:pr-496
git checkout pr-496
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_BUILD_TYPE=Debug -Wno-dev -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-sanitize=leak -fno-omit-frame-pointer -Wall" -DENABLE_TOOLS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_SHARED_LIBS=ON Cmake > cmake.log 2>&1
make -j32
find . -type f -executable ! -name "*.a" ! -name "*.so" ! -name "*.dylib" ! -path "*/obj/*" ! -path "*/.git/*" ! -path "*/.sh/*" -print
        cd ../Testing/
        echo "=== Updating PATH ==="
         for d in ../Build/Tools/*; do
          [ -d "$d" ] && export PATH="$(realpath "$d"):$PATH"
         done
          sh CreateAllProfiles.sh
          sh RunTests.sh
          cd HDR
          sh mkprofiles.sh
          cd ..
          cd hybrid
          sh BuildAndTest.sh
          cd ..
          cd CalcTest
          sh checkInvalidProfiles.sh
          cd ..
          cd mcs
          sh updateprev.sh
          sh updateprevWithBkgd.sh
          cd ..
echo "=== PR496 DONE ==="
