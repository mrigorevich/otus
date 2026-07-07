# otus
Работа с mdadm

Задание:

• Добавьте в виртуальную машину несколько дисков  
• Соберите RAID-0/1/5/10 на выбор  
• Сломайте и почините RAID  
• Создайте GPT таблицу, пять разделов и смонтируйте их в системе.  
<br>
1. Добавляем в гипервизоре 3 диска по 5гб.
<img width="974" height="358" alt="image" src="https://github.com/user-attachments/assets/4d95e685-8915-430c-a847-a7f77cc4fa6b" />
  
<br>
<br>
2. Соберем RAID1 из дисков sdb и sdc

`sudo mdadm --create /dev/md127 -l 1 -n 2 /dev/sd{b,c}`  
`sudo mdadm -D /dev/md127`  
  
<img width="974" height="792" alt="image" src="https://github.com/user-attachments/assets/e6be4f37-9aef-4988-9700-7d185e360cbc" />  
<br>  
<br>  
3. Сломаем RAID, удалив диск sdb в гипервизоре. Имеем следующую картину:  
<br>
<img width="974" height="1093" alt="image" src="https://github.com/user-attachments/assets/0ee623d3-c47c-4adc-8245-970271afd331" /><br>  
  
Добавим имеющийся свободный диск в RAID  
`sudo mdadm /dev/md127 --add /dev/sdd`  
После окончания resync RAID починился:  
<br>
<img width="974" height="799" alt="image" src="https://github.com/user-attachments/assets/f675a8e0-8e46-48c8-8e55-0cf7837afe37" />  

  
4. Создаем разметку на новом диске:  
`sudo fdisk /dev/md127`  
`g` #создаем новую таблицу разделов GPT  
Создаем 5 разделов по алгоритму:  
`n`  
`default`  
`default`  
`+1G`  
`w` #записываем созданные разделы на диск  
`lsblk`  
<img width="905" height="483" alt="image" src="https://github.com/user-attachments/assets/de7d21dc-b07b-4c83-8849-e75ffbd4c0e8" />  


Создаем файловую систему:  
`for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md127p$i; done`  
Монтируем:  
`sudo mkdir -p /mnt/raid_part{1,2,3,4,5}`  
`for i in $(seq 1 5); do sudo mount /dev/md127p$i /mnt/raid_part$i; done`  
`df -h`  

<img width="974" height="340" alt="image" src="https://github.com/user-attachments/assets/6f345e61-95f7-4b71-b181-b73b7f3b8807" />
  
