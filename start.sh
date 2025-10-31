#!/bin/bash

# Prozesse und Lock-Datei bereinigen, falls zuletzt nicht korrekt beendet
pkill -f Xvfb || true
pkill -f websockify || true
pkill -f x11vnc || true
pkill -f xfwm4 || true
pkill -f startxfce4 || true
pkill -f xfce4-terminal || true
rm -f /tmp/.X0-lock

# Xvfb (virtueller Display) starten
Xvfb :0 -screen 0 ${RESOLUTION}x${COLOR_DEPTH} &

# Webserver für novnc und Kommunikation mit VNC-Server (x11vnc) starten
websockify --web=/usr/share/novnc/ ${NOVNC_PORT} localhost:${VNC_PORT} &

# Prüfen ob bereits Passwort für VNC gesetzt wurde
if [ -f "/home/${USER}/.vnc/pw" ]; then
    # Falls ja: VNC-Server mit Passwort und anschließend den Desktop starten
    x11vnc -display :0 -rfbauth /home/${USER}/.vnc/pw -forever -rfbport ${VNC_PORT} &
    startxfce4 &
else
    # Falls nein: Terminal öffnen damit der Benutzer vor dem ersten LogIn ein Passwort setzt
    x11vnc -display :0 -nopw -forever -rfbport ${VNC_PORT} &
    xfwm4 &
    sleep 3
    xfce4-terminal --fullscreen --command="bash -c 'mkdir -p ~/.vnc && echo Bitte Passwort für VNC setzen && x11vnc -storepasswd ~/.vnc/pw && echo Passwort gesetzt - Bitte Enter drücken um && echo den Container zu beenden. Nach dem Neustart && echo kann das Passwort verwendet werden && read'"
    kill 0
fi

# Warten, bis ein Prozess beendet wird
wait -n

# Alle Prozesse beenden
kill 0