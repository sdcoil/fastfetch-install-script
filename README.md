# fastfetch-install-script
A bash script that downloads and installs the latest Debian package for the running architecture.

## Introduction
[Fastfetch](https://github.com/fastfetch-cli/fastfetch) is a tool for fetching system information and displaying it in a visually appealing way. It is written mainly in C, with a focus on performance and customizability. Currently, it supports Linux, macOS, Windows 7+, Android, FreeBSD, OpenBSD, NetBSD, DragonFly, Haiku, and SunOS. It is not in Debian's repository for 12 and lower. This scripts aims to install the latest version for the current architecture and and a script that runs when a user logs in.

## Use
Download get_fastfetch.sh and execute with elevated privileges. If you trust the code (and you should not without scrutinization) you can run the following from a Debian command prompt:

```bash
curl -s https://raw.githubusercontent.com/sdcoil/fastfetch-install-script/refs/heads/main/get_fastfetch.sh | bash
```

## Notes
Some of the code is inspired by the following:
- [Python Guides](https://pythonguides.com/json-data-in-python/)
- [Parsing JSON with Unix tools (Stack Overflow)](https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools)
- among others.
