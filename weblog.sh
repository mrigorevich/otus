#! /bin/bash
start=$(date '+%d/%b/%Y:%H:%M:%S') #время запуска скрипта
log="/var/log/nginx/access.log" #основной входящий файл
current="last.txt" #последняя обработанная строка во входящем логе

lockfile="weblog.lock"
#проверка дубля
exec 200>"$lockfile"
if ! flock -n 200; then
	echo "Задача уже выполняется"
	exit 1
fi

# echo 0 > "$current" #для отладки обнуляем строки на запуске

#временные файлы для промежуточных отчетов
iplog="ip.log"
iphead="ip_head.log"
urllog="url.log"
urlhead="url_head.log"
errlog="error.log"
errhead="error_head.log"
responselog="response.log"
responsehead="response_head.log"

#настройки почты
email="d.......@......ru"
subject="Отчет по логу access.log ($start)"
report="mail_report.txt"

current_lines=$(wc -l < "$log") #строчек во входящем логе

#ищем строку, на которой остановились в прошлый раз
if [ -f "$current" ]; then
	last=$(cat "$current")
else #значит первый раз запускаем
	last=0 
fi
#проверяем, не отработал ли log rotate?
if [ "$current_lines" -lt "$last" ]; then
	last=0
fi
#кол-во строк, которые нужно отработать
new_lines=$((current_lines - last))

if [ "$new_lines" -gt 0 ]; then
	tail -n "$new_lines" "$log" | awk '{print $1}' | sort -n | uniq -c | sort -nr > "$iplog" #сортируем ip-адреса по количеству запросов
	head -10 "$iplog" > "$iphead" #оставляем первые 10
	tail -n "$new_lines" "$log" | awk '{print $7}' | sort | uniq -c | sort -nr > "$urllog" #сортируем url по количеству запросов
	head -10 "$urllog" > "$urlhead" #оставляем первые 10
	tail -n "$new_lines" "$log" | awk '$9 ~ /^[45]/ {print $9}' | sort | uniq -c | sort -nr > "$errlog" #сортируем ответы сервера 4хх или 5хх по количеству
	head -10 "$errlog" > "$errhead" #оставляем первые 10
	tail -n "$new_lines" "$log" | awk '{print $9}' | grep -P '[0-9]{3}' | sort | uniq -c | sort -nr > "$responselog" #сортируем все ответы сервера
	head -10 "$responselog" > "$responsehead" #оставляем первые 10

	time_start=$(echo "$new_lines" | head -n 1 | awk '{print substr($4, 2)}') #ищем первую дату
	time_end=$(echo "$new_lines" | tail -n 1 | awk '{print substr($4, 2)}') #ищем последнюю дату

#пишем отчет
	{
		echo "Отчет по логам веб-сервера"
		echo "Начало обработки: $start"
		echo "Найдено новых строк: $new_lines"
		echo "Временной диапазон обработки: с $time_start по $time_end"
		echo ""
		echo ""
		echo "Top-10 ip-адресов"
		cat "$iphead"
		echo ""
		echo "Top-10 URL"
		cat "$urlhead"
		echo ""
		echo "Top ошибок"
		cat "$errhead"
		echo ""
		echo "HTTP-коды ответов сервера"
		cat "$responsehead"
	} > "$report"

#отправляем отчет
	mail -s "$subject" "$email" < "$report"
echo "Найдено новых строк: $new_lines. Отчет отправлен на $email"

else
	#если новых строк нет, очищаем временные файлы
	echo "С момента последнего запуска новых строк не найдено"
	> "$iplog"
	> "$iphead"
	> "$urllog"
	> "$urlhead"
	> "$errlog"
	> "$errhead"
	> "$responselog"
	> "$responsehead"
fi
echo "$current_lines" > "$current" #фиксируем последнюю обработанную строку
