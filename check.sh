#!/bin/bash
# Check whether the diff output folders and files are correct.
# 检查差异输出文件夹和文件是否正确。

all_passed=0

# Check each Testcase folder.
# 检查每个 Testcase 文件夹。
for testcase in 1 2 3 4
do
    input_dir="Testcase$testcase"
    output_dir="Testcase${testcase}Diff"
    testcase_passed=1
    has_differences=0

    # Check every pair of input files.
    # 检查每一对输入文件。
    for file1 in "$input_dir"/*.1.txt
    do
        file2="${file1%.1.txt}.2.txt"
        pair_name=$(basename "$file1" .1.txt)
        output_file="$output_dir/${pair_name}Diff.txt"

        # Check whether the two input files differ.
        # 检查这两个输入文件是否有差异。
        if diff -q "$file1" "$file2" > /dev/null
        then
            # Identical files must not have a diff output file.
            # 内容相同的文件对不应该有差异输出文件。
            if [ -f "$output_file" ]
            then
                testcase_passed=0
            fi
        else
            has_differences=1

            # A differing pair must have a matching output file.
            # 有差异的文件对必须有对应的输出文件。
            if [ ! -f "$output_file" ]
            then
                testcase_passed=0
            elif ! diff -u "$file1" "$file2" | tail -n +3 | diff -u - <(tail -n +3 "$output_file") > /dev/null
            then
                testcase_passed=0
            fi
        fi
    done

    # The output folder should exist only when there are differences.
    # 只有存在差异时，输出文件夹才应该存在。
    if [ "$has_differences" -eq 1 ] && [ ! -d "$output_dir" ]
    then
        testcase_passed=0
    fi

    if [ "$has_differences" -eq 0 ] && [ -d "$output_dir" ]
    then
        testcase_passed=0
    fi

    # Print one result line for this Testcase.
    # 为这个 Testcase 输出一行结果。
    if [ "$testcase_passed" -eq 1 ]
    then
        echo "Testcase$testcase: PASS"
    else
        echo "Testcase$testcase: FAIL"
        all_passed=1
    fi
done

# Return a failure status if any Testcase failed.
# 如果任何 Testcase 检查失败，就返回错误状态。
exit "$all_passed"
