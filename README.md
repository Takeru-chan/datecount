# Date count command for macOS.
macOSのコマンドラインで動く日付計算コマンドです。  
指定日を起点に指定した日数前または日数後の日付、または指定した日付間の日数を返します。
（指定日を省略すると今日を起点に計算します）
ただし計算可能な期間は西暦1582年から9999年の間のみ。  

## Usage | 使い方
datecount switch command|toDate [fromDate]  

switchは以下のとおり。  
- -a：fromDateで指定した日付に対し、commandで指定した期間経過後の日付を返す  
- -A：fromDateで指定した日付に対し、commandで指定した期間経過後の日付を返す（yyyyMMdd形式）  
- -b：fromDateで指定した日付に対し、commandで指定した期間以前の日付を返す  
- -B：fromDateで指定した日付に対し、commandで指定した期間以前の日付を返す（yyyyMMdd形式）  
- -c：fromDateで指定した日付に対し、toDateで指定した日付までの日数を返す  
- -C：fromDateで指定した日付に対し、toDateで指定した日付までの日数を返す（過去は負数）  
- -v：バージョン番号を返します  
- -h：ヘルプを表示します  

commandは以下単位記号と数字の組み合わせで指定します。  
- d：与える正の整数が日数である場合  
- w：与える正の整数が週数である場合  
- m：与える正の整数が月数である場合
- y：与える正の整数が年数である場合  

数字を省略すると1を指定したことになります。
また日数の指定のみdを省略することができます。  

終了コードは以下のとおり。
- 0：正常終了  
- 1：バージョン表示による正常終了
- 2：ヘルプ表示による正常終了
- 3：オプション指定なしによる異常終了  
- 4：switchの指定間違いによる異常終了  
- 5：command指定の不正による異常終了  
- 6：date指定の不正による異常終了  
- 7：計算可能期間逸脱による異常終了  

date指定は４桁の年、２桁の月、２桁の日を組み合わせた８桁の数字でおこないます。  
date指定を省略した場合は本日の日付を指定したものとみなします。  

```
$ ./datecount -a 25d
25days after Tue Mar 21 2017 is Sat Apr 15 2017

$ ./datecount -A 25d
20170415

$ ./datecount -b 80d
80days before Tue Mar 21 2017 is Sat Dec 31 2016

$ ./datecount -B 80d
20161231

$ ./datecount -a 3y2m 20170101
3years 2months after Jan 1 2017 is Sun Mar 1 2020

$ ./datecount -b w 20170101
7days before Jan 1 2017 is Sun Dec 25 2016

$ ./datecount -b 3 20170101
3days before Jan 1 2017 is Thr Dec 29 2016

$ ./datecount -c 20200724
Fri Jul 24 2020 is 1218days after Fri Mar 24 2017
```

## License
This script has released under the MIT license.  
[http://opensource.org/licenses/MIT](http://opensource.org/licenses/MIT)
