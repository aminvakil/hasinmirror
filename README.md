# mirrorchange
Script to change mirrors in different linux distors package managers to **mirror.saminserver.com**

**Supported and Tested Distros**:

Ubuntu 16.04

Ubuntu 18.04

Debian 10 (Buster)

CentOS 7

**Unsupported Distros**:

CentOS 8

**Read the script CAREFULLY before execution**

Other Ubuntu and Debian distros should work as well as they perform the same

**Debian & Ubuntu**: This script copies existing `/etc/apt/sources.list` to `/etc/apt/sources.list_saminback` first automatically, therefore you can revert any changes made by this script.

**CentOS**: This scripts just disables the existing official repos and add its repo in `/etc/yum.repos.d/centos-Samin.repo`, so for reverting you can remove this file and enable the official repos from `/etc/yum.repos.d/CentOS-Base.repo`.
