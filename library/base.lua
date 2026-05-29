---@meta base
---
---经过重新实现的lua函数，或额外的函数
---

---直接读取包内文件二进制内容
---@param sourceName string 文件路径
---@return string 文件数据字节串
---@nodiscard
function readfile(sourceName) end

--[[
---读取并执行包内lua脚本
---@param scriptPath string 脚本文件路径
---@return any
---@nodiscard
function dofile(scriptPath) end

---加载脚本文件并编译为函数（不执行）<br>
---类似于 dofile，但不会立即运行脚本
---@param scriptPath string 脚本文件路径
---@param mode? "b"|"t"|"bt" 读取模式："b"（二进制）或 "t"（文本）
---@param env? table 设置函数的_ENV(upvalue)
---@return fun():any @编译后的函数（调用后才执行脚本）
function loadfile(scriptPath, mode, env) end


---v2.10起，可以在shady-loader中使用，并导入包内模块<br>
---（在shady-loader中使用时，尚不支持从包内dll文件导入模块；shady-lua直接使用lua原生require，因此没有限制）
---@param modulePath string 模块名
---@return any
function require(modulePath) end
--]]

---@type boolean 关闭battle.replace等函数的不同步警告
CloseDesyncAlert=false