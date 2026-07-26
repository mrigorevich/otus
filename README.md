# otus
Описание домашнего задания:<br>
•	создать свой RPM (можно взять свое приложение, либо собрать, к примеру, Apache с определенными опциями);<br>
•	создать свой репозиторий и разместить там ранее собранный RPM<br><br>


Все действия производились на ВМ с CentOS 9.<br><br>
1.<br><br>
`yum install -y wget rpmdevtools rpm-build createrepo yum-utils cmake gcc git nano` #устанавливаем необходимые пакеты<br>
`mkdir rpm && cd rpm`<br>
`yumdownloader --source nginx` #загружаем source rpm пакет Nginx<br>
`rpm -Uvh nginx*.src.rpm` #устанавливаем пакет с исходниками<br>
`yum-builddep nginx`<br>
`cd /root`<br>
`git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli` #качаем исходник модуля  ngx_brotli (сжатие веб-приложений)<br>
`cd ngx_brotli/deps/brotli`<br>
`mkdir out && cd out`<br>
`cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_CXX_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_INSTALL_PREFIX=./installed ..` #собираем модуль ngx_brotli<br>
`cmake --build . --config Release -j 2 --target brotlienc`<br>
`cd /root`<br>
`nano rpmbuild/SPECS/nginx.spec` #добавляем ngx_brotli в nginx.spec<br><br>
<img width="678" height="641" alt="image" src="https://github.com/user-attachments/assets/1007147f-1cd4-448a-84df-b989ca1c21c1" />
<br><br>
`cd rpmbuild/SPECS/`<br>
`rpmbuild -ba nginx.spec -D 'debug_package %{nil}'` #собираем rmp пакет<br><br>
<img width="558" height="744" alt="image" src="https://github.com/user-attachments/assets/d5a3e65b-3691-4177-a302-13eeb315afa9" /><br><br>

`cd ../`<br>
`ll RPMS/x86_64/`<br><br>
<img width="973" height="175" alt="image" src="https://github.com/user-attachments/assets/9896fa35-bc61-41a4-965d-334569ab6544" /><br><br>

`cp RPMS/noarch/* RPMS/x86_64/`<br>
`cd RPMS/x86_64/`<br>
`yum install *.rpm` #устанавливаем собранный пакет<br>
`systemctl start nginx` #запускаем (если нужна автозагрузка, пишем systemctl enable nginx) <br>
`systemctl status nginx` #и проверяем nginx<br><br>

2.<br><br>
`mkdir /usr/share/nginx/html/repo` #создаем каталог для репозитория<br>
`cd ~`<br>
`cp ~/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/` #помещаем в репозиторий пакеты<br>
`createrepo /usr/share/nginx/html/repo/` #инициализируем репозиторий<br>
`nano /etc/nginx/nginx.conf`  #правки в конфиге Nginx для доступа в каталог репозитория<br><br>
<img width="888" height="403" alt="image" src="https://github.com/user-attachments/assets/36cc4eee-dece-4af2-b8c7-7e03edb36b5c" />
<br><br>
`nginx -s reload` #перезагружаем конфиг Nginx<br>
`curl -a http://localhost/repo/` #проверяем<br><br>
<img width="972" height="275" alt="image" src="https://github.com/user-attachments/assets/0acf8103-6ad4-4432-8654-f0cdde3f9717" />
<br><br>

`cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF` #пропишем созданный локальный репозиторий в системе<br><br>


`cd /usr/share/nginx/html/repo/` #добавим пакет percona-release<br>
`wget https://repo.percona.com/yum/percona-release-latest.noarch.rpm`<br>
`createrepo /usr/share/nginx/html/repo/` #обновим репозиторий<br>
`yum makecache`<br>
`yum list | grep otus` #проверяем наличие пакета в репозитории<br><br>
<img width="966" height="45" alt="image" src="https://github.com/user-attachments/assets/3bc81184-9148-41c1-a538-095f9a7e7a26" />

 

