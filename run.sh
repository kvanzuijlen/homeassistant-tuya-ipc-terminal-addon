#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Tuya IPC Terminal
#
# This script starts the Tuya IPC Terminal application with the configured
# options.
# ==============================================================================

# Read configuration options
readonly TUYA_EMAIL=$(bashio::config 'TUYA_EMAIL')
readonly TUYA_REGION=$(bashio::config 'TUYA_REGION')

# Check if required options are set
if [[ -z "${TUYA_EMAIL}" ]]; then
    bashio::log.fatal "Please configure your Tuya email in the addon options."
    exit 1
fi

# Authenticate with Tuya
bashio::log.info "Authenticating with Tuya..."
printf "%s\n%s\n" "${TUYA_REGION}" "${TUYA_EMAIL}" | /tuya_auth_qr.exp

# Refresh camera list
bashio::log.info "Refreshing camera list..."
tuya-ipc-terminal cameras refresh

# Start the RTSP server
bashio::log.info "Starting RTSP server on port 8554..."
tuya-ipc-terminal rtsp start --port 8554
