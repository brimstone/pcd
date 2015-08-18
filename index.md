app-ng
======

How Appliances Should Be.

Goals:

- **Cloud provider and hardware agnostic.**
  This doesn't depend on anything only provided by any vendor, cloud or
  hardware.
- **Maintain kernel compatibility with a major Linux distribution.**
  This allows the appliance to interoperate with other products and vendors if
  necessary.
- **Easy upgrades**
  Currently, this is simply running the installer again.

Architecture
------------
The base system is build to run entirely from RAM. The drives in the system are only there for persistant data and booting.

The first partition on the system is 200MB. This partition is marked bootable and has the grub bootloader installed. This should leave room for a primary and backup kernel and initramfs and allow future room for expansion.

The second partition is used for Docker images, containers and any shared filesystem. This partition is automatically expanded at boot if needed.

The system uses the runit version in busybox for PID 1.

Using
-----
_TODO_

Boot the system in a variety of ways, PXE, ISO, vagrant, AMI.

Installing or Upgrading
-----------------------
_TODO_

Just copy the upgrade script to the host somewhere?
