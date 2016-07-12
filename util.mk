define cache =
.PHONY: $(2)
$(2):
	@if ! echo "$(3) $(2)" | sha256sum -c; then \
		wget $(1) --progress=bar:force:noscroll -O $(2) \
		&& sha256sum $(2) \
		&& echo "$(3) $(2)" | sha256sum -c || exit 1; \
	fi
endef
