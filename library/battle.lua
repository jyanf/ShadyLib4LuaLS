---@meta battle

---对战战斗系统核心模块
---
---@class battlelib
---@field manager battlelib.Manager 对局管理器实例
---@field gameParams battlelib.GameParams 对局参数实例
---@field activeWeather integer 当前生效的天气ID
---@field displayedWeather integer 当前预报的天气ID
battle = {}

----------------------------
-- 基础数据结构
----------------------------

---
---玩家基本信息
---@class battlelib.PlayerInfo
---@field character sokulib.Character 角色号（只读）
---@field teamId integer 阵营ID（1P=0，2P=1）
---@field isRight integer 是否右方（1P=0，2P=1）
---@field paletteId integer 配色号（0~7, 只读）
---@field palette integer 配色号（0~7, 只读）
---@field deckId integer 卡组ID（只读）
---@field inputType integer 角色控制类型
battle.PlayerInfo = {}

----------------------------
-- 游戏参数类
----------------------------

---
---对局参数
---@class battlelib.GameParams
---@field difficulty integer 难度等级
---@field stageId sokulib.Stage 当前舞台ID
---@field musicId integer BGM编号
---@field player1 battlelib.PlayerInfo 玩家1信息
---@field player2 battlelib.PlayerInfo 玩家2信息
---@field randomSeed integer 随机种子（只读）
battle.GameParams = {}

---
---物体渲染参数
---@class battlelib.RenderInfo
---@field color integer ARGB格式颜色值
---@field shaderType integer 着色器类型（0=正常，1=去色）
---@field shaderColor integer 着色器叠加颜色
---@field scale sokulib.Vector2f 缩放比例
---@field xRotation number X轴旋转角
---@field yRotation number Y轴旋转角
---@field zRotation number Z轴旋转角
battle.RenderInfo = {}

---构造函数
---@return battlelib.RenderInfo
function battle.RenderInfo() end



---对战物体基类
---@class battlelib.ObjectBase
---@field ptr integer 内存指针
---@field position sokulib.Vector2f 场地/屏幕位置坐标
---@field speed sokulib.Vector2f 当前运动速度
---@field gravity sokulib.Vector2f 重力加速度
---@field direction integer 面向方向（1=右，-1=左）
---@field renderInfo battlelib.RenderInfo 物体渲染参数
---@field collisionType sokulib.CollisionType 当前判定类型
---@field collisionLimit integer 剩余判定次数
---@field actionId integer 当前动作ID
---@field sequenceId integer 动作序列ID
---@field poseId integer 当前poseID
---@field poseFrame integer 当前pose帧数
---@field currentFrame integer 序列停留帧数
---@field sequenceSize integer 序列pose总数
---@field poseDuration integer 当前pose时长
---@field opponent battlelib.Player 引用对手
---@field owner battlelib.Player 引用归属玩家
---@field ally battlelib.Player 引用友方（反射弹幕相关）
---@field hp integer 当前生命值
---@field maxHp integer 生命上限
---@field hitStop integer hitstop帧数
---@field groundHeight number 查询所处x位置的地面高度
battle.ObjectBase = {}

---
---创建特效
---@param id integer 特效ID
---@param x number X坐标
---@param y number Y坐标
---@param direction? integer 生成方向（1=右，-1=左，默认1）
---@param layer? integer 渲染层级（默认1）
---@return guilib.Effect
function battle.ObjectBase:createEffect(id, x, y, direction, layer) end

---
---设置动作、序列
---@param actionId integer 动作ID（参考角色动作表）
---@param sequenceId integer 序列ID
function battle.ObjectBase:setActionSequence(actionId, sequenceId) end
---
---设置动作（可能中断动画）
---@param actionId integer 目标动作ID
function battle.ObjectBase:setAction(actionId) end
---
---切换动作子序列（保持当前动作）
---@param sequenceId integer 序列ID
function battle.ObjectBase:setSequence(sequenceId) end
---
---切换pose
---@param poseId integer 目标pose
function battle.ObjectBase:setPose(poseId) end
---
---向后推进动画帧
---@return boolean 是否到达Seq末端或为循环Seq
function battle.ObjectBase:advanceFrame() end
---
---重置物理状态（清空速度/重力）
function battle.ObjectBase:resetForces() end
---
---检测触地与否
---@return integer 0=空中，1=地面
function battle.ObjectBase:isOnGround() end

