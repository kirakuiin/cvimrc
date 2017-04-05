# Eisoo AnyBackup 6.0 Python 编码规范
大纲汇总
* 寓意
* 一致性考虑
* 代码布局
* 命名约定实践
* 开发规则
* 编码最佳最佳实践
## 寓意
```
The Zen of Python, by Tim Peters
Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

## 一致性考虑
### Readability counts: read much more often than it is written.
* 第三方包，模块忽略以下规范，包容兼容性，拒绝破坏
* 遵循规范，可读性优于代码技巧
* 自建项目统一性，拒绝破坏规范
 
## 代码布局
* Indentation 缩进之 Tab & Space
* 强制 Space 空格
* 不允许 Tab & Space 混合使用
* 对已存的 Tab 转化为 Space
* Indentation 缩进
* 每级缩进用4个空格
* 括号中使用垂直隐式缩进或悬挂缩进
* 不建议括号中的)右括号单独一行
```
# 1. 常规缩进 normal
def normal_indent_func(var_1, var_2, var_3, var_4):
return var_1, var_2, var_3, var_4

# 2. 垂直隐式缩进 vertical - 左括号对齐
def vertical_indent_func(var_1, var_2,
var_3, var_4):
return var_1, var_2, var_3, var_4

# 3. 悬挂缩进 hang - 2层缩进
def hang_indent_func(
var_1, var_2, var_3, var_4):
return var_1, var_2, var_3, var_4

var_one = var_two = var_three = var_four = True
# 悬挂缩进 hang - 2层缩进
foo = normal_indent_func(
var_one, var_two, var_three, var_four)
# 垂直隐式缩进 vertical - 左括号对齐
foo1 = normal_indent_func(var_one, var_two,
var_three, var_four)
```
* Maximum Line Length - 行宽
`限制所有行的最大行宽为119字符, 续行的首选方法是使用小括号、中括号和大括号，其次是反斜杠`
```
# Maximum Line Length - 行宽 Demo
class Blob(object):
# () 换行
def __init__(self, width, height,
color='black', emphasis=None, highlight=0):
print width, height, color, emphasis, highlight

class Rectangle(Blob):
def __init__(self, width, height,
color='black', emphasis=None, highlight=0):
# () 换行
if (width == 0 and height == 0 and
color == 'red' and emphasis == 'strong' or
highlight > 100):
raise ValueError("sorry, you lose")
# \ 换行
if width == 0 and height == 0 and \
(color == 'red' or emphasis is None):
raise ValueError("I don't think so -- values are %s, %s" %
(width, height))
Blob.__init__(self, width, height,
color, emphasis, highlight)
```
* Blank Lines - 空白行
* 顶级函数&类，空2行
* 类中方法，空1行
* 逻辑代码块分行区分
* Python 支持 CTRL-L 换行
* Python 文件最后一行空白行
```
# Blank Lines - 空白行 Demo
def bl_func_first():
pass

# 空白2行，函数&类定义
class BLClass(object):
def __init__(self):
pass
# 空白一行，类方法定义
def bl_method(self):
# 逻辑代码块分行区分
if 1:
print '逻辑代码块分行区分'

