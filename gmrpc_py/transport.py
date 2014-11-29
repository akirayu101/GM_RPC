__author__ = 'hzyuxin'

from twisted.internet.protocol import ClientFactory, Protocol
from twisted.internet import reactor
from PyQt4.QtCore import QThread
from PyQt4.QtCore import QCoreApplication
import sys


class Client(Protocol):

    def dataReceived(self, data):
        self.on_data(data)

    def send_data(self,data):
        self.transport.write(data)

class CustomClientFactory(ClientFactory):
    protocol = Client

    def __init__(self, on_data):
        self.proto = None
        self.on_data = on_data

    def buildProtocol(self, addr):
        self.proto = ClientFactory.buildProtocol(self, addr)
        self.proto.on_data = self.on_data
        return self.proto

class ClientThread(QThread):
    def __init__(self, port, on_data, sep):
        QThread.__init__(self)
        self.port = port
        self.on_data = on_data
        self.sep = sep

    def run(self):
        self.factory = CustomClientFactory(self.on_data)
        reactor.connectTCP('localhost', self.port, self.factory)
        reactor.run(installSignalHandlers=0)

    def send_data(self, data):
        self.factory.proto.send_data(data + self.sep + '\n')

if __name__ == '__main__':
    def helper(x):
        print x

    app = QCoreApplication(sys.argv)
    t = ClientThread(9000, helper)
    t.start()
    app.exec_()

