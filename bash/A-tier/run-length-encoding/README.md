# Run-Length Encoding

## Introduction

Run-length encoding (RLE) is a simple form of data compression, where runs (consecutive data elements) are replaced by just one data value and count.
RLE allows the original data to be perfectly reconstructed from the compressed data, which makes it a lossless data compression.

## Instructions

Implement run-length encoding and decoding.

For example we can represent the original 53 characters with only 13.

```text
"WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB"  ->  "12WB12W3B24WB"
```

```text
"AABCCCDEEEE"  ->  "2AB3CD4E"  ->  "AABCCCDEEEE"
```

For simplicity, you can assume that the unencoded string will only contain the letters A through Z (either lower or upper case) and whitespace.
This way data to be encoded will never contain any numbers and numbers inside data to be decoded always represent the count for the following character.

## Source
[Wikipedia](https://en.wikipedia.org/wiki/Run-length_encoding)

## My Solution Idea

