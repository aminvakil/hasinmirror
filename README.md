# Change mirrors to mirrros.hasin.ir
You could use this script which automatically replaces your existing mirrors to **mirrros.hasin.ir** which is located in Iran and would speed your updating, installing packages up.

**Supported and Tested Distros**:

Ubuntu 16.04

Ubuntu 18.04

CentOS 7

**Unsupported Distros**:

CentOS 8

**Read the script CAREFULLY before execution**

Other Ubuntu distros should work as well as they perform the same

**Ubuntu**: This script copies existing `/etc/apt/sources.list` to `/etc/apt/sources.list_hasinback` first automatically, therefore you can revert any changes made by this script. If you have any repos aside from official debian / ubuntu repos in your /etc/apt/sources.list you should add them again yourself in /etc/apt/sources.list.d which is more appropriate and suggested by debian/ubuntu themselves.

**CentOS**: This scripts just disables the existing official repos and add its repo in `/etc/yum.repos.d/centos-Samin.repo`, so for reverting you can remove this file and enable the official repos from `/etc/yum.repos.d/CentOS-Base.repo`.

**Arch Linux**: Arch is also available in **mirrors.hasin.ir**, although not included in this script.
