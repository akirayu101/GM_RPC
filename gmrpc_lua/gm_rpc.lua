-- @hzyuxin
-- 新gm架构的rpc总入口
-- 新添加业务需要
-- 1. 更改本文件中的register_rpc_handlers接口
-- 2. 增加rpc_handlers文件夹下的rpc handler

require "src/new_gm/poller.lua"
require "src/new_gm/rpc_base.lua"
require "src/new_gm/rpc_manager.lua"
require "src/new_gm/rpc_handlers/rpc_handler_sample.lua"

GM_RPC = luaClass()

function GM_RPC:ctor()
	-- 初始化rpc manager
	self.rpc_manager = RPC_Manager:create()
	local function on_data(...) 
		self.rpc_manager:on_data(...)
	end
	-- 创建poller
	self.poller = GMPoller(on_data, '###', 9000)
	self:register_rpc_handlers()
end

function GM_RPC:create()
	return GM_RPC()
end

function GM_RPC:register_rpc_handlers()
	local sample = RPC_Handler_Sample:create(self.poller)
	self.rpc_manager:register(sample)
end

function GM_RPC:update()
	self.poller:poll()
end

local function test()

	local gm_rpc = GM_RPC:create()
	while 1 do 
		gm_rpc:update()
	end

end


