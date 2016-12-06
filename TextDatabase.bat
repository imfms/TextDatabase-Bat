@echo off
setlocal ENABLEDELAYEDEXPANSION
cd/d "%~dp0"

title TextDatabase ^| ��ʾ

REM ����
echo=#���ɲ����ļ�
(
	echo=a	b	c	d	e	f	g	h	i
	echo=1	2	3	4	5	6	7	8	9
	echo=app	ban	int	liu	feng	li	july	ab	Ab
)>test.txt
cls
type test.txt
echo=
echo=#����Database_Read
echo=
echo=����2�еĵ�3�к͵�5�����ݷֱ�д�뵽����a�ͱ���b
CALL:Database_Read "test.txt" "	" "2" "3,5" "a b"
echo=����a:%a%
echo=����b:%b%

echo=&pause&echo=

echo=����3�еĵ�5�к͵�6�����ݷֱ�д�����c�ͱ���d
CALL:Database_Read "test.txt" "	" "3" "5,6" "c d"
echo=����c:%c%
echo=����d:%d%

echo=&pause&echo=

cls
type test.txt
echo=
echo=#����Database_Update
echo=����3�е�2�С���5�е����ݷֱ����Ϊ��change1��change2
CALL:Database_Update "test.txt" "	" "3" "2,5" "change1" "change2"
type test.txt

echo=&pause&echo=
echo=����2�е�3��4�����ݷֱ����Ϊ:change3,change4
CALL:Database_Update "test.txt" "	" "2" "3,4" "change3" "change4"
type test.txt

echo=&pause&echo=

cls
type test.txt
echo=
echo=#����Database_Print
echo=����һ�е������еĵ�2�С���5����*Ϊ�ָ�����ʾ����
CALL:Database_Print "test.txt" "	" "*" "1-3" "2,5"

echo=&pause&echo=

echo=����һ�е������еĵ�3�С���7����*Ϊ�ָ�����ʾ����(�����)
CALL:Database_Print /ln "test.txt" "	" "*" "1-3" "3,7"

echo=&pause&echo=

echo=����һ�е������еĵ�2�С���5����*Ϊ�ָ���������ļ�test.tmp��
CALL:Database_Print /ln "test.txt" "	" "*" "1-3" "2,5" /f test.tmp
type test.tmp
if exist "test.tmp" del /f /q "test.tmp"

echo=&pause&echo=

cls
type test.txt
echo=
echo=#����Database_Find
echo=����������1-3�У�1-9����Ϊ"ab"���ַ���λ��,���ִ�Сд
CALL:Database_Find "test.txt" "	" "ab" "1-3" "1-9" "result"
echo=%result%

echo=&pause&echo=

echo=����������1-3�У�1-9����Ϊ"ab"���ַ���λ��,�����ִ�Сд
CALL:Database_Find /i "test.txt" "	" "ab" "1-3" "1-9" "result"
echo=%result%

echo=&pause&echo=

cls
type test.txt
echo=#����DatabaseInsert
echo=�������� A-I ��	Ϊ�ָ�����β��
CALL:Database_Insert "test.txt" "	" "A" "B" "C" "D" "E" "F" "G" "H" "I"
type test.txt

echo=&pause&echo=

echo=�������� A-I ��	Ϊ�ָ������ڶ���
CALL:Database_Insert "test.txt" /ln 2 "	" "A" "B" "C" "D" "E" "F" "G" "H" "I"
type test.txt

echo=&pause&echo=

cls
type test.txt
echo=
echo=#����Database_Sort
echo=����һ��Ų��������
CALL:Database_Sort "test.txt" 1 3
type test.txt

echo=&pause&echo=

echo=��������Ų����һ��
CALL:Database_Sort "test.txt" 3 1
type test.txt

echo=&pause&echo=

cls
type test.txt
echo=#����Database_DeleteLine
echo=ɾ��������
CALL:Database_DeleteLine "test.txt" 3 1 
type test.txt

echo=&pause&echo=

echo=ɾ��1,2,3��
CALL:Database_DeleteLine "test.txt" 1 3
type test.txt

echo=&pause&echo=

cls
echo=�������
if exist "test.txt" del /f /q "test.txt"
pause



goto end
:-----------------------------------------------------------�ӳ���ʼ�ָ���-----------------------------------------------------------:


REM _____________________________________________________________������Properties�ı���ȡ������__________________________________________________________________
REM 
REM                                                          ������������ı����ݿ⹤����(Database_Tools)��Щ������
REM                                                                     ĳЩע��������Ҫ��ѭDatabase_Tools
REM                                                                        -20161204-
REM                                                     ���ߣ�F_Ms | ���䣺imf_ms@yeah.net | ���ͣ�f-ms.cn
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Properties_Read	Propertiesģʽ��ȡ����(key��value֮��ʹ���Ʊ���ָ�ģʽ)
REM 	CALL:Properties_Read "�ļ�·��" "keyName" "�������ݱ�����"
REM 		����: ���ļ� "config.ini" �ж�ȡkeyΪphoneNumber�����ݵ�����mobilePhoneNumber��
REM 			CALL:Properties_Read "config.ini" phoneNumber mobilePhoneNumber
REM 		��ע: ���ӳ�����Ҫ�ӳ��� Database_Find, Database_Read
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Properties_Write	Propertiesģʽ��ȡ����(key��value֮��ʹ���Ʊ���ָ�ģʽ)
REM 	CALL:Properties_Write "�ļ�·��" "keyName" ["keyValue"(������keyValue��ֵʱ��Ϊɾ����������)]
REM 		����: д��keyΪphoneNumber, valueΪ110�����ݵ�config.ini
REM 			CALL:Properties_Write "config.ini" phoneNumber 110
REM 		����: ɾ��config.ini��keyΪphoneNumber������
REM 			CALL:Properties_Write "config.ini" phoneNumber
REM ��ע: ���ӳ�����Ҫ�ӳ��� Database_Find, Database_Update, Database_DeleteLine
REM ____________________________________________________________________________________________________________________________________________________________________

REM :------------------------------------------------------------Properties_Read------------------------------------------------------------------------------------:
REM Propertiesģʽ��ȡ����(key��value֮��ʹ���Ʊ���ָ�ģʽ)
REM CALL:Properties_Read "�ļ�·��" "keyName" "�������ݱ�����"
REM ���ӣ����ļ� "config.ini" �ж�ȡkeyΪphoneNumber�����ݵ�����mobilePhoneNumber��
REM 		CALL:Properties_Read "config.ini" phoneNumber mobilePhoneNumber
REM ����ֵ����: 0-��ȡ�ɹ�, 1-���޴�key(������), 2-��������
REM ��ע: ���ӳ�����Ҫ�ӳ��� Database_Find, Database_Read
:Properties_Read

REM ����key�Ƿ����ļ��д���
set p_r_find_result=
CALL:Database_Find /Q /i /first "%~1" "	" "%~2" 0 1 p_r_find_result
if "%errorlevel%"=="1" exit/b 1
if "%errorlevel%"=="2" exit/b 2

REM ���ҵ��Ļ����ȡ��ȡ�����к�
set p_r_find_line=
for %%a in (%p_r_find_result%) do for /f "tokens=1,2" %%b in ("%%~a") do (
	set p_r_find_line=%%b
)

REM ��ȡ����key�������ݲ�����
CALL:Database_Read /Q "%~1" "	" "%p_r_find_line%" 2 "%~3"
exit/b %errorlevel%

