#!/usr/bin/env bash

# TmuxLibre: Monitor Your Blood Glucose Levels in Tmux
################################################################################
#
# This script retrieves and displays continuous glucose monitoring (CGM) data
# from the LibreView API. It caches the data to minimize API requests and
# displays the latest glucose level along with a trend indicator in a Tmux
# status bar.
#
# Features:
# - Fetches glucose data from the LibreView API.
# - Caches data to reduce the number of API requests.
# - Displays glucose level and trend in a Tmux status bar.
# - Rotates log files to manage log size.
#
# How It Works:
# 1. The script loads configuration settings from ~/.tmuxlibre.conf.
# 2. If necessary, it creates a default configuration file and exits.
# 3. The script checks the cache for recent data.
# 4. If the cache is outdated, it logs into the LibreView API and fetches new data.
# 5. The script parses the data and determines the glucose trend.
# 6. Finally, it outputs the glucose level and trend for display in Tmux.
#
# Configuration:
# - Create or edit ~/.tmuxlibre.conf with the following settings:
#   LIBREVIEW_API_URL="https://api-de.libreview.io"
#   CACHE_FILE="/tmp/tmuxlibre_cache.json"
#   CACHE_DURATION=180
#   LOG_FILE="/tmp/tmuxlibre.log"
#   LOG_MAX_SIZE=2000000
#   LIBREVIEW_EMAIL="your_email"
#   LIBREVIEW_PASSWORD="your_password"
#
# Dependencies:
# - curl
# - jq
# - bc
# - gzip
################################################################################

# Setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# Load utils
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

# Constants (Default values, can be overridden by config)
BASE_URL="${LIBREVIEW_API_URL:-https://api-de.libreview.io}"
CACHE_FILE="/tmp/tmuxlibre_cache.json"
CACHE_DURATION=180  # Cache duration in seconds (3 minutes)
LOG_FILE="/tmp/tmuxlibre.log"
LOG_MAX_SIZE=2000000 # 2MB
CONFIG_FILE="$HOME/.tmuxlibre.conf"
TOKEN_FILE="/tmp/tmuxlibre_token.json" # File to store the token and its expiry

HEADERS=(
    -H "accept-encoding: gzip"
    -H "cache-control: no-cache"
    -H "connection: Keep-Alive"
    -H "content-type: application/json"
    -H "product: llu.android"
    -H "version: 4.7"
)

# Function to log messages to the log file and rotate the log if needed
# Input: Log message as a string
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    rotate_log
}

# Function to get the file size in bytes
# Input: File path as a string
# Output: File size in bytes as a string
get_file_size()
{
    case $(uname -s) in
        Linux)
            du -b "$1" | cut -f1
            ;;
        Darwin|FreeBSD)
            du -k "$1" | cut -f1
            ;;
        *)
            log "Unsupported OS: $(uname -s)"
            echo 0
            ;;
    esac
}

# Function to rotate the log file if it exceeds the maximum size
# No input, no output
rotate_log() {
    if [ -f "$LOG_FILE" ]; then
        log_size=$(get_file_size "$LOG_FILE")
        if [ "$log_size" -gt $LOG_MAX_SIZE ]; then
            mv "$LOG_FILE" "$LOG_FILE.1"
            gzip "$LOG_FILE.1"
        fi
    fi
}

# Function to load configuration settings from the config file
# Creates a default config file if it doesn't exist
# No input, no output
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        cat <<EOL > "$CONFIG_FILE"
# Configuration file for tmuxlibre
# Uncomment and set the following variables as needed:

# LIBREVIEW_API_URL="https://api-de.libreview.io"
# CACHE_FILE="/tmp/tmuxlibre_cache.json"
# CACHE_DURATION=180
# LOG_FILE="/tmp/tmuxlibre.log"
# LOG_MAX_SIZE=2000000
# LIBREVIEW_EMAIL=""
# LIBREVIEW_PASSWORD=""
EOL
        log "Configuration file created: $CONFIG_FILE"
        echo "🦋 CONFIG FILE CREATED, PLEASE CONFIGURE AND RE-RUN ❌"
        exit 1
    fi

    source "$CONFIG_FILE"

    : "${LIBREVIEW_API_URL:=$BASE_URL}"
    : "${CACHE_FILE:=$CACHE_FILE}"
    : "${CACHE_DURATION:=$CACHE_DURATION}"
    : "${LOG_FILE:=$LOG_FILE}"
    : "${LOG_MAX_SIZE:=$LOG_MAX_SIZE}"

    if [ -z "$LIBREVIEW_EMAIL" ] || [ -z "$LIBREVIEW_PASSWORD" ]; then
        if grep -q '^[^#]' "$CONFIG_FILE"; then
            log "Email and password must be set in the configuration file"
            echo "🦋 CHECK CONFIG ❌"
        fi
        exit 1
    fi
}

