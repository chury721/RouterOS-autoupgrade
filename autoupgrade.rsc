:local FWcurrent [/system routerboard get current-firmware]
       :local FWupgrade [/system routerboard get upgrade-firmware]
       :local d [/system clock get date]
       :local t [/system clock get time]
       :local mk [/system identity get name]
       :local emailTo "email@domain.cz" 
       ### Pro upgrade ROS
       /system package update
       check-for-updates once
       :delay 3s
       :local novaVerze [get latest-version]
       :if ( [get status] = "New version is available") \
       do={ \
       :log info "Nova verze ROS $novaVerze je dostupna, stahuji..." 
       :tool e-mail send to=$emailTo subject="$mk upgrade RoS" body="V $t $d, n>
       install 
       :log info "Restartuji..." 
       else={ \
       :log info "Aktualni ROS, kontroluji aktualnost Firmware..." 
       ### Pro upgrade Firmware
       :if ($FWcurrent = $FWupgrade) \
              do={ \
             :log info "Aktualni Firmware" \
              } \
             else={ \
             :log info "Neaktualni Firmware" 
             :delay 2 
             :log info "Nastavuji upgrade" 
             /system routerboard upgrade
             :tool e-mail send to=$emailTo subject="$mk upgrade Firmware" body="V>
             :delay 10 
             :log info "Restartuji..."
             /system reboot
             } 
       } 
