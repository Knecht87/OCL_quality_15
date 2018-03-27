#!/bin/bash
cd /ua13app/lifeua/ecom/scripts/OCL_quality_15/SKVYRSKVKY/

path_src=/ua13app/lifeua/ecom/scripts/OCL_quality_15/SKVYRSKVKY
path_out=/ua13app/lifeua/ecom/scripts/OCL_quality_15/SKVYRSKVKY/OUT

. /ua13app/lifeua/.unims

echo "start"

file_name=SKVYRSKVKY_q15_`date +'%d%m%Y%H%M'`

usu edekua SKVYRSKVKY_sql.sh >> ${path_out}/${file_name}.txt

echo "file generated"

iconv -f utf8 -t cp1251 ${path_out}/${file_name}.txt > ${path_out}/${file_name}.csv
echo "file converted"

rm ${path_out}/${file_name}.txt

${path_src}/SKVYRSKVKY_mail.sh "${path_out}/${file_name}.csv" > /dev/null

echo "mail sent"

#rm ${path_out}/${file_name}.csv

echo "done"