---
---获取额外攻击框参数
---@return integer left 左边界
---@return integer top 上边界
---@return integer right 右边界
---@return integer bottom 下边界
---@return integer angle 旋转角度
---@return integer anchorX 锚点X
---@return integer anchorY 锚点Y
---@nodiscard
function battle.ObjectBase:getHitBoxData() end

---
---设置动态攻击框
---@param left? integer 左边界（默认0）
---@param top? integer 上边界（默认0）
---@param right? integer 右边界（默认0）
---@param bottom? integer 下边界（默认0）
---@param angle? integer 框体旋转（默认0）
---@param anchorX? integer 旋转锚点X（默认0）
---@param anchorY? integer 旋转锚点Y（默认0）
function battle.ObjectBase:setHitBoxData(left, top, right, bottom, angle, anchorX, anchorY) end



---对战物体
---@class battlelib.Object : battlelib.ObjectBase
---@field lifetime integer 是否存活（0=立即销毁，1=存活）
---@field parentObjectB battlelib.Object? 父物体（如果有）
---@field parentPlayerB battlelib.Player? 父玩家（如果有）
battle.Object = {}

---
---创建对战物体
---@param actionId integer 物体动作ID
---@param x number X坐标
---@param y number Y坐标
---@param direction? integer 朝向（1=右，-1=左，默认1）
---@param layer? integer 图层层级（1=前景，-1=背景，默认1）
---@param customData string ！！初始化数据
---@return battlelib.Object
function battle.Object:createObject(actionId, x, y, direction, layer, customData) end

---
---创建子物体（配合getChildrenB/parentObjectB）
---@param id integer 物体动作ID
---@param x number X坐标
---@param y number Y坐标
---@param direction? integer 朝向（1=右，-1=左，默认1）
---@param layer? integer 图层层级（1=前景，-1=背景，默认1）
---@param customData string ！！初始化数据
---@return battlelib.Object
function battle.Object:createChild(id, x, y, direction, layer, customData) end
---
---获取所有子对象的列表
---@return table<integer, battlelib.Object> 子对象表
function battle.Object:getChildrenB() end
---
---处理擦弹事件（仍需手动消除弹幕）
---@param grazeDensity integer 最大擦弹抗性
---@return boolean 是否超过抗性
function battle.Object:checkGrazed(grazeDensity) end

---
---处理弹幕相杀事件（仍需手动消除弹幕）
---@param collisionDensity integer 最大相杀回数
---@return boolean 是否超过回数
function battle.Object:checkProjectileHit(collisionDensity) end

---
---处理受击时散落天气玉（仍需手动消除弹幕）
---@param onlyAirHit boolean 仅吹飞时消失
---@param bigCrystals integer 生成大水晶数量
---@param smallCrystals integer 生成小水晶数量
---@param offsetX? number 生成位置X轴偏移（默认0）
---@param offsetY? number 生成位置Y轴偏移（默认0）
---@return boolean 是否发生受击
function battle.Object:checkTurnIntoCrystal(onlyAirHit, bigCrystals, smallCrystals, offsetX, offsetY) end

---
---设置拖尾效果
---@param actionId integer 拖尾图ID
---@param width number 拖尾半径
---@param length integer 拖尾长度
---@param unknown integer （需要大于0，填入1即可）
---@param blendMode integer 混合模式（1=正常，2=滤色，3=相减，4=相乘）
function battle.Object:setTail(actionId, width, length, unknown, blendMode) end

---
---读取额外float数据
---@param count integer 要读取的字节数
---@return string 数据字节串（需自行解析）
function battle.Object:getCustomData(count) end


