#! /bin/sh
command="./datecount"
printf "[errNo.1] => "
$command -v > nul
if test "$?" -eq 1; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.2] => "
$command -h > nul
if test "$?" -eq 2; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.3] => "
$command > nul
if test "$?" -eq 3; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.4] => "
$command -error > nul
if test "$?" -eq 4; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.5] => "
$command -a error > nul
if test "$?" -eq 5; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.6] => "
$command -c error > nul
if test "$?" -eq 6; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
printf "[errNo.7] => "
$command -b 500y > nul
if test "$?" -eq 7; then
echo "\033[32mOK\033[0m"
else echo "\033[31mNG\033[0m"
fi
