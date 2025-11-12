# Wir starten mit einem stabilen, modernen Ubuntu
FROM ubuntu:22.04

# Umgebungsvariablen für eine nicht-interaktive Installation
ENV DEBIAN_FRONTEND=noninteractive

# Installiere Abhängigkeiten und das OBS PPA für eine aktuelle Version
RUN apt-get update && \
    apt-get install -y software-properties-common wget && \
    add-apt-repository -y ppa:obsproject/obs-studio && \
    apt-get update && \
    # Installiere OBS und ffmpeg
    apt-get install -y obs-studio ffmpeg && \
    # Lade die NDI 5.5 Runtime herunter und installiere sie
    wget https://downloads.ndi.tv/SDK/NDI_SDK_Linux/libndi5_5.5.3-1_amd64.deb && \
    apt-get install -y ./libndi5_5.5.3-1_amd64.deb && \
    # Lade das obs-ndi Plugin herunter und installiere es
    wget https://github.com/obs-ndi/obs-ndi/releases/download/4.11.0/obs-ndi-4.11.0-linux-x86_64.deb && \
    apt-get install -y ./obs-ndi-4.11.0-linux-x86_64.deb && \
    # Aufräumen
    rm *.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Kopiere unser Start-Skript in den Container und mache es ausführbar
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Setze den Befehl, der beim Start des Containers ausgeführt wird
ENTRYPOINT ["/start.sh"]