REM :------------------------------------------------------------Properties_Write-----------------------------------------------------------------------------------:
REM Propertiesģʽд������(key��value֮��ʹ���Ʊ���ָ�ģʽ)
REM 	CALL:Properties_Write "�ļ�·��" "keyName" ["keyValue"(������keyValue��ֵʱ��Ϊɾ����������)]
REM ����: д��keyΪphoneNumber, valueΪ110�����ݵ�config.ini
REM 		CALL:Properties_Write "config.ini" phoneNumber 110
REM ����: ɾ��config.ini��keyΪphoneNumber������
REM 		CALL:Properties_Write "config.ini" phoneNumber
REM ����ֵ����: 0-�ɹ�, 2-��������
REM ��ע: ���ӳ�����Ҫ�ӳ��� Database_Find, Database_Update, Database_DeleteLine
:Properties_Write

REM ����key�Ƿ����ļ����Ѵ���
set p_w_find_result=
CALL:Database_Find /Q /i /first "%~1" "	" "%~2" 0 1 p_r_find_result
if "%errorlevel%"=="0" (
	REM �Ѵ������
	
	REM ��ȡ�����к�
	set p_w_find_line=
	for %%a in (%p_r_find_result%) do for /f "tokens=1,2" %%b in ("%%~a") do (
		set p_w_find_line=%%b
	)
	
	if "%~3"=="" (
		REM ���valueΪ����ɾ����������
		CALL:DataBase_DeleteLine /Q "%~1" "!p_w_find_line!" "1"
		exit/b !errorlevel!
	) else (
		REM ��Ϊ������¸�������
		CALL:Database_Update /Q "%~1" "	" "!p_w_find_line!" "2" "%~3"
		exit/b !errorlevel!
	)
) else (
	REM ���������
	CALL:Database_Insert /Q "%~1" "	" "%~2" "%~3"
	exit/b !errorlevel!
)
exit/b 2

REM __________________________________________________________________�������ı����ݿ⹤����_______________________________________________________________________
REM 
REM                                                          ���������������ı����ݿ�Ĳ���Ч�ʼ��׻�
REM                                                                        -20160625-
REM                                                     ���ߣ�F_Ms | ���䣺imf_ms@yeah.net | ���ͣ�f-ms.cn
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM ʹ�÷�����
REM 	���ӳ���ģ��ֱ�Ӹ��Ƶ��Լ������к�ֱ�Ӹ���ʹ�÷������ü���(���ᱻ�������е���λ��)
REM 	ÿ���ӳ��򶼿��Զ�������(��չ���ܳ���)��ֻ��Ҫ��ȡ�Լ���Ҫ���ӳ��򵽴����м���
REM 	�����ӳ���û��ʹ�õ��������ߣ�����ʹ��������ԭ������׫д�� �޼��������⣬WinXP/Win7/Win10���Ծ�������
REM 
REM ע�����
REM 	�ӳ���������Ҫ�����ӳ�, ��ע���������� SETLOCAL ENABLEDELAYEDEXPANSION
REM 	�ӳ���ʹ��������for %���� (��ʮ����ASCII�����ַ�������),���ڱ�д����ʱforǶ���е���������ʱ�ܿ���Щ������(����ʹ��Сдa-z)
REM 		%%; %%: %%^> %%? %%@ %%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z %%[ %%\ %%] %%_
REM 	�����ӳ���δ�����������ַ��Ĵ������ԣ�����"< > |"����Щ�ַ��ļ����Ծͺ��ѱ�֤��
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Read	��ָ���ļ���ָ���С�ָ���ָ�����ָ���л�ȡ���ݸ�ֵ��ָ������
REM 		CALL:Database_Read [/Q(����ģʽ������ʾ����)] "����Դ�ļ�" "�����зָ���" "����������" "�Էָ���Ϊ�ָ��N������(��Ŀ������Ŀ��֮��ʹ��,�ָ�ҿ�������ָ��-)" "������������(�������֮��ʹ�ÿո��,���зָ�)"
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �н��� "	" Ϊ�ָ����ĵ�4�����ݵĵ�1,2,3,6�����ݷֱ�ֵ��var1,var2,var3,var4
REM					CALL:Database_Read "c:\users\a\Database.ini" "	" "4" "1-3,6" "var1 var2 var3 var4"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Update	�޸�ָ���ļ���ָ������ָ���ָ����ָ��ָ���е�����
REM 		CALL:Database_Update [/Q(����ģʽ������ʾ����)] "����Դ" "�����зָ���" "���޸��������ڿ�ʼ�к�" "�Էָ���Ϊ�ָ��N������(�к����к�֮��ʹ��,�ָ�ҿ�������ָ��-)" "���е�һ���޸ĺ�����" "���еڶ����޸ĺ�����" ...
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �е�4���� "	" Ϊ�ָ�1,2,3,6�������޸�Ϊ�ֱ��޸�Ϊ string1 string2 string3 string4
REM					CALL:Database_Update "c:\users\a\Database.ini" "	" "4" "1-3,6" "string1" "string2" "string3" "string4"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Print	��ָ���ļ���ָ���С�ָ���ָ�����ָ���л�ȡ���ݲ���ӡ����Ļ���ļ�
REM CALL:Database_Print [/Q(����ģʽ������ʾ����)] [/LN(��ʾ�����������ӡ�����е����,������������Դ�ļ��е��к�)] [/HEAD ��ӡ��ͷ�������] [/FOOT ��ӡ��β׷������] "����Դ" "������ȡ�ָ���" "���ݴ�ӡ�ָ���" "��ӡ������(֧�ֵ����ָ���,�����������ָ���-,0Ϊָ��ȫ����)" "�Էָ���Ϊ�ָ��N������(�к����к�֮��ʹ��,�ָ�ҿ�������ָ��-)" [/F �ļ�(������������ļ�)] 
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �еĵ�4-5���� "	" Ϊ�ָ����ĵ�1,2,3,6��������"*"Ϊ�ָ�����ӡ����
REM 				CALL:Database_Print "c:\users\a\Database.ini" "	" "*" "4-5" 1-3,6"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Find	��ָ���ļ���ָ���С�ָ���ָ�����ָ���С�ָ���ַ�����������������������к�д�뵽ָ��������
REM 		CALL:Database_Find [/Q(����ģʽ������ʾ����)] [/i(�����ִ�Сд)] [/first(���ز��ҵ��ĵ�һ�����)] "����Դ" "�����зָ���"  "�����ַ���" "����������(֧�ֵ����ָ���,�����������ָ���-,0Ϊָ��ȫ����)" "����������(֧�ֵ����ָ���,�����������ָ���-)" "���ҽ���к��кŽ�����ܸ�ֵ������"
REM 			ע��---------------------------------------------------------------------------------------------------------------------------------
REM 				��������������ʽΪ��"�� ��","�� ��","..."���εݼӣ�����ڶ��е����к͵����е����еĸ�ֵ���ݾ�Ϊ��"2 3","5 6"
REM 				����ʹ�� 'for %%a in (%�������%) do for /f "tokens=1,2" %%b in ("%%~a") do echo=��%%b�У���%%c��' �ķ������н��ʹ��
REM 				---------------------------------------------------------------------------------------------------------------------------------
REM 			���ӣ����ļ� "c:\users\a\Database.ini"�е�����������"	"Ϊ�ָ����ĵ�һ���в����ִ�Сд�Ĳ����ַ���data(��ȫƥ��)����������������кŸ�ֵ������result
REM 				CALL:Database_Find /i "c:\users\a\Database.ini" "	" "data" "3-5" "1" "result"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Insert	�������ݵ�ָ���ı����ݿ��ļ���
REM 		CALL:Database_Insert [/Q(����ģʽ������ʾ����)] "����Դ" [/LN [���뵽��λ��(Ĭ�ϵײ�׷��)]] "�����зָ���" "����1" "����2" "����3" "..."
REM 			���ӣ�������"data1" "data2" "data3" �� "	"Ϊ�ָ������뵽�ı����ݿ��ļ�" "c:\users\a\Database.ini"
REM 				CALL:Database_Insert "c:\users\a\Database.ini" "	" "data1" "data2" "data3"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Sort	����������ʹ��ת�Ƶ�ָ����
REM 		CALL:Database_Sort [/Q(����ģʽ������ʾ����)] "����Դ" "�������к�" "������к�"
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �е���������ԭ�ڶ��е�λ��
REM 				CALL:Database_Sort "c:\users\a\Database.ini" "4" "2"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_DeleteLine	ɾ��ָ���ļ�ָ����
REM 		CALL:Database_DeleteLine [/Q(����ģʽ������ʾ����)] "����Դ" "��ɾ��������ʼ��" "����ʼ�п�ʼ��������ɾ��������(�������У����µ���β������0)"
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �еڶ�������ɾ��
REM 				CALL:Database_DeleteLine "c:\users\a\Database.ini" "2" "2"
REM ____________________________________________________________________________________________________________________________________________________________________

