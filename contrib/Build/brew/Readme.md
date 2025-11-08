# [iccDEV v2.3.1](https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz)

## BREW Package

Last Updated: 08-NOV-2025 0200Z by D Hoyt

```
class Iccdev < Formula
  desc "Libraries and tools for ICC color management profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"
  revision 1
```

### History Sample

| Version / Change | Reference |
|------------------:|:-----------|
| **iccMAX 2.1.26** | [Homebrew PR #221560](https://github.com/Homebrew/homebrew-core/pull/221560) |
| **iccMAX 2.2.50** | [Homebrew PR #232375](https://github.com/Homebrew/homebrew-core/pull/232375) |
| **Renamed Formula** | [Homebrew PR #232435](https://github.com/Homebrew/homebrew-core/pull/232435) |
| **iccDEV 2.3.1_1** | [Homebrew PR #250463](https://github.com/Homebrew/homebrew-core/pull/250463) |
| **iccDEV 2.3.1_1** | [Homebrew PR #253803](https://github.com/Homebrew/homebrew-core/pull/253803) |

**HOST**

```
Linux 6.6.87.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun  5 18:30:46 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
Darwin 25.1.0 Darwin Kernel Version 25.1.0: Mon Oct 20 19:32:47 PDT 2025; root:xnu-12377.41.6~2/RELEASE_ARM64_T8103 arm64
Darwin 24.6.0 Darwin Kernel Version 24.6.0: Wed Oct 15 21:12:21 PDT 2025; root:xnu-11417.140.69.703.14~1/RELEASE_X86_64 x86_64
```

## Brew Packaging Reproduction

1. Fork https://github.com/Homebrew/homebrew-core
2. Create branch iccdev-formula
3. Update Formula/i/iccdev.rb

### iccDEV Maintainer Checklist

[Releases](https://github.com/InternationalColorConsortium/iccDEV/releases/tag/v2.3.1) are processed by Homebrew-Core in the normal course of business.  When updating [iccDEV Formula](https://raw.githubusercontent.com/Homebrew/homebrew-core/refs/heads/main/Formula/i/iccdev.rb)  please run these tests on **macOS arm64** prior to opening a [PR](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request):

**License:** Verify BSD-3-Clause in Formula/i/iccdev.rb

**Content:** [Acceptable Formula](https://docs.brew.sh/Acceptable-Formulae)

**Checks:** macOS arm64 strict

```
brew update-reset && brew update --force --quiet && \
brew cleanup -s && \
rm -rf "$(brew --cache)/downloads"/*{lz4,giflib,jpeg,libpng,iccdev}* /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true && \
brew uninstall --force iccdev local/iccdev/iccdev 2>/dev/null || true && \
brew list | grep iccdev || echo "iccdev not installed (clean state)" && \
brew style local/iccdev/iccdev && brew audit --strict local/iccdev/iccdev && brew audit --new local/iccdev/iccdev && \
brew deps --tree --annotate --include-build --include-test local/iccdev/iccdev && \
brew fetch --formulae --force --retry cmake giflib jpeg jpeg-turbo libpng libtiff lz4 nlohmann-json pcre2 pkgconf webp wxwidgets xz zstd && \
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccdev/iccdev && \
brew test --verbose local/iccdev/iccdev && brew info local/iccdev/iccdev && \
brew linkage --cached --test --strict local/iccdev/iccdev && \
brew uninstall --formula --force --ignore-dependencies iccdev && \
brew cleanup -s && \
brew uninstall --formulae --force --ignore-dependencies cmake giflib jpeg jpeg-turbo libpng libtiff lz4 nlohmann-json pcre2 pkgconf webp wxwidgets xz zstd 2>/dev/null || true
```

## Cross Platform Reproduction

### Ubuntu 24

#### Create iccdev.rb

```
cat <<'EOF' > /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d434b22f04c894203cde92c60e9a590b0a6705c942f23572e13e3274d5da6c78"
    sha256 cellar: :any,                 arm64_sequoia: "5b635498be6f03183c07cfcba9a8899f198a3e16f1cb3bd6f28d12e3397535fd"
    sha256 cellar: :any,                 arm64_sonoma:  "127bf1deb554d1b774f44c715e447f35dbe6a106018c089a6534a6407d4c6b30"
    sha256 cellar: :any,                 sonoma:        "fae45ba6ef1c1609955ff57f8d1d5c7e9cc93e6a645ab098b51dcb768119f052"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0619301afeacc7f18b3696d9a15ec3ac4fc64b27b36cb3fd3e839e202d6f86d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ff0873946edc0c0e3a84d0407bac877bfcd9ac48012c30bea94ca29155cc49"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
EOF
```

### Ubuntu 24

#### Run Checks

```
brew uninstall --force iccdev
brew cleanup -s iccdev
brew update-reset && brew update --force --quiet
brew uninstall iccdev
brew uninstall --force iccdev 2>/dev/null || true
brew cleanup -s iccdev 2>/dev/null || true
rm -rf "$(brew --cache)/iccdev--*" "$(brew --cache)/downloads/iccdev--*" 2>/dev/null || true
rm -rf /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true
brew list | grep iccdev || echo "iccdev not installed (clean state)"
brew style local/iccdev/iccdev
brew audit --new local/iccdev/iccdev
brew audit --strict local/iccdev/iccdev
brew uninstall --force iccdev 2>/dev/null || true
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccdev/iccdev
brew style local/iccdev/iccdev
brew audit --strict local/iccdev/iccdev
brew audit --new local/iccdev/iccdev
brew test local/iccdev/iccdev
brew info local/iccdev/iccdev
brew uninstall --force iccdev
brew cleanup -s iccdev
```

### Ubuntu 24

#### Expected Output

```
Uninstalling iccdev... (82 files, 9.5MB)
Removing: /home/xss/.cache/Homebrew/iccdev--2.3.1.tar.gz... (35.5MB)
==> This operation has freed approximately 35.5MB of disk space.
iccdev not installed (clean state)

1 file inspected, no offenses detected
==> Fetching downloads for: iccdev
✔︎ Formula iccdev (2.3.1)
==> Installing iccdev from local/iccdev
==> cmake -S Build/Cmake -B build -DCMAKE_INSTALL_RPATH=/home/linuxbrew/.linuxbrew/opt/iccdev/lib
==> cmake --build build
==> cmake --install build
🍺  /home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1: 82 files, 9.5MB, built in 20 seconds
==> Running `brew cleanup iccdev`...
Disable this behaviour by setting `HOMEBREW_NO_INSTALL_CLEANUP=1`.
Hide these hints with `HOMEBREW_NO_ENV_HINTS=1` (see `man brew`).

1 file inspected, no offenses detected
==> Testing local/iccdev/iccdev
==> /home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1/bin/iccFromXml /home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1/share/iccdev/CameraModel.xml output.icc
==> /home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1/bin/iccToXml output.icc output.xml

==> local/iccdev/iccdev: stable 2.3.1
ICC libraries and tools for working with color profiles
https://github.com/InternationalColorConsortium/iccDEV
Installed
/home/linuxbrew/.linuxbrew/Cellar/iccdev/2.3.1 (82 files, 9.5MB) *
  Built from source on 2025-11-07 at 10:21:11
From: /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
License: BSD-3-Clause
==> Dependencies
Build: cmake ✔
Required: jpeg ✔, libpng ✔, libtiff ✔, nlohmann-json ✔, wxwidgets ✔, libxml2 ✔
```

### macOS Reproduction arm64

#### Create iccdev.rb

```
cat <<'EOF' > /opt/homebrew/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d434b22f04c894203cde92c60e9a590b0a6705c942f23572e13e3274d5da6c78"
    sha256 cellar: :any,                 arm64_sequoia: "5b635498be6f03183c07cfcba9a8899f198a3e16f1cb3bd6f28d12e3397535fd"
    sha256 cellar: :any,                 arm64_sonoma:  "127bf1deb554d1b774f44c715e447f35dbe6a106018c089a6534a6407d4c6b30"
    sha256 cellar: :any,                 sonoma:        "fae45ba6ef1c1609955ff57f8d1d5c7e9cc93e6a645ab098b51dcb768119f052"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0619301afeacc7f18b3696d9a15ec3ac4fc64b27b36cb3fd3e839e202d6f86d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ff0873946edc0c0e3a84d0407bac877bfcd9ac48012c30bea94ca29155cc49"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
EOF
```

### macOS arm64 - Run Checks

- Run Checks

```
brew update-reset && brew update --force --quiet
brew uninstall iccdev
brew uninstall --force iccdev 2>/dev/null || true
brew cleanup -s iccdev 2>/dev/null || true
rm -rf "$(brew --cache)/iccdev--*" "$(brew --cache)/downloads/iccdev--*" /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true
brew list | grep iccdev || echo "iccdev not installed (clean state)"
brew style local/iccdev/iccdev
brew audit --strict local/iccdev/iccdev
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccdev/iccdev
brew style local/iccdev/iccdev
brew audit --strict local/iccdev/iccdev
brew test local/iccdev/iccdev
brew info local/iccdev/iccdev
brew uninstall --force iccdev
rm -rf "$(brew --cache)/iccdev--*" "$(brew --cache)/downloads/iccdev--*" /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true
brew cleanup -s iccdev
```

### macOS arm64 -  Expected Output

- Verify Output

```
...
==> Fetching downloads for: iccdev
✔︎ Bottle Manifest jpeg (9f)                    [Downloaded   10.7KB/ 10.7KB]
✔︎ Bottle jpeg (9f)                             [Downloaded  307.8KB/307.8KB]
✔︎ Bottle Manifest wxwidgets (3.3.1)            [Downloaded   46.2KB/ 46.2KB]
✔︎ Bottle wxwidgets (3.3.1)                     [Downloaded    8.6MB/  8.6MB]
✔︎ Formula iccdev (2.3.1)                       [Verifying    35.5MB/ 35.5MB]
==> Installing iccdev from local/iccdev
==> Installing dependencies for local/iccdev/iccdev: jpeg and wxwidgets
==> Installing local/iccdev/iccdev dependency: jpeg
==> Pouring jpeg--9f.arm64_tahoe.bottle.tar.gz
🍺  /opt/homebrew/Cellar/jpeg/9f: 22 files, 903.4KB
==> Installing local/iccdev/iccdev dependency: wxwidgets
==> Pouring wxwidgets--3.3.1.arm64_tahoe.bottle.1.tar.gz
🍺  /opt/homebrew/Cellar/wxwidgets/3.3.1: 870 files, 28.7MB
==> Installing local/iccdev/iccdev
==> cmake -S Build/Cmake -B build -DCMAKE_INSTALL_RPATH=/opt/homebrew/opt/iccdev/lib
==> cmake --build build
==> cmake --install build
🍺  /opt/homebrew/Cellar/iccdev/2.3.1: 82 files, 6.6MB, built in 17 seconds
==> Running `brew cleanup iccdev`...
Disable this behaviour by setting `HOMEBREW_NO_INSTALL_CLEANUP=1`.
Hide these hints with `HOMEBREW_NO_ENV_HINTS=1` (see `man brew`).
/opt/homebrew/Library/Homebrew/vendor/bundle/ruby/3.4.0/bin/bundle
==> Testing local/iccdev/iccdev
==> /opt/homebrew/Cellar/iccdev/2.3.1/bin/iccFromXml /opt/homebrew/Cellar/iccdev/2.3.1/share/iccdev/CameraModel.xml output.icc
Profile parsed and saved correctly

==> /opt/homebrew/Cellar/iccdev/2.3.1/bin/iccToXml output.icc output.xml
XML successfully created
==> local/iccdev/iccdev: stable 2.3.1 (bottled)
Libraries and tools for cross-platform color management systems from the ICC
https://github.com/InternationalColorConsortium/iccDEV
Installed
/opt/homebrew/Cellar/iccdev/2.3.1 (82 files, 6.6MB) *
  Built from source on 2025-11-07 at 16:00:05
From: /opt/homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
License: BSD-3-Clause
==> Dependencies
Build: cmake ✔, nlohmann-json ✔
Required: jpeg ✔, libpng ✔, libtiff ✔, wxwidgets ✔
```

### macOS x64 - Run Checks

#### Create iccdev.rb

```
cat <<'EOF' > /usr/local/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d434b22f04c894203cde92c60e9a590b0a6705c942f23572e13e3274d5da6c78"
    sha256 cellar: :any,                 arm64_sequoia: "5b635498be6f03183c07cfcba9a8899f198a3e16f1cb3bd6f28d12e3397535fd"
    sha256 cellar: :any,                 arm64_sonoma:  "127bf1deb554d1b774f44c715e447f35dbe6a106018c089a6534a6407d4c6b30"
    sha256 cellar: :any,                 sonoma:        "fae45ba6ef1c1609955ff57f8d1d5c7e9cc93e6a645ab098b51dcb768119f052"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0619301afeacc7f18b3696d9a15ec3ac4fc64b27b36cb3fd3e839e202d6f86d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ff0873946edc0c0e3a84d0407bac877bfcd9ac48012c30bea94ca29155cc49"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
EOF
```

### macOS x64

#### Run Checks

```
brew update-reset && brew update --force --quiet && \
brew cleanup -s && \
rm -rf "$(brew --cache)/downloads"/*{lz4,giflib,jpeg,libpng,iccdev}* /tmp/*iccdev* "$(brew --prefix)/Cellar/iccdev" 2>/dev/null || true && \
brew uninstall --force iccdev local/iccdev/iccdev 2>/dev/null || true && \
brew list | grep iccdev || echo "iccdev not installed (clean state)" && \
brew style local/iccdev/iccdev && brew audit --strict local/iccdev/iccdev && brew audit --new local/iccdev/iccdev && \
brew deps --tree --annotate --include-build --include-test local/iccdev/iccdev && \
brew fetch --formulae --force --retry cmake giflib jpeg jpeg-turbo libpng libtiff lz4 nlohmann-json pcre2 pkgconf webp wxwidgets xz zstd && \
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccdev/iccdev && \
brew test --verbose local/iccdev/iccdev && brew info local/iccdev/iccdev && \
brew linkage --cached --test --strict local/iccdev/iccdev && \
brew style local/iccdev/iccdev && \
brew audit --strict local/iccdev/iccdev && \
brew test local/iccdev/iccdev && \
brew info local/iccdev/iccdev && \
brew uninstall --formula --force --ignore-dependencies iccdev && \
brew cleanup -s && \
brew uninstall --formulae --force --ignore-dependencies cmake giflib jpeg jpeg-turbo libpng libtiff lz4 nlohmann-json pcre2 pkgconf webp wxwidgets xz zstd 2>/dev/null || true
```

### macOS x64 

#### Expected Output

```
...
==> Fetching downloads for: iccdev
✔︎ Bottle Manifest pcre2 (10.47)                                                                                                                                               [Downloaded   10.1KB/ 10.1KB]
✔︎ Bottle pcre2 (10.47)                                                                                                                                                        [Downloaded    2.3MB/  2.3MB]
✔︎ Formula iccdev (2.3.1)                                                                                                                                                      [Verifying    35.5MB/ 35.5MB]
==> Installing iccdev from local/iccdev
==> cmake -S Build/Cmake -B build -DCMAKE_INSTALL_RPATH=/usr/local/opt/iccdev/lib
==> cmake --build build
==> cmake --install build
🍺  /usr/local/Cellar/iccdev/2.3.1: 82 files, 6.0MB, built in 1 minute 12 seconds
[2025-11-07 19:59:25]
```

---

## PR Summary

1. Modified [iccdev.rb](https://github.com/InternationalColorConsortium/homebrew-core/commit/4c6790c54c3668024bf430c29331aea3048e3bc2)

**Note:** desc field modified to comply with Brew PR Submission Guidelines.
- Description shouldn't end with a full stop

```
  desc "Developer tools for interacting with and manipulating ICC profiles"
```

2. Minimized Build Args

3. Retested

```
[2025-11-07 20:16:19 EST] 
$ head /usr/local/Homebrew/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb
class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"

$ brew audit --new --online --strict local/iccdev/iccdev
$ brew style local/iccdev/iccdev

1 file inspected, no offenses detected
```

4. Ready for PR

## TODO

Season the latest **desc field** changes at least 48 hours to allow additional feedback. 

---

## Notes

### Editor Workflow

```
pico "$(brew --repository)/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb"
head "$(brew --repository)/Library/Taps/local/homebrew-iccdev/Formula/iccdev.rb"
brew audit --new --online --strict local/iccdev/iccdev
brew style local/iccdev/iccdev
```

### Purge & Report

```
brew uninstall --force --ignore-dependencies iccdev 2>/dev/null || true
brew cleanup -s iccdev 2>/dev/null || true
rm -rf "$(brew --cache)"/*iccdev* \
       "$(brew --prefix)/Cellar/iccdev" \
       "$(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/iccdev.rb" \
       /tmp/*iccdev* \
       ~/.cache/Homebrew/iccdev* 2>/dev/null || true
brew doctor
brew search iccdev
brew info iccdev
```

### PR Threshold
This PR represented a metadata-only update (desc, license) which would typically not meet the merge threshold under Homebrew-core contributor policy. The merge proceeded under maintainer discretion, recognizing the update as low-ci-impact and aligning with accurate metadata correction.

### Metadata

- Allow 24 hours for Updates

```
$ curl -s https://formulae.brew.sh/api/formula/iccdev.json | jq -r '.desc'
Demonstration Implementation for iccMAX color profiles

$ curl -s https://raw.githubusercontent.com/Homebrew/homebrew-core/HEAD/Formula/i/iccdev.rb | grep '^  desc'
  desc "Developer tools for interacting with and manipulating ICC profiles"
```


### Confirm

`brew info iccdev`

```
==> iccdev: stable 2.3.1 (bottled)
Developer tools for interacting with and manipulating ICC profiles
https://github.com/InternationalColorConsortium/iccDEV
Not installed
From: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/i/iccdev.rb
License: BSD-3-Clause
==> Dependencies
Build: cmake ✔, nlohmann-json ✔
Required: jpeg ✔, libpng ✔, libtiff ✔, wxwidgets ✔, libxml2 ✔
==> Analytics
install: 70 (30 days), 96 (90 days), 147 (365 days)
install-on-request: 70 (30 days), 96 (90 days), 147 (365 days)
build-error: 0 (30 days)

Mon Nov 10 10:52:29 AM EST 2025
```