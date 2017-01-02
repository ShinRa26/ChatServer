module Client;

import std.string, core.thread, std.concurrency, std.stdio;
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

void main(string[] args)
{
    Main.init(args);
    auto client = new Client();
    auto nw = new NameWindow();
    Main.run();

    client.name = nw.text;
    destroy(nw); //Kills the name window as it is no longer needed.

    try
    {
        //TODO Enter client code.
        //TODO Implement an update function into the ClientGUI.d file.
    }
    catch(Exception){writefln("Unable to connect to %s:%d - Server Offline.", client.ip, c.port); return;}
}
