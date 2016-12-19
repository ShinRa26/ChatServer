import std.stdio, std.string, std.socket, core.thread, std.concurrency;

static ushort port = 9000;
static string ip = "127.0.0.1";
Socket client;
static auto buffer = new ubyte[128];

void main(string[] args)
{
    client = new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
    auto addr = getAddress(ip, port);
    
    try
    {
        auto name = getName();
        client.connect(addr[0]);
        client.send(name);

        //Receive welcome message
        client.receive(buffer);
        auto ans = processBuffer(buffer);
        writeln(ans);

        //Flushes the buffer
        clearBuffer(buffer);
        
        //Spawns a thread to process the other inputs
        auto listener = new ClientListener(client);
        listener.start();

        //Main loop
        while(true)
        {
            //writef("[%s]: ", name);
            auto s = readln();
            client.send(s);
        }
    }
    catch(Exception) {writeln("Unable to connect: Server offline."); return;}
}

static string getName()
{
    while(true)
    {
        write("Enter chat name: ");
        auto s = readln();
        
        if(s == "" || s is null)
            writeln("That is not a valid name.");
        else
            return s[0..s.length-1];
    }
}

static string processBuffer(ubyte[] buffer)
{
    char[] c;

    foreach(b; buffer)
    {
        if(b == 0 || b == 10)
            break;
        else    
            c~=b;
    }

    auto s = cast(string) c;
    return s;
}

static void clearBuffer(ubyte[] buffer) {buffer[0..$] = 0;}


//Small class for processing other user text
static class ClientListener : Thread
{
public:
    this(Socket client)
    {
        super(&run);
        this.client = client;
    }

    ~this(){}

private:
    Socket client;

    void run()
    {
        while(true)
        {
            client.receive(buffer);
            auto msgs = processBuffer(buffer);
            writeln("\n"~msgs~"\n");
            clearBuffer(buffer);
        }
    }
}