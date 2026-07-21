# otus
Описание домашнего задания:<br>
•	запустить 2 виртуальных машины (сервер NFS и клиента);<br>
•	на сервере NFS должна быть подготовлена и экспортирована директория;<br>
•	в экспортированной директории должна быть поддиректория с именем upload с правами на запись в неё;<br>
•	экспортированная директория должна автоматически монтироваться на клиенте при старте виртуальной машины (systemd, autofs или fstab — любым способом);<br>
•	монтирование и работа NFS на клиенте должна быть организована с использованием NFSv3.<br><br>
_____________________________________________________________________________________________________________________________________________<br><br>

1.	запустить 2 виртуальных машины (сервер NFS и клиента)<br><br>
Запущены ВМ: otushw (192.168.216.129) и otusclient (192.168.216.128). Обе ВМ на Ubuntu 24.04<br><br>
2.	на сервере NFS должна быть подготовлена и экспортирована директория. в экспортированной директории должна быть поддиректория с именем upload с правами на запись в неё.<br><br>
`apt update && apt install nfs-kernel-server` #устанавливаем NFS сервер<br>
`ss -tlnp` #проверяем запущен ли сервер по tcp:<br><br>
<img width="974" height="147" alt="image" src="https://github.com/user-attachments/assets/cbc9edf4-863b-4b8a-bdda-68b4e183bd48" /><br><br>

`mkdir -p /srv/share/upload` #создаем каталог для шары<br>
`chown -R nobody:nogroup /srv/share` #устанавливаем права<br>
`chmod 0777 /srv/share/upload`<br>
`nano /etc/exports`<br>
Допишем в файл:    /srv/share 192.168.216.128/32(rw,sync)<br>
`exportfs -r` #применяем<br>
`exportfs -s` #проверяем<br><br>
<img width="974" height="39" alt="image" src="https://github.com/user-attachments/assets/e07a43ec-f3ff-4a13-97f0-051b5bc21736" /><br><br>

3.	экспортированная директория должна автоматически монтироваться на клиенте при старте виртуальной машины. монтирование и работа NFS на клиенте должна быть организована с использованием NFSv3.<br><br>
На клиенте:<br><br>
`apt update && apt install nfs-common` #устанавливаем клиентскую часть NFS<br>
`nano /etc/fstab`<br>
Добавляем автомонтирование шары с сервера:<br>
192.168.216.129:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0<br>
`systemctl daemon-reload`<br>
`systemctl restart remote-fs.target`<br>
`cd /mnt`<br>
`mount | grep mnt`<br><br>
<img width="974" height="125" alt="image" src="https://github.com/user-attachments/assets/49dc1177-8fbc-43bb-b740-e496fc806a55" /><br><br>

`reboot` #проверяем автомонтирование<br>
`cd /mnt`<br>
`df -hT`<br><br>
<img width="974" height="220" alt="image" src="https://github.com/user-attachments/assets/9ca76cc6-9847-4a1d-a085-0698dfe213cb" /><br><br>

`touch upload/file_from_client` #аплоадим файл от клиента<br><br>
На сервере:<br><br>
`showmount -a`<br><br>
<img width="491" height="103" alt="image" src="https://github.com/user-attachments/assets/3560656a-3271-4d76-9c38-491e24308f78" /><br><br>

`ls /srv/share/upload/`<br><br>
<img width="630" height="63" alt="image" src="https://github.com/user-attachments/assets/8efde958-94d2-4a9f-91bb-01a620c4cea1" /><br><br>

`touch /srv/share/upload/server_secret` #"отправляем" файл клиенту<br><br>
На клиенте:<br><br>
`ls /mnt/upload/`<br><br>
<img width="648" height="80" alt="image" src="https://github.com/user-attachments/assets/393542e6-79be-419f-9142-7b98ab0b4242" />

