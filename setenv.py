#coding=utf8
import os
import sys
import subprocess
try:
    import win32api, win32con
except ImportError:
    os.system('pip3 install pywin32 -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com')
    print('please run again !!!')
if sys.hexversion > 0x03000000:
    import winreg
else:
    import _winreg as winreg

root = winreg.HKEY_LOCAL_MACHINE
subkey = r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'

def get_env(name):
    #系统环境变量获取
    key = winreg.OpenKey(root, subkey, 0, winreg.KEY_READ)
    try:
        value, _ = winreg.QueryValueEx(key, name)
    except WindowsError:
        value = ''
    #print(value)
    return value

def set_env(name, value):
    #系统环境变量设置
    # Note: for 'system' scope, you must run this as Administrator
    key = winreg.OpenKey(root, subkey, 0, winreg.KEY_ALL_ACCESS)
    winreg.SetValueEx(key, name, 0, winreg.REG_EXPAND_SZ, value)
    winreg.CloseKey(key)
    # For some strange reason, calling SendMessage from the current process
    # doesn't propagate environment changes at all.
    # TODO: handle CalledProcessError (for assert)
    subprocess.check_call('''\"%s" -c "import win32api, win32con;assert win32api.SendMessage(win32con.HWND_BROADCAST, win32con.WM_SETTINGCHANGE,0, 'Environment')"''' % sys.executable)

def add_env(name, value):
    #系统环境变量增加
    # Note: for 'system' scope, you must run this as Administrator
    env_lib = get_env(name)
    #判断环境变量是否存在,存在的话使用追加，不存在的话使用新建
    if env_lib != '' :
        #print('The variable [%s]  was exist' % name)
        #判断值是否已存在于变量,存在的话进行替换操作然后追加，不存在的话使用新建
        if value+';' in env_lib:
            #print('The value [%s] variable was exist' % value)
            set_env(name,(value +';'+ env_lib.replace(value+';','')))
        else:
            #print('The value [%s] variable not exist' % value)
            set_env(name,value+';'+env_lib)
    else:
        print('The variable [%s]  not exist' % name)
        set_env(name, value)

def dup_env(name):
    #系统环境变量去重
    # Note: for 'system' scope, you must run this as Administrator
    env_lib = get_env(name)
    #判断环境变量是否存在,存在的话进行拆分和合并，不存在的话忽略
    if env_lib != '' :
        #print('The variable [%s]  was exist' % name)
        env_lib = env_lib.replace(';;',';').replace('\\;',';').strip('\\')
        env_lib_list = env_lib.split(';')
        #列表去空
        env_lib_list = [i for i in env_lib_list if i != '']
        #列表去重
        env_lib_new = []
        for i in env_lib_list:
            if i not in env_lib_new:
                env_lib_new.append(i)
        env_lib = ';'.join('%s' % i for i in env_lib_new)
        #print('de-weight env_lib_new',env_lib_new)
        set_env(name, env_lib)
    else:
        print('The variable [%s]  not exist' % name)

def rank_env(name):
    #系统环境变量去重
    # Note: for 'system' scope, you must run this as Administrator
    env_lib = get_env(name)
    #判断环境变量是否存在,存在的话进行拆分和合并，不存在的话忽略
    if env_lib != '' :
        #print('The variable [%s]  was exist' % name)
        env_lib = env_lib.replace(';;',';').replace('\\;',';').strip('\\')
        env_lib_list = env_lib.split(';')
        #列表去空
        env_lib_list = [i for i in env_lib_list if i != '']
        #列表去重
        env_lib_new = []
        for i in env_lib_list:
            if i not in env_lib_new:
                env_lib_new.append(i)
        env_lib_new.sort()
        #print(env_lib_new)
        env_lib = ';'.join('%s' % i for i in env_lib_new)
        set_env(name, env_lib)
    else:
        print('The variable [%s]  not exist' % name)
                
if __name__=='__main__':
    """
    get_env("TEST")
    add_env("TEST","")
    dup_env("TEST")
    """
    print(sys.argv)
    usage="""
请使用管理员权限运行!!!
查询、追加设置、覆盖设置、去杂 指定环境变量!!!
scrpt_name -g 环境变量名称
scrpt_name -a 环境变量名称 环境变量的值
scrpt_name -s 环境变量名称 环境变量的值
scrpt_name -d 环境变量名称 (原顺)
scrpt_name -r 环境变量名称  (排顺)
""".replace('scrpt_name',sys.argv[0].rsplit('\\',1)[-1]).strip()

    if len(sys.argv) > 2:
        name = sys.argv[2]
        if   sys.argv[1]== '-g' :
            print(get_env(name))
        elif  sys.argv[1]== '-a' :
            value = sys.argv[3]
            add_env(name,value)
            print(get_env(name))
        elif  sys.argv[1]== '-d' :
            dup_env(name)
            print(get_env(name))
        elif sys.argv[1]== '-s' :
            value = sys.argv[3]
            set_env(name,value)
            print(get_env(name))
        elif  sys.argv[1]== '-r' :
            rank_env(name)
            print(get_env(name))
    else:
        print(usage)
