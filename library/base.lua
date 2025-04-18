---@meta base
---
---经过重新实现的lua函数，或额外的函数
---


---直接读取文件内容
---@param sourceName string 文件路径
---@return string 文件数据字节串
---@nodiscard
function readfile(sourceName) end

---@type boolean 关闭battle.replace等函数的不同步警告
CloseDesyncAlert=false