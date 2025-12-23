# iccDEV libFuzzer Image

```
docker pull ghcr.io/internationalcolorconsortium/iccdev:libfuzzer
docker run --rm -it ghcr.io/internationalcolorconsortium/iccdev:libfuzzer
```

## Expected Output

```
INFO: Running with entropic power schedule (0xFF, 100).
INFO: Seed: 2701678992
INFO: Loaded 1 modules   (3 inline 8-bit counters): 3 [0x607cb6ac0e88, 0x607cb6ac0e8b),
INFO: Loaded 1 PC tables (3 PCs): 3 [0x607cb6ac0e90,0x607cb6ac0ec0),
INFO: -max_len is not provided; libFuzzer will not generate inputs larger than 4096 bytes
INFO: A corpus is not provided, starting from an empty corpus
#2      INITED cov: 2 ft: 2 corp: 1/1b exec/s: 0 rss: 31Mb
#61     NEW    cov: 3 ft: 3 corp: 2/5b lim: 4 exec/s: 0 rss: 32Mb L: 4/4 MS: 4 CopyPart-ChangeBit-CrossOver-InsertByte-
#4194304        pulse  cov: 3 ft: 3 corp: 2/5b lim: 4096 exec/s: 1398101 rss: 344Mb
...
```

## Update Source

`docker run --rm -it ghcr.io/internationalcolorconsortium/iccdev:libfuzzer bash -l`

```
git fetch
git pull
```
 
## Expected Output

```
remote: Enumerating objects: 149, done.
remote: Counting objects: 100% (123/123), done.
remote: Compressing objects: 100% (86/86), done.
remote: Total 149 (delta 67), reused 69 (delta 37), pack-reused 26 (from 1)
Receiving objects: 100% (149/149), 221.81 KiB | 4.93 MiB/s, done.
Resolving deltas: 100% (70/70), completed with 10 local objects.
From https://github.com/InternationalColorConsortium/iccDEV
   f095236..ace2d88  master     -> origin/master
 * [new branch]      issue-331  -> origin/issue-331
 * [new branch]      issue-332  -> origin/issue-332
 * [new branch]      issue-340  -> origin/issue-340
 * [new branch]      issue-342  -> origin/issue-342
 * [new branch]      issue-345  -> origin/issue-345
   82c2321..074080d  research   -> origin/research
 * [new branch]      wasm-2311  -> origin/wasm-2311
Updating f095236..ace2d88
Fast-forward
 IccProfLib/IccIO.cpp                            |  62 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 IccProfLib/IccMpeCalc.cpp                       |  12 +++++++++++
 IccProfLib/IccProfile.cpp                       | 169 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
 IccProfLib/IccProfile.h                         |  14 ++++++++-----
 IccProfLib/IccSparseMatrix.cpp                  |   8 +++----
 IccProfLib/IccSparseMatrix.h                    |   6 +++---
 IccProfLib/IccTagBasic.cpp                      |  87 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
 IccProfLib/IccTagEmbedIcc.cpp                   |   4 ++--
 IccProfLib/IccUtil.cpp                          |   5 +++++
 IccXML/IccLibXML/IccProfileXml.cpp              |   4 ++--
 IccXML/IccLibXML/IccTagXml.cpp                  |   3 +++
 Tools/CmdLine/IccDumpProfile/iccDumpProfile.cpp |  14 ++++++-------
 Tools/wxWidget/wxProfileDump/wxProfileDump.cpp  |  12 +++++------
 13 files changed, 262 insertions(+), 138 deletions(-)
```

## Run a Fuzzer

```
iccdev@8d8d076c136a:~$ fuzzers/icc_profile_fuzz
INFO: Running with entropic power schedule (0xFF, 100).
INFO: Seed: 739061843
INFO: Loaded 1 modules   (3 inline 8-bit counters): 3 [0x560f1d5cae88, 0x560f1d5cae8b),
INFO: Loaded 1 PC tables (3 PCs): 3 [0x560f1d5cae90,0x560f1d5caec0),
INFO: -max_len is not provided; libFuzzer will not generate inputs larger than 4096 bytes
INFO: A corpus is not provided, starting from an empty corpus
#2      INITED cov: 2 ft: 2 corp: 1/1b exec/s: 0 rss: 31Mb
#105    NEW    cov: 3 ft: 3 corp: 2/5b lim: 4 exec/s: 0 rss: 31Mb L: 4/4 MS: 3 ChangeBit-InsertByte-CopyPart-
...
```
