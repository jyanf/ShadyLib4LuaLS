---@meta resource

---资源管理模块
---@class resourcelib
resource = {}

----------------------------
-- 枚举定义
----------------------------


---资源类型枚举
---@enum resource.Type
resource.Type = {
    Unknown = 0,    -- 未知类型
    Text = 1,       -- 文本资源
    Table = 2,      -- 表格数据
    Label = 3,      -- 标签标记
    Image = 4,      -- 图像资源
    Palette = 5,    -- 调色板
    Sfx = 6,        -- 音效资源
    Bgm = 7,        -- 背景音乐
    Schema = 8,     -- 结构模板
    Texture = 9     -- 纹理数据
}

----------------------------
-- 类定义
----------------------------

---文本资源类
---@class resourcelib.Text
---@field data string 文本内容
resource.Text = {}
---
---构造函数
---@return resourcelib.Text
---@nodiscard
function resource.Text() end
---
---从指针建立
---@param ptr integer 指针地址
---@return resourcelib.Text
---@nodiscard
function resource.Text.fromPtr(ptr) end


---BGM循环范围标签
---@class resourcelib.Label
---@field begin integer 起始时间点（秒）
---@field finish integer 结束时间点（秒）
resource.Label = {}
---
---构造函数
---@return resourcelib.Label
---@nodiscard
function resource.Label() end
---
---从指针建立
---@param ptr integer 指针地址
---@return resourcelib.Label
---@nodiscard
function resource.Label.fromPtr(ptr) end


---调色板资源类
---@class resourcelib.Palette
---@field data string 原始调色板数据
resource.Palette = {}
---
---构造函数
---@return resourcelib.Palette
---@nodiscard
function resource.Palette() end
---
---从指针建立
---@param ptr integer 指针地址
---@return resourcelib.Palette
---@nodiscard
function resource.Palette.fromPtr(ptr) end
---
---获取颜色值(16bit格式)
---@param index integer 颜色索引 (0-255)
---@return boolean 透明通道
---@return integer 红色通道(0~31)
---@return integer 绿色通道(0~31)
---@return integer 蓝色通道(0~31)
---@nodiscard
function resource.Palette:getColor(index) end
---
---设置颜色值
---@param index integer  颜色索引 (0-255)
---@param alpha? boolean 是否透明
---@param r? integer     红色通道值 (0-31)
---@param g? integer     绿色通道值 (0-31)
---@param b? integer     蓝色通道值 (0-31)
function resource.Palette:setColor(index, alpha, r, g, b) end


---图像资源类
---@class resourcelib.Image
---@field width integer 图像宽度（只读）
---@field height integer 图像高度（只读）
---@field paddedWidth integer 内存对齐后的宽度（只读）
---@field bitsPerPixel integer 位深度（只读）
---@field size integer 数据总大小（只读）
---@field raw string 像素数据
resource.Image = {}
---
---构造函数
---@return resourcelib.Image
---@nodiscard
function resource.Image() end
---
---从指针建立
---@param ptr integer 指针地址
---@return resourcelib.Image
---@nodiscard
function resource.Image.fromPtr(ptr) end
---
---创建空画布（黑）
---@param bpp integer 位深度
---@param width integer 图像宽度
---@param height integer 图像高度
function resource.Image:create(bpp, width, height) end


---音频资源类
---@class resourcelib.Sfx
---@field channels integer 声道数
---@field sampleRate integer 采样率
---@field byteRate integer 字节率
---@field blockAlign integer 块对齐
---@field bitsPerSample integer 位深度
---@field data string 原始音频数据
resource.Sfx = {}
---
---构造函数
---@return resourcelib.Sfx
---@nodiscard
function resource.Sfx() end
---
---从指针建立
---@param ptr integer 指针地址
---@return resourcelib.Sfx
---@nodiscard
function resource.Sfx.fromPtr(ptr) end

----------------------------
-- 全局函数
----------------------------

---@alias resourcelib.supported 
---|resourcelib.Text
---|resourcelib.Label
---|resourcelib.Palette
---|resourcelib.Image
---|resourcelib.Sfx
---
---从文件创建资源对象
---@param sourceName string 源文件路径
---@return resourcelib.supported 资源对象
---@nodiscard
function resource.createfromfile(sourceName) end

---
---导出资源对象到文件
---@param resObject resourcelib.supported 资源对象
---@param exportPath string 导出路径
function resource.export(resObject, exportPath) end

return resource