module ClientGUI;

import std.string;
import gtk.Main, gtk.MainWindow, gtk.TextView, gtk.ScrolledWindow, gtk.Box;
import gdk.Event, gdk.RGBA, gdk.Color, gtk.Widget, gtk.TextBuffer;

class ClientGUI
{
public:
    this()
    {
        win = new MainWindow("DChat");
        win.setDefaultSize(800,400);

        setupChatRoomWidgets();

        scroll = new ScrolledWindow(chatDisplay);
        scroll2 = new ScrolledWindow(chatEntry);

        box = new Box(Orientation.VERTICAL, 5);
        box.packStart(scroll, true, true, 0);
        box.packStart(scroll2, false, false, 0);

        win.add(box);
        win.showAll();
    }
    ~this(){}


private:
    MainWindow win;
    TextView chatDisplay, chatEntry;
    Box box;
    ScrolledWindow scroll, scroll2;

    void setupChatRoomWidgets()
    {
        chatDisplay = new TextView();
        chatDisplay.setEditable(false);
        chatDisplay.overrideBackgroundColor(GtkStateFlags.NORMAL, new RGBA(0,0,0,1));
        chatDisplay.overrideColor(GtkStateFlags.NORMAL, new RGBA(65535,65535,65535,1));

        chatEntry = new ChatTextBox(chatDisplay);
            
    }
}

class ChatTextBox : TextView
{
    import gtk.TextIter;
public:
    this(TextView chatDisplay)
    {
        super();
        this.overrideBackgroundColor(GtkStateFlags.NORMAL, new RGBA(0,0,0,1));
        this.overrideColor(GtkStateFlags.NORMAL, new RGBA(65535,65535,65535,1)); 
        addOnKeyPress(&enter);

        this.chatDisplay = chatDisplay;
    }
    ~this(){}

private:
    TextView chatDisplay;

    //Event handler for textbox
    bool enter(Event key, Widget widget)
    {
        uint val;
        key.getKeyval(val);
        auto buff = this.getBuffer();

        TextIter start, end;
        buff.getStartIter(start);
        buff.getEndIter(end);

        if(val == 65293)
        {
            chatDisplay.appendText(buff.getText() ~ "\n");
            buff.delet(start, end);
        }
        else
            return false;

        return true;
    }
}

void main(string[] args)
{
    Main.init(args);
    auto c = new ClientGUI();
    //c.getBuffer();
    Main.run();
}