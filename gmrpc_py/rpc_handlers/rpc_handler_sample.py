__author__ = 'hzyuxin'
from rpc_base import RPC_Base

class RPC_Handler_Sample(RPC_Base):
    def __init__(self, poller):
        self.eid = 'sample'
        super(RPC_Handler_Sample, self).__init__(poller, self.eid)

    def test(self, arg1, arg2, arg3):
        self.client.test(1,2,3)

if __name__ == '__main__':
    rpc_sample = RPC_Handler_Sample(1)
    rpc_sample.test(1,2,3)


