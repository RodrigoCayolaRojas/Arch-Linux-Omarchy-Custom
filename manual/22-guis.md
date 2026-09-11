# GUIs

## Files

Files (Nautilus) is the graphical file manager. `Super + Shift + F` opens it, and `Super + Shift + Alt + F` opens it in the directory your terminal is sitting in, which saves a lot of clicking. `Ctrl + L` lets you type a path, and hitting `Space` on any file gives you a quick preview without opening anything.

Plug in a USB stick or an SD card and it's mounted automatically, so it just shows up in the sidebar. For anything more involved — formatting a drive, checking SMART health, creating partitions — launch _Disks_ from the app launcher (`Super + Space`).

Double-clicking follows sensible defaults: images open in imv, video in mpv, PDFs in Document Viewer, and plain text in Neovim.

## Signal

[Signal](https://signal.org/) is the pioneer of E2E encrypted messaging, and a great communication option for anyone who'd prefer not to go through one of the big tech conglomerates.

You start Signal with `Super + Shift + G`. It's not part of the base install, so the first time you hit that, Omarchy will offer to install it for you (it's also under _Install > Service_ in the Omarchy menu).

[LocalSend](https://localsend.org/) lets you send files to other devices on the same network running the app, like Apple's AirDrop. It's cross-platform, though, so you can send files to and from Windows, macOS, Android, iOS, and of course Linux.

You can open the Share menu on `Super + Ctrl + S` or under _Trigger > Share_ in the Omarchy menu. It gives you four options:

- **Clipboard** sends whatever you've copied as a text file. Great for getting a link or a snippet onto your phone without emailing yourself.
- **File** opens a file picker where you can select several at once.
- **Folder** sends an entire directory.
- **Receive** opens LocalSend proper so another device can send something to you.

The same thing works from the terminal with `omarchy share clipboard`, `omarchy share file [path]`, and `omarchy share folder [path]`. Leave the path off and you get the picker.

You can also send straight from the file manager: right-click any selection in Nautilus and pick _Send via LocalSend_.

Omarchy's firewall is closed by default except for LocalSend's port, so this works out of the box on a fresh install. See [security](48-security.md).

## mpv

[mpv](https://mpv.io/) is a simple, fast media player that'll play almost anything from any source. Great for watching videos.

You start mpv via the application launcher (`Super + Space`) or just double-click on a video in the file manager.
