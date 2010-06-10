unpack: $(stamp)unpack
$(stamp)unpack: $(DEB_TARBALL) $(patsubst %,$(stamp)%,$(subst /,-,$(GLIBC_OVERLAYS)))
	touch $(stamp)unpack

$(DEB_TARBALL): $(stamp)$(DEB_TARBALL)
$(stamp)$(DEB_TARBALL):
	mkdir -p $(build-tree)
	cd $(build-tree) && cp -a $(CURDIR)/$(DEB_TARBALL) .
	touch $@

$(patsubst %,$(stamp)%,$(subst /,-,$(GLIBC_OVERLAYS))): $(stamp)$(DEB_TARBALL)
	cd $(DEB_SRCDIR) && cp -a $(subst -,/,$(CURDIR)/$(notdir $@)) $(shell basename $(subst -,/,$@))
	touch $@
