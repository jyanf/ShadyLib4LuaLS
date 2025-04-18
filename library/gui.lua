---@meta gui

---图形用户界面模块
---@class guilib
gui = {}



---字体配置类
---@class guilib.Font
---@field height integer 字体高度
---@field weight integer 加粗
---@field italic integer 斜体
---@field shadow integer 描边效果
---@field wrap integer 自动换行
---@field offsetX integer X轴偏移
---@field offsetY integer Y轴偏移
---@field spacingX integer 字距
---@field spacingY integer 行距
gui.Font = {}

---构造函数
---@return guilib.Font
---@nodiscard
function gui.Font() end

---
---设置字体名称
---@param fontname string 字体名称
function gui.Font:setFontName(fontname) end

---
---设置字体纵向颜色渐变
---@param color1 integer 上颜色
---@param color2 integer 下颜色
function gui.Font:setColor(color1, color2) end

---
---加载字体文件
---@param fileName string 字体文件路径
---@return integer 加载状态
function gui.Font.loadFontFile(fileName) end



---精灵对象
---@class guilib.Sprite
---@field isEnabled boolean 是否启用
---@field position sokulib.Vector2f 位置坐标
---@field scale sokulib.Vector2f 缩放比例
---@field rotation number 旋转角度
gui.Sprite = {}

---设置整体颜色
---@param color integer ARGB颜色值
function gui.Sprite:setColor(color) end

---
---设置纹理贴图
---@param texturePath string 纹理路径
---@param x? integer 源X坐标（默认0）
---@param y? integer 源Y坐标（默认0）
---@param w? integer 裁剪宽度（默认-1全幅）
---@param h? integer 裁剪高度（默认-1全高）
---@param ax? integer 锚点X（默认0）
---@param ay? integer 锚点Y（默认0）
---@param layer? integer 图层层级（默认0）
function gui.Sprite:setTexture(texturePath, x, y, w, h, ax, ay, layer) end

---
---设置文本内容
---@param text string 显示文本
---@param font guilib.Font 字体配置
---@param w integer 文本框宽度
---@param h integer 文本框高度
---@param layer? integer 图层层级（默认0）
function gui.Sprite:setText(text, font, w, h, layer) end



---光标控制类
---@class guilib.Cursor
---@field isActive boolean 是否激活
---@field index integer 当前索引
gui.Cursor = {}

---设置光标位置
---@param index integer 索引编号
---@param x integer X坐标
---@param y integer Y坐标
function gui.Cursor:setPosition(index, x, y) end

---设置移动范围
---@param x integer 起始X
---@param y integer 起始Y
---@param dx integer 横向移动量
---@param dy integer 纵向移动量
function gui.Cursor:setRange(x, y, dx, dy) end



---值联合类型
---@class guilib.DesignValue
---@field gauge integer 整数值（0~100，用于<slidervert><sliderhorz>显示）
---@field number number 浮点值（用于<number>显示）



---设计对象
---@class guilib.DesignObject
---@field x integer X坐标
---@field y integer Y坐标
---@field isActive boolean 激活状态
gui.DesignObject = {}
---
---从指针建立
---@param ptr integer 指针地址
---@return guilib.DesignObject
---@nodiscard
function gui.DesignObject.fromPtr(ptr) end

---
---设置对象颜色
---@param color integer ARGB颜色值
function gui.DesignObject:setColor(color) end

---
---获取动态值控制器
---@return guilib.DesignValue
---@nodiscard
function gui.DesignObject:getValueControl() end

---
---界面设计管理器
---@class guilib.Design
gui.Design = {}
---
---构造函数
---@return guilib.Design
---@nodiscard
function gui.Design() end
---
---从指针建立
---@param ptr integer 指针地址
---@return guilib.Design
---@nodiscard
function gui.Design.fromPtr(ptr) end

---
---加载布局文件
---@param layoutPath string 布局文件路径
function gui.Design:loadResource(layoutPath) end

---
---清空释放布局
function gui.Design:clear() end

---
---通过ID获取元素
---@param id integer 元素ID
---@return guilib.DesignObject
---@nodiscard
function gui.Design:getItemById(id) end

---
---通过序号获取元素
---@param index integer 元素序号
---@return guilib.DesignObject
---@nodiscard
function gui.Design:getItem(index) end

---
---获取元素总数
---@return integer
---@nodiscard
function gui.Design:getItemCount() end



---特效对象
---@class guilib.Effect
---@field isEnabled boolean 是否启用
---@field isAlive integer 激活状态
---@field position sokulib.Vector2f 当前位置
---@field speed sokulib.Vector2f 移动速度
---@field gravity sokulib.Vector2f 重力加速度
---@field center sokulib.Vector2f 效果中心点
gui.Effect = {}

