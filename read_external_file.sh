#!/bin/bash
# Dieses Skript versucht, alle Dateien in einem Verzeichnis außerhalb des Projektverzeichnisses zu lesen.

TARGET_DIR="$1"

# Überprüfe, ob das Verzeichnis existiert
if [ ! -d "$TARGET_DIR" ]; then
    echo "Fehler: '$TARGET_DIR' ist kein Verzeichnis."
    exit 1
fi

echo "Lese Dateien aus dem Verzeichnis: $TARGET_DIR"
echo "============================================="

# Schleife durch alle Elemente im Verzeichnis
for file in "$TARGET_DIR"/*
do
    # Überprüfe, ob es sich um eine reguläre Datei handelt
    if [ -f "$file" ]; then
        echo ""
        echo "--- Inhalt von: $file ---"
        cat "$file"
        echo "--- Ende von: $file ---"
    fi
done