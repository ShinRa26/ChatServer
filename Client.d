module Client;

import std.string, gio.socket, core.thread, std.concurrency;
import ClientGUI, gtk.Main;

class Client
{
public:
    this()
    {
        this.nw = new NameWindow();
        this.client = new Socket(GSocketFamily.IPV4, GSocketType.STREAM, GSocketProtocol.TCP);

    }

private:
    ushort port = 9000;
    string ip = "127.0.0.1";
    Socket client;
    ClientGUI g;
    NameWindow nw;
}