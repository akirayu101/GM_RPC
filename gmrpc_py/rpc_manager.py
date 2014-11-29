__author__ = 'hzyuxin'

import msgpack
class RPC_Manager(object):
    def __init__(self):
        pass

    def register(self, rpc_handler):
        setattr(self, rpc_handler.eid, rpc_handler)

    def call(self, eid, fun_name, *param):
        getattr(getattr(self, eid), fun_name)(*param)

    def on_data(self, data):
        unpack_msg = msgpack.unpackb(data)
        self.call(*unpack_msg)

if __name__ == "__main__":
    def bar(eid, fun_name, arg1, arg2, arg3):
        print eid, fun_name, arg1, arg2, arg3
    def foo(eid, fun_name, *param):
        bar(eid, fun_name, *param)
    foo(*[1,2,3,4,5])
