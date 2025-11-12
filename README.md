### Headless OBS NDI Streamer in Docker

This project provides a complete Docker-based solution for running a dedicated, headless OBS Studio instance. It is designed to function as a powerful streaming server, offloading the resource-intensive task of video encoding from a primary gaming or workstation PC to a secondary server. This effectively implements a modern "2-PC streaming setup" using the power and flexibility of Docker and NDI®.

The primary goal is to maintain maximum performance on your main computer while producing a high-quality stream for services like Twitch, YouTube, or others.

#### Features

*   **Headless OBS Studio:** Runs a full-featured OBS Studio without a graphical user interface, dedicating all server resources to encoding.
*   **NDI® Integration:** Receives a high-quality, low-latency video feed from another computer on your local network using the NDI® protocol.
*   **Remote Control:** Includes the `obs-websocket` plugin, allowing you to start/stop the stream, monitor status, and control OBS remotely via a wide range of tools (e.g., Touch Portal, Bitfocus Companion, or custom scripts).
*   **Custom Docker Image:** Built from a clean Ubuntu base with the official OBS PPA, NDI 5.5 Runtime, and the `obs-ndi` plugin, ensuring up-to-date and stable components.
*   **GitOps-Ready:** Designed to be deployed via Portainer from a Git repository. Simply push changes to your repository, and Portainer can automatically rebuild and redeploy the stack.
*   **Flexible Configuration:** All important settings (bitrate, resolution, stream key, etc.) are managed via environment variables for easy and secure configuration.

#### How it Works

The workflow is split between two machines:

1.  **Gaming / Workstation PC:** Your primary machine runs a standard OBS Studio instance with the `obs-ndi` plugin installed. Instead of streaming directly to Twitch, you enable the "NDI Main Output". This broadcasts your final rendered scene (including webcam, overlays, and alerts) as a high-quality video source to your local network. This process requires minimal CPU/GPU power.

2.  **Docker Server:** This Docker container runs on your secondary server.
    *   It automatically detects and connects to the NDI source broadcasted by your primary PC.
    *   The headless OBS instance inside the container uses this NDI feed as its only source.
    *   It then encodes this feed according to your settings (e.g., using the powerful x264 software encoder) and streams the final output to your chosen RTMP service (e.g., Twitch).

#### Setup & Deployment

This setup is managed via Docker Compose.

##### 1. Prerequisites

*   A server with Docker and Docker Compose installed.
*   A primary PC on the same network with OBS Studio and the `obs-ndi` plugin installed.

##### 2. Deployment via `docker-compose`

1.  Clone this repository to your Docker server.
2.  Navigate into the project directory.
3.  Create your environment file by copying the example: `cp .env.example .env`
4.  Edit the `.env` file and fill in your personal values, especially `STREAM_KEY` and `OBS_WS_PW`.
5.  Build and start the container with: `sudo docker compose up --build`

##### 3. Deployment via Portainer (Recommended GitOps approach)

1.  In Portainer, create a new "Stack".
2.  Choose "Git Repository" as the deployment method.
3.  Enter the URL of this repository and specify the `main` branch.
4.  In the "Environment variables" section, either add each variable from the `.env.example` file manually or use the "Load variables from .env file" option to paste the content of your local `.env` file. **Do not commit your secrets!**
5.  Click "Deploy the stack". Portainer will clone the repository, build the custom Docker image, and start the service using the variables you provided. For automated updates, you can configure a polling interval or use the provided webhook in your Git repository's settings.
