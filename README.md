# otus
Описание домашнего задания:<br><br>
•	Включить отображение меню Grub.<br>
•	Попасть в систему без пароля несколькими способами.<br>
•	Установить систему с LVM, после чего переименовать VG.<br><br>


Все действия производились на ВМ с Ubuntu 24.04.<br><br>
1.<br><br>
`nano /etc/default/grub` # отключаем скрытие меню Grub<br><br>
<img width="497" height="247" alt="image" src="https://github.com/user-attachments/assets/ef48c396-00e0-4f86-a1ff-f9cbd80c8ce4" /><br><br>
`update-grub`<br>
`reboot`<br><br>
<img width="974" height="655" alt="image" src="https://github.com/user-attachments/assets/6e7b31aa-8c1f-4eef-bf28-10e60079db0f" /><br><br>
<br>

2.<br><br>
Получаем доступ в систему первым способом.<br>
Нажимаем `e` и дописываем в параметры загрузчика `init=/bin/bash` <br><br>
<img width="974" height="614" alt="image" src="https://github.com/user-attachments/assets/01cce53a-8f3e-4fa6-bba3-0a8f867f3431" /><br><br>
После загрузки:<br>
`mount -o remount,rw /` # перемонтируем фс в режим записи.<br>
Проверяем права на систему:<br><br>
<img width="974" height="396" alt="image" src="https://github.com/user-attachments/assets/2327bc40-8954-423b-bd5b-32b2293be0b8" /><br><br>
<img width="664" height="145" alt="image" src="https://github.com/user-attachments/assets/490fc3e3-553b-4750-bc80-7ad70c3aa06c" /><br><br>
<br>
Пробуем получить доступ в систему вторым способом.<br>
При загрузке выбираем Recovery mode. Включаем сеть «Enable networking», далее «Drop to root shell prompt»<br><br>
<img width="847" height="383" alt="image" src="https://github.com/user-attachments/assets/cd158518-ca72-454f-86b8-d3c51b392e0f" /><br><br>
На этом этапе был запрошен пароль, поэтому способ не 100% рабочий.<br><br>
<img width="598" height="728" alt="image" src="https://github.com/user-attachments/assets/4a42de43-7548-42b8-8d51-5cfe33623b1a" /><br><br>

3.<br><br>
Исходное состояние:<br><br>
<img width="773" height="158" alt="image" src="https://github.com/user-attachments/assets/b59fb1ab-31af-41f9-b146-637d663a663e" /><br><br>
`vgrename ubuntu-vg otus-vg` # переименуем volume group<br>
Далее исправляем имя VG на новое в файле grub.cfg напрямую (чего делать нельзя).<br>
`nano /boot/grub/grub.cfg`<br>
CTRL+W, ищем строку ubuntu--vg и заменяем на новое имя (встретилось 3 упоминания)<br><br>
<img width="731" height="131" alt="image" src="https://github.com/user-attachments/assets/027abb04-378a-424f-97e1-20c6080a81d7" /><br><br>
Сохраняем, перезагружаемся.<br><br>
<img width="739" height="123" alt="image" src="https://github.com/user-attachments/assets/aede56d1-52bc-4946-a0b8-b6ac6707ac9a" />
