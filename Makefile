DCC = dmd
DFLAGS = -w
SRC = Client.d ClientGUI.d
OBJ = $(wildcard *.o)
OUT = -ofClientApp

INCLUDES = -I/home/group/personal/libs/GtkD/src/gtk/ -I/home/group/personal/libs/GtkD/src/gdk/\
-I/home/group/personal/libs/GtkD/src/gio/ -I/home/group/personal/libs/GtkD/src/glib/\
-I/home/group/personal/libs/GtkD/src/gtkc/ -I/home/group/personal/libs/GtkD/src/gobject/\
-I/home/group/personal/libs/GtkD/src/cairo/ -I/home/group/personal/libs/GtkD/src/gdkpixbuf/\
-I/home/group/personal/libs/GtkD/src/atk/ -I/home/group/personal/libs/GtkD/src/pango/

GTK = /home/group/personal/libs/GtkD/src/gtk/
GDK = /home/group/personal/libs/GtkD/src/gdk/
GIO = /home/group/personal/libs/GtkD/src/gio/
GLIB = /home/group/personal/libs/GtkD/src/glib/
GTKC = /home/group/personal/libs/GtkD/src/gtkc/
GOBJ = /home/group/personal/libs/GtkD/src/gobject/
CAIRO = /home/group/personal/libs/GtkD/src/cairo/
PIXBUF = /home/group/personal/libs/GtkD/src/gdkpixbuf/
ATK = /home/group/personal/libs/GtkD/src/atk/
PANGO = /home/group/personal/libs/GtkD/src/pango/

all:
	$(DCC) $(SRC) $(INCLUDES) $(GTK)*.d $(GDK)*.d $(GIO)*.d $(GLIB)*.d $(GTKC)*.d $(GOBJ)*.d $(CAIRO)*.d $(PIXBUF)*.d $(ATK)*.d $(PANGO)*.d $(OUT)

clean:
	rm *.o
	