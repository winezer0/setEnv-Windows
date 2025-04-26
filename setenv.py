#coding=utf8
import argparse
import ctypes
import json
import os
import winreg  # Python 3



# 定义注册表路径和权限
root = winreg.HKEY_LOCAL_MACHINE
subkey = r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
CONCAT_SYMBOL = ';'

def dump_json(file_path: str, data, encoding: str = 'utf-8', indent: int = 2, mode: str = 'w+') -> tuple:
    """ 将给定的数据存储为JSON文件。  """
    error = None
    try:
        with open(file_path, mode, encoding=encoding) as f:
            json.dump(data, f, ensure_ascii=False, indent=indent)
        return True, error
    except IOError as error:
        print(f"写入JSON发生IO异常: {file_path} -> {error}")
    except Exception as error:
        print(f"写入JSON发生未知错误: {file_path} -> {error}")
    return False, error

def dumps_json(data, indent=0, ensure_ascii=False, sort_keys=False, allow_nan=False) -> tuple:
    try:
        json_string = json.dumps(data, indent=indent, ensure_ascii=ensure_ascii, sort_keys=sort_keys, allow_nan=allow_nan)
        return json_string, None
    except Exception as e:
        print(f"dumps json error: {e}")
        return None, e


def print_json(data, indent=2, ensure_ascii=False, sort_keys=False, allow_nan=False):
    if not isinstance(data,str):
        json_string, _ = dumps_json(data, indent=indent, ensure_ascii=ensure_ascii, sort_keys=sort_keys, allow_nan=allow_nan)
    else:
        json_string = data
    print(json_string)

def load_json(json_path: str, encoding: str = 'utf-8'):
    """加载漏洞扫描结果"""
    try:
        with open(json_path, 'r', encoding=encoding) as f:
            return json.load(f)
    except Exception as e:
        raise RuntimeError(f"加载 JSON 失败: {str(e)}")


def get_env(env_name:str):
    #系统环境变量获取
    key = winreg.OpenKey(root, subkey, 0, winreg.KEY_READ)
    try:
        value, _ = winreg.QueryValueEx(key, env_name)
        print(f"Get Env [{env_name}] -> Value: [{value}]")
    except WindowsError:
        value = ''
        print(f"Environment '{env_name}' not found")
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
        value = value.replace("/", "\\").replace("\\\\", "\\").rstrip('\\/')
        if str(value).lower() not in seen:
            seen.add(str(value).lower())
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
        env_value = join_env_values(env_value)

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


def sort_env(env_name):
    #系统环境变量去重排序 Administrator
    env_values = to_dedup_env_values(get_env(env_name))
    if env_values:
        set_env(env_name, join_env_values(sorted(env_values)))
    else:
        print(f'The variable [{env_name}]  not exist')

def delete_env(env_name:str, remove_value:str):
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


PATH = "PATH"
PATH_EXTEND = "PATH_EXTEND"

def reduce_path_by_extend(extend_env_name=PATH_EXTEND):
    # 优化PATH环境变量,将其中 非 C:\WINDOWS开头和非 %开头的变量 移动到 extend_env_name 中去, 缩短path长度
    path_env_values = to_dedup_env_values(get_env(PATH))

    # 进行 PATH 缓存记录,防止错误发生
    dump_env_to_json(PATH)

    # 把扩展变量加入到环境变量
    if f"%{extend_env_name}%" not in path_env_values and f"%{extend_env_name}%".lower() not in path_env_values:
        path_env_values.append(f"%{extend_env_name}%")

    # 获取其中需要移动的路径
    not_move_values = []
    need_move_values = []
    for env_value in path_env_values:
        if env_value.startswith("%") or env_value.startswith(r"C:\WINDOWS"):
            not_move_values.append(env_value)
        else:
            need_move_values.append(env_value)

    add_env(extend_env_name, join_env_values(need_move_values))
    set_env(PATH, join_env_values(not_move_values))


def extend_path_add_value(env_value:str):
    """增加 EXTEND_PATH """
    add_env(PATH_EXTEND, env_value)


