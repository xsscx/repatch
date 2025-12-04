###############################################################
#
## Copyright (©) 2025 International Color Consortium.
##                 All rights reserved.
##                 https://color.org
#
# Last Modified: 27-NOV-2025 2300Z by David Hoyt
# Intent: Windows Issue Template
#
# Instructions: Please run this powershell script when you have a:
#                 - Config Issue
#                      - Include the Cmake Output
#                  - Build Issue
#                      - Include the Build Output
#                  - Tools Issue
#                  *** - Provide your Repoduction ***
#                      - Include the Output
# *** All Reports must include a known good & working reproduction ***
# 1. Perform self-diagnosis before opening the Issue
#    Minimum expectations:
#    Sync to current main or release branch.
#    Confirm local headers match implementation.
#    Rebuild clean.
#    Verify PR history for related code paths.
#
# 2. Document evidence indicating due diligence
#    This includes:
#    Commit hash tested.
#    Diff showing header/implementation mismatch.
#    Exact error trace.
#    Confirmation whether the issue persists after resync.
#
# 3. Provide the corrected diagnosis once the root cause is found
#    If the maintainer discovers the problem was self-inflicted:
#    They must update the Issue with the corrected root cause.
#    They must close the Issue unless there is a true upstream defect.
#
#
#
#  URL https://github.com/InternationalColorConsortium/iccDEV
#
#
# iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/iccDEV/refs/heads/research/contrib/HelperScripts/windows-issue-template.ps1").Content
#
###############################################################

Write-Host ""
Write-Host "========================================================================"
Write-Host "===================== iccDEV | Windows Issue Template ====================="
Write-Host "Fetching the Code..."
Write-Host ""
Write-Host "========================================================================"
Write-Host "iccDEV Configure Issue Report ** Please include the data below this line"
Write-Host "========================================================================"
Write-Host ""
git clone https://github.com/InternationalColorConsortium/iccDEV.git
cd iccDEV
# git fetch origin pull/247/head:pr-247
# git checkout pr-247
Write-Host "Branch Status"
          pwd
          git branch
          git status
          date
          Write-Host "========= Fetching Deps... ================`n"
          Start-BitsTransfer -Source "https://github.com/InternationalColorConsortium/iccDEV/releases/download/v2.3.1/vcpkg-exported-deps.zip" -Destination "deps.zip"
          Write-Host "========= Extracting Deps... ================`n"
          tar -xf deps.zip
          cd Build/Cmake
          Write-Host "========= Building... ================`n"  
          cmake  -B build -S . -DCMAKE_TOOLCHAIN_FILE="..\..\scripts\buildsystems\vcpkg.cmake" -DVCPKG_MANIFEST_MODE=OFF -DCMAKE_BUILD_TYPE=Debug  -Wno-dev
Write-Host ""
Write-Host "========================================================================"
Write-Host "iccDEV Configure Issue Report ** Please include the data above this line"
Write-Host "========================================================================"
Write-Host ""
Write-Host ""
Write-Host "========================================================================"
Write-Host "iccDEV Build Issue Report ****** Please include the data below this line"
Write-Host "========================================================================"
Write-Host ""
          cmake --build build -- /m /maxcpucount
          cmake --build build -- /m /maxcpucount   
Write-Host ""
Write-Host "========================================================================"
Write-Host "iccDEV Build Issue Report ****** Please include the data above this line"
Write-Host "========================================================================"
Write-Host ""
Write-Host "========================================================================"
Write-Host "iccDEV Issue Report ************ Please include the data below this line"
Write-Host "========================================================================"
Write-Host ""
Write-Host "Setting PATH"
            $exeDirs = Get-ChildItem -Recurse -File -Include *.exe -Path .\build\ |
                Where-Object { $_.FullName -match 'iccdev' -and $_.FullName -notmatch '\\CMakeFiles\\' -and $_.Name -notmatch '^CMake(C|CXX)CompilerId\.exe$' } |
                ForEach-Object { Split-Path $_.FullName -Parent } |
                Sort-Object -Unique
            $env:PATH = ($exeDirs -join ';') + ';' + $env:PATH
            $env:PATH -split ';' | Select-String "icc"
            $toolDirs = Get-ChildItem -Recurse -File -Include *.exe -Path .\Tools\ | ForEach-Object { Split-Path -Parent $_.FullName } | Sort-Object -Unique
            $env:PATH = ($toolDirs -join ';') + ';' + $env:PATH
            pwd
            cd ..\..\Testing
            cd CMYK-3DLUTs
            iccFromXml CMYK-3DLUTs.xml CMYK-3DLUTs.icc
            Write-Host "All Done!"
Write-Host ""
Write-Host "========================================================================"
Write-Host "iccDEV Issue Report ************ Please include the data above this line"
Write-Host "========================================================================"
Write-Host ""