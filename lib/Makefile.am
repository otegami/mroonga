AM_CPPFLAGS =					\
	-I$(top_builddir)			\
	-I$(top_srcdir)				\
	$(MYSQL_INCLUDES)			\
	$(GROONGA_CFLAGS)			\
	$(MYSQL_VERSION_CFLAGS)

libmrn_need_mysql_la_CXXFLAGS =			\
	$(AM_CXXFLAGS)				\
	$(MYSQL_CFLAGS)				\
	-DMYSQL_DYNAMIC_PLUGIN

noinst_LTLIBRARIES =				\
	$(LIBMYSQLSERVICES_COMPAT)		\
	libmrn_no_mysql.la			\
	libmrn_need_mysql.la

include libmrn_no_mysql_sources.am
include libmrn_need_mysql_sources.am