---
---设置动作序列
---@param actionId integer 动作ID
---@param sequenceId integer 动作序列ID
function gui.Effect:setActionSequence(actionId, sequenceId) end
---
---设置动作
---@param actionId integer 动作ID
function gui.Effect:setAction(actionId) end
---
---设置序列
---@param sequenceId integer 序列ID
function gui.Effect:setSequence(sequenceId) end
---
---重置当前序列到初始状态
function gui.Effect:resetSequence() end
---
---跳转至上一动作序列
function gui.Effect:prevSequence() end
---
---跳转至下一动作序列
function gui.Effect:nextSequence() end
---
---设置当前姿势
---@param poseId integer 姿势ID
function gui.Effect:setPose(poseId) end
---
---切换至上一姿势
function gui.Effect:prevPose() end
---
---切换至下一姿势
function gui.Effect:nextPose() end



---特效资源管理器
---@class guilib.EffectManager
gui.EffectManager = {}

---
---加载特效资源pat
---@param patternPath string 特效pat文件路径
---@param reserve? integer ？预分配实例数量（默认0）？
function gui.EffectManager:loadResource(patternPath, reserve) end

---
---清空所有资源（释放pat和实例）
function gui.EffectManager:clear() end

---
---？仅清除当前特效实例（保留pat）？
function gui.EffectManager:clearEffects() end



---图形渲染控制器
---@class guilib.Renderer
---@field design guilib.Design 界面设计系统
---@field effects guilib.EffectManager 特效管理系统
---@field isActive boolean 渲染器启用状态
gui.Renderer = {}

---
---创建精灵对象
---@param texturePath string 纹理路径
---@param x? integer 初始X坐标（默认0）
---@param y? integer 初始Y坐标（默认0）
---@param w? integer 显示宽度（默认-1自动适配）
---@param h? integer 显示高度（默认-1自动适配）
---@param ax? integer 锚点X偏移（默认0，0=左对齐）
---@param ay? integer 锚点Y偏移（默认0，0=上对齐）
---@param layer? integer 图层层级（默认0，越大越上层）
---@return guilib.Sprite
---@nodiscard
function gui.Renderer:createSprite(texturePath, x, y, w, h, ax, ay, layer) end

---
---创建文本精灵对象
---@param text string 显示文本
---@param font guilib.Font 字体配置
---@param w integer 文本框宽度
---@param h integer 文本框高度
---@param layer? integer 图层层级（默认0）
---@return guilib.Sprite
---@nodiscard
function gui.Renderer:createText(text, font, w, h, layer) end

---
---创建特效实例
---@param id integer 特效patID（需先通过EffectManager加载）
---@param x? number 初始X坐标（默认0.0）
---@param y? number 初始Y坐标（默认0.0）
---@param direction? integer 朝向方向±1
---@param layer? integer 图层层级（默认0）
---@return guilib.Effect
---@nodiscard
function gui.Renderer:createEffect(id, x, y, direction, layer) end

---
---创建水平方向光标
---@param width integer 光标宽度（像素）
---@param max? integer 总槽位数（至少为1）
---@param pos? integer 初始位置索引[0, max)
---@return guilib.Cursor
---@nodiscard
function gui.Renderer:createCursorH(width, max, pos) end

---
---创建垂直方向光标
---@param width integer 光标高度（像素）
---@param max? integer 总槽位数（至少为1）
---@param pos? integer 初始位置索引[0, max)
---@return guilib.Cursor
---@nodiscard
function gui.Renderer:createCursorV(width, max, pos) end

---
---可销毁对象联合类型
---@alias guilib.destroyable 
---|>guilib.Sprite #精灵对象
---| guilib.Cursor #光标对象
---| guilib.Effect #特效对象
---
---销毁图形对象
---@param object guilib.destroyable 需销毁的对象
function gui.Renderer:destroy(object) end


---输入帧计数
---@class guilib.KeyInput
---@field axisH integer 水平轴计数
---@field axisV integer 垂直轴计数
---@field a integer A键计数
---@field b integer B键计数
---@field c integer C键计数
---@field d integer D键计数
---@field change integer 切卡键计数
---@field spell integer 符卡键计数
gui.KeyInput = {}
---
---从指针建立
---@param ptr integer 指针地址
---@return guilib.KeyInput
---@nodiscard
function gui.KeyInput.fromPtr(ptr) end

---Scene对象
---@class guilib.Scene
---@field renderer guilib.Renderer 关联渲染器
---@field input guilib.KeyInput 输入状态
---@field data table 存放用户自定义数据
gui.Scene = {}

---Menu对象
---@class guilib.Menu
---@field renderer guilib.Renderer 关联的渲染器
---@field input guilib.KeyInput 输入状态
---@field data table 存放用户自定义数据
gui.Menu = {}

----------------------------
-- 其他函数
----------------------------

---打开一新的空白菜单
---@param onProcess fun(menu: guilib.Menu):boolean? 菜单处理回调函数
---@return guilib.Menu 新的菜单对象
---@nodiscard
function gui.OpenMenu(onProcess) end

---检查是否存在打开的菜单
---@return boolean
---@nodiscard
function gui.isMenuOpen() end

return gui
