ICON_SOURCE_DIR := ./icon-folder
ICON_DEST_DIR   := ~/.local/share/icons/
PLASMOID_SOURCE_DIR := ./contents
PLASMOID_DEST_DIR   := ~/.local/share/plasma/plasmoids/org.kde.Now\ Playing/
METADATA_FILE   := ./metadata.desktop

install:
	@cp $(ICON_SOURCE_DIR)/* $(ICON_DEST_DIR)
	@echo -e "\e[32;1mIcons copied to $(ICON_DEST_DIR)\e[0m"

	@mkdir -p $(PLASMOID_DEST_DIR)

	@cp $(METADATA_FILE) $(PLASMOID_DEST_DIR)
	@cp -r $(PLASMOID_SOURCE_DIR) $(PLASMOID_DEST_DIR)
	@echo -e "\e[32;1mPlasmoid files installed to $(PLASMOID_DEST_DIR)\e[0m"

	@echo -e "\n\e[32;1mInstallation completed successfully.\e[0m"

remove:
	@rm -rf $(ICON_DEST_DIR)/NowPlaying.png
	@echo -e "\e[32;1mIcons removed from $(ICON_DEST_DIR)\e[0m"

	@rm -rf $(PLASMOID_DEST_DIR)
	@echo -e "\e[32;1mPlasmoid files removed from $(PLASMOID_DEST_DIR)\e[0m"

	@echo "Removal completed successfully."
