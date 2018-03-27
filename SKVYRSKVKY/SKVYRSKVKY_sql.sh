usql -h -n -t\; -e "
/*!pass-through*/

SELECT
'Номер вантажу',
'Номер реф.',
'Запланована дата',
'Дата POD',
'Відділ дост.',
 'Статус',
'Отримувач',
'Місто',
'Країна'
FROM DUAL


UNION ALL


SELECT
to_char(nrPrzes),
nrRef,
to_char(dataRoz),
to_char(dataPOD),
getECL(nrPrzes),
 case
 when stat = 'wcz' then 'Завчасно'
 when stat = 'ter' then 'Вчасно'
 when stat = 'poz' then 'Із запызненням'
 when stat = 'nie' then 'Не доставлена'
 else 'Brak'
 end,
odbNazwa,
odbMiasto,
odbKraj
from
(
select
nrPrzes,
nrRef,
ocl,
dataRoz,
 (case
 when dataRoz > dataPod then 'wcz'
 when dataRoz = dataPod then 'ter'
 when dataRoz < dataPod then 'poz'
 else 'nie'
 end) as stat,
dataBu,
dataPOD,
odbNazwa,
odbMiasto,
odbKraj,
kliZoek,
kliNaz,
plaanl,
afd
from
(
select
substr(\"tsdsmd\".\"afd\",1,2) ocl,
\"tsdsmd\".\"dosvlg\" nrPrzes,
\"tsdsmd\".\"refopd\" nrRef,
\"tsdsmd\".\"tsunld\" dataRoz,
getPODdate(\"tsdsmd\".\"dosvlg\",'j') as dataPod,
getBUdate(\"tsdsmd\".\"dosvlg\") as dataBu,
\"odbior\".\"tsnam1\" as odbNazwa,
\"odbior\".\"tscity\" as odbMiasto,
\"odbior\".\"land\" as odbKraj,
\"tsdnaw\".\"zoek\" as kliZoek,
\"tsdnaw\".\"tsnam1\" as kliNaz,
\"tsdsmd\".\"plaanl\" as plaanl,
\"tsdsmd\".\"afd\" as afd
from
life.\"cef_tsdsmd\" \"tsdsmd\"
left outer join life.\"cef_vw_naw\" \"tsdnaw\" on
\"tsdsmd\".\"dosvlg\" = \"tsdnaw\".\"dosvlg\"
and \"tsdnaw\".\"tsroln\" = 0
left outer join life.\"cef_vw_naw\" \"nadawc\" on
\"tsdsmd\".\"dosvlg\" = \"nadawc\".\"dosvlg\"
and \"nadawc\".\"tsroln\" = 2
left outer join life.\"cef_vw_naw\" \"odbior\" on
\"tsdsmd\".\"dosvlg\" = \"odbior\".\"dosvlg\"
and \"odbior\".\"tsroln\" = 4
left outer join life.\"cef_vw_naw\" \"msc_zal\" on
\"tsdsmd\".\"dosvlg\" = \"msc_zal\".\"dosvlg\"
and \"msc_zal\".\"tsroln\" = 1
left outer join life.\"cef_vw_naw\" \"msc_roz\" on
\"tsdsmd\".\"dosvlg\" = \"msc_roz\".\"dosvlg\"
and \"msc_roz\".\"tsroln\" = 3
where
\"tsdsmd\".\"srtdos\" = 'd'
and \"tsdsmd\".\"tsunld\" >= to_date(SYSDATE-1,'YYYY-MM-DD')
and \"tsdsmd\".\"tsunld\" <= to_date(SYSDATE-1,'YYYY-MM-DD')
and substr(\"tsdsmd\".\"afd\", 1, 2) like '%'
and getCzyAnulowana(\"tsdsmd\".\"dosvlg\") = 'n'
and (
substr(\"tsdsmd\".\"afd\", 3, 2) = ''
or
'a' = 'a'
or
('' = 'kr'
and
(
substr(\"tsdsmd\".\"afd\", 3, 2) = 'nf' or
substr(\"tsdsmd\".\"afd\", 3, 2) = 'wd' or
substr(\"tsdsmd\".\"afd\", 3, 2) = 'fl'
)
)
)
and (
('a' = 'a')
or
('' = 'FOOD' and \"tsdsmd\".\"comkod\" like 'f%')
or
('' = 'NONF' and \"tsdsmd\".\"comkod\" not like 'f%')
or
('' = 'ADR' and \"tsdsmd\".\"comkod\" like 'ad%')
or
(\"tsdsmd\".\"comkod\" = '')
)
and (\"tsdnaw\".\"zoek\" like 'SKVYRSKVKY' or
'SKVYRSKVKYa' = 'a')
and (\"nadawc\".\"zoek\" like '%' or
'a' = 'a')
and (
(
'' = 'F' and \"tsdsmd\".\"tarsrt\" = 'FL'
and substr(\"tsdsmd\".\"afd\",3,2) = 'if'
)
or
('' = 'T' and \"msc_zal\".\"land\" <> 'PL'
and \"msc_roz\".\"land\" <> 'PL'
and substr(\"tsdsmd\".\"afd\",3,2) = 'if')
or
('' = 'I'
and \"msc_zal\".\"land\" <> 'PL'
and \"msc_roz\".\"land\" = 'PL'
and substr(\"tsdsmd\".\"afd\",3,2) = 'if')
or
('' = 'E'
and \"msc_zal\".\"land\" = 'PL'
and \"msc_roz\".\"land\" <> 'PL'
and substr(\"tsdsmd\".\"afd\",3,2) = 'if')
or
('a' = 'a')
or
(substr(\"tsdsmd\".\"afd\",3,2) <> 'if')
)
and (
(\"msc_zal\".\"land\" = '' or \"msc_zal\".\"land\" IS NULL)
or
('a' = 'a')
)
and (
(\"msc_roz\".\"land\" = '' or \"msc_roz\".\"land\" IS NULL)
or
('a' = 'a')
)
and (\"tsdnaw\".\"zoek\" = '' or 'a' = 'a')
and (\"nadawc\".\"zoek\" = '' or 'a' = 'a')
)
)
where
 (
 (
 ('' <> 'dost' or '' IS NULL)
 and stat like '%'
 ) 
 or
 (
 '' = 'dost'
 and stat in ('wcz', 'ter', 'poz')
 )
 )
 and 
(ocl = '01' or '01a' = 'a')
and (
(
'zw' = 'ubr'
and dataBu IS NOT NULL
)
or
'zw' = 'zw'
)
and (dataRoz = '' or 'a' = 'a')
AND (
('0'='0') or
(plaanl <> 'MGL') or
(plaanl is null)
)
AND (
('0'='0') or
(plaanl <> 'RETURN') or
(plaanl is null)
)
AND (
('0'='0') or
(
((plaanl = 'MGL')
and(plaanl is not null))
or ((plaanl = 'RETURN')
and(plaanl is not null)) or
(kliZoek like 'WOK%') or
(kliZoek like 'WVK%')
or ((plaanl = 'CHI')
and(plaanl is not null))
or ((plaanl = 'MFV')
and(plaanl is not null))
)
)
AND (('0'<>'0') or (afd not like '__if'))
AND (
('0'='0') or
(kliZoek not like 'WOK%')
)
AND (
('0'='0') or
(kliZoek not like 'WVK%')
)
AND (
('0'='0') or
(plaanl <> 'CHI') or
(plaanl is null)
)
AND (
('0'='0') or
(plaanl <> 'MFV') or
(plaanl is null)
)
AND GETLASTMGLSTATUS(nrPrzes)<>'D90'
AND GETLASTMGLSTATUS(nrPrzes)<>'XXX'
;
"