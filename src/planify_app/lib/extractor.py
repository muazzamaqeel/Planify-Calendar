#!/usr/bin/env python3
import os
import argparse

def extract_dart_code(start_dir: str, output_file: str):
    """
    Recursively finds all .dart files under start_dir and writes their contents
    into output_file, with file-path separators.
    """
    with open(output_file, 'w', encoding='utf-8') as out_f:
        for dirpath, dirnames, filenames in os.walk(start_dir):
            for fname in filenames:
                if fname.lower().endswith('.dart'):
                    full_path = os.path.join(dirpath, fname)
                    out_f.write(f'// ----- File: {full_path} -----\n')
                    try:
                        with open(full_path, 'r', encoding='utf-8') as in_f:
                            out_f.write(in_f.read())
                    except Exception as e:
                        out_f.write(f'// ERROR reading file: {e}\n')
                    out_f.write('\n\n')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Extract all Dart (.dart) source files into a single text file."
    )
    parser.add_argument(
        '-s', '--start-dir',
        default='.',
        help='Directory to start searching from (default: current directory)'
    )
    parser.add_argument(
        '-o', '--output',
        default='all_dart_code.txt',
        help='Output text file (default: all_dart_code.txt)'
    )
    args = parser.parse_args()
    extract_dart_code(args.start_dir, args.output)
    print(f"Done! All Dart code has been written to {args.output}")
