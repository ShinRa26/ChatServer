import std.stdio, std.socket, std.string, core.thread;
import std.algorithm;

static ushort port = 9000;
static TcpSocket server;
__gshared auto eh = new EchoHandler();

/*
 * Main method for launching the server
 */
void main(string[] args)
{
    server = new TcpSocket();
    scope(exit)
    {
        server.shutdown(SocketShutdown.BOTH);
        server.close();
    }
    assert(server.isAlive);
    server.blocking = true;
    server.bind(new InternetAddress(port));
    writefln("Server online!\nListening on port: %d\n", port);
    server.listen(1);

    //Starts the Echo handler
    while(true)
    {
        auto h = new Handler(server.accept());
        eh.clients ~= h.client;
        h.start();
    }
}


/*
 * Handler class for each client
 * Processes the incoming text from them
 */
static class Handler : Thread
{
private:
    auto buffer = new ubyte[128];

    //Thread method
    void run()
    {
        //Buffer only for processing name
        auto nameBuffer = new ubyte[128];
        client.receive(nameBuffer);
        Thread.name = processBuffer(nameBuffer);

        //writefln("Echo length: %d", eh.clients.length);

        //Acknowledges the connection and takes name;
        writefln("%s has joined the server.", Thread.name);

        //Send welcome message!
        client.send("Welcome to the Server!\n");

        //Main loop for receiving messages
        while(true)
        {
            auto recv = client.receive(buffer);

            //If the client disconnects, break and destroy
            if(recv == -1 || recv == 0)
            {
                writefln("%s has left the server.", Thread.name);
                break;
            }
            else
            {
                auto msg = processBuffer(buffer);           
                writefln("[%s]: %s", Thread.name, msg);
                eh.echo(Thread.name, msg);
                clearBuffer(buffer);
            }
        }

        //Removes the client from the EchoHandler array
        auto index = countUntil(eh.clients, this.client);
        eh.clients = remove(eh.clients, index);
        
        //Destroys the handler once disconnected
        destroy(this);
    }

    //Converts the byte buffer to string
    string processBuffer(ubyte[] buffer)
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

    //Clears the buffer
    void clearBuffer(ubyte[] buffer) {buffer[0..$] = 0;}

//Generic contructors and stuff
public:
    this(Socket c)
    {
        super(&run);
        this.client = c;
    }

    ~this(){}

    Socket client;
}



/*
 * Class for echoing each received message to all clients.
 * There must be a better way...
 */
static class EchoHandler
{
public:
    Socket[] clients;

    this(){}
    ~this(){}

    void echo(string name, string msg)
    {
        foreach(c; clients)
        {
            if(c is null)
                continue;
            else
            {
                auto s = format("[%s]: %s", name, msg);
                c.send(s);
            }
        }
    }

private:
    auto buffer = new ubyte[128];

    string processBuffer(ubyte[] buffer)
    {
        char[] c;

        foreach(b; buffer)
        {
            if(b ==0 || b == 10)
                break;
            else
                c~=b;
        }

        auto s = cast(string)c;
        return s;
    }

    void clearBuffer(ubyte[] buffer){buffer[0..$] = 0;}
}