REM :--------------------------------------------------------------------Database_Print------------------------------------------------------------------------------:
REM ��ָ���ļ���ָ���С�ָ���ָ�����ָ���л�ȡ���ݲ���ӡ����Ļ���ļ�
REM CALL:Database_Print [/Q(����ģʽ������ʾ����)] [/LN(��ʾ�����������ӡ�����е����,������������Դ�ļ��е��к�)] [/HEAD ��ӡ��ͷ�������] [/FOOT ��ӡ��β׷������] "����Դ" "������ȡ�ָ���" "���ݴ�ӡ�ָ���" "��ӡ������(֧�ֵ����ָ���,�����������ָ���-,0Ϊָ��ȫ����)" "�Էָ���Ϊ�ָ��N������(�к����к�֮��ʹ��,�ָ�ҿ�������ָ��-)" [/F �ļ�(������������ļ�)] 
REM ���ӣ����ļ� "c:\users\a\Database.ini" �еĵ�4-5���� "	" Ϊ�ָ����ĵ�1,2,3,6��������"*"Ϊ�ָ�����ӡ����
REM					CALL:Database_Print "c:\users\a\Database.ini" "	" "*" "4-5" 1-3,6"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20160625
:Database_Print
REM ����ӳ������л����������
for %%A in (d_P_ErrorPrint d_P_LineNumber d_P_PrintHead d_P_PrintFoot) do set "%%A="
if /i "%~1"=="/ln" (
	set "d_P_LineNumber=Yes"
	shift/1
) else if /i "%~1"=="/q" (shift/1) else set "d_P_ErrorPrint=Yes"
if /i "%~1"=="/ln" (
	set "d_P_LineNumber=Yes"
	shift/1
) else if /i "%~1"=="/q" (shift/1) else set "d_P_ErrorPrint=Yes"

if /i "%~1"=="/head" (
	set "d_P_PrintHead=%~2"
	shift/1
	shift/1
) else if /i "%~1"=="/foot" (
	set "d_P_PrintFoot=%~2"
	shift/1
	shift/1
)
if /i "%~1"=="/head" (
	set "d_P_PrintHead=%~2"
	shift/1
	shift/1
) else if /i "%~1"=="/foot" (
	set "d_P_PrintFoot=%~2"
	shift/1
	shift/1
)

if /i "%~6"=="/f" if "%~7"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����7-ָ������ļ�Ϊ��]
)
if "%~5"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����6-ָ����Ŀ��Ϊ��]
	exit/b 2
)
if "%~4"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����4-ָ���к�Ϊ��]
	exit/b 2
)
if "%~3"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����3-ָ�����ݴ�ӡ�ָ���Ϊ��]
	exit/b 2
)
if "%~2"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����2-ָ��������ȡ�ָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_P_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)
REM ��ʼ������
for %%_ in (d_P_Count d_P_Count2 d_P_Count3 d_P_ValueTemp d_P_StringTest d_P_Count4 d_P_Pass) do set "%%_="
for /f "delims==" %%_ in ('set d_P_AlreadyLineNumber 2^>nul') do set "%%_="
if /i "%~6"=="/f" (
	set d_P_File=">>"%~7""
	if exist "%~7" del /f /q "%~7"
) else set "d_P_File= "

REM �ӳ���ʼ����

REM �ж��û������к��Ƿ���Ϲ���
set "d_P_StringTest=%~4"
for %%_ in (1,2,3,4,5,6,7,8,9,0,",",-) do if defined d_P_StringTest set "d_P_StringTest=!d_P_StringTest:%%~_=!"
if defined d_P_StringTest (
	if defined d_P_ErrorPrint echo=	[����%0:����4:ָ�������в����Ϲ���:%~4]
	exit/b 2
)
for %%_ in (%~4) do (
	set "d_P_Pass="
	set "d_P_Pass=%%~_"
	if "!d_P_Pass!"=="!d_P_Pass:-=!" (
		if "%%~_"=="0" (
			set "d_P_Count2=0"
			set "d_P_Count=No"
			set "d_P_Pass="
			) else (
			set /a "d_P_Count2=%%~_-1"
			set /a "d_P_Pass=%%~_-1"
			set "d_P_Count=0"
			if "!d_P_Pass!"=="0" (set "d_P_Pass=") else set "d_P_Pass=skip=!d_P_Pass!"
			)
		CALL:Database_Print_Run "%~1" "%~2" "%~3" "%~5"
	) else (
		for /f "tokens=1,2 delims=-" %%: in ("%%~_") do (
			if "%%~:"=="%%~;" (
				set "d_P_Count2=%%~:-1"
				set /a "d_P_Pass=%%~:-1"
				set "d_P_Count=0"
				) else CALL:Database_Print2 "%%~:" "%%~;"
			if "!d_P_Pass!"=="0" (set "d_P_Pass=") else set "d_P_Pass=skip=!d_P_Pass!"
			CALL:Database_Print_Run "%~1" "%~2" "%~3" "%~5"
		)
	)
)
exit/b 0


REM CALL:Database_Print_Run "�ļ�" "������ȡ�ָ���" "���ݴ�ӡ�ָ���" "�к�"
:Database_Print_Run
set "d_P_Count3="
(
	for /f "usebackq %d_P_Pass% eol=^ tokens=%~4 delims=%~2" %%? in ("%~1") do (
		set /a "d_P_Count3+=1"
		set /a "d_P_Count2+=1"
		
		if not defined d_P_AlreadyLineNumber!d_P_Count2! (
			set "d_P_AlreadyLineNumber!d_P_Count2!=Yes"
			set /a "d_P_Count4+=1"
			
			if defined d_P_LineNumber set "d_P_LineNumber=!d_P_Count4!.%~3"
			for /f "eol=^ delims=%%" %%^> in ("!d_P_LineNumber!%%?%~3%%@%~3%%A%~3%%B%~3%%C%~3%%D%~3%%E%~3%%F%~3%%G%~3%%H%~3%%I%~3%%J%~3%%K%~3%%L%~3%%M%~3%%N%~3%%O%~3%%P%~3%%Q%~3%%R%~3%%S%~3%%T%~3%%U%~3%%V%~3%%W%~3%%X%~3%%Y%~3%%Z%~3%%[%~3%%\%~3%%]") do set d_P_ValueTemp=%%^>
			if "!d_P_ValueTemp:~-1!"=="%~3" (echo=%d_P_PrintHead%!d_P_ValueTemp:~0,-1!%d_P_PrintFoot%) else echo=%d_P_PrintHead%!d_P_ValueTemp!%d_P_PrintFoot%
		)
		if /i not "%d_P_Count%"=="No" (
			if "%d_P_Count%"=="0" exit/b 0
			if "!d_P_Count3!"=="%d_P_Count%" exit/b 0
		)
	)
)%d_P_File:~1,1%%d_P_File:~2,-1%

