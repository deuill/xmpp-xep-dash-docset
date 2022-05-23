# Makefile for XMPP XEP Dash Docset.
# Use this to build a new version of the docset based on the latest XEP state.

# Docset generation options.
NAME        := XEPs
DESCRIPTION := Protocol Extensions for XMPP
REMOTE_URL  := https://xmpp.org/extensions

# Build-time dependencies.
ENVSUBST = $(call find-cmd,envsubst)
SQLITE   = $(call find-cmd,sqlite3)
TAR      = $(call find-cmd,tar)

# Directory aliases.
ROOTDIR    := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
BUILDDIR   := $(ROOTDIR)build/
CONTENTDIR := $(BUILDDIR)$(NAME).docset/Contents/
XEPDIR     := $(ROOTDIR)xeps/

# Default Makefile options.
XEPS    := $(patsubst $(XEPDIR)xep-%.xml,$(CONTENTDIR)Resources/Documents/xep-%.html,$(wildcard $(XEPDIR)xep-????.xml))
VERBOSE :=

## Build and archive docset.
build: $(BUILDDIR)$(NAME).tgz

## Remove all temporary build files.
clean:
	$Q rm -Rf $(BUILDDIR)

$(CONTENTDIR)Info.plist: template/Info.plist
	$Q mkdir -p $(@D)
	$Q $(ENVSUBST) < $< > $@

$(BUILDDIR)$(NAME).docset/icon.png: template/xmpp-logo.png
	$Q mkdir -p $(@D)
	$Q cp -f $< $@

$(CONTENTDIR)Resources/docSet.dsidx: template/docSet.dsidx
	$Q mkdir -p $(@D)
	$Q cp -f $< $@

$(CONTENTDIR)Resources/Documents/xep-%.html: $(XEPDIR)xep-%.xml | $(CONTENTDIR)Resources/docSet.dsidx
	$Q mkdir -p $(@D)
	$Q $(SQLITE) $(CONTENTDIR)Resources/docSet.dsidx "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('$(subst ','',$(call extract-title,$<))', 'Guide', 'xep-$*.html');"
	$Q $(MAKE) -C $(XEPDIR) xep-$*.html OUTDIR=$(@D)

$(BUILDDIR)$(NAME).tgz: $(XEPS) $(CONTENTDIR)Info.plist
	$Q $(TAR) --create --gzip --file $(BUILDDIR)$(NAME).tgz -C $(BUILDDIR) $(NAME).docset

.PHONY: build clean

# Conditional command echo control.
Q := $(if $(VERBOSE),,@)

# Find and return full path to command by name, or throw error if none can be found in PATH.
# Example use: $(call find-cmd,ls)
find-cmd = $(or $(firstword $(wildcard $(addsuffix /$(1),$(subst :, ,$(PATH))))),$(error "Command '$(1)' not found in PATH"))

# Extract XEP title from XML file.
extract-title = $(shell printf '%s: %s' "$(shell basename $(1) .xml | tr '[:lower:]' '[:upper:]')" "$(shell awk -F '[<>]' '/<title>/ {print $$3; exit}' $(1))")

# Exported variables for templated files.
export NAME DESCRIPTION REMOTE_URL
