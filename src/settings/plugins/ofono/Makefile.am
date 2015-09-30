SUBDIRS = .

@GNOME_CODE_COVERAGE_RULES@

nm-ofono-glue.h: nm-ofono.xml
	$(AM_V_GEN) dbus-binding-tool --prefix=nm_ofono --mode=glib-server --output=$@ $<

BUILT_SOURCES = \
	nm-ofono-glue.h

INCLUDES = \
	-I$(top_srcdir)/src \
	-I$(top_srcdir)/src/logging \
	-I$(top_srcdir)/src/config \
	-I$(top_srcdir)/src/settings \
	-I$(top_srcdir)/include \
	-I$(top_builddir)/include \
	-I$(top_srcdir)/libnm-glib \
	-I$(top_srcdir)/libnm-util \
	-I$(top_builddir)/libnm-util

noinst_LTLIBRARIES = libofono-io.la

libofono_io_la_SOURCES = \
	parser.c \
	parser.h

libofono_io_la_CPPFLAGS = \
	$(GLIB_CFLAGS) \
	$(DBUS_CFLAGS) \
	$(POLKIT_CFLAGS) \
	-DSYSCONFDIR=\"$(sysconfdir)\"

libofono_io_la_LIBADD = \
	$(top_builddir)/libnm-util/libnm-util.la \
	$(GLIB_LIBS)

pkglib_LTLIBRARIES = libnm-settings-plugin-ofono.la

libnm_settings_plugin_ofono_la_SOURCES = \
	$(BUILT_SOURCES) \
	nm-ofono-connection.c \
	nm-ofono-connection.h \
	plugin.c \
	plugin.h

libnm_settings_plugin_ofono_la_CPPFLAGS = \
	$(GLIB_CFLAGS) \
	$(DBUS_CFLAGS) \
	$(POLKIT_CFLAGS) \
	$(GUDEV_CFLAGS) \
	-DSYSCONFDIR=\"$(sysconfdir)\"

libnm_settings_plugin_ofono_la_LDFLAGS = -module -avoid-version
libnm_settings_plugin_ofono_la_LIBADD = \
	$(top_builddir)/libnm-util/libnm-util.la \
	libofono-io.la \
	$(GLIB_LIBS) \
	$(GUDEV_LIBS)

dbusservicedir = $(DBUS_SYS_DIR)
dbusservice_DATA = nm-ofono.conf

EXTRA_DIST = \
	$(dbusservice_DATA) \
	nm-ofono.xml

CLEANFILES = $(BUILT_SOURCES)
