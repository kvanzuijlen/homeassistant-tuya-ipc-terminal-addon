# Home Assistant Add-on: Tuya IPC Terminal
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Expose your Tuya-based security cameras as standard RTSP streams within your local network.
This addon builds on the awesome work of @seydx on [Tuya IPC Terminal](https://github.com/seydx/tuya-ipc-terminal)
and makes integration with Home Assistant a little bit easier.

## About

This addon integrates the tuya-ipc-terminal application into Home Assistant. It authenticates with your Tuya account, 
discovers your compatible IP cameras, and creates a local RTSP stream for each one.

This allows you to use your Tuya cameras with any RTSP-compatible software, including Home Assistant's camera 
integrations, VLC, Frigate, or other NVR systems, without relying on cloud-based P2P connections for viewing.

## Features
- **Local RTSP Streams**: Keeps video traffic on your local network for lower latency and improved privacy.
- **Simple Authentication**: Uses a one-time QR code login process with your Tuya/Smart Life mobile app.
- **Auto-Discovery**: Automatically discovers and refreshes your camera list on startup.
- **Wide Compatibility**: Works with any RTSP-compatible client or NVR software.

## Installation

### Automatic

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL
pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)
](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fkvanzuijlen%2Fhomeassistant-tuya-ipc-terminal-addon)

1. Click on the button above (see the official [docs](https://my.home-assistant.io/) for more information)
2. Click Add
3. Close the dialog and refresh the page. The "Tuya IPC Terminal" addon will now appear in the store.
4. Click on the "Tuya IPC Terminal" addon and then click Install.

### Manual

1. Navigate to your Home Assistant instance.
2. Go to Settings > Add-ons > Add-on Store.
3. Click the 3-dots menu in the top-right corner and select Repositories.
4. Add the URL of this repository and click Add.
5. Close the dialog and refresh the page. The "Tuya IPC Terminal" addon will now appear in the store.
6. Click on the "Tuya IPC Terminal" addon and then click Install.

## Configuration

### Step 1: Add-on Options

Before starting the addon, you must configure it with your Tuya account details.
1. On the addon page, go to the Configuration tab.
2. Set the following options:
   - **TUYA_EMAIL**: The email address associated with your Tuya Smart or Smart Life account.
   - **TUYA_REGION**: The cloud region your account is registered in. Common values are:
     - eu-central
     - eu-east
     - us-west
     - us-east
     - china
     - india
     - See [this list](https://github.com/seydx/tuya-ipc-terminal#-authentication-management)
3. Click Save.

### Step 2: First-Time Authentication (QR Code)

The addon uses a one-time QR code process to securely log into your account. This QR will be valid for 20 seconds,
after which the addon will need to be restarted.

1. Open the Tuya or Smart Life app on your smartphone.
2. Click Start to run the addon for the first time.
3. Go to the addon's Log tab on your desktop/laptop or another separate device.
4. The logs will refresh, and you will see a large QR code appear.
5. In the app, go to your profile tab and then find the Scan button (usually in the top-right corner).
6. Scan the QR code displayed in the addon logs.
7. Confirm the login on your phone.
8. The addon will automatically detect the successful login and proceed. On success, it creates a `.tuya-data` folder in 
9. the `/addon_configs/966623c8_tuya_ipc_terminal` directory to store authentication tokens, so you only need to do this once.

### Step 3: Finding Your Camera Streams

Once authentication is complete, the addon will start the RTSP server and list the URLs for your cameras.

1. Look at the logs again. After the authentication messages, you will see entries for each camera, like this:
   ```log
    22:53:35.138 INF Available endpoints:
    22:53:35.139 INF   rtsp://localhost:8554/Front_Door_Cam (Front Door Cam)
    22:53:35.139 INF   rtsp://localhost:8554/Backyard_Cam (Backyard Cam)
    22:53:35.139 INF RTSP server is running. Press Ctrl+C to stop.
   ```
2. Copy the RTSP URL for the camera you wish to add to Home Assistant or another client.

## Usage in Home Assistant

The easiest way to add your camera to the Home Assistant dashboard is by using the Generic Camera integration.

1. Go to Settings > Devices & Services.
2. Click Add Integration and search for Generic Camera.
3. Fill out the configuration:
   - Stream Source URL: Paste the RTSP URL you copied from the addon logs.
   - Authentication: Select None, as authentication is not required for the local stream.
4. Click Submit, and your camera feed should now be available as an entity in Home Assistant.

Other ways to add your camera to Home Assistant are via integrations like Frigate or MotionEye.

## Re-authenticating

If your authentication token expires or you change your password, you may need to re-authenticate.

1. Stop the Tuya IPC Terminal addon.
2. Use the File editor, Samba, or Terminal addon to access your Home Assistant configuration files.
3. Navigate to the `/addon_configs/966623c8_tuya_ipc_terminal` directory.
4. Delete the entire `.tuya-data` folder.
5. Start the Tuya IPC Terminal addon again and follow the QR code authentication steps from above.

## Troubleshooting

- QR Code Expired: The authentication process has a 20 second timeout. Be ready to scan the QR code as soon as it 
  appears in the logs. If you miss it, simply restart the addon to generate a new one.
- No Cameras Found:
  - Verify that your cameras are online and visible in your Tuya Smart/Smart Life app.
  - Double-check that the `TUYA_EMAIL` and `TUYA_REGION` in the addon configuration are correct.
- RTSP Stream Not Working:
  - Ensure the RTSP URL is correct.
  - Verify that port `8554` is correctly mapped in the addon's Network configuration section.
  - Check the addon logs for any error messages related to the RTSP server.
- See the [Tuya IPC Terminal docs](https://github.com/seydx/tuya-ipc-terminal#-complete-documentation)
