#!/bin/bash

# Number of apps to start (default: 3)
NUM_APPS=${1:-3}

# Starting port
START_PORT=22280

# JAR file path
JAR_FILE="show-port-number-app.jar"

# Check if JAR file exists
if [ ! -f "$JAR_FILE" ]; then
    echo "Error: JAR file not found at $JAR_FILE"
    echo "Please build the project first with: mvn package"
    exit 1
fi

echo "Starting $NUM_APPS app instance(s) starting from port $START_PORT..."

# Start each app instance
for ((i=0; i<NUM_APPS; i++)); do
    PORT=$((START_PORT + i))
    echo "Starting app on port $PORT..."
    java -jar "$JAR_FILE" --server.port=$PORT > "app_${PORT}.log" 2>&1 &
    echo "App started on port $PORT (PID: $!, log file: app_${PORT}.log)"
    sleep 1  # Small delay to avoid port conflicts
done

echo ""
echo "All $NUM_APPS app instance(s) started!"
echo "Logs are available in app_<port>.log files"
echo ""
echo "To stop all apps, run: pkill -f 'show-port-number-app.jar'"