exit/b 0

REM ��������Ƕ�����ԭ���µ����ⲻ�ò�д��һ���ӳ�������ж�
REM CALL:Database_Print2 ��һ��ֵ �ڶ���ֵ
:Database_Print2
if %~10 gtr %~20 (
	set /a "d_P_Count2=%~2-1"
	set /a "d_P_Pass=%~2-1"
	set /a "d_P_Count=%~1-%~2+1"
) else (
	set /a "d_P_Count2=%~1-1"
	set /a "d_P_Pass=%~1-1"
	set /a "d_P_Count=%~2-%~1+1"
)
exit/b


REM :--------------------------------------------------------------------Database_Insert------------------------------------------------------------------------------:
REM �������ݵ�ָ���ı����ݿ��ļ���
REM CALL:Database_Insert [/Q(����ģʽ������ʾ����)] "����Դ" [/LN [���뵽��λ��(Ĭ�ϵײ�׷��)]] "�����зָ���" "����1" "����2" "����3" "..."
REM ���ӣ�������"data1" "data2" "data3" �� "	"Ϊ�ָ������뵽�ı����ݿ��ļ�" "c:\users\a\Database.ini"
REM					CALL:Database_Insert "c:\users\a\Database.ini" "	" "data1" "data2" "data3"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20160507
:Database_Insert
REM ����ӳ������л����������
for %%A in (d_I_ErrorPrint d_I_LineNumber d_I_Value) do set "%%A="
if /i "%~1"=="/q" (
	shift/1
) else set "d_I_ErrorPrint=Yes"

if "%~2"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����3-ָ���ָ���Ϊ��]
	exit/b 2
)
if /i "%~2"=="/LN" if "%~3"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����3-ָ�������к�Ϊ��]
	exit/b 2
) else (
	set "d_I_LineNumber=%~3"
	shift/2
	shift/2
)
if defined d_I_LineNumber if %d_I_LineNumber%0 lss 10 (
	if defined d_I_ErrorPrint echo=	[����%0:����3-ָ�������к�С��1]
	exit/b 2
)
if "%~3"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����3-ָ��д������Ϊ��]
	exit/b 2
)
if "%~2"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����2-ָ���ָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_I_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_I_Count d_I_Pass1 d_I_Temp_File) do set "%%_="
for /l %%_ in (1,1,31) do set "d_I_Value%%_="
if defined d_I_LineNumber (
	set "d_I_Temp_File=%~1_Temp"
	if exist "%d_I_Temp_File%" del /f /q "%d_I_Temp_File%"
)

REM �ӳ���ʼ����
REM ��ȡ�û�ָ��ֵ
:Database_Insert1
set /a "d_I_Count+=1"
set "d_I_Value%d_I_Count%=%~3"
if not "%~4"=="" (
	shift/3
	goto Database_Insert1
)
for /l %%_ in (1,1,%d_I_Count%) do (
	set "d_I_Value=!d_I_Value!%~2!d_I_Value%%_!"
)
set "d_I_Value=%d_I_Value:~1%"
REM δָ�������к����
if not defined d_I_LineNumber CALL:Database_Insert_Echo d_I_Value>>"%~1"&exit/b 0
REM ָ�������к����
REM ���������Ƿ����
set /a "d_I_Pass1=%d_I_LineNumber%-1"
if "%d_I_Pass1%"=="0" (set "d_I_Pass1=") else set "d_I_Pass1=skip=%d_I_Pass1%"
for /f "usebackq %d_I_Pass1% eol=^ delims=" %%? in ("%~1") do goto Database_Insert2
if defined d_I_ErrorPrint echo=	[����%0:���:���޴���:%d_I_LineNumber%]
exit/b 1
:Database_Insert2
set "d_I_Count="
REM ָ����ǰ������д����ʱ�ļ�
set /a "d_I_Count2=%d_I_LineNumber%-1"
if "%d_I_Count2%"=="0" goto Database_Insert3
for /f "usebackq eol=^ delims=" %%? in ("%~1") do (
	set /a "d_I_Count+=1"
	echo=%%?
	if "!d_I_Count!"=="%d_I_Count2%" goto Database_Insert3
)>>"%d_I_Temp_File%"
:Database_Insert3
REM д��������ݵ���ʱ�ļ�
CALL:Database_Insert_Echo d_I_Value>>"%d_I_Temp_File%"
REM д������к����ݵ���ʱ�ļ�
(
	for /f "usebackq %d_I_Pass1% eol=^ delims=" %%? in ("%~1") do echo=%%?
)>>"%d_I_Temp_File%"
REM ����ʱ�ı����ݿ��ļ�����Դ�ı����ݿ��ļ�
copy "%d_I_Temp_File%" "%~1">nul 2>nul
if not "%errorlevel%"=="0" (
	if defined d_I_ErrorPrint echo=	[����%0:���:���ݸ���ʧ�ܣ�����Ȩ�޲�����ļ�������]
	exit/b 1
)
if exist "%d_I_Temp_File%" del /f /q "%d_I_Temp_File%"
exit/b 0

REM ���ڽ����������ݲ��ܽ�βΪ�ո�+0/1/2/3�Ͳ��ܺ���()����
REM CALL:Database_Insert_Echo ������
:Database_Insert_Echo
echo=!%~1!
exit/b 0


REM :--------------------------------------------------------------------Database_Read-------------------------------------------------------------------------------:
REM ��ָ���ļ���ָ���С�ָ���ָ�����ָ���л�ȡ���ݸ�ֵ��ָ������
REM CALL:Database_Read [/Q(����ģʽ������ʾ����)] "����Դ�ļ�" "�����зָ���" "����������" "�Էָ���Ϊ�ָ��N������(��Ŀ������Ŀ��֮��ʹ��,�ָ�ҿ�������ָ��-)" "������������(�������֮��ʹ�ÿո��,���зָ�)"
REM ���ӣ����ļ� "c:\users\a\Database.ini" �н��� "	" Ϊ�ָ����ĵ�4�����ݵĵ�1,2,3,6�����ݷֱ�ֵ��var1,var2,var3,var4
REM					CALL:Database_Read "c:\users\a\Database.ini" "	" "4" "1-3,6" "var1 var2 var3 var4"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20151127
:Database_Read
REM ����ӳ������л����������
set "d_R_ErrorPrint="
if /i "%~1"=="/q" (shift/1) else set "d_R_ErrorPrint=Yes"
if "%~5"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����5-ָ������ֵ������Ϊ��]
	exit/b 2
)
if "%~4"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����4-ָ����Ŀ��Ϊ��]
	exit/b 2
)
if "%~3"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����3-ָ���к�Ϊ��]
	exit/b 2
)
if %~3 lss 1 (
	if defined d_R_ErrorPrint echo=	[����%0:����3-ָ���к�С��1:%~3]
	exit/b 2
)
if "%~2"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����2-ָ���ָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_R_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_R_Count d_R_Pass) do set "%%_="
for /l %%_ in (1,1,31) do if defined d_R_Count%%_ set "d_R_Count%%_="
set /a "d_R_Pass=%~3-1"
if "%d_R_Pass%"=="0" (set "d_R_Pass=") else set "d_R_Pass=skip=%d_R_Pass%"

