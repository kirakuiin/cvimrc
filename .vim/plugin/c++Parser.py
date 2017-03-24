import re

class CppParser:
    """ This class is used to parser c++ file """

    def __init__(self, filename):
        self._macroDict = {}
        self._classDict= {}
        self._methodList = []
        self._filename = filename

    def ParserHeaderFile(self):
        fin = open(self._filename, 'r')
        linenum = 0
        for line in fin:
            linenum += 1
            content = line.strip()
            
            macroPat = re.compile(r'#define\s+(\w+)')
            classPat = re.compile(r'(struct|class)\s+(\w+)[^;]+$')
            methodPat = re.compile(r'(inline)?\s*(virtual|static)?\s*(\w+)?\s*(\w+)\((.+)?\)')
            variablePat = re.compile(r'(.+)\s+(_\w+);')

            res = variablePat.match(content)

            if res != None:
                print(linenum, end=" : ")
                print(res.group(0+))

            else:
                print(linenum, ":")


a = CppParser('main.h')
a.ParserHeaderFile()



