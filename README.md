# Docker<br><br>

Описание домашнего задания:<br><br>
<br>
•	Установите Docker на хост машину<br>
•	Установите Docker Compose - как плагин, или как отдельное приложение<br>
•	Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)<br>
•	Определите разницу между контейнером и образом<br>
•	Вывод опишите в домашнем задании<br>
•	Ответьте на вопрос: Можно ли в контейнере собрать ядро?<br><br>

1.<br>
`apt update && apt install -y docker.io docker-compose-v2` # устанавливаем docker и docker-compose<br>
`mkdir nginx_alpn && cd nginx_alpn`<br><br>
Внутри каталога создаем страницу index.html, отличную от дефолтной.<br>
Там же создаем Dockerfile:<br><br>
<img width="833" height="217" alt="image" src="https://github.com/user-attachments/assets/e217d706-e03b-43a8-9ffc-bbc25983ddb8" />
<br><br>
`docker build -t custom_nginx_alpn .` # собираем образ<br>
`docker run -d -p 80:80 --name customnginx custom_nginx_alpn` # запускаем контейнер из собранного образа и проверяем в браузере<br><br>
<img width="974" height="470" alt="image" src="https://github.com/user-attachments/assets/d6df22c4-41f9-45b8-95a1-0ef9b4c5a57b" />
<br><br>
2. <br>
Образ отличается от контейнера тем, что он не изменяется в процессе работы, а служит основой для запуска контейнеров. Из одного образа можно запустить несколько контейнеров с различными параметрами.
При необходимости собрать ядро в контейнере можно, с сохранением его в основную ОС (для последующего использования).
