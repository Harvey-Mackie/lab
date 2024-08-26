#!/bin/bash

# Remove the current symlinks
rm ~/.docker/cli-plugins/docker-buildx
rm ~/.docker/cli-plugins/docker-compose

# Create new symlinks pointing to the correct locations
ln -s ~/.rd/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
ln -s ~/.rd/bin/docker-compose ~/.docker/cli-plugins/docker-compose

echo "Symlinks updated successfully!"
