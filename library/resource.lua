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
    Text = 1,       -- 文本资源(txt/cv0)
    Table = 2,      -- 表格数据(csv/cv1)
    Label = 3,      -- bgm循环标记(lbl/sfl)
    Image = 4,      -- 图像资源(png/cv2)
    Palette = 5,    -- 调色板(act/pal)
    Sfx = 6,        -- 音效资源(wav/cv3)
    Bgm = 7,        -- 背景音乐(ogg)
    Schema = 8,     -- 结构模板(xml/pat/dat)
    Texture = 9     -- 纹理数据(dds)
}

----------------------------
-- 类定义
----------------------------

---文本资源类
---@class resourcelib.Text
---@field data string 文本内容

---构造函数
---@class resourcelib.Text
---@overload fun():resourcelib.Text
resource.Text = {}

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

---构造函数
---@class resourcelib.Label
---@overload fun():resourcelib.Label
resource.Label = {}

---
---从指针建立
---@param ptr integer 指针地址
---@return resourcelib.Label
---@nodiscard
function resource.Label.fromPtr(ptr) end


---调色板资源类
---@class resourcelib.Palette
---@field data string 原始调色板数据

---构造函数
---@class resourcelib.Palette
---@overload fun():resourcelib.Palette
resource.Palette = {}

---
---从指针建立
---@param ptr integer 指针地址
---@return resourcelib.Palette
---@nodiscard
function resource.Palette.fromPtr(ptr) end
---
---获取颜色值(16bit格式)
---@param index integer 颜色索引 (0-255)
---@return boolean alpha 透明通道
---@return integer red 红色通道(0~31)
---@return integer green 绿色通道(0~31)
---@return integer blue 蓝色通道(0~31)
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

---构造函数
---@class resourcelib.Image
---@overload fun():resourcelib.Image 
resource.Image = {}
---

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

---构造函数
---@class resourcelib.Sfx
---@overload fun():resourcelib.Sfx
resource.Sfx = {}

---
---从指针建立
---@param ptr integer 指针地址
---@return resourcelib.Sfx
---@nodiscard
function resource.Sfx.fromPtr(ptr) end

---
---解析并创建音频实例
---@return resourcelib.SoundInstance
---@nodiscard
function resource.Sfx:parse() end

---音频实例类
---@class resourcelib.SoundInstance

---构造函数（通过wav文件名创建）
---@class resourcelib.SoundInstance
---@overload fun(filename:string):resourcelib.SoundInstance
resource.SoundInstance = {}

---播放一次音频
function resource.SoundInstance:play() end

---停止正在播放的音频
function resource.SoundInstance:stop() end

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
---@return resourcelib.supported @资源对象
---@nodiscard
function resource.createfromfile(sourceName) end

---
---导出资源对象到文件
---@param resObject resourcelib.supported 资源对象
---@param exportPath string 导出路径
function resource.export(resObject, exportPath) end

return resource