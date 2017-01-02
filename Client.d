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
    }
    ~this(){}

private:
    Socket client;
    ClientGUI gui;
    string buffer = "";

    void run()
    {
        while(true)
        {
            client.receive(buffer, null);
            if(buffer.length == 0)
                continue;
            else
                writeln(buffer);
            gui.update("TITTIES");
        }
    }
}

void main(string[] args)
{
    uint bufSize = 2048;

    Main.init(args);
    auto clientHolder = new Client();
    auto client = clientHolder.self;
    auto nw = new NameWindow();
    Main.run();

    clientHolder.name = nw.text;
    destroy(nw); //Kills the name window as it is no longer needed.

    try
    {
        string buffer = new string(bufSize);

        client.connect(clientHolder.addr, null);
        client.send(clientHolder.name, null);

        auto gui = new ClientGUI(clientHolder);

        auto recv = client.receive(buffer, null);
        writefln("Received: %s", recv);
        gui.update(buffer);
        
        auto listener = new ClientListener(client, gui);
        listener.start();

        Main.run();
    }
    catch(Exception){writeln("Unable to connect to DChat Service: Server offline."); return;}
}
