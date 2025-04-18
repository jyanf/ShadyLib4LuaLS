---@meta memory

---底层内存操作模块
---@class memorylib
memory = {}

----------------------------
-- 内存读写操作
----------------------------

---
---读取32位整数
---@param address integer 内存地址
---@return integer
---@nodiscard
function memory.readint(address) end

---
---读取16位短整数
---@param address integer 内存地址
---@return integer
---@nodiscard
function memory.readshort(address) end

---
---读取单精度浮点数
---@param address integer 内存地址
---@return number
---@nodiscard
function memory.readfloat(address) end

---
---读取双精度浮点数
---@param address integer 内存地址
---@return number
---@nodiscard
function memory.readdouble(address) end

---
---读取原始字节数据
---@param address integer 起始地址
---@param size integer 读取长度
---@return string 读取所得字节串
---@nodiscard
function memory.readbytes(address, size) end

---
---写入32位整数
---@param address integer 内存地址
---@param value integer 要写入的值
function memory.writeint(address, value) end

---
---写入16位短整数
---@param address integer 内存地址
---@param value integer 要写入的值
function memory.writeshort(address, value) end

---
---写入单精度浮点数
---@param address integer 内存地址
---@param value number 浮点数值
function memory.writefloat(address, value) end

---
---写入双精度浮点数
---@param address integer 内存地址
---@param value number 双精度值
function memory.writedouble(address, value) end

---
---写入原始字节数据
---@param address integer 起始地址
---@param bytes string 数据字节串
function memory.writebytes(address, bytes) end

----------------------------
-- 自定义函数调用系统
----------------------------

---
---函数调用包装器
---@class memorylib.FuncCall
---@overload fun(thisptr?: integer, sargs...: integer): integer?
memory.FuncCall = {}

---调用目标函数


---
---创建函数调用器
---@param addr integer 函数地址
---@param argc integer 参数个数
---@param isThisCall boolean 是否thiscall调用约定
---@return memorylib.FuncCall
---@nodiscard
function memory.createfunccall(addr, argc, isThisCall) end

---
---创建虚函数调用器
---@param index integer 虚函数表索引
---@param argc integer 参数个数
---@return memorylib.FuncCall
---@nodiscard
function memory.createvirtualcall(index, argc) end

----------------------------
-- 钩子系统
----------------------------

---
---CPU寄存器状态快照
---@class memorylib.CPUState
---@field eax integer
---@field ebx integer
---@field ecx integer
---@field edx integer
---@field esp integer
---@field ebp integer
---@field esi integer
---@field edi integer
memory.CPUState = {}

---@alias ccb fun(state: memorylib.CPUState, ...: integer): integer|boolean?
---
---回调处理器
---@class memorylib.Callback
---@field enabled boolean 回调是否启用
---@overload fun(state: memorylib.CPUState, sargs...: integer): integer|boolean?
memory.Callback = {}

---回调调用接口

---
---创建回调处理器
---@param sargc integer 栈中参数个数
---@param callback ccb 回调函数，“...”参数量需与sargc一致
---@return memorylib.Callback
---@nodiscard
function memory.createcallback(sargc, callback) end

---
---函数调用钩子
---@param addr integer call指令地址
---@param callback memorylib.Callback 回调处理器
---@return boolean 该地址是否为初次hook
function memory.hookcall(addr, callback) end

---
---虚函数表钩子
---@param addr integer 虚表地址
---@param callback memorylib.Callback 回调处理器
---@return boolean 该地址是否为初次hook
function memory.hookvtable(addr, callback) end

---
---指令级钩子
---@param addr integer 目标地址
---@param asmSize integer 覆盖指令长度（最小为5）
---@param callback memorylib.Callback 回调处理器
---@return boolean 该地址是否为初次hook
function memory.hooktramp(addr, asmSize, callback) end

---
---设置跨包回调
---@param name string 凭据名称
---@param callback memorylib.Callback 回调处理器
function memory.setIPC(name, callback) end

---
---获取跨包回调
---@param name string 凭据名称
---@return memorylib.Callback?
---@nodiscard
function memory.getIPC(name) end

return memory
