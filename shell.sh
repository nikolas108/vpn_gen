https://coollib.com/b/275969
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done



echo "Do you wish to install this program?"
select yn in "Yes" "No"
case $yn in
    Yes ) make install;;
    No ) exit;;
esac


function run() {
    number=$1
    shift
    for n in $(seq $number); do
      $@
    done
}

[ $# -eq 0 ] && { echo "Usage: $0 argument"; exit 1; }
$# 	переменная, содержащая количество аргументов, преданных скрипту
$0 	возвращает путь к shell скрипту

Синтаксис

 grep -q [ШАБЛОН] [ФАЙЛ] && echo $?

$cat file
x=1
y=2
z=3

$cat readvars.sh
#!/bin/sh
vars=`cat file`
for i in $vars; do eval $i; done
echo $x $y $z

$./readvars.sh
1 2 3 

Re: [bash] построчное чтение файла

while read -r LINE 1<&3; do
  echo HEH, got line "$LINE"
done 3< some_file

> >у read другая беда -- он искажает строки

> ???

например, начальные пробелы в строке он пропустит

А какая задача-то? coreutils сами по файлам умеют ходить, не надо делать за них
их работу :)   Ну а так стандартный foreach:

for line in "`cat $FILE`"; do echo "$line"; done

% while read i;                  # тут будет прочитан файл 'list'
    echo "Please fill file $i"
    do cat <&3 >>$i;           # тут будет прочитан stdin до Ctrl-D
done 3<&0 <list

> Так, написал неправильно.

Исправляюсь:

IFS=$'\012'; for line in `cat $FILE`; do echo $line; done

Но некрасиво, да.  Зато не убивает пробелы :)

Еще если с read:

cat $FILE | while read line; do echo $line; done

---------
% while read i;                  # тут будет прочитан файл 'list'
    echo "Please fill file $i"
    do cat <&3 >>$i;           # тут будет прочитан stdin до Ctrl-D
done 3<&0 <list

Разумеется, это не работает, потому что кто-то не смотрит, что печатает. В данном случае команда echo выполняется не в теле цикла, а в условии while. Которое от этого становится истинным! 

Fixed:

% while read i; do                 # тут будет прочитан файл 'list'
    echo "Please fill file $i"
    cat <&3 >>$i;           # тут будет прочитан stdin до Ctrl-D
done 3<&0 <list
---------------

#!/bin/sh

echo -n "введите ip адреса для конфигов клиента . Любое количество - через пробел. Эти ip адреса будут добавлени при создании конфигов клиента, параметр remote. : "
index=0

while true;do 
read ip
if [ "$ip" != "stop" ];then
	arr[$index]=$ip
	index=`expr $index + 1`
	echo "${arr[@]} $arr["$index"] "
else
	for i in ${arr[@]}
		do
			echo "ip $i"
		done
	break
fi
done

echo "HAPPY END"
