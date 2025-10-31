# Ein Ubuntu mit XFCE4 Desktop, dass über den Browser bedient werden kann.
# Basiert auf Ubuntu 24.04 LTS. 
# Alle Pakete werden in ihrer Standard-Version (Stand 15.10.2025) aus den Standard-Repositories installiert.

# Basis Image
FROM ubuntu:24.04

# Einstellungen (können angepasst werden)
ARG USER=User
ARG VNC_PORT=5900
ARG NOVNC_PORT=6080
ARG RESOLUTION=1920x1080
ARG COLOR_DEPTH=24

# Bash als Shell; Build bricht ab wenn nur ein Befehl fehlschlägt; Übergibt jeden folgenden Befehl als String
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Pakete ohne Rückfragen installieren, dann aufräumen
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        # Lokalisierung
        locales=2.39-0ubuntu8.6 \
        # Zeitzone
        tzdata=2025b-0ubuntu0.24.04.1 \
        # Desktop
        xfce4=4.18 \
        # Terminal
        xfce4-terminal=1.1.3-1build1 \
        # Extras für den Desktop
        xfce4-goodies=4.18.2build1 \
        # Kommunikation zwischen grafischen Anwendungen
        dbus-x11=1.14.10-4ubuntu4.1 \
        # Virtueller Display
        xvfb=2:21.1.12-1ubuntu1.4 \
        # VNC Server
        x11vnc=0.9.16-10 \
        # Kommunikation zwischen Browser und VNC-Server
        websockify=0.10.0+dfsg1-5build2 \
        # Browser VNC-Client
        novnc=1:1.3.0-2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
# Lokalisierung
    locale-gen de_DE.UTF-8 && \
    update-locale LANG=de_DE.UTF-8 && \
# Neuer Benutzer und root sperren
    useradd -m ${USER} && \
    passwd -l root

# Umgebungsvariablen
ENV LANG=de_DE.UTF-8 \
    LANGUAGE=de_DE:de \
    LC_ALL=de_DE.UTF-8 \
    TZ=Europe/Berlin \
    DISPLAY=:0 \
    USER=${USER} \
    VNC_PORT=${VNC_PORT} \
    NOVNC_PORT=${NOVNC_PORT} \
    RESOLUTION=${RESOLUTION} \
    COLOR_DEPTH=${COLOR_DEPTH} \
    DEBIAN_FRONTEND=dialog

# Portfreigabe
EXPOSE ${VNC_PORT} ${NOVNC_PORT}

# Startskript und Benutzerwechsel
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
USER ${USER}
WORKDIR /home/${USER}
ENTRYPOINT ["/usr/local/bin/start.sh"]