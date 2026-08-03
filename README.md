# otus
Описание домашнего задания:<br><br>
1.	Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/default)..<br>
2.	Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта (https://gist.github.com/cea2k/1318020).	Попасть в систему без пароля несколькими способами.<br>
3.	Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно.<br><br>


Все действия производились на ВМ с Ubuntu 24.04.<br><br>
1.<br><br>
Мониторим файл auth.log на предмет ошибочного ввода пароля.<br><br>
`nano /etc/default/authlog` # создаем файл конфигурации <br><br>
<img width="398" height="80" alt="image" src="https://github.com/user-attachments/assets/20c602c8-fc73-4beb-a391-6142b451ab24" /><br>
`CTRL+o CTRL+x`<br><br>
`nano /opt/watchauthlog.sh` # создаем скрипт<br><br>
<img width="819" height="416" alt="image" src="https://github.com/user-attachments/assets/63147075-86ee-472d-9651-0322785fa0ad" /><br>
`CTRL+o CTRL+x`<br><br>
`chmod +x /opt/watchauthlog.sh` # делаем скрипт исполняемым<br><br>
`nano /etc/systemd/system/watchauthlog.service` # создаем сервис<br>
<img width="803" height="256" alt="image" src="https://github.com/user-attachments/assets/339c4403-0fb0-4621-8fbd-28da00443243" /><br>
`CTRL+o CTRL+x`<br><br>
`nano /etc/systemd/system/watchauthlog.timer` # создаем таймер<br>
<img width="898" height="377" alt="image" src="https://github.com/user-attachments/assets/fb4e3d99-5fb7-48a5-b8a4-d8e1d84070b0" /><br>
`CTRL+o CTRL+x`<br><br>
`systemctl daemon-reload` # обновляем список сервисов. В параллельной сессии пробуем авторизоваться с неверным паролем.<br><br>
`systemctl start watchauthlog.timer` # запускаем таймер<br>
`journalctl -u watchauthlog.service -f` # проверяем<br><br>
<img width="974" height="292" alt="image" src="https://github.com/user-attachments/assets/af99e95f-4aa0-40fb-b1ce-b4bdb317bda3" /><br><br>
Сервис работает.<br><br><br>

2.<br><br>

`apt install spawn-fcgi php php-cgi php-cli apache2 libapache2-mod-fcgid` # устанавливаем необходимые пакеты<br>
`mkdir /etc/spawn-fcgi`<br>
`nano /etc/spawn-fcgi/fcgi.conf` # создаем файл с настройками<br>
<img width="974" height="196" alt="image" src="https://github.com/user-attachments/assets/f52577a5-85e8-4ace-8bd6-e6d7114a1a8e" /><br>
`CTRL+o CTRL+x`<br><br>

`nano /etc/systemd/system/spawn-fcgi.service` # создаем unit файл сервиса<br>
<img width="838" height="459" alt="image" src="https://github.com/user-attachments/assets/2295bf3f-632d-4bea-83ca-7a9a75710e18" /><br>
`CTRL+o CTRL+x`<br><br>
`systemctl start spawn-fcgi` # просто запускаем без автозагрузки<br>
`systemctl status spawn-fcgi`<br><br>
<img width="974" height="867" alt="image" src="https://github.com/user-attachments/assets/aed75d85-39ea-4ab6-a623-851ecdce2cab" /><br><br><br>

3.<br><br>

`apt remove apache2 spawn-fcgi libapache2-mod-fcgid` # удалим установленное на предыдущих шагах<br>
`apt autoremove` # и ненужные зависимости<br><br>
`apt install nginx` # установим Nginx<br>
`nano /etc/systemd/system/nginx@.service` # создаем новый юнит для запуска нескольких инстансов Nginx<br>
<img width="974" height="458" alt="image" src="https://github.com/user-attachments/assets/febb56b8-c978-4b27-a07e-eaca3cd9960c" /><br>
`CTRL+o CTRL+x`<br><br>
`cp /etc/nginx/nginx.conf /etc/nginx/nginx-first.conf`<br>
`nano /etc/nginx/nginx-first.conf` # создаем конфиг для первого инстанса<br><br>
Здесь добавим в блок http:<br><br>
<img width="380" height="113" alt="image" src="https://github.com/user-attachments/assets/71d55e59-8d7c-4ba2-9d24-9c1a8d509ce2" /><br><br>
Так же закомментируем строки:<br>
`pid /run/nginx-first.pid;` # pid мы передаем в юните сервиса<br>
`include /etc/nginx/sites-enabled/*;` # чтобы исключить дефолтный 80-й порт<br><br>

По аналогии делаем второй конфиг, но для порта 9002.<br><br>

Проверяем:<br>
`systemctl start nginx@first`<br>
`systemctl start nginx@second`<br>
`ss -tulnp`<br><br>
<img width="974" height="223" alt="image" src="https://github.com/user-attachments/assets/f06d77ab-2c40-4ab2-bbc9-9c684b51f914" />