REM �ӳ���ʼ����
for %%_ in (%~5) do (
	set /a "d_R_Count+=1"
	set "d_R_Count!d_R_Count!=%%_"
)
set "d_R_Count="
for /f "usebackq eol=^ %d_R_Pass% tokens=%~4 delims=%~2" %%? in ("%~1") do (
	for %%_ in ("!d_R_Count1!=%%~?","!d_R_Count2!=%%~@","!d_R_Count3!=%%~A","!d_R_Count4!=%%~B","!d_R_Count5!=%%~C","!d_R_Count6!=%%~D","!d_R_Count7!=%%~E","!d_R_Count8!=%%~F","!d_R_Count9!=%%~G","!d_R_Count10!=%%~H","!d_R_Count11!=%%~I","!d_R_Count12!=%%~J","!d_R_Count13!=%%~K","!d_R_Count14!=%%~L","!d_R_Count15!=%%~M","!d_R_Count16!=%%~N","!d_R_Count17!=%%~O","!d_R_Count18!=%%~P","!d_R_Count19!=%%~Q","!d_R_Count20!=%%~R","!d_R_Count21!=%%~S","!d_R_Count22!=%%~T","!d_R_Count23!=%%~U","!d_R_Count24!=%%~V","!d_R_Count25!=%%~W","!d_R_Count26!=%%~X","!d_R_Count27!=%%~Y","!d_R_Count28!=%%~Z","!d_R_Count29!=%%~[","!d_R_Count30!=%%~\","!d_R_Count31!=%%~]") do (
		set /a "d_R_Count+=1"
		if defined d_R_Count!d_R_Count! set %%_
	)
	exit/b 0
)
if not defined d_R_Count if defined d_R_ErrorPrint echo=	[����%0:���-���޴���:%~3]
exit/b 1


REM :--------------------------------------------------------------------Database_Sort-------------------------------------------------------------------------------:
REM ����������ʹ��ת�Ƶ�ָ����
REM CALL:Database_Sort [/Q(����ģʽ������ʾ����)] "����Դ" "�������к�" "������к�"
REM ���ӣ����ļ� "c:\users\a\Database.ini" �е���������ԭ�ڶ��е�λ��
REM					CALL:Database_Sort "c:\users\a\Database.ini" "4" "2"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���3-��������ֵ��ͬ
REM �汾:20151204
:Database_Sort
REM ����ӳ������л����������
for %%A in (d_S_ErrorPrint) do set "%%A="
if /i "%~1"=="/q" (
	shift/1
) else set "d_S_ErrorPrint=Yes"
if "%~3"=="" (
	if defined d_S_ErrorPrint echo=	[����%0:����3-ָ�������������Ϊ��]
	exit/b 2
)
if %~3 lss 0 (
	if defined d_S_ErrorPrint echo=	[����%0:����3-ָ�������������С��0:%~2]
)
if "%~2"=="" (
	if defined d_S_ErrorPrint echo=	[����%0:����2-ָ����������Ϊ��]
	exit/b 3
)
if %~2 lss 0 (
	if defined d_S_ErrorPrint echo=	[����%0:����2-ָ����������С��0:%~2]
)
if "%~2"=="%~3" (
	if defined d_S_ErrorPrint echo=	[����%0:����2;����1:�����������������������ͬ����ʵ�����壬���������:%~2:%~3]
	exit/b 1
)
if "%~1"=="" (
	if defined d_S_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_S_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_S_Count d_S_Count2 d_S_Pass1 d_S_Pass2 d_S_Pass3 d_S_Temp_File) do set "%%_="
set "d_S_Temp_File=%~1_Temp"
if exist "%d_S_Temp_File%" del /f /q "%d_S_Temp_File%"


if %~2 lss %~3 (
	REM ǰ������
	set /a "d_S_Count1=%~2-1"
	REM ��ʼ�к󣬽�����ǰ
	set /a "d_S_Pass1=%~2
	set /a "d_S_Count2=%~3-%~2"
	REM ��ʼ������
	set /a "d_S_Pass2=%~2-1"
	set /a "d_S_LineDefinedCheck1=%~2-1"
	REM �����к�(����������)
	set /a "d_S_Pass3=%~3"
	set /a "d_S_LineDefinedCheck2=%~3-1"
) else (
	REM ǰ������
	set /a "d_S_Count1=%~3-1"
	REM ��ʼ������
	set /a "d_S_Pass1=%~2-1"
	set /a "d_S_LineDefinedCheck1=%~2-1"
	REM ������(����������)����ʼ��֮������
	set /a "d_S_Pass2=%~3-1"
	set /a "d_S_Count2=%~2-%~3"
	set /a "d_S_LineDefinedCheck2=%~3-1"
	REM ��ʼ�к�����
	set /a "d_S_Pass3=%~2"
)

for %%_ in (d_S_LineDefinedCheck1 d_S_LineDefinedCheck2 d_S_Pass1 d_S_Pass2 d_S_Pass3) do if "!%%_!"=="0" (set "%%_=") else set "%%_=skip=!%%_!"

REM �ж��Ƿ���ָ��ɾ����
for /f "usebackq eol=^ %d_S_LineDefinedCheck1% delims=" %%? in ("%~1") do goto Database_Sort_2
if defined d_S_ErrorPrint (
	echo=	[����:%0:���:���޴���:%~2]
)
exit/b 1
:Database_Sort_2
for /f "usebackq eol=^ %d_S_LineDefinedCheck2% delims=" %%? in ("%~1") do goto Database_Sort_3
if defined d_S_ErrorPrint (
	echo=	[����:%0:���:���޴���:%~3]
)
:Database_Sort_3

REM �ӳ���ʼ����
REM �ı����ݿ�ǰ������д��
if not "%d_S_Count1%"=="0" for /f "usebackq eol=^ delims=" %%_ in ("%~1") do (
	set /a "d_S_Count+=1"
	echo=%%_
	if "!d_S_Count!"=="!d_S_Count1!" goto Database_Sort1
)>>"%d_S_Temp_File%"

:Database_Sort1
set "d_S_Count="
(
	if %~2 lss %~3 (
		for /f "usebackq %d_S_Pass1% eol=^ delims=" %%_ in ("%~1") do (
			set /a "d_S_Count+=1"
			echo=%%_
			if "!d_S_Count!"=="%d_S_Count2%" goto Database_Sort2
		)
	) else (
		for /f "usebackq %d_S_Pass1% eol=^ delims=" %%_ in ("%~1") do (
			echo=%%_
			goto Database_Sort2
		)
	)
)>>"%d_S_Temp_File%"

:Database_Sort2
set "d_S_Count="
(
	if %~2 lss %~3 (
		for /f "usebackq %d_S_Pass2% eol=^ delims=" %%_ in ("%~1") do (
			echo=%%_
			goto Database_Sort3
		)
	) else (
		for /f "usebackq %d_S_Pass2% eol=^ delims=" %%_ in ("%~1") do (
			set /a "d_S_Count+=1"
			echo=%%_
			if "!d_S_Count!"=="%d_S_Count2%" goto Database_Sort3
		)
	)
)>>"%d_S_Temp_File%"
:Database_Sort3
for /f "usebackq %d_S_Pass3% eol=^ delims=" %%_ in ("%~1") do (
	echo=%%_
)>>"%d_S_Temp_File%"

REM ����ʱ�ı����ݿ��ļ�����Դ�ı����ݿ��ļ�
copy "%d_S_Temp_File%" "%~1">nul 2>nul
if not "%errorlevel%"=="0" (
	if defined d_S_ErrorPrint echo=	[����%0:���:���ݸ���ʧ�ܣ�����Ȩ�޲�����ļ�������]
	exit/b 1
)
if exist "%d_S_Temp_File%" del /f /q "%d_S_Temp_File%"
exit/b 0

