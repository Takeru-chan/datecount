#! /bin/sh
command="./datecount"
printf "[errNo.1:$command -v] => "
$command -v > /dev/null
if test "$?" -eq 1; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.2:$command -h] => "
$command -h > /dev/null
if test "$?" -eq 2; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.3:${command}] => "
$command > /dev/null
if test "$?" -eq 3; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.4:$command -error] => "
$command -error > /dev/null
if test "$?" -eq 4; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.5:$command -a error] => "
$command -a error > /dev/null
if test "$?" -eq 5; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.6:$command -c error] => "
$command -c error > /dev/null
if test "$?" -eq 6; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.7:$command -b 500y] => "
$command -b 500y > /dev/null
if test "$?" -eq 7; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[Today check:$command -a 0] => "
$command -a 0 | grep -e "^Today is " > /dev/null
if test "$?" -eq 0; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[Today check:$command -b 0] => "
$command -b 0 | grep -e "^Today is " > /dev/null
if test "$?" -eq 0; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[Today check:$command -A 0] => "
if test `$command -A 0` -eq `date +"%Y%m%d"`; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[Today check:$command -B 0] => "
if test `$command -B 0` -eq `date +"%Y%m%d"`; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[1day check:$command -a 1] => "
$command -a 1 | grep -e "^1day " > /dev/null
if test "$?" -eq 0; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[1day check:$command -b 1] => "
$command -b 1 | grep -e "^1day " > /dev/null
if test "$?" -eq 0; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[1day check:$command -A 1] => "
if test `$command -A 1` -eq `date -v+1d +"%Y%m%d"`; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[1day check:$command -B 1] => "
if test `$command -B 1` -eq `date -v-1d +"%Y%m%d"`; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[2days check:$command -a 2] => "
$command -a 2 | grep -e "^2days " > /dev/null
if test "$?" -eq 0; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[2days check:$command -b 2] => "
$command -b 2 | grep -e "^2days " > /dev/null
if test "$?" -eq 0; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[2days check:$command -A 2] => "
if test `$command -A 2` -eq `date -v+2d +"%Y%m%d"`; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[2days check:$command -B 2] => "
if test `$command -B 2` -eq `date -v-2d +"%Y%m%d"`; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
