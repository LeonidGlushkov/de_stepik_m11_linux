#!/bin/bash

# Создаем или очищаем файл report.txt
> report.txt

# Заголовок
echo -e "Отчет о логе веб-сервера\n========================" >> report.txt

#подсчет кол-ва запросов
q=$(wc -l access.log | awk '{print $1}')
echo "Общее количество запросов:    $q" >> report.txt

#подсчет кол-ва уникальных IP-адресов
unic_ips=$(awk '{ ips[$1]=ips[$1] + 1 } END { print length(ips) }' access.log)
echo "Количество уникальных IP-адресов:    $unic_ips" >> report.txt

#подсчет кол-ва запросов по методам
echo -e "\nКоличество запросов по методам: " >> report.txt
awk '{ met[$6]=met[$6] + 1 } END { for (m in met) print " ", met[m],  substr(m, 2) }' access.log >> report.txt

#самый популярный URL
popular_url=$(awk '{
	 url[$7]=url[$7] + 1
      }
 END {
	max_count=0
	max_url=""
	for (u in url) {
		if (url[u] > max_count) {
			max_count=url[u]
			max_url=u
		}
	} 
	print max_count, max_url }' access.log)
echo -e "\nСамый популярный URL:    $popular_url" >> report.txt

echo "Отчет сохранен в файл report.txt"