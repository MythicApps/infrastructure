import 'default.pp'

# USERS
user { 'yoseph':
  ensure     => present,
  groups     => ['sudo'],
  managehome => true,
  shell      => '/bin/zsh',
}

# KEYS
ssh_authorized_key { 'raddingy@msu.edu':
  user => 'yoseph',
  type => 'ssh-rsa',
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCvEPpsYdupFJpG3/KgvhnWAhyYwhiymsu5vy7LE6ingBDzYf3vhFAdzgC3EOD85KgD66edUHMrxO02Hm78fl4t7aP1evKmjTHRvLrYTiNyRlW/l+Pfty6TfaUC6XDuaLXAqSyqKW8798+anLsO6R/RiHnBdOGW3lHj0u2bOpt5H0JGe7r+OkVsZD+FiA65lC3O1SmlfXDjXYjPE509AX+jrmoPgZXLmBv4/5U7ovcFIX9FS52jL++v48+DRXTeVMhbS7tmhf9JPWZBc23LqmsJOTpbWecey1zNBGJMz3H3+tbWrrxpNMdTC3l2Ad2jDnLOiNK8NEDVearwapKDSnsj',
}
