Dies ist ein Ubuntu 24.04 LTS mit XFCE4 Desktop, der über den Browser aufgerufen wird.

Standardmäßig ist das root Konto deaktiviert und der Standardbenutzer hat keine root Rechte.

Die Installation zusätzlicher Pakete muss daher standardmäßig über Docker erfolgen.
______________________________________________________________________________________________________________________________________________________

Im Dockerfile oder als Argumente beim Build können folgende Parameter angepasst werden:
    -User:          Name des Standardbenutzers
    -VNC_PORT:      Port des VNC-Servers
    -NOVNC_PORT:    Port des NOVNC_Servers und damit der Port der im Browser aufgerufen werden muss
    -RESOLUTION:    Auflösung und damit Größe des Fensters im Browser
    -COLOR_DEPTH:   Farbtiefe
______________________________________________________________________________________________________________________________________________________

Beispiel für Build:

docker build -t xfce_ubuntu_im_browser .
______________________________________________________________________________________________________________________________________________________

Beispiel für Containerstart:

docker run -d -p 127.0.0.1:6080:6080 --name XFCE_Ubuntu --restart unless-stopped xfce_ubuntu_im_browser

- Der zweite Port muss NOVNC_PORT entsprechen.
- --restart unless-stopped ermöglicht es, sich nach dem Passwort setzen direkt neu anmelden zu können, ohne den Container neustarten zu müssen.