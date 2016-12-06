`V0.9` `20161206`
# TextDatabase | 批处理文本数据库工具箱

> 作者在撰写纯批处理的工具时总是会为数据的记录而苦恼，在撰写`VNC_BookLink(VNC远程连接通讯录管理工具)`时，看着满满要增删改查的一堆数据时决定将手头工作先放一放，写出了本工具

>代码的更新会相对迟缓，一般是以作者的撰写需求为推动力的

## 功能概述

- `Database_Sort` 数据排序
- `Database_Find` 数据查找
- `Database_Print` 数据控制台/文件打印输出
- `Database_Read` 数据读取
- `Database_Update` 数据更新
- `Database_DeleteLine` 数据删除
- `Database_Insert` 数据插入

### 扩展功能
- `Properties_Read` Properties数据读取
	- 需要 `Database_Find` `Database_Read`

- `Properties_Write` Properties数据写入
	- 需要 `Database_Find` `Database_Update` `Database_DeleteLine`

## 使用方法

将子程序模块直接复制到自己代码中后直接根据使用方法调用即可(不会被正常运行到的位置)

每个子程序都可以独立运行(扩展功能除外)，只需要提取自己需要的子程序到代码中即可

所有子程序没有使用第三方工具，所有使用命令行原生命令撰写， 无兼容性问题，WinXP/Win7/Win10测试均无问题

## 注意事项
- 子程序运行需要变量延迟，请注意代码中添加`SETLOCAL ENABLEDELAYEDEXPANSION`
- 代码实现思路原因，子程序使用了以下for %变量 (按十进制ASCII编码字符集排序),请在编写程序时for嵌套中调用批处理时避开这些变量名(可以使用小写`a-z`)

- 推荐在数据库使用中使用`制表符` `	`作为数据分隔符,防止后期数据的存储与分隔符的混淆导致的不可控问题

- 子程序列数只支持到`31`列(内部实现原因,for命令限制)

		%%; %%: %%^> %%? %%@ %%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z %%[ %%\ %%] %%_

- 所有子程序未作过多特殊字符的处理及测试，故像`<` `>` `|` "等这些字符的兼容性就很难保证存储与读取

## 基础功能模块使用帮助

### Database_Insert | 数据插入

插入数据到指定文本数据库文件中

- 使用方法

		CALL:Database_Insert [/Q(安静模式，不提示错误)] "数据源" [/LN [插入到行位置(默认底部追加)]] "数据列分隔符" "数据1" "数据2" "数据3" "..."

- ERRORCODE
	- `0` 运行正常
	- `1` 查无此行
	- `2` 参数错误

- 使用示例
	> 将数据"data1" "data2" "data3" 以 "	"为分隔符插入到文本数据库文件" "c:\users\a\Database.ini"

		CALL:Database_Insert "c:\users\a\Database.ini" "	" "data1" "data2" "data3"

### Database_DeleteLine | 数据删除

删除指定文件指定行

- 使用方法
	
		CALL:Database_DeleteLine [/Q(安静模式，不提示错误)] "数据源" "欲删除数据起始行" "从起始行开始继续向下删除多少行(包括本行，向下到结尾请输入0)"

- ERRORCODE
	- `0` 运行正常
	- `1` 查无此行
	- `2` 参数错误

- 使用示例
	> 把文件 "c:\users\a\Database.ini" 中第二第三行删除

		CALL:Database_DeleteLine "c:\users\a\Database.ini" "2" "2"

### Database_Update | 数据更新

修改指定文件的指定行以指定分隔符分割的指定列的内容

- 使用方法

		CALL:Database_Update [/Q(安静模式，不提示错误)] "数据源" "数据列分隔符" "欲修改数据所在开始行号" "以分隔符为分割的N列数据(列号与列号之间使用,分割，且可以区间分割符-)" "该行第一列修改后数据" "该行第二列修改后数据" ...

- ERRORCODE
	- `0` 运行正常
	- `1` 查无此行
	- `2` 参数错误

- 使用示例
	> 从文件 "c:\users\a\Database.ini" 中第4行以 "	" 为分隔1,2,3,6列数据修改为分别修改为 string1 string2 string3 string4

		CALL:Database_Update "c:\users\a\Database.ini" "	" "4" "1-3,6" "string1" "string2" "string3" "string4"

### Database_Read | 数据读取
从指定文件、指定行、指定分隔符、指定列获取内容赋值到指定变量

- 使用方法

		CALL:Database_Read [/Q(安静模式，不提示错误)] "数据源文件" "数据列分隔符" "数据所在行" "以分隔符为分割的N列数据(列目号与列目号之间使用,分割，且可以区间分割符-)" "单个或多个变量(多个变量之间使用空格或,进行分割)"

