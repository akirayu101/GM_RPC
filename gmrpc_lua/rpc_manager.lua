-- @hzyuxin
-- RPC Manager for handle rpc dispatch
local msgpack = require 'src/third/MessagePack'

RPC_Manager = luaClass()

function RPC_Manager:ctor()
end

function RPC_Manager:create()
	return RPC_Manager()
end

function RPC_Manager:register(rpc_handler)
	-- 注册一个rpc到rpc manager
	self[rpc_handler.eid] = rpc_handler
end

-- 消息转发，把对应的消息，发到对应的rpc_handler，然后进行执行
function RPC_Manager:call(eid, fun_name, ...)
	self[eid][fun_name](self[eid], ...)
end

function RPC_Manager:on_data(msg) 
	local unpack_msg = msgpack.unpack(msg)
	self:call(unpack(unpack_msg))
end