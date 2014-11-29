-- @hzyuxin
-- RPC base, for transform remote call
-- sample 
-- rpc.foo(1,2,3) --> msgpack [rpc.eid, 'foo', 1, 2, 3]
local msgpack = require 'src/third/MessagePack'

RPC_Base = luaClass()

function RPC_Base:ctor(poller, eid)
	self.poller = poller
	self.eid = eid
	self.server = {}
	self.server.parent = self
	self:transform_dispatch()
end

-- 注意，rpc的实体handler，不应该包括任何的数据成员!!!!!!
function RPC_Base:transform_dispatch()
	local function transform_index(o, key)
		rawset(o, key, 
			function(...)
				local msg = msgpack.pack({self.eid, key, ...})
				o.parent.poller:send(msg)

			end
			)
		return o[key]
	end

	setmetatable(self.server, {__index = transform_index})
end