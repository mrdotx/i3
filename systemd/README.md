# i3/systemd

systemd services and timer

| file             | comment                                 |
| :--------------- | :-------------------------------------- |
| suspend@.service | service to lock the screen before sleep |

## installation

- cp suspend@.service /etc/systemd/system/suspend@.service

## enable service

- systemctl enable suspend@[username]

## check after reboot

- systemctl status suspend@[username]
