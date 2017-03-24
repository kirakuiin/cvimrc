#define BUFFER_SIZE 10

class Subject;
class Observer
{
    public:
        virtual void Update() = 0;

        virtual void Subscribe(Subject* sub);
        virtual void UnSubscribe();
        virtual ~Observer(){}

    protected:
        Observer(){}

    private:
        Subject*        _subject;
};

class Subject
{
    public:
        virtual ~Subject(){}
        virtual void Attach(Observer* );
        virtual void Detach(Observer* );
        virtual void Notify();

    protected:
        Subject(){}

    private:
        list<Observer*>         _observers;
};

class DataThread : public Thread, public Subject
{
    public:
        DataThread();
        virtual ~DataThread();

        virtual void run();

        void Start();
        void Finished();
        void Write(unsigned char* buffer, size_t size);

    private:
        bool                _readDone;
        bool                _isDone;
        unsigned char*      _buffer;
};

class Main : public Observer
{
    public:
        Main();
        ~Main();

        void Read(unsigned char* buffer, size_t size);
        void Write(unsigned char* buffer, size_t size);

        virtual void Update();

    private:
        DataThread*         _subject;
        bool                _writeDone;
        unsigned char*      _buffer;
};

