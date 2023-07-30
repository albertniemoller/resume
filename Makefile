OUT_DIR=build
TMP_DIR=tmp
IN_DIR=src
TOOLS_DIR=buildtools
REDACT_DIR=redactsnippets

all: pdf 

pdf: mergecontact
	for f in $(TMP_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.pdf; \
		$(TOOLS_DIR)/buildpdf.sh $(TMP_DIR)/$$FILE_NAME.md $(OUT_DIR) $(TMP_DIR); \
	done

mergecontact: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.md; \
		$(TOOLS_DIR)/mergeredacts.sh $(IN_DIR)/$$FILE_NAME.md $(REDACT_DIR)/contactinfo.md $(TMP_DIR)/$$FILE_NAME.md MERGE_CONTACT_DETAILS_HERE; \
	done

init: clean
	mkdir -p $(OUT_DIR) $(TMP_DIR)

clean:
	rm -rf $(OUT_DIR) $(TMP_DIR)