---角色控制类
---@class battlelib.Player : battlelib.ObjectBase
---@field character sokulib.Character 角色号（只读）
---@field spellStopCounter integer 设置符卡发动时停
---@field groundDashCount integer 地面冲刺计时
---@field airDashCount integer 空中冲刺次数
---@field currentSpirit integer 当前灵力值（只读）
---@field timeStop integer 时停剩余帧数（只读）
---@field comboRate integer 连击rate（只读）
---@field comboCount integer 当前连击数（只读）
---@field comboDamage integer 连击累计伤害（只读）
---@field comboLimit integer 连击limit（只读）
---@field untech integer 不可受身帧数（只读）
---@field skillCancelCount integer 苍天必杀取消次数
---@field meleeInvulTimer integer 近战无敌剩余帧数
---@field grabInvulTimer integer 投技无敌剩余帧数
---@field projectileInvulTimer integer 弹幕无敌剩余帧数
---@field grazeTimer integer 擦弹状态剩余帧数
---@field confusionDebuffTimer integer 混乱状态剩余帧数
---@field SORDebuffTimer integer 天气封印剩余帧数
---@field healCharmTimer integer 护符回血剩余帧数
---@field handCount integer 当前手卡数量（只读）
battle.Player = {}

----------------------------
---通用处理
----------------------------

---处理地面更新
---@return boolean 是否因地形变化离地
function battle.Player:applyGroundMechanics() end
---
---处理空中更新
---@return boolean 是否触发着陆
function battle.Player:applyAirMechanics() end
---
---更新地面行走
---@param speed number 行走速度
---@return boolean 
function battle.Player:updateGroundMovement(speed) end
---
---检测地面接触状态
---@return boolean 是否落地
---@nodiscard
function battle.Player:isGrounded() end

---@deprecated 使用checkTurnAround替代
function battle.Player:unknown487C20() end
---
---处理转身
function battle.Player:checkTurnAround() end

----------------------------
-- 输入与动作系统
----------------------------
---
---获取招式取消级
---@param actionId integer 招式所在的动作ID
---@return integer 取消级
---@nodiscard
function battle.Player:getMoveLock(actionId) end
---
---处理长按大跳
---@return boolean 是否成功大跳
function battle.Player:handleHJ() end
---
---处理输入大跳
---@param actionLock integer 当前动作被取消级
---@param moveCancelable integer 可移动取消
---@return boolean 是否成功大跳
function battle.Player:handleHJInput(actionLock, moveCancelable) end
---
---处理地面冲刺（前/后）
---@param actionLock integer 当前动作被取消级
---@param moveCancelable integer 可移动取消
---@return boolean 是否成功冲刺
function battle.Player:handleGroundDash(actionLock, moveCancelable) end
---
---处理地面DD
---@return boolean 是否成功发动
function battle.Player:handleGroundBE() end
---
---处理空中DD
---@return boolean 是否成功发动
function battle.Player:handleAirBE() end
---
---处理前冲空中冲刺
---@param actionLock integer 当前动作被取消级
---@param moveCancelable integer 可移动取消
---@param allowedAirMoves integer 允许空中机动次数
---@param airDashCancelSeq integer 空中冲刺取消序列
---@return boolean 是否发生成功
function battle.Player:handleFwdAirDash(actionLock, moveCancelable, allowedAirMoves, airDashCancelSeq) end
---
---处理后撤空中冲刺
---@param actionLock integer 当前动作被取消级
---@param moveCancelable integer 可移动取消
---@param allowedAirMoves integer 允许空中机动次数
---@param airDashCancelSeq integer 空中冲刺取消序列
---@return boolean 是否发生冲刺
function battle.Player:handleBackAirDash(actionLock, moveCancelable, allowedAirMoves, airDashCancelSeq) end
---
---处理普通飞行
---@param actionLock integer 当前动作取消级
---@param moveCancelable integer 可移动取消
---@param allowedAirMoves integer 允许空中机动次数
---@return boolean 是否进入飞行
function battle.Player:handleNormalFlight(actionLock, moveCancelable, allowedAirMoves) end
---
---处理切卡操作
---@return boolean 是否发生切换
---@nodiscard
function battle.Player:handleCardSwitch() end
---
---刷新输入缓冲相关
function battle.Player:unknown46d950() end
----------------------------
-- 卡杀系统
----------------------------

