# Dockerfile.iccdev-fuzzer

Fuzzing container based on `srdcx/iccdev:latest` with libFuzzer support.

## Build

```bash
docker build -f Dockerfile.iccdev-fuzzer -t ipatch-iccdev-fuzzer:latest .
```

## Run

### Quick test (60 seconds, address sanitizer)
```bash
docker run --rm ipatch-iccdev-fuzzer:latest
```

### Custom configuration
```bash
docker run --rm \
  -e SANITIZER=undefined \
  -e FUZZER=icc_dump_fuzzer \
  -e DURATION=300 \
  -e JOBS=4 \
  ipatch-iccdev-fuzzer:latest
```

### Using helper script
```bash
./test-iccdev-fuzzer.sh [address|undefined] [fuzzer_name] [duration]
```

Examples:
```bash
./test-iccdev-fuzzer.sh address icc_profile_fuzzer 120
./test-iccdev-fuzzer.sh undefined icc_dump_fuzzer 300
```

## Available Fuzzers

- `icc_profile_fuzzer` - Profile parsing and validation
- `icc_dump_fuzzer` - Profile dumping and tag enumeration (32 tags)
- `icc_link_fuzzer` - Profile linking with CMM
- `icc_apply_fuzzer` - Color transformation application
- `icc_roundtrip_fuzzer` - Round-trip color accuracy
- `icc_io_fuzzer` - I/O operations

## Available Sanitizers

- `address` - AddressSanitizer (heap/stack/global overflow, use-after-free)
- `undefined` - UndefinedBehaviorSanitizer (integer overflow, invalid enum, null dereference)

## Environment Variables

- `SANITIZER` - Sanitizer to use (default: `address`)
- `FUZZER` - Fuzzer binary name (default: `icc_profile_fuzzer`)
- `DURATION` - Max fuzzing time in seconds (default: `60`)
- `JOBS` - Number of parallel fuzzer jobs (default: `1`)

## Base Image

Built on `srdcx/iccdev:latest` which includes ICC profile development dependencies.
