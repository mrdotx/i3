# i3/systemd

systemd services and timer

| file          | comment                                 |
| :------------ | :-------------------------------------- |
| lock@.service | service to lock the screen before sleep |

## installation

- cp lock@.service /etc/systemd/system/lock@.service

## enable service

- systemctl enable lock@[username]

## check after reboot

- systemctl status lock@[username]
