#!/bin/bash

set -euo pipefail

function write-or-log() {
	defaults write "$@" || echo >&2 "Error: defaults write $*"
}

function sudo-write-or-log() {
	sudo defaults write "$@" || echo >&2 "Error: sudo defaults write $*"
}

# Global
write-or-log -g AppleInterfaceStyleSwitchesAutomatically -bool true
write-or-log -g AppleMiniaturizeOnDoubleClick -bool false
write-or-log -g AppleShowAllExtensions -bool true
write-or-log -g AppleSpacesSwitchOnActivate -bool false
write-or-log -g CGDisableCursorLocationMagnification -bool true
write-or-log -g NSDisableAutomaticTermination -bool true
write-or-log -g NSNavPanelExpandedStateForSaveMode -bool true
write-or-log -g NSNavPanelExpandedStateForSaveMode2 -bool true
write-or-log -g NSNavPanelFileLastListModeForOpenModeKey -int 2
write-or-log -g NSNavPanelFileListModeForOpenMode2 -int 2
write-or-log -g NSPersonNameDefaultDisplayNameOrder -int 2
write-or-log -g NSPersonNameDefaultShortNameEnabled -bool true
write-or-log -g NSPersonNameDefaultShortNameFormat -int 3
write-or-log -g NSPersonNameDefaultShouldPreferNicknamesPreference -bool false
write-or-log -g PMPrintingExpandedStateForPrint -bool true
write-or-log -g PMPrintingExpandedStateForPrint2 -bool true

# Keyboard settings
write-or-log -g ApplePressAndHoldEnabled -bool false
write-or-log -g AppleKeyboardUIMode -int 3
write-or-log -g InitialKeyRepeat -int 25
write-or-log -g KeyRepeat -int 2
write-or-log -g NSAutomaticCapitalizationEnabled -bool false
write-or-log -g NSAutomaticDashSubstitutionEnabled -bool false
write-or-log -g NSAutomaticInlinePredictionEnabled -bool false
write-or-log -g NSAutomaticPeriodSubstitutionEnabled -bool false
write-or-log -g NSAutomaticQuoteSubstitutionEnabled -bool false
write-or-log -g NSAutomaticSpellingCorrectionEnabled -bool false
write-or-log -g NSAutomaticTextCompletionEnabled -bool false
write-or-log -g NSSpellCheckerAutomaticallyIdentifiesLanguages -bool false
write-or-log com.apple.hitoolbox AppleCapsLockPressAndHoldToggleOff -bool false
write-or-log com.apple.hitoolbox AppleDictationAutoEnable -bool false
write-or-log com.apple.hitoolbox AppleFnUsageType -int 1

# Dock
write-or-log com.apple.dock appswitcher-all-displays -bool true
write-or-log com.apple.dock autohide -bool true
write-or-log com.apple.dock expose-group-apps -bool true
write-or-log com.apple.dock largesize -int 128
write-or-log com.apple.dock magnification -bool true
write-or-log com.apple.dock mineffect -string scale
write-or-log com.apple.dock mouse-over-hilite-stack -bool true
write-or-log com.apple.dock mru-spaces -bool false
write-or-log com.apple.dock no-bouncing -bool true
write-or-log com.apple.dock showAppExposeGestureEnabled -bool true
write-or-log com.apple.dock showhidden -bool true
write-or-log com.apple.dock tilesize -int 32

# Finder
write-or-log com.apple.finder _FXSortFoldersFirst -bool true
write-or-log com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
write-or-log com.apple.finder FXEnableExtensionChangeWarning -bool false
write-or-log com.apple.finder FXPreferredSearchViewStyle -string Nlsv
write-or-log com.apple.finder FXPreferredViewStyle -string Nlsv
write-or-log com.apple.finder NewWindowTarget -string 'PfHm'
write-or-log com.apple.finder NewWindowTargetPath -string "file://$HOME/"
write-or-log com.apple.finder PathBarRootAtHome -bool true
write-or-log com.apple.finder QLEnableTextSelection -bool true
write-or-log com.apple.finder QLHidePanelOnDeactivate -bool false
write-or-log com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
write-or-log com.apple.finder ShowHardDrivesOnDesktop -bool false
write-or-log com.apple.finder ShowPathbar -bool true
write-or-log com.apple.finder ShowRemovableMediaOnDesktop -bool true
write-or-log com.apple.finder ShowStatusBar -bool true

