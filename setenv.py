#coding=utf8
import os
import sys
import subprocess
import argparse
import winreg  # Python 3
import ctypes
from pkgutil import EXTEND_PATH

# 定义注册表路径和权限
root = winreg.HKEY_LOCAL_MACHINE
subkey = r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
CONCAT_SYMBOL = ';'


def get_env(env_name:str, show=True):
    #系统环境变量获取
    key = winreg.OpenKey(root, subkey, 0, winreg.KEY_READ)
    try:
        value, _ = winreg.QueryValueEx(key, env_name)
    except WindowsError:
        value = ''
        print(f"Environment '{env_name}' not found")
    if show:
        print(f"Get Env [{env_name}] -> Value: [{value}]")
    return value

# def set_env(name, value):
#     #系统环境变量设置 Administrator
#     import win32api, win32con
#     key = winreg.OpenKey(root, subkey, 0, winreg.KEY_ALL_ACCESS)
#     winreg.SetValueEx(key, name, 0, winreg.REG_EXPAND_SZ, value)
#     winreg.CloseKey(key)
#     # 由于某些奇怪的原因，从当前进程调用SendMessage根本不会传播环境更改。
#     # TODO: 处理 CalledProcessError (for assert)
#     subprocess.check_call('''\"%s" -c "import win32api, win32con;assert win32api.SendMessage(win32con.HWND_BROADCAST, win32con.WM_SETTINGCHANGE,0, 'Environment')"''' % sys.executable)

def dedup_env_values(env_values: list):
    """去重字符串列表值，并保持原始顺序"""
    if not env_values:
        return []
    seen = set()
    result = []
    for value in env_values:
        value = value.replace("/", "\\").rstrip('\\/')
        if value not in seen:
            seen.add(value)
            result.append(value)
    return result


def to_dedup_env_values(env_value:str):
    """分割字符串到列表，并进行去重"""
    env_values = []
    if env_value and isinstance(env_value, str):
        env_values = env_value.split(CONCAT_SYMBOL)
        env_values = [v for v in env_values if v.strip()]
    return dedup_env_values(env_values)

def join_env_values(env_values: list):
    return CONCAT_SYMBOL.join(env_values)


def set_env(env_name:str, env_value:str):
    """
    设置系统环境变量，并通知系统更新环境变量。
    :param env_name: 环境变量名称
    :param env_value: 环境变量值
    """
    if not env_name:
        return

    if isinstance(env_value, list):
        env_value =join_env_values(env_value)

    try:
        # 使用上下文管理器确保注册表键被正确关闭
        with winreg.OpenKey(root, subkey, 0, winreg.KEY_ALL_ACCESS) as key:
            # 设置环境变量
            winreg.SetValueEx(key, env_name, 0, winreg.REG_EXPAND_SZ, env_value)
        # 广播 WM_SETTINGCHANGE 消息以通知系统更新环境变量
        try:
            # 定义常量
            HWND_BROADCAST = 0xFFFF
            WM_SETTINGCHANGE = 0x001A

            # 发送广播消息
            result = ctypes.windll.user32.SendMessageTimeoutW(
                HWND_BROADCAST,
                WM_SETTINGCHANGE,
                0,
                "Environment",
                0x0002 | 0x0000,  # SMTO_ABORTIFHUNG | SMTO_NORMAL
                5000,  # 超时时间（毫秒）
                None
            )
            if result == 0:
                raise RuntimeError("广播消息失败，可能未正确更新环境变量！")
            print(f"环境变量 {env_name} 已成功设置为 {env_value}")

        except Exception as e:
            print(f"广播消息时出错: {e}")
            raise

    except FileNotFoundError:
        print(f"无法找到注册表路径 {subkey}")
        raise
    except PermissionError:
        print("权限不足，请以管理员身份运行此脚本！")
        raise
    except Exception as e:
        print(f"设置环境变量时出错: {e}")
        raise


