# Package opsdisplay for EL7.
PKG_NAME=opsdisplay
VERSION=1.4
RELEASE=1.el7
ARCH=x86_64
DESCRIPTION=Display Opera browser in full-screen mode on multiple screens (e.g. in an ops center)
URL=https://github.com/liger1978/opsdisplay
PACKAGER=grainger@gmail.com
LICENSE=MIT

.PHONY: package
package:
	rm -f *.rpm
	rm -rf /tmp/fpm
	mkdir -p /tmp/fpm
	cp -R src /tmp/fpm
	chmod 0755 /tmp/fpm/src/usr/bin/opsdisplay
	chmod 0755 /tmp/fpm/src/usr/bin/opsdisplay_screen
	chmod 0664 /tmp/fpm/src/etc/opsdisplay
	chmod -R 0664 /tmp/fpm/src/etc/opsdisplay.d
	chmod 0664 /tmp/fpm/src/etc/opsdisplay_operaprefs.ini
	chmod 0644 /tmp/fpm/src/lib/systemd/system/opsdisplay.service
	fpm \
	-s dir \
	-t rpm \
	-n $(PKG_NAME) \
	-v $(VERSION) \
  --iteration $(RELEASE) \
	-a $(ARCH) \
	-C /tmp/fpm/src \
	-m "$(PACKAGER)" \
	--url "$(URL)" \
	--description "$(DESCRIPTION)" \
	--license "$(LICENSE)" \
	--rpm-use-file-permissions \
	--after-install /tmp/fpm/src/post-script.sh \
	-d opera -d matchbox-window-manager -d glx-utils -d mesa-dri-drivers \
	-d plymouth-system-theme -d spice-vdagent -d xorg-x11-drivers \
	-d xorg-x11-server-Xorg -d xorg-x11-utils -d xorg-x11-xauth \
	-d xorg-x11-xinit -d xvattr \
	usr/bin/opsdisplay \
	usr/bin/opsdisplay_screen \
	etc/opsdisplay \
	etc/opsdisplay.d/ \
	etc/opsdisplay_operaprefs.ini \
	lib/systemd/system/opsdisplay.service

