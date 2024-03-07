MODID=chroot-distro
AUTOMOUNT=true
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=false

print_modname() {
  ui_print "*******************************"
  ui_print "               chroot-distro                "
  ui_print "*******************************"
}
dos2unix /system/bin/chroot-distro
REPLACE=""
set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}