# WindowManager
write-or-log com.apple.windowmanager AppWindowGroupingBehavior -bool true

# Clock
write-or-log com.apple.menuextra.clock ShowAMPM -bool true
write-or-log com.apple.menuextra.clock ShowDate -bool true
write-or-log com.apple.menuextra.clock ShowDayOfWeek -bool true
write-or-log com.apple.menuextra.clock ShowSeconds -bool true

# Safari
write-or-log -g WebKitDeveloperExtras -bool true
write-or-log com.apple.Safari AutoOpenSafeDownloads -bool false
write-or-log com.apple.Safari IncludeDevelopMenu -bool true
write-or-log com.apple.Safari IncludeInternalDebugMenu -bool true
write-or-log com.apple.Safari ShowStatusBar -bool true
write-or-log com.apple.Safari ShowOverlayStatusBar -bool true
write-or-log com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
write-or-log com.apple.Safari WebKitDefaultTextEncodingName -string ks_c_5601-1987
write-or-log com.apple.Safari WebKitPreferences.defaultTextEncodingName -string ks_c_5601-1987
write-or-log com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true
write-or-log com.apple.Safari.SandboxBroker AlwaysPromptForDownloadFolder -bool true

# Mail
write-or-log com.apple.mail AddressesIncludeNameOnPasteboard -bool false
write-or-log com.apple.mail DisableInlineAttachmentViewing -bool true
write-or-log com.apple.mail DraftsViewerAttributes -dict-add \
	DisplayInThreadedMode -string YES
write-or-log com.apple.mail DraftsViewerAttributes -dict-add \
	SortedDescending -string YES
write-or-log com.apple.mail DraftsViewerAttributes -dict-add \
	SortOrder -string received-date
write-or-log com.apple.mail EnableToCcInMessageList -bool true
write-or-log com.apple.mail NSFixedPitchFont -string D2Coding
write-or-log com.apple.mail NSFixedPitchFontSize -int 12
write-or-log com.apple.mail NSFontSize -int 13
write-or-log com.apple.mail SendFormat -string Plain
write-or-log com.apple.mail SpellCheckingBehavior -string NoSpellCheckingEnabled

# Extra system settings
write-or-log com.apple.LaunchServices LSQuarantine -bool false

# Speedups
write-or-log -g NSAutomaticWindowAnimationsEnabled -bool false
write-or-log -g NSToolbarTitleViewRolloverDelay -float 0
write-or-log -g NSWindowResizeTime -float 0.05
write-or-log -g QLPanelAnimationDuration -float 0
write-or-log -g com.apple.springing.delay -float 0.1
write-or-log com.apple.dock autohide-delay -float 0.05
write-or-log com.apple.dock autohide-time-modifier -float 0.3
write-or-log com.apple.dock expose-animation-duration -float 0.1

# ALF
sudo-write-or-log /Library/Preferences/com.apple.alf globalstate -int 1
sudo-write-or-log /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool true
sudo-write-or-log /Library/Preferences/com.apple.alf allowsignedenabled -bool true
sudo-write-or-log /Library/Preferences/com.apple.alf loggingenabled -bool true
sudo-write-or-log /Library/Preferences/com.apple.alf stealthenabled -bool true

# Gatekeeper
sudo spctl --master-disable

# Power management
sudo pmset -b powernap 0
sudo pmset -b gpuswitch 0
sudo pmset -b sleep 15
sudo pmset -b disksleep 10
sudo pmset -b displaysleep 5

sudo pmset -c powernap 1
sudo pmset -c gpuswitch 2
sudo pmset -c sleep 30
sudo pmset -c disksleep 30
sudo pmset -c displaysleep 15

# Restart services
sudo killall Finder Dock SystemUIServer