REM :--------------------------------------------------------------------Database_Update-----------------------------------------------------------------------------:
REM �޸�ָ���ļ���ָ������ָ���ָ����ָ��ָ���е�����
REM CALL:Database_Update [/Q(����ģʽ������ʾ����)] "����Դ" "�����зָ���" "���޸��������ڿ�ʼ�к�" "�Էָ���Ϊ�ָ��N������(�к����к�֮��ʹ��,�ָ�ҿ�������ָ��-)" "���е�һ���޸ĺ�����" "���еڶ����޸ĺ�����" ...
REM ���ӣ����ļ� "c:\users\a\Database.ini" �е�4���� "	" Ϊ�ָ�1,2,3,6�������޸�Ϊ�ֱ��޸�Ϊ string1 string2 string3 string4
REM					CALL:Database_Update "c:\users\a\Database.ini" "	" "4" "1-3,6" "string1" "string2" "string3" "string4"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20151130
:Database_Update
REM ����ӳ������л����������
for %%A in (d_U_ErrorPrint) do set "%%A="
if /i "%~1"=="/q" (
	shift/1
) else set "d_U_ErrorPrint=Yes"
if "%~5"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����5-ָ���޸ĺ�����Ϊ��]
	exit/b 2
)
if "%~4"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����4-ָ���к�Ϊ��]
	exit/b 2
)
if "%~3"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����3-ָ���к�Ϊ��]
	exit/b 2
)
if %~3 lss 1 (
	if defined d_U_ErrorPrint echo=	[����%0:����3-ָ���к�С��1:%~3]
	exit/b 2
)
if "%~2"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����2-�����зָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_U_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)
REM ��ʼ������
for %%_ in (d_U_Count d_U_Pass1 d_U_Pass2 d_U_Pass3 d_U_Temp_File d_U_FinalValue d_U_Value) do set "%%_="
for /l %%_ in (1,1,31) do (
	set "d_U_Value%%_="
	set "d_U_FinalValue%%_="
)
set "d_U_Temp_File=%~1_Temp"
if exist "%d_U_Temp_File%" del /f /q "%d_U_Temp_File%"
set /a "d_U_Pass3=%~3"
set /a "d_U_Pass2=%~3-1"
set /a "d_U_Pass1=%~3-1"

set "d_U_Pass3=skip=%d_U_Pass3%"
if "%d_U_Pass2%"=="0" (set "d_U_Pass2=") else set "d_U_Pass2=skip=%d_U_Pass2%"

REM �ж��Ƿ���ָ���޸���
for /f "usebackq eol=^ %d_U_Pass2% delims=" %%? in ("%~1") do goto Database_Updata_2
if defined d_U_ErrorPrint (
	echo=	[����:%0:���:���޴���:%~3]
)
exit/b 1
:Database_Updata_2
if %d_U_Pass1% leq 0 goto Database_Updata2

REM �ӳ���ʼ����
REM �������׶ν����޸ģ����ı����ݿ�Դ�ļ���Ϊ���׶Σ��޸���ǰ������ȡд�룬�޸�����ȡ�޸Ĳ�д�룬�޸��к�������ȡ��д�� �����޸��ı����ݿ�

REM �޸���ǰ������ȡд��׶�
:Database_Updata1

(
	for /f "usebackq eol=^ delims=" %%? in ("%~1") do (
		set /a "d_U_Count+=1"
		echo=%%?
		if "!d_U_Count!"=="%d_U_Pass1%" goto Database_Updata2
	)
)>>"%d_U_Temp_File%"

REM �޸�����ȡ�޸Ĳ�д��׶�
:Database_Updata2
set "d_U_Count="

:Database_Updata2_2
REM ���û�ָ���޸����ݸ�ֵ�����б���
set /a "d_U_Count+=1"
set "d_U_Value%d_U_Count%=%~5"
if not "%~6"=="" (
	shift/5
	goto Database_Updata2_2
)

set "d_U_Count="

REM ���û�ָ���޸����ݸ�ֵ������������λ�����б���
for /f "tokens=%~4 delims=," %%? in ("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31") do set "d_U_Column=%%? %%@ %%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z %%[ %%\ %%]"
for /f "delims=%%" %%a in ("%d_U_Column%") do set "d_U_Column=%%a"
for %%a in (%d_U_Column%) do (
	set /a "d_U_Count+=1"
	CALL:Database_Updata_Var d_U_FinalValue%%a d_U_Value!d_U_Count!
)

set "d_U_Count="

REM ���ı����ݿ��޸��в����޸ĵ����ݸ�ֵ������������λ�����б���(�Ѿ�����ֵ�����б���������)
for /f "usebackq eol=^ tokens=1-31 %d_U_Pass2% delims=%~2" %%? in ("%~1") do (
	for %%_ in ("%%?" "%%@" "%%A" "%%B" "%%C" "%%D" "%%E" "%%F" "%%G" "%%H" "%%I" "%%J" "%%K" "%%L" "%%M" "%%N" "%%O" "%%P" "%%Q" "%%R" "%%S" "%%T" "%%U" "%%V" "%%W" "%%X" "%%Y" "%%Z" "%%[" "%%\" "%%]") do (
		if "%%~_"=="" goto Database_Updata2_3
		set /a "d_U_Count+=1"
		if not defined d_U_FinalValue!d_U_Count! set "d_U_FinalValue!d_U_Count!=%%~_"
	)
	goto Database_Updata2_3
)
:Database_Updata2_3
if "%d_U_FinalValue1%"=="" (
	if not defined d_U_ErrorPrint echo=	[����%0:���:���޴���]
	exit/b 1
)
REM ���޸ĺ��޸�����ʽд����ʱ�ı����ݿ��ļ�
for /l %%_ in (1,1,%d_U_Count%) do (
	set "d_U_FinalValue=!d_U_FinalValue!%~2!d_U_FinalValue%%_!"
)
set "d_U_FinalValue=%d_U_FinalValue:~1%"
CALL:Database_Update_Echo d_U_FinalValue>>"%d_U_Temp_File%"

REM �޸��к�������ȡ��д��׶�
:Database_Updata3
(
	for /f "usebackq %d_U_Pass3% eol=^ delims=" %%? in ("%~1") do echo=%%?
)>>"%d_U_Temp_File%"

REM ����ʱ�ı����ݿ��ļ�����Դ�ı����ݿ��ļ����޸����
copy "%d_U_Temp_File%" "%~1">nul 2>nul
if not "%errorlevel%"=="0" (
	if defined d_U_ErrorPrint echo=	[����%0:���:�޸ĺ����ݸ���ʧ�ܣ�����Ȩ�޲�����ļ�������]
	exit/b 1
)
if exist "%d_U_Temp_File%" del /f /q "%d_U_Temp_File%"
exit/b 0

REM ���ڱ������������������ӳ���
:Database_Updata_Var
set "%~1=!%~2!"
exit/b 0
REM ���ڽ����������ݲ��ܽ�βΪ�ո�+0/1/2/3�Ͳ��ܺ���()����
REM CALL:Database_Update_Echo ������
:Database_Update_Echo
echo=!%~1!
exit/b 0


REM :--------------------------------------------------------------------Database_Find-------------------------------------------------------------------------------:
REM ��ָ���ļ���ָ���С�ָ���ָ�����ָ���С�ָ���ַ�����������������������к�д�뵽ָ��������
REM CALL:Database_Find [/Q(����ģʽ������ʾ����)] [/i(�����ִ�Сд)] [/first(���ز��ҵ��ĵ�һ�����)] "����Դ" "�����зָ���"  "�����ַ���" "����������(֧�ֵ����ָ���,�����������ָ���-,0Ϊָ��ȫ����)" "����������(֧�ֵ����ָ���,�����������ָ���-)" "���ҽ���к��кŽ�����ܸ�ֵ������"
	REM ע�⣺-------------------------------------------------------------------------------------------------------------------------------
	REM 	��������������ʽΪ��"�� ��","�� ��","..."���εݼӣ�����ڶ��е����к͵����е����еĸ�ֵ���ݾ�Ϊ��"2 3","5 6"
	REM 	����ʹ�� 'for %%a in (%�������%) do for /f "tokens=1,2" %%b in ("%%~a") do echo=��%%b�У���%%c��' �ķ������н��ʹ��
	REM -------------------------------------------------------------------------------------------------------------------------------------
