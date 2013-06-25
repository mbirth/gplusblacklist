CC=coffee
SRCDIR=src
BUILDDIR=build
ALL_SRC_FILES := $(wildcard $(SRCDIR)/*)
ALL_OTHER_SRC_FILES := $(filter-out %.coffee, $(ALL_SRC_FILES))
ALL_OTHER_FILES := $(ALL_OTHER_SRC_FILES:$(SRCDIR)/%=$(BUILDDIR)/%)

SRC=$(wildcard $(SRCDIR)/*.coffee)
BUILD=$(SRC:$(SRCDIR)/%.coffee=$(BUILDDIR)/%.js)

all: other coffee

# coffeescript files

coffee: $(BUILD)

$(BUILDDIR)/%.js: $(SRCDIR)/%.coffee
	$(CC) -cs < $< > $@

# other files

other: $(ALL_OTHER_FILES)

$(ALL_OTHER_FILES): $(BUILDDIR)/%: $(SRCDIR)/%
	cp $< $@

# crx building stuff

rsakey: key.pem

crx: gplusblacklist.crx

key.pem:
	@echo "Generating RSA key in PKCS#8 format."
	openssl genrsa 4096 | openssl pkcs8 -topk8 -nocrypt -out $@

gplusblacklist.crx: $(ALL_OTHER_FILES) $(BUILD) key.pem
	google-chrome --pack-extension="$(BUILDDIR)/" --pack-extension-key="key.pem"
	mv $(BUILDDIR).crx $@
	-rm libpeerconnection.log
