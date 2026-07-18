# otus
Начальная ситуация<br><br>
<img width="974" height="277" alt="image" src="https://github.com/user-attachments/assets/3b6d6078-2157-4470-94eb-c00723662d55" />
<br><br>
1.	Определить алгоритм с наилучшим сжатием:<br>
•	определить, какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4);<br>
•	создать 4 файловых системы, на каждой применить свой алгоритм сжатия;<br>
•	для сжатия использовать либо текстовый файл, либо группу файлов.<br><br>


`apt install zfsutils-linux` #устанавливаем утилиты ZFS<br>
`zpool create otusdz sdb` #создаем пул<br><br>
Создаем 4 фс с разным типом сжатия:<br>
`zfs create -o compression=lz4 otusdz/part_lz4`<br>
`zfs create -o compression=lzjb otusdz/part_lzjb`<br>
`zfs create -o compression=zle otusdz/part_zle`<br>
`zfs create -o compression=gzip otusdz/part_gzip`<br><br>
<img width="974" height="160" alt="image" src="https://github.com/user-attachments/assets/36e7b767-75ed-4f9a-b894-459bdeab5539" />
<br><br>
Скопируем данные в созданные ФС:<br>
`cp -r /var/log /otusdz/part_gzip/`<br>
`cp -r /var/log /otusdz/part_zle/`<br>
`cp -r /var/log /otusdz/part_lzjb/`<br>
`cp -r /var/log /otusdz/part_lz4/`<br>
`zfs list` #проверяем<br><br>
<img width="974" height="235" alt="image" src="https://github.com/user-attachments/assets/906b88f2-d761-4738-a2c7-debac6989d82" />
<br><br>
На наборе текстовых файлов делаем вывод, что алгоритм с наилучшим сжатием – gzip<br>
`zfs get all | grep compressratio | grep -v ref`<br><br>
<img width="814" height="177" alt="image" src="https://github.com/user-attachments/assets/0cf4f855-aaa4-435f-8491-1cf6940b4003" />
<br><br>
__________________________________________________________________________________________________________________________________ 
<br>
2.	Определить настройки пула.<br>
С помощью команды zfs import собрать pool ZFS.<br>
Командами zfs определить настройки:<br>
•	размер хранилища;<br>
•	тип pool;<br>
•	значение recordsize;<br>
•	какое сжатие используется;<br>
•	какая контрольная сумма используется.<br><br><br>


Начальная ситуация:<br><br>
<img width="974" height="396" alt="image" src="https://github.com/user-attachments/assets/526a9d50-7b0e-4735-b419-edb56438bb98" />
<br><br> 
`wget -O archive.tar.gz --no-check-certificate ‘https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'` #скачиваем предлагаемый архив<br>
`tar -xzvf archive.tar.gz` #разархивируем<br>
`zpool import -d zpoolexport`<br>
`zpool import -d zpoolexport/ otus` #импортируем пул<br><br>
Определяем:<br><br>
Размер хранилища:<br>
<img width="661" height="108" alt="image" src="https://github.com/user-attachments/assets/21dad3c1-f5fa-4488-9b9a-04b08666e1f2" />
<br><br>
Тип pool:<br>
<img width="974" height="460" alt="image" src="https://github.com/user-attachments/assets/935965b1-1bbc-4c1c-8b06-463b0ec2c3d0" />
<br><br> 
Значение recordsize:<br>
<img width="672" height="111" alt="image" src="https://github.com/user-attachments/assets/f5db7eb4-fe89-492b-bd2b-cf136f95b8bc" />
<br><br>
Какое сжатие используется:<br>
<img width="728" height="105" alt="image" src="https://github.com/user-attachments/assets/15bbf1df-c64b-494e-ac80-de756b53a24c" />
<br><br>
Какая контрольная сумма используется:<br>
<img width="639" height="111" alt="image" src="https://github.com/user-attachments/assets/ca5ad25e-b874-4fab-aaa0-a22efb6f1c7d" />
<br><br>
________________________________________________________________________________________________________________________________________________________________________________________
<br>
3.	Работа со снапшотами:<br>
•	скопировать файл из удаленной директории;<br>
•	восстановить файл локально. zfs receive;<br>
•	найти зашифрованное сообщение в файле secret_message.<br><br>


`wget -O otus_task2.file --no-check-certificate 'https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download'` #скачаем предлагаемый файл<br>
`zfs receive otus/test@today < otus_task2.file` #восстанавливаем ФС из скачанного файла<br><br>
<img width="974" height="34" alt="image" src="https://github.com/user-attachments/assets/34db6b76-7ac8-4eb7-bec5-d16ac775a16c" />
<br><br>
` find /otus/ -name "secret_message"` #ищем файл<br>
` cat /otus/test/task1/file_mess/secret_message` <br><br>
<img width="974" height="78" alt="image" src="https://github.com/user-attachments/assets/5c871c2b-ca86-437c-8d76-893674634397" />
