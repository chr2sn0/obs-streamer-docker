# Wir starten mit einem stabilen, modernen Ubuntu
FROM ubuntu:22.04

# Umgebungsvariablen für eine nicht-interaktive Installation
ENV DEBIAN_FRONTEND=noninteractive

# Installiere Abhängigkeiten, PPA, OBS und NDI-Komponenten in logischen Schritten zum Debuggen

# Schritt 1: Basis-Abhängigkeiten installieren
RUN apt-get update && \
    apt-get install -y software-properties-common wget

# Schritt 2: OBS PPA hinzufügen
RUN add-apt-repository -y ppa:obsproject/obs-studio

# Schritt 3: OBS Studio selbst installieren
RUN apt-get update && \
    apt-get install -y obs-studio ffmpeg

# Schritt 4: NDI 5.5 Runtime installieren
RUN wget https://downloads.ndi.tv/SDK/NDI_SDK_Linux/libndi5_5.5.3-1_amd64.deb && \
    apt-get install -y ./libndi5_5.5.3-1_amd64.deb && \
    rm libndi5_5.5.3-1_amd64.deb

# Schritt 5: obs-ndi Plugin installieren
RUN wget https://github.com/obs-ndi/obs-ndi/releases/download/4.11.0/obs-ndi-4.11.0-linux-x86_64.deb && \
    apt-get install -y ./obs-ndi-4.11.0-linux-x86_64.deb && \
    rm obs-ndi-4.11.0-linux-x86_64.deb

# Schritt 6: Aufräumen
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Kopiere unser Start-Skript in den Container und mache es ausführbar
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Setze den Befehl, der beim Start des Containers ausgeführt wird
ENTRYPOINT ["/start.sh"]
