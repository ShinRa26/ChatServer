module Client;

import std.string, core.thread, std.concurrency, std.stdio;
import gio.socket, gio.InetSocketAddress, gio.InetAddress;
import ClientGUI, gtk.Main;

class Client
{
public:
    this()
    {
        this.nw = new NameWindow();
        this.self = new Socket(GSocketFamily.IPV4, GSocketType.STREAM, GSocketProtocol.TCP);
    }

    void setUsername()
    {
        this.username = this.nw.text;
    }

    //Public Variables
    ushort port = 9000;
    string ip = "127.0.0.1";
    string username;
    Socket self;

private:
    NameWindow nw;
}


void main(string[] args)
{
    Main.init(args);
    auto clientHolder = new Client();
    auto client = clientHolder.self;
    
    try
    {
        auto addr = new InetSocketAddress(clientHolder.ip, clientHolder.port);
        client.connect(addr, null);
    }
    catch(Exception)
    {
        writeln("Error!");
    }

    Main.run();
}