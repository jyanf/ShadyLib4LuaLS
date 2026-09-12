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
---@return string @读取所得字节串
---@nodiscard
function memory.readbytes(address, size) end

---
---读取布尔值
---@param address integer 内存地址
---@return boolean
---@nodiscard
function memory.readbool(address) end


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

---
---写入布尔值
---@param address integer 内存地址
---@param value boolean 布尔值
function memory.writebool(address, value) end

----------------------------
-- 自定义函数调用系统
----------------------------

---
---函数调用器（通过函数地址调用C函数）
---@class memorylib.FuncCall
---@operator call(unknown):any
---@overload fun(thisptr?: integer, sargs...: integer): integer?
---@enum memorylib.CallConvs
memory.FuncCall = {
    CDECL=0, STDCALL=0,
    THISCALL=1,
    FASTCALL=2,
}

-- 调用目标函数


---
---创建函数调用器
---@param addr integer 函数地址
---@param argc integer 参数个数（不计this指针）
---@param callConvs memorylib.CallConvs|boolean 调用约定类型（cdecl/stdcall=0，thiscall=1，fastcall=2）
---@return memorylib.FuncCall
---@nodiscard
function memory.createfunccall(addr, argc, callConvs) end

---
---创建虚函数调用器
---@param index integer 虚函数表索引（从0数起）
---@param argc integer 参数个数（不计this指针）
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
---@alias ccb2 fun(state: nil, ...: any): any
---
---回调包装器
---@class memorylib.Callback
---@field enabled boolean 回调是否启用
---@operator call(...): any
memory.Callback = {}

---
---注册跨包回调（Inter Package Callback）
---========
---注册后，其他包的lua脚本可通过同名凭据使用 `memory.getIPC` 获取该回调并自行调用，获得其返回值。
---@see memory.getIPC
---
---注意：
---* IPC 调用支持lua基础类型以及大部分userdata类型。
---* IPC 场景的Callback不支持直接传递或返回 Lua function。
---* 如需传递回调函数，请使用 `memory.createCallback` 包装为`Callback`对象后方可传递。
---
---示例：
---```lua
----- package as API
---memory.setIPC("math_add", 
---    memory.createCallback(2, function(state, a, b)
---    -- call from lua, para state is nil
---        return a + b
---    end)
---)
---```
---@param name string 凭据名称
---@param callback memorylib.Callback 待注册的IPC
function memory.setIPC(name, callback) end

---
---获取跨包回调（Inter Package Callback）
---========
---获取由其他包注册过的回调包装器。
---@see memory.setIPC
---
---示例：
---```lua
---local add = memory.getIPC("math_add")
---if add then
---    print(add(3, 5)) -- 8
---end
---```
---@param name string 凭据名称
---@return memorylib.Callback? @依名称获取到的IPC，返回nil则代表不存在
---@nodiscard
function memory.getIPC(name) end

---
---创建回调包装器
---@param sargc integer 对钩子回调（Hook）：需要获取的栈中参数个数；对跨包回调（IPC）：预期参数个数
---@param callback ccb|ccb2 回调函数，“...”可变参数个数需与sargc一致
---@return memorylib.Callback
---@nodiscard
function memory.createcallback(sargc, callback) end

---
---函数调用钩子
---@param addr integer call指令地址
---@param callback memorylib.Callback 回调包装器
---@param argv integer? 原函数栈上参数的个数（跳过非__cdecl类原函数时需要指定该数据以平衡堆栈）
---@return boolean @该地址是否为初次hook
function memory.hookcall(addr, callback, argv) end

---
---虚函数表钩子
---@param addr integer 虚表地址
---@param callback memorylib.Callback 回调包装器
---@return boolean @该地址是否为初次hook
function memory.hookvtable(addr, callback) end

---
---指令级钩子
---@param addr integer 目标地址
---@param asmSize integer 覆盖指令长度（至少为5）
---@param callback memorylib.Callback 回调包装器
---@return boolean @该地址是否为初次hook
function memory.hooktramp(addr, asmSize, callback) end


----------------------------
-- 内存分配器
----------------------------
---
---@param size integer 分配内存字节数
---@return integer @分配的内存地址
---@nodiscard
function memory.new(size) end
---
---@param addr integer 待释放的内存地址
function memory.delete(addr) end



return memory
