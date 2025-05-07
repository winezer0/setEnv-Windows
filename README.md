setenv 通过注册表操作环境变量, 防止环境变量过长问题.

setenv-cmd 中是存放一些常用的环境变量设置脚本。



```
λ python setenv.py -h
usage: setenv.py [-h] [-g NAME] [-s NAME VALUE] [-a NAME VALUE] [-d NAME VALUE] [-t NAME] [-R] [-T]
                 [-A VALUE] [-b NAME] [-r NAME] [-D NAME]

Windows环境变量管理工具

options:
  -h, --help            show this help message and exit
  -g, --get NAME        获取指定环境变量的值
  -s, --set NAME VALUE  设置指定环境变量的值
  -a, --add NAME VALUE  追加指定环境变量的值
  -d, --delete NAME VALUE
                        刪除指定环境变量的值
  -t, --sort NAME       环境变量排序去重
  -R, --reduce-path     通过新增[path_extend]环境变量缩减path内容
  -T, --extend-sort     排序[path_extend]环境变量内容
  -A, --extend-add VALUE
                        追加[path_extend]环境变量内容
  -b, --backup NAME     备份指定环境变量的值
  -r, --restore NAME    还原指定环境变量的值
  -D, --decode NAME     解压指定环境变量的值

请使用管理员权限运行!!!

```



