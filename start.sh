#!/bin/bash
set -e

# Pfade für die OBS-Konfiguration
OBS_CONFIG_DIR="/root/.config/obs-studio"
OBS_PROFILE_DIR="${OBS_CONFIG_DIR}/basic/profiles/headless"
OBS_SCENES_DIR="${OBS_CONFIG_DIR}/basic/scenes"

# Erstelle die Verzeichnisse
mkdir -p "${OBS_PROFILE_DIR}"
mkdir -p "${OBS_SCENES_DIR}"

# Erstelle die service.json für die Stream-URL und den Key
cat <<EOF > "${OBS_PROFILE_DIR}/service.json"
{
    "settings": {
        "key": "${STREAM_KEY}",
        "server": "${STREAM_URL}"
    },
    "type": "rtmp_custom"
}
EOF

# Erstelle die basic.ini für die Encoder- und Video-Einstellungen
cat <<EOF > "${OBS_PROFILE_DIR}/basic.ini"
[General]
Name=headless

[Video]
BaseCX=${RESOLUTION_W:-1920}
BaseCY=${RESOLUTION_H:-1080}
OutputCX=${RESOLUTION_W:-1920}
OutputCY=${RESOLUTION_H:-1080}
FPSType=0
FPSCommon=${FPS:-60}

[Output]
Mode=Advanced
RecFormat=mkv
RecEncoder=none
StreamEncoder=${ENCODER:-x264}
RecFilePath=/tmp

[AdvOut]
TrackIndex=1
Rec=false
UseRescale=false
Bitrate=${VIDEO_BITRATE:-6000}
KeyframeSec=2
Preset=${PRESET:-veryfast}
RateControl=CBR
EOF

# Erstelle die Szene mit der SRT-Quelle
cat <<EOF > "${OBS_SCENES_DIR}/scene.json"
{
    "current_program_scene": "SRT Scene",
    "current_scene": "SRT Scene",
    "scene_order": [
        {
            "name": "SRT Scene"
        }
    ],
    "sources": [
        {
            "id": "ffmpeg_source",
            "name": "SRT Source",
            "settings": {
                "input": "srt://0.0.0.0:${SRT_PORT:-19937}?mode=listener",
                "is_local_file": false
            },
            "version": 2
        }
    ]
}
EOF

# Erstelle die global.ini, um den Auto-Configuration-Wizard zu überspringen
cat <<EOF > "${OBS_CONFIG_DIR}/global.ini"
[General]
FirstRun=false
[WebsocketAPI]
ServerEnabled=${OBS_WS_ENABLED:-true}
ServerPort=${OBS_WS_PORT:-4455}
AuthRequired=true
ServerPassword=${OBS_WS_PW}
EOF

echo "OBS Konfiguration erstellt. Starte OBS..."

# Starte OBS innerhalb eines virtuellen Bildschirms
exec xvfb-run --auto-servernum obs --verbose --startstreaming --profile "headless" --scene "scene.json"
