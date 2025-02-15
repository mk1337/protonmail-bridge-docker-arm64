#!/bin/bash
set -ex

# Function to stop any running instance of ProtonMail Bridge safely
stop_existing_instance() {
    echo "Stopping any running ProtonMail Bridge processes..."

    # Find process IDs (PID) of running ProtonMail Bridge instances
    pids=$(ps aux | grep '[p]rotonmail/proton-bridge' | awk '{print $2}')

    # If found, kill the process
    if [ -n "$pids" ]; then
        echo "Killing processes: $pids"
        kill $pids
    fi
}

# Function to initialize ProtonMail Bridge
initialize() {
    echo "Initializing ProtonMail Bridge..."

    gpg --generate-key --batch /protonmail/gpgparams
    pass init pass-key
    stop_existing_instance  # Kill any running instance before starting
    exec /protonmail/proton-bridge --cli "$@"
}

# Function to start the ProtonMail Bridge service
start_bridge() {
    echo "Starting ProtonMail Bridge in daemon mode..."

    # Bind SMTP (1025) and IMAP (1143)
    socat TCP-LISTEN:25,fork TCP:127.0.0.1:1025 &
    socat TCP-LISTEN:143,fork TCP:127.0.0.1:1143 &

    # Ensure a fake terminal to prevent EOF issues
    rm -f faketty
    mkfifo faketty
    cat faketty | exec /protonmail/proton-bridge --cli
}

# Entry point logic
if [[ "$1" == "init" ]]; then
    initialize "$@"
else
    start_bridge
fi
