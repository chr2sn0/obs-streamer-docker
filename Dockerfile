# Wir starten mit einem stabilen, modernen Ubuntu
FROM ubuntu:22.04

# Umgebungsvariablen für eine nicht-interaktive Installation
ENV DEBIAN_FRONTEND=noninteractive

# Installiere Abhängigkeiten und OBS Studio
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:obsproject/obs-studio && \
    apt-get update && \
    apt-get install -y obs-studio ffmpeg && \
    # Aufräumen
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Kopiere unser Start-Skript in den Container und mache es ausführbar
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Setze den Befehl, der beim Start des Containers ausgeführt wird
ENTRYPOINT ["/start.sh"]
