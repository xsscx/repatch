# Dockerfile.libfuzzer Usage

Build and run multi-sanitizer fuzzers for ICC profile library.

## Build

```bash
docker build -f Dockerfile.libfuzzer -t ipatch-fuzzer:latest .
```

## Run Examples

### ASan (Address Sanitizer) - Default
```bash
docker run --rm \
  -e SANITIZER=asan \
  -e FUZZER=icc_profile_fuzzer \
  -e DURATION=60 \
  ipatch-fuzzer:latest
```

### UBSan (Undefined Behavior Sanitizer)
```bash
docker run --rm \
  -e SANITIZER=ubsan \
  -e FUZZER=icc_link_fuzzer \
  -e DURATION=300 \
  ipatch-fuzzer:latest
```

### MSan (Memory Sanitizer)
```bash
docker run --rm \
  -e SANITIZER=msan \
  -e FUZZER=icc_apply_fuzzer \
  -e DURATION=600 \
  ipatch-fuzzer:latest
```

### Parallel Execution
```bash
docker run --rm \
  -e SANITIZER=asan \
  -e FUZZER=icc_dump_fuzzer \
  -e DURATION=1800 \
  -e JOBS=8 \
  --cpus=8 \
  ipatch-fuzzer:latest
```

## Available Fuzzers

- `icc_profile_fuzzer` - Core profile parsing
- `icc_link_fuzzer` - Profile chaining operations
- `icc_apply_fuzzer` - Color transformation application
- `icc_dump_fuzzer` - Profile inspection/validation
- `icc_roundtrip_fuzzer` - Read/write cycle testing
- `icc_io_fuzzer` - File I/O operations

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SANITIZER` | `asan` | Sanitizer type: `asan`, `ubsan`, or `msan` |
| `FUZZER` | `icc_profile_fuzzer` | Fuzzer binary name |
| `DURATION` | `60` | Fuzzing duration in seconds |
| `JOBS` | `1` | Number of parallel fuzzing jobs |

## Corpus Persistence

Mount a volume to persist corpus across runs:

```bash
docker run --rm \
  -v $(pwd)/corpus:/tmp/corpus \
  -e SANITIZER=asan \
  -e FUZZER=icc_profile_fuzzer \
  -e DURATION=3600 \
  ipatch-fuzzer:latest
```

## Resource Limits

```bash
docker run --rm \
  --memory=4g \
  --cpus=4 \
  -e SANITIZER=asan \
  -e FUZZER=icc_link_fuzzer \
  -e DURATION=7200 \
  -e JOBS=4 \
  ipatch-fuzzer:latest
```

## Crash Analysis

Crashes are written to `/tmp/corpus/` inside the container. Extract them:

```bash
docker run --rm \
  -v $(pwd)/crashes:/tmp/corpus \
  -e SANITIZER=asan \
  -e FUZZER=icc_profile_fuzzer \
  -e DURATION=600 \
  ipatch-fuzzer:latest
```

## Build Verification

Check all sanitizer builds succeeded:

```bash
docker run --rm --entrypoint /bin/bash ipatch-fuzzer:latest -c "ls -la /fuzzers/*/"
```
