# otus
Обновление ядра системы

1. 
<img width="1105" height="795" alt="image" src="https://github.com/user-attachments/assets/43fd856d-f954-4fc8-885e-8e22bca611d8" />

2. Обновляем ядро на последнюю версию из mainlne репозитория:
   mkdir kernel && cd kernel
   wget https://kernel.ubuntu.com/mainline/v7.1.2/amd64/linux-headers-7.1.2-070102-generic_7.1.2-070102.202606271039_amd64.deb
   wget https://kernel.ubuntu.com/mainline/v7.1.2/amd64/linux-headers-7.1.2-070102_7.1.2-070102.202606271039_all.deb
   wget https://kernel.ubuntu.com/mainline/v7.1.2/amd64/linux-image-unsigned-7.1.2-070102-generic_7.1.2-070102.202606271039_amd64.deb
   wget https://kernel.ubuntu.com/mainline/v7.1.2/amd64/linux-modules-7.1.2-070102-generic_7.1.2-070102.202606271039_amd64.deb
   sudo dpkg -i *.deb
   <img width="899" height="514" alt="image" src="https://github.com/user-attachments/assets/1c4db424-503e-4b62-8930-4ff5bc1421a1" />

   Устанавливаем в загрузку по умолчанию:
   sudo update-grub
   sudo grub-set-default 0
   sudo reboot
   <img width="697" height="459" alt="image" src="https://github.com/user-attachments/assets/f0c68fcd-058d-406f-b470-9faa9ef4a511" />
   
