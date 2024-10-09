# i3

shell scripts for i3

| file                 | comment                                                      | images                                                                             |
| :------------------- | :----------------------------------------------------------- | :--------------------------------------------------------------------------------- |
| i3_autotiling.sh     | automatic optimal tilings for windows                        |                                                                                    |
| i3_container.sh      | shows keybindings for i3 container actions                   | ![container mode](images/container.png)                                            |
| i3_editor.sh         | shows keybindings for editor                                 | ![editor mode](images/editor.png)                                                  |
| i3_exit.sh           | shows keybindings for lock, reboot, shutdown, etc.           | ![exit mode](images/exit.png)                                                      |
| i3_floating.sh       | shows keybindings for positioning floating windows           | ![floating mode](images/floating.png)                                              |
| i3_helper.sh         | used in the other scripts for table, notify, net check, etc. |                                                                                    |
| i3_macros.sh         | shows keybindings for predefined macros                      | ![macros mode](images/macros.png) ![macros autostart](images/macros_autostart.gif) |
| i3_mouse_move.sh     | move mouse pointer to the edge of the monitor                |                                                                                    |
| i3_nfs.sh            | shows keybindings for nfs mounts                             | ![nfs mode](images/nfs.gif)                                                        |
| i3_notes.sh          | shows keybindings for notes                                  | ![notes mode](images/notes.png)                                                    |
| i3_services.sh       | shows keybindings for services                               | ![services mode](images/services.png)                                              |
| i3_ssh.sh            | shows keybindings for ssh connections                        | ![ssh mode](images/ssh.png)                                                        |
| i3_tmux.sh           | open applications in tmux windows                            |                                                                                    |
| i3_window_move.sh    | move floating window to the edge of the monitor              |                                                                                    |
| i3_workspace_swap.sh | swap workspaces and focus(left,right,up,down)                |                                                                                    |
| suspend@.service     | systemd service to lock the screen before sleep              |                                                                                    |

config files:

- [dotfiles/i3](https://github.com/mrdotx/dotfiles/tree/master/.config/i3)
- [dotfiles/polybar](https://github.com/mrdotx/dotfiles/tree/master/.config/polybar)
- [dotfiles/tmux](https://github.com/mrdotx/dotfiles/tree/master/.config/tmux)
- [dotfiles/dunst](https://github.com/mrdotx/dotfiles/tree/master/.config/dunst)
- [dotfiles/systemd](https://github.com/mrdotx/dotfiles/tree/master/.config/systemd/user)

related projects:

- [polybar](https://github.com/mrdotx/polybar)

# suspend systemd service

service to lock the screen before sleep

## installation

- cp suspend@.service /etc/systemd/system/suspend@.service

## enable service

- systemctl enable suspend@[username]

## check after reboot

- systemctl status suspend@[username]

