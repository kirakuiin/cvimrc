#include <abprec.h>
#include <ncutil.h>

#include "main.h"

void
Observer::Subscribe(Subject* sub)
{
    _subject = sub;
    _subject->Attach(this);
}

void
Observer::UnSubscribe()
{
    if (_subject) {
        _subject->Detach(this);
        _subject = NULL; 
    }
}

void
Subject::Attach(Observer* ob)
{
    _observers.push_back(ob);
}
 
void
Subject::Detach(Observer* ob)
{
    _observers.remove(ob);
}
 
void
Subject::Notify()
{
    for (list<Observer*>::iterator iter = _observers.begin()
            ; iter != _observers.end(); ++iter) {
        (*iter)->Update();
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//class DataThread
// 

DataThread::DataThread()
    : _readDone(false)
    , _isDone(true)
    , _buffer(NULL)
{
}

DataThread::~DataThread()
{
}

void
DataThread::run()
{
    while (_isDone) {
        Sleep(10);

        if (_readDone) {
            Sleep(2000);
            printf("write-msg=%s\n", _buffer);
            _readDone = false;
            Notify();
        }
    }
    printf("thread end!\n");
}

void
DataThread::Start()
{
    start();
}

void
DataThread::Finished()
{
    _isDone = false;
    while (this->isAlive()) {
        Sleep(10);
    }
}

void
DataThread::Write(unsigned char* buffer, size_t size)
{
    _buffer = buffer; 
    _readDone = true;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//class Main
// 

Main::Main()
    : _subject(NULL)
    , _writeDone(true)
    , _buffer(NULL)
{
    _subject = new DataThread();
    _subject->Start();
    this->Subscribe(_subject);
}

Main::~Main()
{
    this->UnSubscribe();
    _subject->Finished();
    delete _subject;
}

void
Main::Update()
{
    _writeDone = true;
}

void
Main::Read(unsigned char* buffer, size_t size)
{
    Sleep(500);
    char* msg = "hello lm!";
    memcpy(buffer, msg, size);
    printf("read-msg=%s\n", msg);
}

void
Main::Write(unsigned char* buffer, size_t size)
{
    while (true) {
        if (_writeDone) {
            _subject->Write(buffer, size);
            _writeDone = false;
            break;
        }
        Sleep(10);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//class main
// 

void initDll (void)
{
	static AppContext appCtx (AB_APPLICATION_NAME);
	AppContext::setInstance (&appCtx);
	AppSettings* appSettings = AppSettings::getCFLAppSettings ();    
	LibManager::getInstance ()->initLibs (appSettings, &appCtx, 0);
	
    try {
        ::ncInitXPCOM ();
    }
    catch (Exception& e) {
        printMessage(e.toFullString());
        exit(0);
    }
}

void releaseDll (void)
{
	::ncShutDownXPCOM ();
	
	AppSettings::deleteCFLAppSettings ();
	LibManager::getInstance ()->closeLibs (0);
	LibManager::delInstance ();
}

int main(void)
{
    initDll();
    try {

        Main m;
        Sleep(1000);
        int i = 0;
        unsigned char buffer[BUFFER_SIZE];
        while(i < 10) {
            m.Read(buffer, BUFFER_SIZE);
            m.Write(buffer, BUFFER_SIZE);
            ++i;
        }
    }
    catch (Exception& e) {
        printMessage(e.toFullString());
    }
    releaseDll();
    return 0;
}
