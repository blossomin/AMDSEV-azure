#!/bin/bash

set -ex

# Set variables
PACKAGE_NAME="snp-qemu"
PACKAGE_VERSION="$(date +%Y.%m.%d)"
ARCHITECTURE="amd64"
MAINTAINER="Jeremi Piotrowski <jpiotrowski@microsoft.com>"
DESCRIPTION="QEMU with AMD SNP support"

# Create the package directory structure
mkdir -p ${PACKAGE_NAME}-${PACKAGE_VERSION}/debian
mkdir -p ${PACKAGE_NAME}-${PACKAGE_VERSION}/debian/${PACKAGE_NAME}

# Copy the binary files to the package directory
cp snp-release-$(date +%F).tar.gz ${PACKAGE_NAME}-${PACKAGE_VERSION}/snp-release.tar.gz
apt-get install $(ls ./snp-release-$(date +%F)/linux/guest/linux-image*snp-guest*.deb | grep -v dbg)
cp /boot/vmlinuz*snp-guest* ${PACKAGE_NAME}-${PACKAGE_VERSION}/
pushd ${PACKAGE_NAME}-${PACKAGE_VERSION}
ln -sf vmlinuz*snp-guest* vmlinuz 
img=debian-12-nocloud-amd64.qcow2
wget -nc https://cloud.debian.org/images/cloud/bookworm/latest/${img}
popd

pushd ${PACKAGE_NAME}-${PACKAGE_VERSION}
# Create the control file
cat > debian/control <<EOF
Source: ${PACKAGE_NAME}
Maintainer: ${MAINTAINER}
Section: misc
Priority: optional
Standards-Version: 3.9.2
Build-Depends: debhelper (>= 9)

Package: ${PACKAGE_NAME}
Architecture: ${ARCHITECTURE}
Description: ${DESCRIPTION}
Depends: \${shlibs:Depends}, \${misc:Depends}
EOF

cat > debian/rules <<EOF
#!/usr/bin/make -f

%:
	dh \$@

override_dh_auto_install:
	mkdir -p debian/${PACKAGE_NAME}
	tar -xpzf snp-release.tar.gz --strip-components=1 -C debian/${PACKAGE_NAME}
	cd debian/${PACKAGE_NAME} && mv launch-qemu.sh usr/local/bin/
	cd debian/${PACKAGE_NAME} && rm -rf kvm.conf install.sh linux
	cd debian/${PACKAGE_NAME}/usr/local/bin && sed -i \
-e 's|^EXEC_PATH.*|EXEC_PATH="\$\$(readlink -f "\$\$(dirname "\$\$0")/..")"|' \
-e 's|^HDA=.*|HDA="\$\$EXEC_PATH/share/snp-qemu/${img}"|' launch-qemu.sh
	install -d -m 755 debian/${PACKAGE_NAME}/usr/local/share/${PACKAGE_NAME}/
	install -m 644 -t debian/${PACKAGE_NAME}/usr/local/share/${PACKAGE_NAME}/ ${img}
	install -m 644 -t debian/${PACKAGE_NAME}/usr/local/share/${PACKAGE_NAME}/ vmlinuz* 

override_dh_usrlocal:

EOF

cat > debian/changelog <<EOF
${PACKAGE_NAME} (${PACKAGE_VERSION}-0) unstable; urgency=low

  * Initial release.

 -- ${MAINTAINER}  $(date -R)
EOF

cat > debian/compat <<EOF
10
EOF

# Set permissions
chmod -R 755 debian

# Build the package
dpkg-buildpackage -us -uc -b
