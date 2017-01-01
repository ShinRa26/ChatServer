module Client;

import std.string, core.thread, std.concurrency, std.stdio;
import gio.Socket, gio.InetSocketAddress, gio.InetAddress;
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

    auto ip = new InetAddress(clientHolder.ip);
    auto addr = new InetSocketAddress(ip, clientHolder.port);
    writeln(addr);
    
    //SERIOUSLY, JUST MAKE THE FUCKING ADDRESS, YOU DICK!

    Main.run();
}