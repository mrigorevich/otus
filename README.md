# Практика с SELinux<br><br>

Описание домашнего задания:<br><br>
1.	Запустить nginx на нестандартном порту 3-мя разными способами:<br>
•	переключатели setsebool;<br>
•	добавление нестандартного порта в имеющийся тип;<br>
•	формирование и установка модуля SELinux.<br><br>

2.	Обеспечить работоспособность приложения при включенном selinux.<br>
•	развернуть приложенный стенд https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems;<br>
•	выяснить причину неработоспособности механизма обновления зоны (см. README);<br>
•	предложить решение (или решения) для данной проблемы;<br>
•	выбрать одно из решений для реализации, предварительно обосновав выбор;<br>
•	реализовать выбранное решение и продемонстрировать его работоспособность.<br><br>



1.<br>
Vagrant файл скачан по ссылке: https://github.com/Nickmob/vagrant_selinux<br>
Для корректного запуска в Vagrant-файл была добавлена строка:<br>
«box.vm.box_architecture = "amd64"»<br><br>

После запуска имеем установленный неработоспособный Nginx:<br>
<img width="974" height="280" alt="image" src="https://github.com/user-attachments/assets/82cab098-8d5f-4b34-9f4e-040d5dd69d21" />
<br><br>

Предварительные проверки:<br>
`systemctl status firewalld` #firewall. в нашем случае выключен<br>
`nginx -t` #конфиг nginx. в нашем случае ок<br>
`getenforce` #SELinux. в нашем случае Enforcing<br>
`cat /etc/nginx/nginx.conf` #проверяем порт в конфиге nginx <br><br>
<img width="664" height="228" alt="image" src="https://github.com/user-attachments/assets/f34bf41d-9cfc-4190-9a1e-b7387adcc0f5" />
<br><br>

Запускаем первым способом через setsebool.<br><br>
`grep nginx /var/log/audit/audit.log | audit2why` # смотрим в логе подсказки от audit2why<br><br>
<img width="974" height="283" alt="image" src="https://github.com/user-attachments/assets/d8263c80-6d0b-407d-b626-45b73ad5d7de" />
<br><br>

`setsebool -P nis_enabled 1` # следуем рекомендации audit2why<br>
`systemctl restart nginx` # перезапускаем nginx и проверяем<br><br>
<img width="819" height="297" alt="image" src="https://github.com/user-attachments/assets/3016c579-f2cf-4eec-a6f2-a15360b8d2e7" /><br><br>
<img width="974" height="135" alt="image" src="https://github.com/user-attachments/assets/2f37b7b5-c7f4-4750-a58a-25a3e53cad37" /><br><br>

`setsebool -P nis_enabled off` # возвращаем исходное состояние<br><br>

Запускаем вторым способом.<br><br>

`semanage port -l | grep http` # проверяем список стандартных портов<br><br>
<img width="974" height="160" alt="image" src="https://github.com/user-attachments/assets/967369af-f644-460b-a33b-ca342ad47cf4" />
<br><br>

`semanage port -a -t http_port_t -p tcp 4881` # добавляем наш нестандартный порт<br>
`systemctl restart nginx`<br><br>

<img width="974" height="299" alt="image" src="https://github.com/user-attachments/assets/aaae3244-8e87-49db-bf7c-c982978bef0b" />
<br><br>

` semanage port -d -t http_port_t -p tcp 4881` # возвращаем в исходное состояние<br><br>

Запускаем третьим способом.<br><br>

`systemctl restart nginx` # перезапускаем nginx и получаем ошибку<br>
`grep nginx /var/log/audit/audit.log | audit2allow -M nginx` # с помощью audit2allow формируем модуль для SELinux<br><br>
<img width="974" height="309" alt="image" src="https://github.com/user-attachments/assets/f9b6449d-1b3d-4ba4-b655-8d83ca471dd7" />
<br><br>

`semodule -i nginx.pp` # импортируем модуль<br>
`systemctl restart nginx` # запускаем, проверяем<br><br>
<img width="974" height="331" alt="image" src="https://github.com/user-attachments/assets/07f2c3a4-0786-449d-a66a-7b9b18616f4a" />
<br><br>

`semodule -r nginx` # возвращаем в исходное состояние<br><br><br><br>

Задание 2.<br><br>

Ссылка на стенд: https://github.com/Nickmob/vagrant_selinux_dns_problems/tree/main<br><br>

Для корректного запуска в Vagrant-файл была добавлена строка:<br>
«config.vm.box_architecture = "amd64"»<br><br>

Т.к. на хосте (Windows) нет установленного ansible, запускаем его внутри ВМ. Меняем строки в Vagrant-файле:<br>
config.vm.provision "ansible_local" do |ansible|<br>
ns01.vm.synced_folder ".", "/vagrant", disabled: false<br>
client.vm.synced_folder ".", "/vagrant", disabled: false<br><br>
<img width="974" height="93" alt="image" src="https://github.com/user-attachments/assets/383d488a-c1de-4887-a624-65b401aeb6cf" />
<br><br>
<img width="974" height="58" alt="image" src="https://github.com/user-attachments/assets/9a22f856-19e6-4ec5-b787-dde6400e1b41" />
<br><br>
 
`vagrant status`<br><br>
<img width="974" height="203" alt="image" src="https://github.com/user-attachments/assets/f1f6937b-f577-41ef-9f67-2b8a12ef0814" />
<br><br>

`nsupdate -k /etc/named.zonetransfer.key`<br>
`> server 192.168.50.10`<br>
`> zone ddns.lab`<br>
`> update add www.ddns.lab. 60 A 192.168.50.15`<br>
`> send` # пробуем внести изменения в зону dns на ВМ client
<br><br>
<img width="974" height="413" alt="image" src="https://github.com/user-attachments/assets/7a4a8f7d-030f-437d-bc2f-f01afbe08236" />
<br><br>

`cat /var/log/audit/audit.log | audit2why` # на ВМ ns-01 анализируем лог<br><br>
<img width="975" height="229" alt="image" src="https://github.com/user-attachments/assets/aa4666d5-30d2-4957-9d7e-26bbf1598973" />
<br><br>
Как вариант - здесь можно было бы создать модуль с помощью audit2allow. Но мы проверим контексты безопасности.<br><br>

` ls -alZ /var/named/named.localhost` # смотрим контекст безопасности для файла зоны<br><br>
<img width="974" height="63" alt="image" src="https://github.com/user-attachments/assets/129e003b-0a32-4796-a76e-60a924efa903" />
<br><br>
` ls -laZ /etc/named` # и файлов конфигурации<br><br>
<img width="974" height="179" alt="image" src="https://github.com/user-attachments/assets/3fa04633-e4da-4390-9172-fa5ac5bde46c" />
<br><br>

`chcon -R -t named_zone_t /etc/named` # поменяем тип контекста на файлах конфигурации<br><br>
<img width="974" height="240" alt="image" src="https://github.com/user-attachments/assets/4caf478d-fd94-46bb-8386-6e9b94cce5cf" />
<br><br>
` nsupdate -k /etc/named.zonetransfer.key`<br>
`> server 192.168.50.10`<br>
`> zone ddns.lab`<br>
`> update add www.ddns.lab. 60 A 192.168.50.15`<br>
`> send` # снова пробуем обновить зону с клиента
<br><br>
<img width="974" height="762" alt="image" src="https://github.com/user-attachments/assets/b9402d6b-724f-4a96-8b1f-89abb19d689e" />
<br><br>

На этот раз всё получилось, видим ошибку уже другого рода – на ns01 не установлен веб-сервер. Но DNS работает, доступен – озвученная проблема решена.
