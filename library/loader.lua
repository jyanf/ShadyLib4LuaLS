---@meta loader

---
---加载器模块，提供文件与数据管理功能。
---
---@class loaderlib
loader = {}

---
---将目标路径的文件重定向到源文件。
---
---@param targetPath string 目标路径
---@param sourceName string 源文件路径
---@return boolean 操作是否成功
function loader.addAlias(targetPath, sourceName) end

---
---对目标路径的文件，移除其重定向。
---
---@param targetPath string 目标路径
---@return boolean 操作是否成功
function loader.removeFile(targetPath) end

---
---将目标路径的文件重定向到含有给定数据的临时文件。
---
---@param targetPath string 目标路径
---@param sourceData string 数据字节串
---@return boolean 操作是否成功
function loader.addData(targetPath, sourceData) end

return loader