# otus
<br><br>
Начальная ситуация <br><br>
<img width="974" height="300" alt="image" src="https://github.com/user-attachments/assets/c6e6ba53-2a34-43fc-b4cc-40b4a2eb3fb8" />

 

1.	Уменьшить том под / до 8G.

Соберем временный том для / <br>
`pvcreate /dev/sdb /dev/sdc`<br>
`vgcreate root-vg /dev/sdb /dev/sdc`<br>
`lvcreate -L 8G -n lv-root root-vg`<br>
`mkfs.ext4 /dev/root-vg/lv-root`<br>
`mkdir /mnt/root-tmp && mount /dev/root-vg/lv-root /mnt/root-tmp`<br><br>
Копируем / в новый каталог:<br>
`rsync -avxHAX --progress / /mnt/root-tmp/`  #ключом x исключаем копирование «лишнего», как каталога назначения, так и виртуальные системные каталоги.<br><br>
Проверяем что скопировалось:<br>
<img width="974" height="834" alt="image" src="https://github.com/user-attachments/assets/44c0ece8-7f83-4fb5-8b26-7cea0d6e6ac2" /><br><br>


Конфигурируем GRUB:<br>
`for i in /proc/ /sys/ /dev/ /run/ /boot/; \
 do mount --bind $i /mnt/root-tmp/$i; done`<br>
`chroot /mnt/root-tmp/`<br>
`grub-mkconfig -o /boot/grub/grub.cfg`<br>
`update-initramfs -u`<br>
`exit`<br>
`reboot`<br><br>
 <img width="974" height="368" alt="image" src="https://github.com/user-attachments/assets/7c4f6c1c-18d5-4ed4-93b7-a21cb130c715" />
<br><br>

Уменьшаем раздел ubuntu-lv до 8Gb:<br>
`e2fsck -f /dev/ubuntu-vg/ubuntu-lv`<br>
`resize2fs /dev/ubuntu-vg/ubuntu-lv 8G`<br>
`lvreduce /dev/ubuntu-vg/ubuntu-lv -L 8G`<br><br>
Копируем / обратно на старый раздел:<br>
`mount /dev/ubuntu-vg/ubuntu-lv /mnt/root-tmp`<br>
`rsync -avxHAX --progress / /mnt/root-tmp/`<br><br>
Конфигурируем GRUB:<br>
`for i in /proc/ /sys/ /dev/ /run/ /boot/; \
 do mount --bind $i /mnt/root-tmp/$i; done`<br>
`chroot /mnt/root-tmp/`<br>
`grub-mkconfig -o /boot/grub/grub.cfg`<br>
`update-initramfs -u`<br>
`exit`<br>
`reboot`<br><br>
Проверяем:<br>
<img width="974" height="344" alt="image" src="https://github.com/user-attachments/assets/c4b2c52e-aace-4159-9432-3ca6c279393a" />


2.	Выделить том под /home.<br><br>

`lvremove /dev/root-vg/lv-root`<br>
`lvcreate -n lv-home -L 2G /dev/root-vg`<br>
`mkfs.ext4 /dev/root-vg/lv-home`<br>
`mkdir /mnt/home && mount /dev/root-vg/lv-home /mnt/home`<br>
`cp -aR /home/* /mnt/home/`<br>
`rm -rf /home/*`<br>
`umount /mnt/home`<br>
`mount /dev/root-vg/lv-home /home/`<br>
`echo "/dev/root-vg/lv-home /home ext4 defaults 0 2" >> /etc/fstab` #автомонтирование в fstab<br>
`reboot`<br><br>
<img width="974" height="311" alt="image" src="https://github.com/user-attachments/assets/afe0a5d4-c298-4f42-a142-b16aacd0f1e8" /><br><br>



3.	Выделить том под /var - сделать в mirror.<br><br>

`lvcreate -L 1G -m1 -n lv-var root-vg` #делаем raid1 lv-var<br>
`mkfs.ext4 /dev/root-vg/lv-var`<br>
`mkdir /mnt/var && mount /dev/root-vg/lv-var /mnt/var`<br>
`cp -aR /var/* /mnt/var/` # после этого делаем снэпшот на гипервизоре <br>
`rm -rf /var/*`<br>
`umount /mnt/var`<br>
`mount /dev/root-vg/lv-var /var`<br>
`echo "/dev/root-vg/lv-var /var ext4 defaults 0 2" >> /etc/fstab` #автомонтирование в fstab<br>
`reboot`<br><br>
<img width="974" height="528" alt="image" src="https://github.com/user-attachments/assets/468c2555-cdeb-4c8a-b539-9f93ea70ec35" />
<br><br>


4.	/home - сделать том для снапшотов.<br><br>

`lvcreate -L 100M -s -n home-snap /dev/root-vg/lv-home`<br><br>

5.	Прописать монтирование в fstab.<br><br>
Сделано в п.2 и 3.<br><br>
<!-- AI используют для проверки ДЗ? -->
6.	Работа со снапшотами:<br>
•	сгенерить файлы в /home/;<br>
•	снять снапшот;<br>
•	удалить часть файлов;<br>
•	восстановиться со снапшота.<br><br>

`umount /mnt/snap && lvremove /dev/root-vg/home-snap` #удалим предыдущий снэпшот<br>
`touch /home/file{1..10}`<br>
`lvcreate -L 100M -s -n home-snap /dev/root-vg/lv-home`<br>
`rm /home/file1*`<br><br>
<img width="974" height="69" alt="image" src="https://github.com/user-attachments/assets/46f78a61-223e-41b9-b401-9d381805706a" />
<br><br>

`umount -l /home` #лениво отмонтируем /home
<br>
`lvconvert --merge /dev/root-vg/home-snap`<br>
`reboot`<br>
Файлы восстановлены:
<br><br> 
<img width="974" height="51" alt="image" src="https://github.com/user-attachments/assets/7ce166bb-c6cc-4bc1-b307-07d031a4b8a6" />