def add_env(env_name:str, env_value:str):
    #系统环境变量增加 Administrator
    if not env_value:
        return

    raw_env_values = to_dedup_env_values(get_env(env_name))
    new_env_values = to_dedup_env_values(env_value)
    #判断需要添加的值是否已存在于环境变量
    new_env_values.extend(raw_env_values)
    new_env_values = dedup_env_values(new_env_values)
    set_env(env_name, join_env_values(new_env_values))

def dedup_env(env_name):
    #系统环境变量去重 Administrator
    env_values = to_dedup_env_values(get_env(env_name))
    if env_values:
        set_env(env_name, join_env_values(env_values))
    else:
        print(f'The variable [{env_name}]  not exist')


def sort_env(env_name):
    #系统环境变量去重 Administrator
    env_values = to_dedup_env_values(get_env(env_name))
    if env_values:
        set_env(env_name, join_env_values(sorted(env_values)))
    else:
        print(f'The variable [{env_name}]  not exist')

def remove_env(env_name:str, remove_value:str):
    """刪除指定env的某值"""
    if not remove_value:
        return

    env_values = to_dedup_env_values(get_env(env_name))
    del_values = to_dedup_env_values(remove_value)
    #判断需要添加的值是否已存在于环境变量
    for del_value in del_values:
        if del_value in env_values:
            env_values.remove(del_value)
    set_env(env_name, join_env_values(env_values))


PATH = "path"
EXTEND_PATH = "extend_path"

def reduce_path_by_extend(extend_env_name=EXTEND_PATH):
    # 优化PATH环境变量,将其中 非 C:\WINDOWS开头和非 %开头的变量 移动到 extend_env_name 中去, 缩短path长度
    path_env_values = to_dedup_env_values(get_env(PATH))

    # 把扩展变量加入到环境变量
    if f"%{extend_env_name}%" not in path_env_values:
        path_env_values.append(f"%{extend_env_name}%")

    # 获取其中需要移动的路径
    not_move_values = []
    need_move_values = []
    for env_value in path_env_values:
        if env_value.startswith("%") or env_value.startswith("C:\WINDOWS"):
            not_move_values.append(env_value)
        else:
            need_move_values.append(env_value)

    add_env(extend_env_name, join_env_values(need_move_values))
    set_env(PATH, join_env_values(not_move_values))


def extend_path_add_value(env_value:str):
    """增加 EXTEND_PATH """
    add_env(EXTEND_PATH, env_value)

def extend_path_sort_value():
    """排序 EXTEND_PATH """
    sort_env(EXTEND_PATH)


def main():
    parser = argparse.ArgumentParser(
        description='Windows环境变量管理工具',
        epilog='请使用管理员权限运行!!!'
    )
    
    parser.add_argument('-g', '--get', 
                      help='获取指定环境变量的值',
                      metavar='NAME')

    parser.add_argument('-s', '--set',
                        help='设置指定环境变量的值',
                        metavar=('NAME', 'VALUE'),
                        nargs=2)

    parser.add_argument('-a', '--add',
                      help='追加指定环境变量的值',
                      metavar=('NAME', 'VALUE'),
                      nargs=2)

    parser.add_argument('-r', '--remove',
                      help='刪除指定环境变量的值',
                      metavar=('NAME', 'VALUE'),
                      nargs=2)

    parser.add_argument('-d', '--dedup',
                      help='环境变量内容去重',
                      metavar='NAME')
    
    parser.add_argument('-s', '--sort',
                      help='环境变量排序去重',
                      metavar='NAME')

    args = parser.parse_args()

    if args.get:
        get_env(args.get)
    elif args.add:
        add_env(args.add[0], args.add[1])
        get_env(args.add[0])
    elif args.remove:
        remove_env(args.add[0], args.add[1])
        get_env(args.add[0])
    elif args.set:
        set_env(args.set[0], args.set[1])
        get_env(args.set[0])
    elif args.dedup:
        dedup_env(args.dedup)
        get_env(args.dedup)
    elif args.sort:
        sort_env(args.sort)
        get_env(args.sort)
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
