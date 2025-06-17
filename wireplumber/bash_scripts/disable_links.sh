#!/bin/bash

SRC_PORT="alsa_input.usb-SteelSeries_Arctis_Nova_Pro_Wireless-00.mono-fallback:capture_MONO"
SINK_PORT="Virtual-Mic.in:input_MONO"

while true; do
    if pw-link -l | sed -n "/^$SRC_PORT\$/,/^[^ ]/ { /^$SRC_PORT\$/d; /^[^ ]/q; p }" | grep -q "$SINK_PORT"; then
        echo "Link from '$SRC_PORT' to '$SINK_PORT' has been created."
        break
    fi
    sleep 1
done

echo "Link from '$SRC_PORT' to '$SINK_PORT' to be deleted."
pw-link -d "$SRC_PORT" "$SINK_PORT"
ret=$?
if [ $ret -ne 0 ]; then
    echo "Failed to delete link from '$SRC_PORT' to '$SINK_PORT'"
fi
exit 0