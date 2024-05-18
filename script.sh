#!/bin/bash

create_archive() {
    local file="$1"
    local password="$2"
    7z a "-p$password" "${file}.7z" "$file" && rm -rf "$file"
    }

process_directory() {
    local directory="$1"
    local password="$2"
    local instructions_content="$3"
    local file_count=$(find "$directory" -type f | wc -l)
    local processed_files=0
    
    shopt -s dotglob
    echo -e "\e[1;35m══════════════════════════ ARCHIVE PROCESSING ══════════════════════════\e[0m"
    echo -e "\e[1;35mCurrent Directory: $directory\e[0m"
    echo -e "\e[1;35mInstructions: $instructions_content\e[0m"
    
    for item in "$directory"/*; do
        if [ -f "$item" ]; then
            echo -e "\e[1;36mProcessing File: $item\e[0m"
            create_archive "$item" "$password"
            ((processed_files++))
            # Progress bar
            percentage=$((processed_files * 100 / file_count))
            echo -ne "Progress: ["
            for ((i=0; i<percentage/2; i++)); do echo -ne "="; done
            for ((i=percentage/2; i<50; i++)); do echo -ne " "; done
            echo -ne "] $percentage%\r"
        elif [ -d "$item" ]; then
            process_directory "$item" "$password" "$instructions_content"
        fi
    done
    
    echo "$instructions_content" > "${directory}/instructions.txt"
    echo -e "\n\e[1;32mAll files processed successfully!\e[0m"
    } 

echo -e "\e[1;34mWELCOME TO ARCHIVER\e[0m"
echo "Please provide necessary information:"

read -s -p "Enter password for all archives: " password
echo

read -p "Enter content for instructions.txt: " instructions_content
echo

read -p "Enter start path: " start_path
echo

process_directory "$start_path" "$password" "$instructions_content"