print 'demo yes.'
# Python 文件最后一行空白行
```
* Source File Encoding - 文件编码
* 文件编码首推UTF-8
* 可行性 Python2:ASCII, Python3: UTF-8
* Imports - 导入
* 单独一行导入模块
* 文档顶部导入
* 绝对路径导入
* 先导入内置模块，再导入第三方模块，最后导入自建模块
* 禁止 from xxx import * 通配导入
```
# Imports - 导入 Demo
# 优先导入内置模块
# 单行导入独立模块
import os
import sys
# 导入模块子对象模块
from subprocess import Popen, PIPE
# 再导入第三方模块
import tornado
# 最后导入自模块，绝对路径导入
import settings
```
* String Quotes - 字符串引用
* "" 和 '' 效果一致，建议 ''
* '''xxx''' 和 """xxx"""， 强制推荐使用 """xxx"""
* 避免使用反斜杆符号
```
# String Quotes - 字符串引用 Demo
def string_quote():
"""强制推荐使用"""
print '强制推荐使用'
```
* Whitespace in Expressions and Statements - 表达式空白格
* 紧靠()[]{}符号时，不使用 Whitespace 空白格
* ,:;符号前，不使用 Whitespace 空白格
* 切片操作:号前后，不使用 Whitespace 空白格
* 函数调用(左括号前，不使用 Whitespace 空白格
* 多行赋值操作，不使用多余的 Whitespace 空白格上下对齐
* 二元运算符前后，使用1个 Whitespace 空白格
* 优先级高的运算符或操作符的前后不建议有空格
* 关键字参数与默认值参数，不使用 Whitespace 空白格
* 不推荐;号的复合语句
* 其他参考PEP8，不强制要求
```
# Whitespace in Expressions and Statements - 表达式空白格 Demo
# 紧靠()[]{}符号时，不使用 Whitespace 空白格
normal_indent_func(var_one, var_two, var_three, var_four) # Yes
normal_indent_func( var_one, var_two, var_three, var_four ) # No
# ,:;符号前，不使用 Whitespace 空白格
normal_indent_func(var_one , var_two , var_three , var_four) # No
if True : print 'no zuo no die.' # No
# 切片操作:号前后，不使用 Whitespace 空白格
wp_list = [1, 2, 3, 4]
sub_wp_list1 = wp_list[1:-1] # Yes
sub_wp_list2 = wp_list[1 : -1] # No
# 函数调用(左括号前，不使用 Whitespace 空白格
string_quote ()
# 多行赋值操作，不使用多余的 Whitespace 空白格上下对齐
# Yes
param_short = 1
param_tiny_short = 2
param_long = 3
param_big_long = 4
# No
param_short = 1
param_tiny_short = 2
param_long = 3
param_big_long = 4
# 二元运算符前后，使用1个 Whitespace 空白格
param = 1 + 2
# 优先级高的运算符或操作符的前后不建议有空格
param_2 = param*2 + 4

# 关键字参数与默认值参数，不使用 Whitespace 空白格
def wp_func(f_param, s_param=False):
pass

# Yes
wp_func(1, s_param=True)
# No
wp_func(1, s_param = True)
# 不推荐;号的复合语句
print 'first'; print 'other1'; print 'other2' # No
```
* Comments - 注释
* 块注释 # 每行注释信息
* 行内注释 #
* 文档字符串，文档字符串的标准参见 PEP 257
```
# Comments - 注释 Demo
# 独立单行注释，变量param_demo赋值信息
param_demo = True if param == 3 else False
# 行内注释，2个空白格后#空白格 注释信息
param_in = 555 if param_demo else 5 # 是5还是555取决于param_demo

# 块注释
# 2015-12-01 By xu.caihua@eisoo.com
# BUG: http://192.168.0.141:8080/browse/PCB-8868
# M18-SMT-日志管理：普通用户可以看见内置客户端的客户端日志。
# 修复方案： 之前普通用户屏蔽内置客户端的做法存在问题
# 虽然界面上普通用户看不到内置客户端
# 但是后台的数据关系还是把内置客户端分配给了所有的普通用户。
# 现在的做法是屏蔽内置客户端修改为，不分配内置客户端的关系给普通用户。
def fix_me_comment_demo():
print 'block comments'

# 文档注释： https://www.python.org/dev/peps/pep-0257/
def func_multi_comment_demo(param_fir, param_sec=True):
"""这是一个多行的文档注释例子函数
这里是补充说明函数用途
接受参数2个，逻辑处理后，返回是否符合要求
:param param_fir: string
:param param_sec: boolean
:return: boolean
"""
return True

