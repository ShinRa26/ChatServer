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
        setUsername();
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

    while(clientHolder.username is null || clientHolder.username == "")
        Thread.sleep(dur!("msecs")(1000));
    
    try
    {
        auto addr = new InetSocketAddress(clientHolder.ip, clientHolder.port);
        bool accepted = client.connect(addr, null);

        if(accepted)
        {
            auto gui = new ClientGUI();
        }
    }
    catch(Exception)
    {
        writeln("Error!");
    }

    Main.run();
}