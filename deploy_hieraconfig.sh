#!/bin/bash
# NOTE: Run as superuser!!
# Run this script to deploy the hiera configuration
# to the proper locations:
# - /etc/hiera.yaml
# - /etc/puppet/hieradata

SCRIPTDIR="`dirname $0`"
HIERACONF='/etc/hiera.yaml'
HIERADATA='/etc/puppet/hieradata'
DATEFORM=`date +"%Y%m%d_%H%M"`

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Backup
echo "Backing up current files.."
cp $HIERACONF $HIERACONF_$DATEFORM
if [ -d "$HIERADATA" ]; then
	cp -a $HIERADATA ${HIERADATA}_$DATEFORM
fi

# Copy
echo "Deploying files.."
cp $SCRIPTDIR/hiera.yaml $HIERACONF
cp -aT $SCRIPTDIR/hieradata $HIERADATA


# Adjust permissions
echo "Adjusting permissions.."
chown -R .puppet $HIERADATA
find $HIERADATA -type f -exec chmod 640 {} \;
find $HIERADATA -type d -exec chmod 750 {} \;
chmod 0644 $HIERACONF
echo "Done."
