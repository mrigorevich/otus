# otus
Обновление ядра системы

1. 
<img width="553" height="398" alt="image" src="https://github.com/user-attachments/assets/43fd856d-f954-4fc8-885e-8e22bca611d8" />

2. Обновляем ядро на последнюю версию из mainlne репозитория:  
   `mkdir kernel && cd kerne`  
   `wget https://kernel.ubuntu.com/mainline/v7.1.2/amd64/linux-headers-7.1.2-070102-generic_7.1.2-070102.202606271039_amd64.deb`  
   `wget https://kernel.ubuntu.com/mainline/v7.1.2/amd64/linux-headers-7.1.2-070102_7.1.2-070102.202606271039_all.deb`  
   `wget https://kernel.ubuntu.com/mainline/v7.1.2/amd64/linux-image-unsigned-7.1.2-070102-generic_7.1.2-070102.202606271039_amd64.deb`  
   `wget https://kernel.ubuntu.com/mainline/v7.1.2/amd64/linux-modules-7.1.2-070102-generic_7.1.2-070102.202606271039_amd64.deb`  
   `sudo dpkg -i *.deb`  
   <img width="599" height="343" alt="image" src="https://github.com/user-attachments/assets/1c4db424-503e-4b62-8930-4ff5bc1421a1" />

   Устанавливаем в загрузку по умолчанию:  
   `sudo update-grub`  
   `sudo grub-set-default 0`  
   `sudo reboot`  
   <img width="465" height="306" alt="image" src="https://github.com/user-attachments/assets/f0c68fcd-058d-406f-b470-9faa9ef4a511" />
   
==================================================================================================================================  

  Собрать ядро самостоятельно из исходных кодов.  
1.	Начальное состояние и предварительные процедуры.  
 <img width="368" height="63" alt="image" src="https://github.com/user-attachments/assets/2e898855-6cc9-4301-9ac9-1091bdc01960" />  


`mkdir kernel && cd kernel`  
`wget https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.1.2.tar.xz`  
`tar -xf linux-7.1.2.tar.xz` # качаем и распаковываем исходники  
`sudo apt install build-essential libncurses-dev bison flex libssl-dev libelf-dev dwarves bc` # устанавливаем зависимости  
`cd linux-7.1.2`  
  
2.	Конфигурация и сборка.  
`sudo make localmodconfig` # на этом этапе все опции оставил по умолчанию  
`sudo nano .config` # удаляем дефолтные ключи из конфига:  
   <img width="476" height="242" alt="image" src="https://github.com/user-attachments/assets/b32a3228-1405-40ea-9e6e-dce44780ad20" />  

`sudo make -j2` # собираем ядро в два потока (по числу ядер на ВМ)  
 здесь для ускорения можно было отключить лишние группы драйверов через make menuconfig  
   
<img width="529" height="145" alt="image" src="https://github.com/user-attachments/assets/b07ceff3-dc1f-4f3d-96e3-dc0cdfac8f23" />
  
3.	Установка.  
`sudo make modules_install` # установка модулей  
`sudo make install` # установка ядра  
`sudo update-grub`  
`sudo reboot`  

     <img width="421" height="165" alt="image" src="https://github.com/user-attachments/assets/0153eb5e-fed8-4ff7-b220-94d8adc5c8d0" />  

 
