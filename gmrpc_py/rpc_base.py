__author__ = 'hzyuxin'

import msgpack

class RPC_Base(object):
    def __init__(self, poller, eid):
        self.poller = poller
        self.eid = eid
        class Client(object):
            def __init__(self, rpc_base):
                self.rpc_base = rpc_base

            def __getattr__(self, key):
                def _(*param):
                    msg =  [self.rpc_base.eid, key] + list(param)
                    msg = msgpack.packb(msg)
                    poller.send_data(msg)
                return _
        self.client = Client(self)

if __name__ == '__main__':
    class helper(object):
        def send_data(self, msg):
            print msgpack.unpackb(msg)
    poller = helper()
    rpc_base = RPC_Base(poller, "test_rpc")
    rpc_base.client.call(1,2,3)

