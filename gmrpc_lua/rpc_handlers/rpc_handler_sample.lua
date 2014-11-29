-- @hzyuxin
-- RPC base, for transform remote call

local msgpack = require 'src/third/MessagePack'

RPC_Handler_Sample = luaClass(RPC_Base)

function RPC_Handler_Sample:create(poller)
	local eid = 'sample'
	return RPC_Handler_Sample(poller, eid)
end

function RPC_Handler_Sample:test(arg1, arg2, arg3)
	print("arg1  " .. arg1)
	print("arg2  " .. arg2)
	print("arg3  " .. arg3)
end

local function test()
	local poller = {}
	poller.send = function(self, ...)
		print(unpack(msgpack.unpack(...)))
	end

	local rpc_sample = RPC_Handler_Sample:create(poller)

	rpc_sample:transform_dispatch()
	rpc_sample:test(1,2,3)
	rpc_sample.server.test(1,2,3)
end