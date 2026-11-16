#!/bin/bash
# Compare every pair of files in Testcase1 to Testcase4.
# 比较 Testcase1 到 Testcase4 中的所有文件对。

for testcase in 1 2 3 4
do
    input_dir="Testcase$testcase"
    output_dir="Testcase${testcase}Diff"

    # Remove results from the previous run.
    # 删除上次运行生成的结果。
    rm -rf "$output_dir"

    # Check every .1.txt file and its matching .2.txt file.
    # 检查每个 .1.txt 文件及其对应的 .2.txt 文件。
    for file1 in "$input_dir"/*.1.txt
    do
        file2="${file1%.1.txt}.2.txt"

        # If the files differ, create the output folder and save the full diff.
        # 如果文件不同，就创建输出文件夹并保存完整的 diff 结果。
        if ! diff -q "$file1" "$file2" > /dev/null
        then
            mkdir -p "$output_dir"

            # Create the required output filename.
            # 生成要求的输出文件名。
            pair_name=$(basename "$file1" .1.txt)

            # Save the complete output of diff -u.
            # 保存 diff -u 的完整输出。
            diff -u "$file1" "$file2" > "$output_dir/${pair_name}Diff.txt"
        fi
    done
done
