---@meta soku


---
---则·集成模块；提供一些通用的API接口，供脚本使用。
---@class sokulib
---
---游戏是否已准备就绪（只读）
---@field isReady boolean
---
---玩家1信息
---@field P1 battlelib.PlayerInfo
---
---玩家2信息
---@field P2 battlelib.PlayerInfo
---
---当前场景ID（只读）
---@field sceneId sokulib.Scene
soku = {}

----------------------------
-- 枚举定义
----------------------------

---
-----对战阶段枚举
---@enum sokulib.BattleEvent
soku.BattleEvent = {
    GameStart = 0,      -- 游戏启动完成
    RoundPreStart = 1,  -- 回合预备
    RoundStart = 2,     -- 回合开始
    RoundEnd = 3,       -- 回合结束
    --Stop = 4
    GameEnd = 5,        -- 对局结束
    EndScreen = 6,      -- 对话
    ResultScreen = 7    -- 结算卡片
}

---
---角色枚举
---@enum sokulib.Character
soku.Character = {
    Reimu = 0,       -- 灵梦
    Marisa = 1,      -- 魔理沙
    Sakuya = 2,      -- 咲夜
    Alice = 3,       -- 爱丽丝
    Patchouli = 4,   -- 帕秋莉
    Youmu = 5,       -- 妖梦
    Remilia = 6,     -- 蕾米莉亚
    Yuyuko = 7,      -- 幽幽子
    Yukari = 8,      -- 紫
    Suika = 9,       -- 萃香
    Reisen = 10,     -- 铃仙
    Aya = 11,        -- 文
    Komachi = 12,    -- 小町
    Iku = 13,        -- 衣玖
    Tenshi = 14,     -- 天子
    Sanae = 15,      -- 早苗
    Cirno = 16,      -- 琪露诺
    Meiling = 17,    -- 美铃
    Utsuho = 18,     -- 空
    Suwako = 19,     -- 诹访子
    Random = 20,     -- _随机选人
    Namazu = 21      -- _大鲶鱼
}

---
---游戏场景枚举
---@enum sokulib.Scene
soku.Scene = {
    Logo = 0,            -- 上海爱丽丝Logo
    Opening = 1,         -- 开幕动画（黑屏白字）
    Title = 2,           -- 主菜单
    Select = 3,          -- 对战选人
    Battle = 5,          -- 对战
    Loading = 6,         -- 少女祈祷中
    SelectSV = 8,        -- 在线1P选人
    SelectCL = 9,        -- 在线2P选人
    LoadingSV = 10,      -- 在线1P加载
    LoadingCL = 11,      -- 在线2P加载
    LoadingWatch = 12,   -- 观战加载
    BattleSV = 13,       -- 在线1P对战
    BattleCL = 14,       -- 在线2P对战
    BattleWatch = 15,    -- 观战
    SelectStage = 16,    -- 故事模式选关
    Ending = 20          -- 结局动画
}

---
---对战场景枚举
---@enum sokulib.Stage
soku.Stage = {
    HakureiShrine = 0,          -- 博丽神社（倒塌）
    ForestOfMagic = 1,          -- 魔法森林
    CreekOfGenbu = 2,           -- 玄武涧
    YoukaiMountain = 3,         -- 妖怪之山
    MysteriousSeaOfClouds = 4,  -- 玄云海
    BhavaAgra = 5,              -- 有顶天
    Space = 6,                  -- 太空
    RepairedHakureiShrine = 10, -- 博丽神社（修复）
    KirisameMagicShop = 11,     -- 雾雨魔法店
    SDMClockTower = 12,         -- 红魔馆钟楼
    ForestOfDolls = 13,         -- 人偶之森
    SDMLibrary = 14,            -- 大图书馆
    Netherworld = 15,           -- 冥界
    SDMFoyer = 16,              -- 红魔馆大堂
    HakugyokurouSnowyGarden =17,-- 白玉楼雪庭
    BambooForestOfTheLost = 18, -- 迷途竹林
    ShoreOfMistyLake = 30,      -- 雾之湖畔
    MoriyaShrine = 31,          -- 守矢神社
    MouthOfGeyser = 32,         -- 间歇泉入口
    CatwalkInGeyser = 33,       -- 地下通道
    FusionReactorCore = 34,     -- 核融合炉心
    SDMClockTowerBG = 36,       -- 钟楼（背景变化）
    SDMClockTowerBlurry = 37,   -- 钟楼（模糊）
    SDMClockTowerSketch = 38    -- 钟楼（草图）
}

