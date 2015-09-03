#Date count command that works on OSX.
OSXのコマンドラインで動く日付計算コマンドです。  
今日を起点に指定した日数前または日数後の日付を返します。
ただし計算可能な期間は西暦1100年から9999年の間のみ。  

##Usage | 使い方
コマンドに続けて**-a**または**-b**オプションの後に計算したい期間を指定します。  
指定日数より後の日付を知りたい時は**-a**、前の日付を知りたい時は**-b**を指定します。
計算したい期間は正の整数で与え、数字に続けて単位を付します。  

- d：与える正の整数が日数である場合  
- w：与える正の整数が週数である場合  
- m：与える正の整数が月数である場合
- y：与える正の整数が年数である場合  

それぞれの期間は組み合わせて指定することができます。
数字を省略すると**1**を指定したことになります。
また日数のみ指定する場合には**d**を省略することができます。  

```
$ date
Thu Sep  3 20:25:42 JST 2015
$ ./datecount -a 25d
25days after is Mon Sep 28 2015
$ ./datecount -b 80d
80days before is Mon Jun 15 2015
$ ./datecount -a 3y2m
3years 2months after is Sat Nov 3 2018
$ ./datecount -b w
7days before is Thr Aug 27 2015
$ ./datecount -b 3
3days before is Mon Aug 31 2015
```

##License
This script has released under the MIT license.  
[http://opensource.org/licenses/MIT](http://opensource.org/licenses/MIT)