def extend_path_sort_value():
    """排序 EXTEND_PATH """
    sort_env(PATH_EXTEND)

def dump_env_to_json(env_name:str):
    # 获取 env_name 的内容 到列表
    # 分析列表中是否存在 %XXX% 变量
    # 转换为字典格式
    # 保存为json文件
    env_values = to_dedup_env_values(get_env(env_name))

    final_env_dict = {}
    if not env_values:
        print(f'The Env [{env_name}] is empty...')

    final_env_dict[env_name] = env_values
    for env_value in env_values:
        if env_value.startswith("%") and env_value.endswith("%"):
            sub_env_name = env_value.strip("%")
            sub_env_values = to_dedup_env_values(get_env(sub_env_name))
            for sub_env_value in sub_env_values:
                if sub_env_value.startswith("%") and sub_env_value.endswith("%"):
                    print(f"请注意: [{env_name}] -> [{sub_env_name}] 中包含环境变量 [{sub_env_value}]")
            final_env_dict[sub_env_name] = sub_env_values

    file_path = f"{env_name}.backup.json"

    status, error = dump_json(file_path, final_env_dict)
    if error:
        raise error
    else:
        print(f"success dump env info [{env_name}] to [{file_path}]")


def load_env_from_json(env_name:str):
    # 读取json文件
    # 循环导入 环境变量
    file_path =  f"{env_name}.backup.json"

    if not os.path.exists(file_path):
        print(f"env backup file [{file_path}] not exist!!!")
        dump_env_to_json(env_name)
        return

    final_env_dict = load_json(file_path)
    print_json(final_env_dict)

    for env_name,env_values in final_env_dict.items():
        set_env(env_name, join_env_values(env_values))

    print(f"success load env info [{env_name}] to [{file_path}]")


def main():
    parser = argparse.ArgumentParser(description='Windows环境变量管理工具', epilog='请使用管理员权限运行!!!')
    
    parser.add_argument('-g', '--get', help='获取指定环境变量的值', metavar='NAME')
    parser.add_argument('-s', '--set', help='设置指定环境变量的值', metavar=('NAME', 'VALUE'), nargs=2)
    parser.add_argument('-a', '--add',  help='追加指定环境变量的值', metavar=('NAME', 'VALUE'), nargs=2)
    parser.add_argument('-d', '--delete', help='刪除指定环境变量的值',  metavar=('NAME', 'VALUE'), nargs=2)
    parser.add_argument('-t', '--sort', help='环境变量排序去重', metavar='NAME')

    parser.add_argument('-R', '--reduce-path',  help='通过新增extend_path缩减path内容', action='store_true', default=False)
    parser.add_argument('-T', '--extend-sort',  help='排序extend_path环境变量内容', action='store_true', default=False)
    parser.add_argument('-A', '--extend-add',  help='追加extend_path环境变量内容', metavar='VALUE')


    parser.add_argument('-b', '--backup',  help='备份指定环境变量的值', metavar='NAME')
    parser.add_argument('-r', '--restore',  help='还原指定环境变量的值', metavar='NAME')

    args = parser.parse_args()

    if args.get:
        get_env(args.get)

    if args.set:
        set_env(args.set[0], args.set[1])
        get_env(args.set[0])

    if args.add:
        add_env(args.add[0], args.add[1])
        get_env(args.add[0])

    if args.delete:
        delete_env(args.add[0], args.add[1])
        get_env(args.add[0])

    if args.sort:
        sort_env(args.sort)
        get_env(args.sort)

    if args.reduce_path:
        # 自动初始化 PATH的内容到  EXTEND_PATH
        reduce_path_by_extend()
        get_env(PATH)
        get_env(PATH_EXTEND)

    if args.extend_sort:
        # 排序 EXTEND_PATH 的内容
        extend_path_sort_value()
        get_env(PATH_EXTEND)

    if args.extend_add:
        # 增加指定 值 到  EXTEND_PATH
        extend_path_add_value(args.extend_add)
        get_env(PATH_EXTEND)

    if args.backup:
        dump_env_to_json(args.backup)

    if args.restore:
        load_env_from_json(args.restore)

if __name__ == '__main__':
    main()
