module ClientGUI;

import std.string;
import gtk.Main, gtk.MainWindow, gtk.TextView, gtk.ScrolledWindow, gtk.Box;
import gdk.Event, gdk.RGBA, gdk.Color, gtk.Widget, gtk.TextBuffer;

/* Main class for displaying the chat program gui */
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

    //Helper to set up the display
    void setupChatRoomWidgets()
    {
        chatDisplay = new TextView();
        chatDisplay.setEditable(false);
        chatDisplay.overrideBackgroundColor(GtkStateFlags.NORMAL, new RGBA(0,0,0,1));
        chatDisplay.overrideColor(GtkStateFlags.NORMAL, new RGBA(65535,65535,65535,1));

        chatEntry = new ChatTextBox(chatDisplay);
    }
}

//Custom TextView for entering text and clearing buffer after message is sent
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


/* Class for obtaining the user's name for the chat program */
class NameWindow
{
    import gtk.Window, gtk.Entry, gtk.Button, gtk.Label;

public:
    string text;

    this()
    {
        frame = new Window("Enter Name");
        frame.setDefaultSize(300,100);

        l = new Label("Enter Chat Name:");
        
        e = new Entry();

        b = new Button("Submit");
        b.addOnButtonRelease(&press);

        box = new Box(Orientation.VERTICAL, 10);
        box.packStart(l, false, false, 5);
        box.packStart(e, false, false, 5);
        box.packStart(b, false, false, 5);

        frame.add(box);
        frame.showAll();
    }

    //Gets the name from the text box and checks validity
    bool getEntry()
    { 
        bool valid = false;
        this.text = e.getText();

        //import std.stdio;
        //writeln(this.text);

        if(this.text == "" || this.text is null)
            return valid;
        else
        {
            valid = true;
            return valid;
        }
    }

    //Event handler for Submit button press
    bool press(Event e, Widget w)
    {
        bool valid = getEntry();

        if(valid)
        {
            frame.destroy();
            return true;
        }
        else
        {
            auto d = makeErrorDialog();
            d.run();
            d.destroy();
            return false;
        }
    }

    import gtk.Dialog;
    //Creates the Error message dialog for invalid name cause messagedialog is fucked
    Dialog makeErrorDialog()
    {
        /* It just loves to be awkward.. */
        string[] buttonName;
        buttonName~="OK";
        GtkResponseType[] responseID;
        responseID~=GtkResponseType.OK;

        //Creates the dialog and adds the relevant parts
        auto dialog = new Dialog("Enter Valid Name", null, GtkDialogFlags.MODAL, buttonName, responseID);
        dialog.setDefaultSize(300,100);
        auto content = dialog.getContentArea();
        content.add(new Label("You must enter a valid name"));
        dialog.showAll();

        return dialog;
    }

private:
    Window frame;
    Label l;
    Entry e;
    Button b;
    Box box;
}



/* FOR TESTING PURPOSES 
void main(string[] args)
{
    import std.stdio;
    Main.init(args);
    auto n = new NameWindow();
    //auto c = new ClientGUI();
    Main.run();
}
*/