---获取手卡ID
---@param index integer 手卡索引
---@return integer 卡牌ID
---@nodiscard
function battle.Player:handGetId(index) end
---
---获取手卡消耗
---@param index integer 手卡索引
---@return integer 耗卡量
---@nodiscard
function battle.Player:handGetCost(index) end
---
---使用系统卡
---@param actionLock integer 动作锁定时间
---@return boolean 是否已使用
function battle.Player:useSystemCard(actionLock) end
--
---检测符卡是否足够消耗
---@param index integer 手卡索引
---@return boolean 是否足够
---@nodiscard
function battle.Player:canActivateCard(index) end
---
---使用符卡
---@param actionId integer 符卡动作ID
---@param actionLock integer 动作被取消级
function battle.Player:useSpellCard(actionId, actionLock) end
---
---符卡使用事件（影响相关天气）
function battle.Player:eventSpellUse() end
---
---检测灵力是否足够（>1）
---@return boolean 是否足够
---@nodiscard
function battle.Player:canSpendSpirit() end
---
---使用必杀
---@param actionId integer 技能动作ID
---@param actionLock integer 动作被取消级
function battle.Player:useSkill(actionId, actionLock) end
---
---必杀使用事件（影响相关天气）
function battle.Player:eventSkillUse() end

----------------------------
---弹幕创建相关
----------------------------
---
---计算射击角度，存入field0x7f0
---@param highLimit number 角度上界
---@param lowLimit number 角度下界
---@return number 发射角度（极坐标系）
function battle.Player:decideShotAngle(highLimit, lowLimit) end
---
---@deprecated 使用decideShotAngle替代
function battle.Player:updateAirMovement(a1, a2) end
---
---创建对战物体
---@param actionId integer 物体动作ID
---@param x number X坐标
---@param y number Y坐标
---@param direction? integer 生成方向（1=右，-1=左，默认1）
---@param layer? integer 图层层级（1=前景，-1=背景，默认1）
---@param customData string ！！初始化数据
---@return battlelib.Object
function battle.Player:createObject(actionId, x, y, direction, layer, customData) end
---
--增加卡槽符力
---@param value integer 增加量（500=一张）
function battle.Player:addCardMeter(value) end
---
---播放音效
---@param sfxId integer 角色音效ID
function battle.Player:playSFX(sfxId) end
---
---播放符卡背景特效（暗转）
---@param id integer 背景图ID
---@param duration integer 持续时间（帧），一般为2
function battle.Player:playSpellBackground(id, duration) end
---
---消费灵力
---@param cost integer 消费量（200=一灵）
---@param delay integer 回灵延迟帧数
function battle.Player:consumeSpirit(cost, delay) end
---
--消费手卡
---@param index integer 手卡索引
---@param costOverride? integer 重设消耗值（0=使用默认）
---@param cardNameTimer? integer 卡名显示时间（默认60帧）
function battle.Player:consumeCard(index, costOverride, cardNameTimer) end
---
---引起天气预报滚动
function battle.Player:eventWeatherCycle() end



---对局管理器
---@class battlelib.Manager
---@field player1 battlelib.Player 玩家1引用
---@field player2 battlelib.Player 玩家2引用
---@field frameCount integer 当前阶段帧数（只读）
---@field matchState integer 对局阶段（只读）
battle.Manager = {}



----------------------------
-- 全局函数
----------------------------

---生成随机整数（基于对战种子）
---@param maxPlusOne integer 随机范围限制（负数为不限）
---@return integer [0, maxPlusOne)范围内的随机整数
---@nodiscard
function battle.random(maxPlusOne) end

---@alias cbp1 fun(actId: integer, player: battlelib.Player, data: table): boolean?
---@alias cbp2 fun(player: battlelib.Player, data: table)
---附加角色逻辑
---@param char sokulib.Character 目标角色
---@param update?       cbp1? 动作更新函数
---@param initAction?   cbp1? 动作初始化回调
---@param initialize?   cbp2? 开局回调
function battle.replaceCharacter(char, update, initAction, initialize) end
---
---@alias cbo1 fun(actId: integer, obj: battlelib.Object, data: table): boolean?
---@alias cbo2 fun(obj: battlelib.Object, data: table)
---附加物体逻辑
---@param char sokulib.Character 目标角色
---@param update?       cbo1? 物体更新回调
---@param initAction?   cbo1? 物体初始化回调
---@param initialize?   cbo2? 开局回调
function battle.replaceObjects(char, update, initAction, initialize) end



return battle