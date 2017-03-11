#Date count command for macOS.
macOSのコマンドラインで動く日付計算コマンドです。  
指定日を起点に指定した日数前または日数後の日付を返します。
（指定日を省略すると今日を起点に計算します）
ただし計算可能な期間は西暦1582年から9999年の間のみ。  

##Usage | 使い方
datecountに続けて**-a**または**-b**オプションの後に計算したい期間を指定します。  
指定日数より後の日付を知りたい時は**-a**、前の日付を知りたい時は**-b**を指定します。
計算したい期間は正の整数で与え、数字に続けて単位を付します。  

- d：与える正の整数が日数である場合  
- w：与える正の整数が週数である場合  
- m：与える正の整数が月数である場合
- y：与える正の整数が年数である場合  

それぞれの期間は組み合わせて指定することができます。
数字を省略すると**1**を指定したことになります。
また日数の指定のみ**d**を省略することができます。  

終了コードは以下のとおり。
- 0：正常終了  
- 1：バージョン表示による正常終了
- 2：ヘルプ表示による正常終了
- 3：オプション指定なしによる異常終了  
- 4：オプションスイッチの指定間違いによる異常終了  
- 5：計算可能期間逸脱による異常終了  
- 6：日付指定フォーマット不正による異常終了  

日付指定は４桁の年、２桁の月、２桁の日を組み合わせた８桁の数字でおこないます。  

```
$ ./datecount -a 25d
25days after today is Wed Apr 5 2017

$ ./datecount -b 80d
80days before today is Wed Dec 21 2016

$ ./datecount -a 3y2m 20170101
3years 2months after Jan 1 2017 is Sun Mar 1 2020

$ ./datecount -b w 20170101
7days before Jan 1 2017 is Sun Dec 25 2016

$ ./datecount -b 3 20170101
3days before Jan 1 2017 is Thr Dec 29 2016
```

##License
This script has released under the MIT license.  
[http://opensource.org/licenses/MIT](http://opensource.org/licenses/MIT)