- ERRORCODE
	- `0` 运行正常
	- `1` 查无此行
	- `2` 参数错误

- 使用示例

	> 从文件 "c:\users\a\Database.ini" 中将以 "	" 为分隔符的第4行数据的第1,2,3,6列数据分别赋值到var1,var2,var3,var4

		CALL:Database_Read "c:\users\a\Database.ini" "	" "4" "1-3,6" "var1 var2 var3 var4"

### Database_Print | 数据控制台/文件打印输出

从指定文件、指定行、指定分隔符、指定列获取内容并打印到屏幕或文件

- 使用方法

		CALL:Database_Print [/Q(安静模式，不提示错误)] [/LN(显示数据在整体打印内容中的序号,非数据在数据源文件中的行号)] [/HEAD 打印行头添加内容] [/FOOT 打印行尾追加内容] "数据源" "数据提取分隔符" "数据打印分隔符" "打印数据行(支持单数分隔符,与区间连续分隔符-,0为指定全部行)" "以分隔符为分割的N列数据(列号与列号之间使用,分割，且可以区间分割符-)" [/F 文件(将内容输出到文件)] 

- ERRORCODE
	- `0` 运行正常
	- `1` 查无此行
	- `2` 参数错误

- 使用示例
	> 将文件 "c:\users\a\Database.ini" 中的第4-5行以 "	" 为分隔符的第1,2,3,6列数据以"*"为分隔符打印出来

			CALL:Database_Print "c:\users\a\Database.ini" "	" "*" "4-5" 1-3,6"

### Database_Find | 数据查找

从指定文件、指定行、指定分隔符、指定列、指定字符串搜索并将搜索结果的行列号写入到指定变量中

- 使用方法
	
		CALL:Database_Find [/Q(安静模式，不提示错误)] [/i(不区分大小写)] [/first(返回查找到的第一个结果)] "数据源" "数据列分隔符"  "查找字符串" "查找数据行(支持单数分隔符,与区间连续分隔符-,0为指定全部行)" "查找数据列(支持单数分隔符,与区间连续分隔符-)" "查找结果行号列号结果接受赋值变量名"

	- 结果变量的输出格式

			"行 列","行 列","..." 依次递加，例如第二行第三列和第五行第六列的赋值内容就为："2 3","5 6"

	- 结果变量推荐使用方法

			for %%a in (%结果变量%) do for /f "tokens=1,2" %%b in ("%%~a") do echo=第%%b行，第%%c列

- ERRORCODE
	- `0` 查找到结果并复制给指定变量
	- `1` 查询无果
	- `2` 参数错误

- 使用示例
	> 从文件 "c:\users\a\Database.ini"中第三到五行以"	"为分隔符的第一列中不区分大小写的查找字符串data(完全匹配)并将搜索结果的行列号赋值到变量result

		CALL:Database_Find /i "c:\users\a\Database.ini" "	" "data" "3-5" "1" "result"

### Database_Sort | 数据排序
排序行数据使其转移到指定行

- 使用方法

		CALL:Database_Sort [/Q(安静模式，不提示错误)] "数据源" "欲排序行号" "排序后行号"

- ERRORCODE
	- `0` 运行正常
	- `1` 查无此行
	- `2` 参数错误
	- `3` 指定排序行与排序后行号相同

- 使用示例
	> 把文件 "c:\users\a\Database.ini" 中第四行排序到原第二行的位置

		CALL:Database_Sort "c:\users\a\Database.ini" "4" "2"

## 扩展功能模块使用帮助

### Properties_Read | Properties数据读取

Properties模式读取数据(key与value之间使用制表符分割模式)

- 使用方法

		CALL:Properties_Read "文件路径" "keyName" "接收数据变量名"

- ERRORCODE
	- `0` 读取成功
	- `1` 查无此key(无数据)
	- `2` 参数错误

- 使用示例
	> 从文件 "config.ini" 中读取key为phoneNumber的数据到变量mobilePhoneNumber中

		CALL:Properties_Read "config.ini" phoneNumber mobilePhoneNumber

### Properties_Write | Properties数据写入

Properties模式读取数据(key与value之间使用制表符分割模式)

- 使用方法

		CALL:Properties_Write "文件路径" "keyName" ["keyValue"(当不给keyValue的值时则为删除该行数据)]

- ERRORCODE
	- `0` 运行成功
	- `2` 参数错误

- 使用示例
	> 写入key为phoneNumber, value为110的数据到config.ini

		CALL:Properties_Write "config.ini" phoneNumber 110
	
	> 删除config.ini中key为phoneNumber的数据

		CALL:Properties_Write "config.ini" phoneNumber

## 相关链接
- [DoDownloadNetFile-Bat](https://github.com/imfms/DoDownloadNetFile-Bat)
	