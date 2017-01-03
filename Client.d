module Client;

import std.string, core.thread, std.concurrency, std.stdio, std.conv;
import core.sync.mutex, core.sync.condition;
import gio.socket, gio.InetSocketAddress;

import ClientGUI, gtk.Main;

static string ip = "127.0.0.1";
static ushort port = 9000;
Socket client;
string name;

class Client
{
public:
    string name = "Not assigned";
    string ip = "127.0.0.1";
    ushort port = 9000;
    Socket self;
    InetSocketAddress addr;

    this()
    {
        this.self = new Socket(GSocketFamily.IPV4, GSocketType.STREAM, GSocketProtocol.TCP);
        this.addr = new InetSocketAddress(this.ip, this.port);
    }

    ~this(){}
}

class ClientListener : Thread
{
public:
    this(Socket client, ClientGUI gui)
    {
        super(&run);
        this.client = client;
        this.gui = gui;
        this.bufSize = 512;
    }
    ~this(){}

private:
    Socket client;
    ClientGUI gui;
    char[] buffer;
    uint bufSize;

    void run()
    {
        buffer = new char[bufSize];
        buffer[0..buffer.length] = 0;
        while(true)
        {
            ushort pos = 0;
            client.receive(buffer, null);
            
            if(buffer.length == 0)
                continue;

            auto newBuffer = processBuffer(buffer);
            gui.update(newBuffer);
            clearBuffer(newBuffer);
        }
    }
}

static char[] processBuffer(char[] buffer)
{
    ushort pos = 0;

    foreach(c; buffer)
    {
        if(c != 0)
            pos++;
    }

    auto newBuffer = buffer[0..pos];
    return newBuffer;
}

static char[] clearBuffer(char[] buffer){buffer[0..$] = 0; return buffer;}

void main(string[] args)
{
    uint bufSize = 512;

    Main.init(args);
    auto clientHolder = new Client();
    auto client = clientHolder.self;
    auto nw = new NameWindow();
    Main.run();

    clientHolder.name = nw.text;
    destroy(nw); //Kills the name window as it is no longer needed.

    try
    {
        auto buffer = new char[bufSize];
        buffer = buffer[0..buffer.length] = 0;

        client.connect(clientHolder.addr, null);
        client.send(clientHolder.name, null);

        auto gui = new ClientGUI(clientHolder);

        auto recv = client.receive(buffer, null);

        if(recv == -1)
        {
            writefln("Allocated buffer is null or did not initialise properly.");
            return;
        }

        auto listener = new ClientListener(client, gui);
        listener.start();

        auto newBuffer = processBuffer(buffer);

        gui.update(newBuffer);

        Main.run();
    }
    catch(Exception){writeln("Unable to connect to DChat Service: Server offline."); return;}
}
