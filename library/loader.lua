---@meta loader

---
---加载器模块，提供文件与数据管理功能。
---
---@class loaderlib
---@field basePath string|nil 该变量仅限shady-lua可用
loader = {}

---
---将目标路径的文件重定向到源文件。
---
---@param targetPath string 目标路径
---@param sourceName string 源文件路径
---@return boolean @操作是否成功
function loader.addAlias(targetPath, sourceName) end

---
---对目标路径的文件，移除其重定向。
---
---@param targetPath string 目标路径
---@return boolean @操作是否成功
function loader.removeFile(targetPath) end

---
---将目标路径的文件重定向到含有给定数据的临时文件流
---
---@param targetPath string 目标路径
---@param sourceData string 数据字节串
---@return boolean @操作是否成功
function loader.addData(targetPath, sourceData) end

---参照游戏目录结构，将路径从下划线分割转换为斜杠分割<br>
---v2.10起，可以在shady-loader中正常使用
---@param path string 待转换的路径字符串
---@return string @转换完成的路径
---@nodiscard
function loader.underlineToSlash(path) end

---
---**该函数仅限shady-lua可用**<br>待验证
---根据资源实例数据创建临时文件，并将目标路径的文件重定向到之
---
---@param targetPath string
---@param sourceProxy resourcelib.supported
---@return boolean @操作是否成功
function loader.addResource(targetPath, sourceProxy) end

---
---**该函数仅限shady-lua可用**<br>待验证
---将目标路径的文件重定向到已有的外部文件
---
---@param targetPath string
---@param sourcePath string
---@return boolean @操作是否成功
function loader.addFile(targetPath, sourcePath) end

---
---**该函数仅限shady-lua可用**<br>待验证
---将已有的外部包，作为子包合并到当前包
---
---@param sourceName string 包名（相对路径或绝对路径）
---@return integer childId 用于配合后续removePackage使用
function loader.addPackage(sourceName) end

---
---**该函数仅限shady-lua可用**<br>待验证
---移除已合并的指定子包
---
---@param childId integer addPackage时得到的childId
---@return boolean @是否成功移除
function loader.removePackage(childId) end


return loader