#!/bin/bash

echo "Inizio installazione della tua applicazione..."

# Controlla se Python è installato
if ! command -v python3 &>/dev/null; then
    echo "Python3 non trovato. Sto installando Python3..."
    # Installa Python3 tramite Homebrew (macOS)
    if ! command -v brew &>/dev/null; then
        echo "Homebrew non è installato. Sto installando Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python
else
    echo "Python3 già installato."
fi

# Assicura che pip sia aggiornato
echo "Aggiornamento di pip..."
python3 -m pip install --upgrade pip

# Installa le librerie necessarie
echo "Installazione delle librerie Python richieste..."
if [ -f "requirements.txt" ]; then
    python3 -m pip install -r requirements.txt
else
    echo "Errore: requirements.txt non trovato. Assicurati che sia nella stessa directory dello script."
    exit 1
fi

# Copia l'app nel percorso delle applicazioni
APP_NAME="LaMiaApp"
APP_SRC_PATH="build/macos/Build/Products/Release/Runner.app"
APP_DST_PATH="/Applications/$APP_NAME.app"

if [ -d "$APP_SRC_PATH" ]; then
    echo "Copio l'applicazione in $APP_DST_PATH..."
    cp -R "$APP_SRC_PATH" "$APP_DST_PATH"
    echo "Installazione completata. Puoi trovare l'app in /Applications."
else
    echo "Errore: non ho trovato l'app in $APP_SRC_PATH. Assicurati di aver costruito l'app prima di eseguire questo script."
    exit 1
fi

echo "Installazione completata con successo!"