REM ���ӣ����ļ� "c:\users\a\Database.ini"�е�����������"	"Ϊ�ָ����ĵ�һ���в����ִ�Сд�Ĳ����ַ���data(��ȫƥ��)����������������кŸ�ֵ������result
REM					CALL:Database_Find /i "c:\users\a\Database.ini" "	" "data" "3-5" "1" "result"
REM ����ֵ���飺0-����ָ���ַ����ҵ�������Ѹ�ֵ������1-δ���ҵ������2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20160625
:Database_Find
REM ����ӳ������л����������
for %%A in (d_F_ErrorPrint d_F_Insensitive d_F_FindFirst) do set "%%A="
if /i "%~1"=="/i" (
	set "d_F_Insensitive=/i"
	shift/1
) else if /i "%~1"=="/q" (shift/1) else set "d_F_ErrorPrint=Yes"
if /i "%~1"=="/i" (
	set "d_F_Insensitive=/i"
	shift/1
) else if /i "%~1"=="/q" (shift/1) else set "d_F_ErrorPrint=Yes"

if /i "%~1"=="/first" (
	set d_F_FindFirst=Yes
	shift/1
)

if "%~6"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����6-ָ�����ܽ��������Ϊ��]
	exit/b 2
)
if "%~5"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����5-ָ�������к�Ϊ��]
	exit/b 2
)
if "%~4"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����4-ָ�������к�Ϊ��]
	exit/b 2
)
if "%~3"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����3-ָ�������ַ���Ϊ��]
	exit/b 2
)
if "%~2"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����2-ָ�������зָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_F_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_F_Count d_F_StringTest d_F_Count2 d_F_Pass %~6) do set "%%_="
for /f "delims==" %%_ in ('set d_F_AlreadyLineNumber 2^>nul') do set "%%_="
for /f "delims==" %%_ in ('set d_F_Column 2^>nul') do set "%%_="

REM �ӳ���ʼ����
REM �ж��û������к��Ƿ���Ϲ���
set "d_F_StringTest=%~4"
for %%_ in (1,2,3,4,5,6,7,8,9,0,",",-) do if defined d_F_StringTest set "d_F_StringTest=!d_F_StringTest:%%~_=!"
if defined d_F_StringTest (
	if defined d_F_ErrorPrint echo=	[����%0:����4:ָ�������кŲ����Ϲ���:%~4]
	exit/b 2
)

REM ���кŸ�ֵ���б���
for /f "tokens=%~5" %%? in ("1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31") do for /f "delims=%%" %%_ in ("%%? %%@ %%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z %%[ %%\ %%]") do for %%: in (%%_) do (
	set /a "d_F_Count+=1"
	set "d_F_Column!d_F_Count!=%%:"
)
set "d_F_Count="
REM �����кŽ��в��ִ������
for %%_ in (%~4) do (
	set "d_F_Pass="
	set "d_F_Pass=%%~_"
	if "!d_F_Pass!"=="!d_F_Pass:-=!" (
		if "%%~_"=="0" (
			set "d_F_Count2=0"
			set "d_F_Count=No"
			set "d_F_Pass="
		) else (
			set /a "d_F_Count2=%%~_-1"
			set /a "d_F_Pass=%%~_-1"
			set "d_F_Count=0"
			if "!d_F_Pass!"=="0" (set "d_F_Pass=") else set "d_F_Pass=skip=!d_F_Pass!"
		)
		CALL:Database_Find_Run "%~1" "%~2" "%~5" "%~3" "%~6"
		if defined d_F_FindFirst if defined %~6 (
			set "%~6=!%~6:~1!"
			exit/b 0
		)
	) else (
		for /f "tokens=1,2 delims=-" %%: in ("%%~_") do (
			if "%%~:"=="%%~;" (
				set /a "d_F_Count2=%%~:-1"
				set /a "d_F_Pass=%%~:-1"
				set "d_F_Count=0"
			) else CALL:Database_Find2 "%%~:" "%%~;"
			if "!d_F_Pass!"=="0" (set "d_F_Pass=") else set "d_F_Pass=skip=!d_F_Pass!"
			CALL:Database_Find_Run "%~1" "%~2" "%~5" "%~3" "%~6"
			if defined d_F_FindFirst if defined %~6 (
				set "%~6=!%~6:~1!"
				exit/b 0
			)
		)
	)
)

if defined %~6 (set "%~6=!%~6:~1!") else (
	if defined d_F_ErrorPrint echo=	[���%0:���ݹؼ���"%~3"δ�ܴ�ָ���ļ��������ҵ����]
	exit/b 1
)
exit/b 0

