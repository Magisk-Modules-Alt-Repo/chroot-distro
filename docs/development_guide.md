## Development Guide

If you want to help with development or test a bug report against the latest version, create a development build using:

```bash
zip chroot-distro.zip config.sh module.prop update.json META-INF/com/google/android/* system/bin/chroot-distro
```

**Alternative approaches:**
- Enable SSH in a distro, update scripts remotely, and test against another distro (no reboot needed thus making the development quicker)
- Develop directly on the device (physically or via remote connection)

**Testing requirements:**
- Test all changes in Termux (or other terminals) AND Android terminal emulator (ADB Shell)
- Note: ADB Shell only has Busybox and Android Toybox commands, which may behave differently than Termux

**Code quality:**
- Use `ShellCheck` for POSIX compliance
- Document warning exceptions with `# shellcheck disable=SCXXXX` and explanatory comments
- For shell scripting guidance, refer to [Grymoire's tutorial](https://www.grymoire.com/Unix/Sh.html)

**Error Detection:**

To control command monitoring and error handling, set the `CHROOT_DISTRO_LOG` variable:
```bash
export CHROOT_DISTRO_LOG=<value>
```
- `0`: Checks syntax without executing commands.
- `1`: Stops on any error.
- `2`: Stops on error and shows executed commands.

**Check rootfs urls:**

1. Download the provided code:  
[scripts/check_rootfs_urls.sh](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/tree/main/scripts/check_rootfs_urls.sh)

2. Make it executable:
```bash
chmod +x check_rootfs_urls.sh
```

3. Run the script:
```bash
./check_rootfs_urls.sh
```
or
```bash
sh check_rootfs_urls.sh
```

If you see a red link, report it in the [issues](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/issues) section.

