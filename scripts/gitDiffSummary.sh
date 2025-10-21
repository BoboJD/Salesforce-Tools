#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

OUTPUT_FILE="git_diff_summary.txt"

declare -a new_files
declare -a modified_files
declare -a deleted_files

while IFS=$'\t' read -r status file1 file2; do
    st="${status:0:1}"

    if [[ -n "$file2" ]]; then
        file="$file2"
    else
        file="$file1"
    fi

    if [[ ! "$file" =~ ^${project_directory} ]]; then
        continue
    fi

    if [[ "$file" =~ -meta\.xml$ && "$file" =~ ^${project_directory}(classes|aura|lwc|triggers)/ ]]; then
        continue
    fi

    file="${file#${project_directory}}"

    case "$st" in
        A)
            new_files+=("$file")
            ;;
        M)
            modified_files+=("$file")
            ;;
        D)
            deleted_files+=("$file")
            ;;
        R)
            file1="${file1#${project_directory}}"
            deleted_files+=("$file1")
            file2="${file2#${project_directory}}"
            new_files+=("$file2")
            ;;
    esac
done < <(git diff --name-status master "$@")

{
    echo "=== NOUVEAUX FICHIERS ==="
    if [[ ${#new_files[@]} -eq 0 ]]; then
        echo "Aucun"
    else
        printf '%s\n' "${new_files[@]}"
    fi

    echo ""
    echo "=== FICHIERS MODIFIÉS ==="
    if [[ ${#modified_files[@]} -eq 0 ]]; then
        echo "Aucun"
    else
        printf '%s\n' "${modified_files[@]}"
    fi

    echo ""
    echo "=== FICHIERS SUPPRIMÉS ==="
    if [[ ${#deleted_files[@]} -eq 0 ]]; then
        echo "Aucun"
    else
        printf '%s\n' "${deleted_files[@]}"
    fi
} > "$OUTPUT_FILE"

echo "Résumé généré dans : $OUTPUT_FILE"