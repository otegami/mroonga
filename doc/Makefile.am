SUBDIRS =					\
	locale

BUILT_SOURCES =
CLEANFILES =

all:

include $(top_srcdir)/doc/files.am

update-examples:
	PATH=$(top_builddir)/src:$(top_builddir)/src/suggest:$$PATH	\
	  $(srcdir)/source/update_execution_example.py			\
	  $(srcdir)/source

files.am: update-files.sh
	update-files

update-files:
	cd locale/en/LC_MESSAGES && $(MAKE) gettext
	cd locale/en && $(MAKE) clean html
	cd $(srcdir); ./update-files.sh > files.am

man pdf clean-html update-po:
	for dir in $(SUBDIRS); do		\
	  (cd $${dir} && $(MAKE) $@);		\
	done

init-locale:
	for dir in $(SUBDIRS); do		\
	  (cd $${dir} && $(MAKE) init);		\
	done

EXTRA_DIST =					\
	CMakeLists.txt				\
	deploy.rb				\
	files.cmake				\
	images.mk				\
	requirements.txt			\
	update-edit-po.rb			\
	update-files.rb				\
	update-po.rb

$(source_files_relative_from_doc_dir): html

update-images:
	cd $(srcdir)/source/images && \
	  make -f $(abs_srcdir)/images.mk update-images

nobase_dist_doc_DATA =                          \
	$(source_files_relative_from_doc_dir)

if DOCUMENT_BUILDABLE
dist-hook: html man
	@touch $(distdir)/build-stamp

CLEANFILES += build-stamp
else
if HAVE_BUILT_DOCUMENT
EXTRA_DIST += build-stamp
endif
endif
