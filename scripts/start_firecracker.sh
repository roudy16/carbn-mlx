#!/bin/bash

# NOTE: Don't delete the firecracker socket in script, could be destructive

${FIRECRACKER} --api-sock ${FIRECRACKER_SOCKET}
