import re

class cppPattern():
    """ This class is used to match specific pattern"""
    
    MACRO   = 0
    CLASS   = 1
    BBEGIN  = 2
    BEND    = 3
    METHOD  = 4
    VAR     = 5
    PUB     = 6
    PRI     = 7
    PRO     = 8

    def __init__(self):

        macroPat = re.compile(r'#define\s+(\w+)')
        classIdPat = re.compile(r'(struct|class)\s+(\w+)[^;]*?$')
        blockBegin = re.compile(r'(\{)\s*$')
        blockEnd = re.compile(r'(\};)\s*$')
        methodPat = re.compile(r'(inline)?\s*(virtual|static)?\s*(\w+)??\s*(~?\w+)\((.+)?\)')
        variablePat = re.compile(r'(.+)\s+(_\w+);')
        publicPat = re.compile(r'(public)\s*:')
        privatePat = re.compile(r'(private)\s*:')
        protectedPat = re.compile(r'(protected)\s*:')

        self._typeList = []

        self._typeList.append(macroPat)
        self._typeList.append(classIdPat)
        self._typeList.append(blockBegin)
        self._typeList.append(blockEnd)
        self._typeList.append(methodPat)
        self._typeList.append(variablePat)
        self._typeList.append(publicPat)
        self._typeList.append(privatePat)
        self._typeList.append(protectedPat)

    def match(self, pType, text):
        res = self._typeList[pType].search(text)
        if res != None:
            return res.groups()
        return ()

class cppParser:
    """ This class is used to parser c++ file """

    def __init__(self, filename):
        self._macroDict = {}
        self._classDict= {}
        self._methodList = []
        self._varList = []
        self._currentClass = None
        self._accessModifier = None
        self._classType = ""

        with open(filename) as f:
            self._content = f.read()

    def Reopen(self, filename):
        """ Reopen one file """
        with open(filename) as f:
            self._content = f.read()

    def ParseHeaderFile(self):

        linenum = 0
        hasClass = False
        hasModifier = False

        total_content = self._content.split('\n')

        for line in total_content:
            linenum += 1
            content = line.strip()

            self.MatchOnePattern(content, linenum, cppPattern.MACRO)
            self.MatchOnePattern(content, linenum, cppPattern.CLASS)
            self.MatchOnePattern(content, linenum, cppPattern.METHOD)
            self.MatchOnePattern(content, linenum, cppPattern.VAR)

            if not hasClass:
                hasClass = self.MatchOnePattern(content, linenum, cppPattern.BBEGIN)
            else: 
                self.MatchOnePattern(content, linenum, cppPattern.PUB)
                self.MatchOnePattern(content, linenum, cppPattern.PRO)
                self.MatchOnePattern(content, linenum, cppPattern.PRI)

                if(True == self.MatchOnePattern(content, linenum,
                    cppPattern.BEND)):
                    hasClass = False

    
    def MatchOnePattern(self, text, line, patternType):
        """ Match a specific pattern """

        pattern = cppPattern()
        res = pattern.match(patternType, text)

        if patternType == cppPattern.MACRO:
            if res != ():
                self._macroDict[res[0]] = line

        elif patternType == cppPattern.CLASS:
            if res != ():
                self._classDict[res[1]] = line
                self._currentClass = res[1]
                self._classType = res[0]

        elif patternType == cppPattern.METHOD:
            if res != ():
                self._methodList.append((self._currentClass, self._accessModifier, line, res))

        elif patternType == cppPattern.VAR:
            if res != ():
                self._varList.append((self._currentClass, self._accessModifier, line, res))

        elif patternType == cppPattern.BBEGIN:
            if res != ():
                if self._classType == 'class':
                    self._accessModifier = "private"
                else:
                    self._accessModifier = "public"
                return True 

        elif patternType == cppPattern.BEND:
            if res != ():
                self._currentClass = None
                self._accessModifier = None
                return True

        elif patternType == cppPattern.PUB:
            if res != ():
                self._accessModifier = 'public'

        elif patternType == cppPattern.PRI:
            if res != ():
                self._accessModifier = 'private'

        elif patternType == cppPattern.PRO:
            if res != ():
                self._accessModifier = 'protected'

        return False
    
    def GetMacro(self):
        return self._macroDict

    def GetClass(self):
        return self._classDict

if __name__ == '__main__':
    a = cppParser('main.h')
    a.ParseHeaderFile()
    print(a.GetMacro())
    print(a.GetClass())





