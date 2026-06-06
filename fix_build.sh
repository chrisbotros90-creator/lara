#!/bin/bash

# Extract the zip file
unzip -q lara-main_7.zip

# Fix ProcessInfo issues in extracted files
sed -i '' 's/ProcessInfo\.processInfo/ProcessInfo()/g' extracted/lara-main/lara/views/fm/FileSystemHelpers.swift
sed -i '' 's/ProcessInfo\.processInfo/ProcessInfo()/g' extracted/lara-main/lara/views/tools/DeviceInfoView.swift

# Fix MainActor annotation in GestaltView.swift
# Add @MainActor before verifyPlist function
sed -i '' '/^func verifyPlist/i\
@MainActor
' extracted/lara-main/lara/views/tweaks/mobilegestalt/GestaltView.swift

# Fix Shape protocol warnings in button styles
sed -i '' 's/var shape: Shape/var shape: any Shape/g' extracted/lara-main/lara/PartyUI/UI/Buttons/FancyButtonStyle.swift
sed -i '' 's/shape: Shape =/shape: any Shape =/g' extracted/lara-main/lara/PartyUI/UI/Buttons/FancyButtonStyle.swift
sed -i '' 's/var shape: Shape/var shape: any Shape/g' extracted/lara-main/lara/PartyUI/UI/Buttons/PrimaryButtonStyle.swift
sed -i '' 's/shape: Shape =/shape: any Shape =/g' extracted/lara-main/lara/PartyUI/UI/Buttons/PrimaryButtonStyle.swift
sed -i '' 's/var shape: Shape/var shape: any Shape/g' extracted/lara-main/lara/PartyUI/UI/Buttons/TranslucentButtonStyle.swift
sed -i '' 's/shape: Shape =/shape: any Shape =/g' extracted/lara-main/lara/PartyUI/UI/Buttons/TranslucentButtonStyle.swift
sed -i '' 's/var shape: Shape/var shape: any Shape/g' extracted/lara-main/lara/PartyUI/UI/Inputs/TextFieldBackground.swift
sed -i '' 's/shape: Shape =/shape: any Shape =/g' extracted/lara-main/lara/PartyUI/UI/Inputs/TextFieldBackground.swift

echo "Fixes applied successfully!"
