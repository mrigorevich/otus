# PAM<br><br>

Описание домашнего задания:<br><br>
<br>
1.	Ограничить доступ к системе для всех пользователей, кроме группы администраторов, в выходные дни (суббота и воскресенье), за исключением праздничных дней.<br>
2.	Предоставить определённому пользователю доступ к Docker и право перезапускать Docker-сервис.<br><br>

Задание 1.<br><br>
`sudo -i`<br>
`useradd -m -s /bin/bash odmin && useradd -m -s /bin/bash user` # создаем пользователей<br>
`echo "odmin:222" | chpasswd && echo "user:222" | chpasswd` # проставим им пароли<br>
`groupadd -f admin` # создаем группу<br>
`usermod odmin -aG admin && usermod root -aG admin && usermod vagrant -aG admin` # добавим всех админов в группу<br>
Проверяем логины и группы двух пользователей:<br><br>
<img width="547" height="119" alt="image" src="https://github.com/user-attachments/assets/0537c3e4-dcf0-4116-8041-60d3bdcb88ed" /><br><br>
<img width="506" height="100" alt="image" src="https://github.com/user-attachments/assets/7cfade7a-44f5-43f6-b15c-105f5bca88a5" /><br><br>
Всё ок, выходим из сеансов.<br>
Ограничим вход по выходным дням всем.<br>
`nano /etc/security/time.conf`<br><br>
<img width="397" height="102" alt="image" src="https://github.com/user-attachments/assets/04d42869-7135-4542-84e6-90a0b3fe3c82" /><br>
звёздочки – разрешено всем сервисам, всем типам терминалов, всем пользователям; кроме выходных дней.<br><br>
`nano /etc/pam.d/common-account` # в начало файла добавляем модуль pam_time, а перед ним проверку принадлежности к группе admin с условием sufficient<br><br>
<img width="974" height="123" alt="image" src="https://github.com/user-attachments/assets/9ab17274-d221-4d82-9b8e-48bde37c2c53" /><br><br>
Тестирование.<br><br>
`timedatectl set-ntp false` # отключаем синхронизацию NTP<br>
`timedatectl set-time "2026-09-26 13:01:00"` # включаем субботу<br><br>
<img width="914" height="128" alt="image" src="https://github.com/user-attachments/assets/d29f3130-265f-478c-9598-0f9a3b1399a7" /><br><br>
Пробуем залогиниться<br>
Пользователем:<br><br>
<img width="974" height="171" alt="image" src="https://github.com/user-attachments/assets/1b604939-10c2-4c48-ab71-53c119fc3dc3" /><br><br>
Админом:<br><br>
<img width="641" height="213" alt="image" src="https://github.com/user-attachments/assets/ac185fee-09ee-42dd-a8c5-ae0f69f47ac1" /><br><br>
<img width="592" height="238" alt="image" src="https://github.com/user-attachments/assets/c8c5733e-0bb6-449d-9779-69487b9d975f" /><br><br><br>
Задание 2.<br><br>
`timedatectl set-ntp true` # вернем дату к текущей после первого задания<br>
`usermod -aG docker user` # добавим обычного пользователя в группу docker<br>
`echo "user ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart docker" > /etc/sudoers.d/docker-restart` # сделаем файл в каталоге sudoers.d для перезапуска docker<br>
Проверяем, залогинившись обычным пользователем:<br><br>
<img width="974" height="182" alt="image" src="https://github.com/user-attachments/assets/6db269cd-a6b6-44e0-bda2-946059f30de0" />

Ссылка на Vagrantfile: https://github.com/mrigorevich/otus/blob/main/Vagrantfile