REM CALL:Database_Find_Run "�ļ�" "�ָ���" "��" "�����ַ���" "������"
:Database_Find_Run
set "d_F_Count3="
for /f "usebackq %d_F_Pass% eol=^ tokens=%~3 delims=%~2" %%? in ("%~1") do (
	set /a "d_F_Count3+=1"
	set /a "d_F_Count2+=1"
	
	if not defined d_F_AlreadyLineNumber!d_F_Count2! (
		set "d_F_AlreadyLineNumber!d_F_Count2!=Yes"
		
		if "%%?"=="%%~?" (
			if %d_F_Insensitive% "%%?"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column1!"&if defined d_F_FindFirst exit/b
		)
		if "%%@"=="%%~@" (
			if %d_F_Insensitive% "%%@"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column2!"&if defined d_F_FindFirst exit/b
		)
		if "%%A"=="%%~A" (
			if %d_F_Insensitive% "%%A"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column3!"&if defined d_F_FindFirst exit/b
		)
		if "%%B"=="%%~B" (
			if %d_F_Insensitive% "%%B"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column4!"&if defined d_F_FindFirst exit/b
		)
		if "%%C"=="%%~C" (
			if %d_F_Insensitive% "%%C"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column5!"&if defined d_F_FindFirst exit/b
		)
		if "%%D"=="%%~D" (
			if %d_F_Insensitive% "%%D"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column6!"&if defined d_F_FindFirst exit/b
		)
		if "%%E"=="%%~E" (
			if %d_F_Insensitive% "%%E"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column7!"&if defined d_F_FindFirst exit/b
		)
		if "%%F"=="%%~F" (
			if %d_F_Insensitive% "%%F"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column8!"&if defined d_F_FindFirst exit/b
		)
		if "%%G"=="%%~G" (
			if %d_F_Insensitive% "%%G"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column9!"&if defined d_F_FindFirst exit/b
		)
		if "%%H"=="%%~H" (
			if %d_F_Insensitive% "%%H"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column10!"&if defined d_F_FindFirst exit/b
		)
		if "%%I"=="%%~I" (
			if %d_F_Insensitive% "%%I"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column11!"&if defined d_F_FindFirst exit/b
		)
		if "%%J"=="%%~J" (
			if %d_F_Insensitive% "%%J"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column12!"&if defined d_F_FindFirst exit/b
		)
		if "%%K"=="%%~K" (
			if %d_F_Insensitive% "%%K"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column13!"&if defined d_F_FindFirst exit/b
		)
		if "%%L"=="%%~L" (
			if %d_F_Insensitive% "%%L"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column14!"&if defined d_F_FindFirst exit/b
		)
		if "%%M"=="%%~M" (
			if %d_F_Insensitive% "%%M"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column15!"&if defined d_F_FindFirst exit/b
		)
		if "%%N"=="%%~N" (
			if %d_F_Insensitive% "%%N"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column16!"&if defined d_F_FindFirst exit/b
		)
		if "%%O"=="%%~O" (
			if %d_F_Insensitive% "%%O"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column17!"&if defined d_F_FindFirst exit/b
		)
		if "%%P"=="%%~P" (
			if %d_F_Insensitive% "%%P"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column18!"&if defined d_F_FindFirst exit/b
		)
		if "%%Q"=="%%~Q" (
			if %d_F_Insensitive% "%%Q"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column19!"&if defined d_F_FindFirst exit/b
		)
		if "%%R"=="%%~R" (
			if %d_F_Insensitive% "%%R"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column20!"&if defined d_F_FindFirst exit/b
		)
		if "%%S"=="%%~S" (
			if %d_F_Insensitive% "%%S"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column21!"&if defined d_F_FindFirst exit/b
		)
		if "%%T"=="%%~T" (
			if %d_F_Insensitive% "%%T"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column22!"&if defined d_F_FindFirst exit/b
		)
		if "%%U"=="%%~U" (
			if %d_F_Insensitive% "%%U"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column23!"&if defined d_F_FindFirst exit/b
		)
		if "%%V"=="%%~V" (
			if %d_F_Insensitive% "%%V"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column24!"&if defined d_F_FindFirst exit/b
		)
		if "%%W"=="%%~W" (
			if %d_F_Insensitive% "%%W"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column25!"&if defined d_F_FindFirst exit/b
		)
		if "%%X"=="%%~X" (
			if %d_F_Insensitive% "%%X"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column26!"&if defined d_F_FindFirst exit/b
		)
		if "%%Y"=="%%~Y" (
			if %d_F_Insensitive% "%%Y"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column27!"&if defined d_F_FindFirst exit/b
		)
		if "%%Z"=="%%~Z" (
			if %d_F_Insensitive% "%%Z"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column28!"&if defined d_F_FindFirst exit/b
		)
		if "%%["=="%%~[" (
			if %d_F_Insensitive% "%%["=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column29!"&if defined d_F_FindFirst exit/b
		)
		if "%%\"=="%%~\" (
			if %d_F_Insensitive% "%%\"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column30!"&if defined d_F_FindFirst exit/b
		)
		if "%%]"=="%%~]" (
			if %d_F_Insensitive% "%%]"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column31!"&if defined d_F_FindFirst exit/b
		)
	)
	if /i not "%d_F_Count%"=="No" (
		if "%d_F_Count%"=="0" exit/b
		if "!d_F_Count3!"=="%d_F_Count%" exit/b
	)
)
exit/b

REM ��������Ƕ�����ԭ���µ����ⲻ�ò�д��һ���ӳ�������ж�
REM CALL:Database_Find2 ��һ��ֵ �ڶ���ֵ
:Database_Find2
if %~10 gtr %~20 (
	set /a "d_F_Count2=%~2-1"
	set /a "d_F_Pass=%~2-1"
	set /a "d_F_Count=%~1-%~2+1"
) else (
	set /a "d_F_Count2=%~1-1"
	set /a "d_F_Pass=%~1-1"
	set /a "d_F_Count=%~2-%~1+1"
)
exit/b


REM :-----------------------------------------------------------------Database_DeleteLine--------------------------------------------------------------------------:
REM ɾ��ָ���ļ�ָ����
REM CALL:Database_DeleteLine [/Q(����ģʽ������ʾ����)] "����Դ" "��ɾ��������ʼ��" "����ʼ�п�ʼ��������ɾ��������(�������У����µ���β������0)"
REM ���ӣ����ļ� "c:\users\a\Database.ini" �еڶ�������ɾ��
REM					CALL:Database_DeleteLine "c:\users\a\Database.ini" "2" "2"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM �汾:20151130
:Database_DeleteLine
REM ����ӳ������л����������
for %%A in (d_DL_ErrorPrint) do set "%%A="
if /i "%~1"=="/q" (
	shift/1
) else set "d_DL_ErrorPrint=Yes"
if "%~3"=="" (
	if defined d_DL_ErrorPrint echo=	[����%0:����3-ָ��ƫ����Ϊ��]
	exit/b 2
)
if %~3 lss 0 (
	if defined d_DL_ErrorPrint echo=	[����%0:����3-ָ��ƫ����С��0:%~4]
)
if "%~2"=="" (
	if defined d_DL_ErrorPrint echo=	[����%0:����2-ָ����ʼ�к�Ϊ��]
	exit/b 2
)
if %~2 lss 1 (
	if defined d_DL_ErrorPrint echo=	[����%0:����2-ָ����ʼ�к�С��1:%~3]
	exit/b 2
)
if "%~1"=="" (
	if defined d_DL_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_DL_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_DL_Count d_DL_Pass1 d_DL_Pass2 d_DL_Pass3 d_DL_Temp_File) do set "%%_="
set "d_DL_Temp_File=%~1_Temp"
if exist "%d_DL_Temp_File%" del /f /q "%d_DL_Temp_File%"
set /a "d_DL_Pass3=%~2-1"
set /a "d_DL_Pass2=%~2+%~3-1"
set /a "d_DL_Pass1=%~2-1"

if "%d_DL_Pass3%"=="0" (set "d_DL_Pass3=") else set "d_DL_Pass3=skip=%d_DL_Pass3%"
if "%d_DL_Pass2%"=="0" (set "d_DL_Pass2=") else set "d_DL_Pass2=skip=%d_DL_Pass2%"

REM �ж��Ƿ���ָ��ɾ����
for /f "usebackq eol=^ %d_DL_Pass3% delims=" %%? in ("%~1") do goto Database_Updata_2
if defined d_DL_ErrorPrint (
	echo=	[����:%0:���:���޴���:%~3]
)
exit/b 1
:Database_Updata_2
if %d_DL_Pass1% leq 0 goto Database_Updata2
REM �ӳ���ʼ����
REM ��ɾ����ǰ����д�뵽��ʱ�ı����ݿ��ļ�
:Database_Updata1
(
	for /f "usebackq eol=^ delims=" %%? in ("%~1") do (
		set /a "d_DL_Count+=1"
		echo=%%?
		if "!d_DL_Count!"=="%d_DL_Pass1%" goto Database_Updata2
	)
)>>"%d_DL_Temp_File%"

REM ��ɾ���к�����д�뵽��ʱ�ı����ݿ��ļ�
:Database_Updata2
if "%~3"=="0" (
	if "%~2"=="1" (if "a"=="b" echo=�˴����ɿ��ļ�)>>"%d_DL_Temp_File%"
) else (
	for /f "usebackq %d_DL_Pass2% eol=^ delims=" %%? in ("%~1") do echo=%%?
)>>"%d_DL_Temp_File%"

REM ����ʱ�ı����ݿ��ļ�����Դ�ı����ݿ��ļ�
copy "%d_DL_Temp_File%" "%~1">nul 2>nul
if not "%errorlevel%"=="0" (
	if defined d_DL_ErrorPrint echo=	[����%0:���:ɾ�������ݸ���ʧ�ܣ�����Ȩ�޲�����ļ�������]
	exit/b 1
)
if exist "%d_DL_Temp_File%" del /f /q "%d_DL_Temp_File%"
exit/b 0

REM :-----------------------------------------------------------�ӳ�������ָ���-----------------------------------------------------------:
:end