# xapk-maker

~~一个屑初中生瞎写的阴间程序()~~

这个工具可以把apk+obb转换成xapk.

目录格式:

文件夹  
 ├── Android  
 │  └── obb  
 │    └── [包名]  
 │      └── main.[版本号].[包名].obb  
 └── [包名].apk

转换后:

文件夹  
 ├── Android  
 │  └── obb  
 │    └── [包名]  
 │      └── main.[版本号].[包名].obb  
 ├── [包名].apk  
 ├── (转换后删除) icon.png  
 ├── (转换后删除) manifest.json  
 └── [应用名]_v[版本名]-[版本号].xapk

## [最新] v1.0版本日志

\+ 可以包含单个obb和单个apk  
× 可以导入文件夹  
× 不可以包含多个obb或apk