---
---碰撞判定类型枚举
---@enum sokulib.CollisionType
soku.CollisionType = {
    None = 0,               -- 无判定
    Hit = 1,                -- 命中
    Blocked = 2,            -- 打防
    Type3 = 3,              -- 当身技命中
    BulletHighDensity = 4,  -- 高密度弹幕相抵
    Type5 = 5,              -- 弹幕即刻销毁
    Grazed = 6,             -- 擦弹
    Armored = 7,            -- 霸体命中
    BulletSameDensity = 8,  -- 同级弹幕相抵
    Type9 = 9               -- 身代命中
}

----------------------------
-- 类定义
----------------------------

---
---二维向量类
---<br>2.9+添加四则运算支持：
---<br>表达式示例：v1+v2, v1-v2, 5-v1, -v2, v1*2, 2*v2, v1/2, v1==v2
---<br>添加__tostring支持，可直接print
---@class sokulib.Vector2f
---@field x number X坐标
---@field y number Y坐标
---@operator add(sokulib.Vector2f|number): sokulib.Vector2f
---@operator sub(sokulib.Vector2f|number): sokulib.Vector2f
---@operator mul(number): sokulib.Vector2f
---@operator div(number): sokulib.Vector2f
---@operator unm: sokulib.Vector2f
----@operator eq(sokulib.Vector2f): boolean
----@operator tostring(): string
soku.Vector2f = {}

---构造函数
---@param x number
---@param y number
---@return sokulib.Vector2f
---@nodiscard
function soku.Vector2f(x, y) end
---从指针建立
---@param ptr integer 指针地址
---@return sokulib.Vector2f
---@nodiscard
function soku.Vector2f.fromPtr(ptr) end
---
---计算向量模长
---@return number 长度
function soku.Vector2f:length() end
---
---计算向量角度
---@return number 角度 （-180~180）
function soku.Vector2f:angle() end
---
---旋转向量
---@param angle number 旋转角度
---@param center sokulib.Vector2f 旋转中心
function soku.Vector2f:rotate(angle, center) end
---
---计算二维叉积
---@param s sokulib.Vector2f 向量
---@param v sokulib.Vector2f 另一个向量
---@return number 叉积结果 （s.x*v.y - s.y*v.x）
function soku.Vector2f.cross(s, v) end
---
---计算向量点乘
---@param s sokulib.Vector2f 向量
---@param v sokulib.Vector2f 另一个向量
---@return number 点乘结果 （s.x*v.x + s.y*v.y）
function soku.Vector2f.dot(s, v) end

---
---检查功能键按下当帧
---@param keyId integer 键位编号
---@return boolean 是否发生按下
---@nodiscard
function soku.checkFKey(keyId) end

---
---播放音效
---@param sfxId integer 音效ID
function soku.playSE(sfxId) end
soku.playSFX = soku.playSE -- 别名支持

---
---播放BGM/停止当前BGM
---@param bgmPath? string|nil BGM文件路径（留空以停止播放）
---@param fadeOut? integer 渐出时间（帧数，默认1000）
---@param fadeIn? integer 渐入时间（帧数，默认500）
function soku.playBGM(bgmPath, fadeIn, fadeOut) end

---
---获取角色名称
---@param characterId integer|sokulib.Character 角色ID
---@return string? 角色名称
---@nodiscard
function soku.characterName(characterId) end

---
---注册玩家信息变化事件
---@param callback fun(info: battlelib.PlayerInfo):any 回调函数
---@return integer 注册ID
function soku.SubscribePlayerInfo(callback) end

---@alias cb2 fun(scene: guilib.Scene):integer?
---
---注册回调到场景切换事件
---@param callback fun(id: sokulib.Scene, scene: guilib.Scene):cb2|boolean? 回调函数
---@return integer 注册ID
function soku.SubscribeSceneChange(callback) end

---
---注册回调到游戏准备事件
---@param callback fun():any 回调函数
---@return integer 注册ID
function soku.SubscribeReady(callback) end

---
---注册回调到战斗事件
---@param callback fun():any 回调函数
---@return integer 注册ID
function soku.SubscribeBattle(callback) end

---
---取消回调注册
---@param callbackId integer 注册ID
function soku.UnsubscribeEvent(callbackId) end

return soku