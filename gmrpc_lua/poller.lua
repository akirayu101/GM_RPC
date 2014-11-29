-- @hzyuxin
-- gm poller for msgpack

-- 这里面不涉及pack和unpack过程，那个可以抽象到data handler里面去做，这里就做poll这个动作
-- 只有一个连接，许允许多连接，所以每次select一个就好了
local socket = require("src/third/socket.lua")
require("src/base/extend.lua")

GMPoller = luaClass()

function GMPoller:ctor(on_data, msg_sep, port)

	self.read_buffer = ''  -- 临时存接受数据的buffer
	self.write_buffer = {} -- 临时存发送数据的buffer
	self.msg_sep = msg_sep -- 每个数据包的分隔符
	self.on_data = on_data -- 处理data的函数
	self.port = port       -- 绑定的端口

	self.socket_fd = socket.bind("0.0.0.0", self.port)
	self.socket_fd:settimeout(0) -- 非阻塞
	self.gm_fd = nil

end

function GMPoller:create(on_data, msg_sep, port)
	return GMPoller(on_data, msg_sep, port)
end

function GMPoller:poll()
	self.gm_fd = self.socket_fd:accept() or self.gm_fd 
	if self.gm_fd == nil then 
		return false
	else
		self:read()
		self:write()
		return true
	end
end

function GMPoller:write()
	-- 增加sep方便gm端分段
	for k, v in pairs(self.write_buffer) do 
		self.write_buffer[k] = v .. self.msg_sep
	end
	-- 发送消息
	local msg = table.concat(self.write_buffer, '')

	if msg ~= '' then 
		self.gm_fd:send(msg)
	end
	-- 重置buffer
	self.write_buffer = {}
end

function GMPoller:send(msgpack_data)
	self.write_buffer[#self.write_buffer+1] = msgpack_data
end

function GMPoller:read()
	local read_fd = socket.select({self.gm_fd},nil,0.01)
	for _, v in ipairs(read_fd) do
		local msg = v:receive()
		if msg ~= nil then
			self:handle_msg(msg)
		end
	end
end

function GMPoller:handle_msg(msg)
	local msg_table = string.split(msg, self.msg_sep)

	if #msg_table == 1 then 
		self.read_buffer = self.read_buffer .. msg_table[1]
	else
		msg_table[1] = self.read_buffer .. msg_table[1]
		self.read_buffer = msg_table[#msg_table]

		for i = 1, #msg_table - 1 do 
			self.on_data(msg_table[i])
		end
	end
end