# Function to log in to the LibreView API and retrieve an authentication token
# This function also checks if a cached token is available and still valid
# Input: Email and password as strings
# Output: Authentication token as a string
login() {
    local email=$1
    local password=$2

    # Check for a cached token
    if [ -f "$TOKEN_FILE" ]; then
        token_data=$(cat "$TOKEN_FILE")
        token=$(echo "$token_data" | jq -r '.token')
        expires=$(echo "$token_data" | jq -r '.expires')

        current_time=$(date +%s)
        if (( current_time < expires )); then
            echo "$token"
            return
        fi
    fi

    # No valid cached token, perform login
    local endpoint="/llu/auth/login"
    local payload="{\"email\": \"$email\", \"password\": \"$password\"}"

    response=$(curl -s -X POST "$LIBREVIEW_API_URL$endpoint" "${HEADERS[@]}" -d "$payload" --compressed)
    if [ $? -ne 0 ]; then
        log "HTTP error occurred during login"
        log "Response: $response"
        echo "🦋 NO DATA ❌"
        exit 1
    fi

    log "Login response: $response"

    response=$(echo "$response" | tr -d '\0' | tr -cd '\11\12\15\40-\176')
    token=$(echo "$response" | jq -r '.data.authTicket.token' 2>/dev/null)
    expires=$(echo "$response" | jq -r '.data.authTicket.expires' 2>/dev/null)
    if [ -z "$token" ] || [ "$token" == "null" ]; then
        log "Failed to retrieve token from login response"
        echo "🦋 NO DATA ❌"
        exit 1
    fi

    echo "{\"token\": \"$token\", \"expires\": $expires}" > "$TOKEN_FILE"

    echo "$token"
}

# Function to get patient connections from the LibreView API
# Input: Authentication token as a string
# Output: Patient connections data as a JSON string
get_patient_connections() {
    local token=$1
    local endpoint="/llu/connections"
    local auth_header="Authorization: Bearer $token"

    response=$(curl -s -X GET "$LIBREVIEW_API_URL$endpoint" "${HEADERS[@]}" -H "$auth_header" --compressed)
    if [ $? -ne 0 ]; then
        log "HTTP error occurred during fetching patient connections"
        log "Response: $response"
        echo "🦋 NO DATA ❌"
        exit 1
    fi

    log "Patient connections response: $response"

    data=$(echo "$response" | jq -c '.data' 2>/dev/null)
    if [ -z "$data" ] || [ "$data" == "null" ]; then
        log "No patient connections found"
        echo "🦋 NO DATA ❌"
        exit 1
    fi

    echo "$data"
}

# Function to get CGM data for a patient from the LibreView API
# Input: Authentication token and patient ID as strings
# Output: CGM data as a JSON string
get_cgm_data() {
    local token=$1
    local patient_id=$2
    local endpoint="/llu/connections/$patient_id/graph"
    local auth_header="Authorization: Bearer $token"

    response=$(curl -s -X GET "$LIBREVIEW_API_URL$endpoint" "${HEADERS[@]}" -H "$auth_header" --compressed)
    if [ $? -ne 0 ]; then
        log "HTTP error occurred during fetching CGM data"
        log "Response: $response"
        echo "🦋 NO DATA ❌"
        exit 1
    fi

    log "CGM data response: $response"

    echo "$response"
}

# Function to get the emoji representing a trend based on a given input number
# Input: A number between 1 and 5 representing the trend
#        1 - SingleDown
#        2 - FortyFiveDown
#        3 - Flat
#        4 - FortyFiveUp
#        5 - SingleUp
# Output: The corresponding emoji for the trend
get_trend() {
    case $1 in
        1)
            echo "⬇️" # SingleDown
            ;;
        2)
            echo "↘️" # FortyFiveDown
            ;;
        3)
            echo "➡️" # Flat
            ;;
        4)
            echo "↗️" # FortyFiveUp
            ;;
        5)
            echo "⬆️" # SingleUp
            ;;
        *)
            echo "🤡"
            ;;
    esac
}

# Function to cache CGM data to a file
# Input: CGM data as a JSON string
cache_data() {
    local data=$1
    echo "{\"timestamp\": $(date +%s), \"data\": $data}" > "$CACHE_FILE"
}

# Function to load cached CGM data from a file
# Output: Cached CGM data as a JSON string, or an empty JSON object if the cache is outdated
load_cached_data() {
    if [ ! -f "$CACHE_FILE" ]; then
        echo "{}"
        return
    fi

    cached=$(cat "$CACHE_FILE")
    cached_timestamp=$(echo "$cached" | jq -r '.timestamp' | awk '{printf "%d\n", $1}')
    current_timestamp=$(date +%s)

    if (( current_timestamp - cached_timestamp > CACHE_DURATION )); then
        echo "{}"
        return
    fi

    echo "$cached" | jq -c '.data'
}

# Function to get CGM data, either from the cache or by fetching it from the API
# No input, outputs the glucose level and trend for display in Tmux
get_data() {
    cached_data=$(load_cached_data)
    if [ "$cached_data" != "{}" ]; then
        cgm_data="$cached_data"
    else
        token=$(login "$LIBREVIEW_EMAIL" "$LIBREVIEW_PASSWORD")
        if [ $? -ne 0 ]; then
            exit 1
        fi

        patient_data=$(get_patient_connections "$token")
        if [ $? -ne 0 ]; then
            exit 1
        fi

        patient_id=$(echo "$patient_data" | jq -r '.[0].patientId' 2>/dev/null)
        if [ -z "$patient_id" ];then
            log "Patient ID not found in patient connections"
            echo "🦋 NO DATA ❌"
            exit 1
        fi

        cgm_data=$(get_cgm_data "$token" "$patient_id")
        if [ $? -ne 0 ]; then
            exit 1
        fi

        cache_data "$cgm_data"
    fi

    value=$(echo "$cgm_data" | jq -r '.data.connection.glucoseMeasurement.Value' 2>/dev/null)
    trendarrow=$(echo "$cgm_data" | jq -r '.data.connection.glucoseMeasurement.TrendArrow' 2>/dev/null)
    trend=$(get_trend "$trendarrow")

    echo "🦋 $value $trend"
}

# Load config and execute the main logic
load_config
get_data