def func_simp_comment_demo():
"""这是一个单行的文档注释例子函数"""
pass
```
* Version Bookkeeping - 版本标签
```
# 版本version Demo
__version__ = '1.0.0'
```
 
## 命名约定实践
* Naming Conventions - 约定命名
* 公有的局部变量命名，字母小写，_下划线分割，最大支持的单词数，建议为5个
* 私有的变量命名，_下划线开头
* 私有的属性命名，__双下划线开头
* 包和模块名，全部小写，下划线分割
* 类名称，大驼峰，单词首字母均大写，无_下划线分割
* 全局变量，常量定义单词字母均大写，_下划线分割
* 对象方法名称命名采用小写字母单词，_下划线分割
* 对象方法参数名称规范，self, cls
```
# Naming Conventions - 约定命名 Demo
# 公有的局部变量命名，字母小写，_下划线分割，最大支持的单词数，建议为5个
is_local_var = True
max_local_var_str_limit = 5
# 全局变量，常量定义单词字母均大写，_下划线分割
MAX_JOB_SUPPORT = 10 # 最大支持任务数

# 类名称，大驼峰，单词首字母均大写，无_下划线分割
class LocalClassNameDemo(object):
_private_name = ''
def __init__(self, other=None):
self._other = other
# 对象方法参数名称规范，self, cls
def _owner_private_m(self):
return self._other + 1
# 对象方法参数名称规范，self, cls
@classmethod
def other_method(cls):
print cls._private_name
```
 
## 开发规则
* 【AnyBackup 部门】内部独立可发布的包命名规则
统一自有独立存在的开发包的名称规范，均使用前缀: [emg_]， 全称为EMG。整体的名称统一小写字母+数字，
下划线作为单词分隔符。如，我们创建一个应用服务监控管理的包，我们的命名要求必须是： emg_services_monitor
* 【AnyBackup 部门】内部独立可发布的包中的模块命名规则
统一自有包内的模块的名称规范，均使用实际意义的小写字母+数字组合，下划线区分，不强制要求使用前缀
名称。如，应用服务监控管理的包[emg_services_monitor]下的一个CPU事件驱动监测模块，我们的命名要求
大致为：cpu_monitor_event.py
* 第三方引入规则
第三方库、包的引入问题需要关注如下规则：
* 预研文档，包括版本、接口、最佳实践，技术栈
* 评审文档，Python开发人员的内部审核机制
* 维护计划
* 导入服务规则
应用产品中的服务规范
* 新服务引入需要全体人员评审
* 服务的功能职责独立不重复性质
* 服务的完整性，包含服务脚本，进程文件，依赖库，安装脚本
* CI构建模块等相关的完整性
 
## 编码最佳实践
### 列表表达式
* 用还是不用?
```
肯定用
```
* 怎么用?
```
1. 不要滥用
2. 尽量用在简单的场合
3. 复杂的列表表达式, 抽取为一个函数
4. 格式. 力求清晰
最简单的: [client.name for client in some_clients]
稍复杂点: [client.name
for client in some_clients
if not client.name.startswith('windows')]
```
### 异常捕获
* 用业务自定义的异常
* 捕获具体的异常, 不到最后, 不要捕获大异常, 如 `except Exception: ` 
* 应当杜绝的风格
```
try:
statement
except:
some action
try:
statement
except Exception:
some action
try:
statement
except Exception:
pass # 实在要这么做, 先考虑清楚, 毕竟异常被默默隐藏了
try:
statement1 # 语句太多, 维护者怎知哪一句产生异常 ?
statement2
statement3
......
except SomeException:
```
* 原则: 先不主动捕获, 让其出错, 让其崩溃. 早发现, 早处理.

### 逻辑表达式
* 短逻辑最好, 如
```
if is_my_name or is_your_name:
do_some_thing
```
* 长逻辑, 用临时变量代替
```
_is_my_name = long_complex_expression
_is_your_name = long_complex_expression
if _is_my_name or _is_your_name:
do_some_thing
```
* 等价的逻辑表达式
```
if name == 'name1' or name == 'name2' or name == 'name3':
转化为
if name in ('name1', 'name2', 'name3'):
```

### 不要有 magic-number 或者 magic-string
