__author__ = 'hzyuxin'

import string

class Data_Handler(object):
    def __init__(self, sep, on_data):
        self.sep = sep
        self.on_data = on_data
        self.buffer = ''

    def __call__(self, data):
        data = string.split(data, self.sep)

        if len(data) == 1:
            self.buffer += data[0]
        else:
            data[0] = self.buffer + data[0]
            self.buffer = data[-1]

            for data in data[:-1]:
                self.on_data(data)


if __name__ == '__main__':
    def on_data(data):
        print data

    data_handler = Data_Handler('###', on_data)
    data_handler('aaaa###aaab###ccc###')