# Первые шаги с Ansible<br><br>

Описание домашнего задания:<br><br>
<br>
Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере, используя Ansible необходимо развернуть nginx со следующими условиями:<br>
•	необходимо использовать модуль yum/apt<br>
•	конфигурационный файлы должны быть взяты из шаблона jinja2 с переменными<br>
•	после установки nginx должен быть в режиме enabled в systemd<br>
•	должен быть использован notify для старта nginx после установки<br>
•	сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible<br><br>

Устанавливаем Ansible на исходную ВМ (Ubuntu 24)<br>
`sudo apt update`<br>
`sudo apt install software-properties-common`<br>
`sudo add-apt-repository --yes --update ppa:ansible/ansible`<br>
`sudo apt install ansible`<br><br>

Разворачиваем стенд Vagrant:<br>
https://drive.google.com/file/d/17MEtg20TFSjKil6ih7PvPez7jmCvo6fb/view?usp=share_link<br><br>

Создаем файл ./staging/hosts<br>
<img width="974" height="64" alt="image" src="https://github.com/user-attachments/assets/6845b0e7-78ea-4806-80b0-9af8b55c58e8" /><br><br>

Проверяем связность Ansible с ВМ стенда:<br>
<img width="974" height="286" alt="image" src="https://github.com/user-attachments/assets/a11ecd4a-c0ea-4d73-b56c-e7e64a06ffd2" /><br><br>

Добавляем файл конфигурации:<br>
<img width="659" height="292" alt="image" src="https://github.com/user-attachments/assets/42b66c68-18fd-4ff1-a703-52aaaf9ed4be" /><br><br>

И проверяем еще раз:<br>
<img width="974" height="234" alt="image" src="https://github.com/user-attachments/assets/17049bde-7d07-4224-83b2-1559efe5ef5f" /><br><br>

Здесь тратим много времени на написание плейбука и в итоге его запускаем:<br>
<img width="974" height="336" alt="image" src="https://github.com/user-attachments/assets/c8336d4a-10e0-4c3e-8c88-3ede19da51e5" /><br><br>

Контрольная проверка в браузере:<br>
<img width="974" height="387" alt="image" src="https://github.com/user-attachments/assets/7120abc3-ea52-42d9-8666-43ee8ca8e3bc" /><br><br>

Файлы:<br><br>
nginx.yml - итоговый плейбук<br>
Vagrantfile - файл стенда
