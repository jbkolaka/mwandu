// Variables exported from FigCraft.
// Module: Ai

import 'dart:ui';

/// AI · Mode
abstract final class AI {
  static const Color userTypeNonUserLightThemeChatPromptBorder = Color(0xFFFFFFFF);
  static const Color userTypeNonUserLightThemeChatPromptBorderStart = Color(0xFFF4F4F4);
  static const Color userTypeNonUserLightThemeChatPromptBorderEnd = Color(0xFFF4F4F4);
  static const Color userTypeNonUserDarkThemeChatPromptBackground = Color(0xFF161616);
  static const Color userTypeNonUserDarkThemeChatPromptBorder = Color(0xFF161616);
  static const Color userTypeNonUserDarkThemeChatPromptBorderStart = Color(0xFF262626);
  static const Color userTypeNonUserDarkThemeChatPromptBorderEnd = Color(0xFF262626);
  static const Color chatBubbleUser = Color(0xFFFFFFFF);
  static const Color userTypeNonUserLightThemeChatPromptBackground = Color(0xFFFFFFFF);
  static const Color chatBubbleAgent = Color(0xFFFFFFFF);
  static const Color chatBubbleAgentBorder = Color(0xFFFFFFFF);
  static const Color chatAvatarBot = Color(0xFFFFFFFF);
  static const Color chatAvatarAgent = Color(0xFFFFFFFF);
  static const Color chatAvatarUser = Color(0xFFFFFFFF);
  static const Color chatPromptBorderStart = Color(0xFFFFFFFF);
  static const Color chatPromptBorderEnd = Color(0xFFFFFFFF);
  static const Color chatShellLightThemeChatPromptBackground = Color(0xFFFFFFFF);
  static const Color chatShellLightThemeChatPromptBorder = Color(0xFFFFFFFF);
  static const Color chatShellLightThemeChatPromptBorderStart = Color(0xFFF4F4F4);
  static const Color chatShellLightThemeChatPromptBorderEnd = Color(0xFFF4F4F4);
  static const Color userTypeUserLightThemeChatAvatarBot = Color(0xFF0F62FE);
  static const Color userTypeUserLightThemeChatAvatarAgent = Color(0xFF161616);
  static const Color userTypeUserLightThemeChatAvatarUser = Color(0xFF161616);
  static const Color chatShellDarkThemeChatPromptBackground = Color(0xFF161616);
  static const Color chatShellDarkThemeChatPromptBorder = Color(0xFF161616);
  static const Color chatShellDarkThemeChatPromptBorderStart = Color(0xFF262626);
  static const Color chatShellDarkThemeChatPromptBorderEnd = Color(0xFF262626);
  static const Color userTypeUserDarkThemeChatBubble = Color(0xFF393939);
  static const Color userTypeUserDarkThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const Color userTypeUserDarkThemeChatAvatarBot = Color(0xFF4589FF);
  static const Color userTypeUserDarkThemeChatAvatarAgent = Color(0xFFF4F4F4);
  static const Color userTypeUserDarkThemeChatAvatarUser = Color(0xFFF4F4F4);
  static const Color userTypeNonUserLightThemeChatBubbleBorder = Color(0xFFE0E0E0);
  static const Color userTypeNonUserLightThemeChatBubble = Color(0xFFFFFFFF);
  static const Color userTypeNonUserLightThemeChatAvatarBot = Color(0xFF0F62FE);
  static const Color userTypeNonUserLightThemeChatAvatarAgent = Color(0xFF161616);
  static const Color userTypeNonUserLightThemeChatAvatarUser = Color(0xFF161616);
  static const Color userTypeNonUserDarkThemeChatBubble = Color(0xFF262626);
  static const Color userTypeNonUserDarkThemeChatBubbleBorder = Color(0xFF525252);
  static const Color userTypeNonUserDarkThemeChatAvatarBot = Color(0xFF4589FF);
  static const Color userTypeNonUserDarkThemeChatAvatarAgent = Color(0xFFF4F4F4);
  static const Color userTypeNonUserDarkThemeChatAvatarUser = Color(0xFFF4F4F4);
  static const Color userTypeUserLightThemeChatBubble = Color(0xFFE0E0E0);
  static const Color userTypeUserLightThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const Color userTypeUserLightThemeChatBubbleHover = Color(0xFFD1D1D1);
  static const Color userTypeUserLightThemeChatBubbleActive = Color(0xFFA8A8A8);
  static const Color userTypeUserDarkThemeChatBubbleHover = Color(0xFF474747);
  static const Color userTypeUserDarkThemeChatBubbleActive = Color(0xFF6F6F6F);
  static const Color userTypeNonUserLightThemeChatBubbleHover = Color(0xFFF4F4F4);
  static const Color userTypeNonUserLightThemeChatBubbleActive = Color(0xFFE0E0E0);
  static const Color userTypeNonUserDarkThemeChatBubbleHover = Color(0xFF333333);
  static const Color userTypeNonUserDarkThemeChatBubbleActive = Color(0xFF525252);
  static const Color aISlugLightThemeEnabledAISlugGradientBackground = Color(0xFF161616);
  static const Color aISlugLightThemeEnabledAISlugGradientStop1 = Color(0xFFA8A8A8);
  static const Color aISlugLightThemeEnabledAISlugGradientStop2 = Color(0xFFFFFFFF);
  static const Color aISlugLightThemeHoverAISlugGradientBackgroundHover = Color(0xFF292929);
  static const Color aISlugLightThemeHoverAISlugGradientStop1Hover = Color(0xFFD1D1D1);
  static const Color aISlugLightThemeHoverAISlugGradientStop2Hover = Color(0xFFFFFFFF);
  static const Color aISlugDarkThemeEnabledAISlugGradientBackground = Color(0xFF8D8D8D);
  static const Color aISlugDarkThemeEnabledAISlugGradientStop1 = Color(0xFFF4F4F4);
  static const Color aISlugDarkThemeEnabledAISlugGradientStop2 = Color(0xFFFFFFFF);
  static const Color aISlugDarkThemeHoverAISlugGradientBackgroundHover = Color(0xFF999999);
  static const Color aISlugDarkThemeHoverAISlugGradientStop1Hover = Color(0xFFFFFFFF);
  static const Color aISlugDarkThemeHoverAISlugGradientStop2Hover = Color(0xFFFFFFFF);
  static const Color aISlugLightThemeEnabledAISlugSolidBackground = Color(0xFF525252);
  static const Color aISlugLightThemeHoverAISlugSolidBackgroundHover = Color(0xFF5E5E5E);
  static const Color aISlugDarkThemeEnabledAISlugSolidBackground = Color(0xFFC6C6C6);
  static const Color aISlugDarkThemeHoverAISlugSolidBackgroundHover = Color(0xFFD1D1D1);
  static const Color aISkeletonLightThemeAISkeletonBackground = Color(0xFFD0E2FF);
  static const Color aISkeletonLightThemeAISkeletonElement = Color(0xFFA6C8FF);
  static const Color aISkeletonDarkThemeAISkeletonBackground = Color(0x8078A9FF);
  static const Color aISkeletonDarkThemeAISkeletonElement = Color(0x4D78A9FF);
  static const Color chatShellLightThemeChatShellBackground = Color(0xFFFFFFFF);
  static const Color chatShellLightThemeChatHeaderBackground = Color(0xFFFFFFFF);
  static const Color chatShellDarkThemeChatShellBackground = Color(0xFF262626);
  static const Color chatShellDarkThemeChatHeaderBackground = Color(0xFF262626);
  static const bool aIPresenceNoAIAIPresentTest = false;
  static const bool aIPresenceNoAIAIRevertedTest = false;
  static const bool aIPresenceAllAIElementsAIPresentTest = false;
  static const bool aIPresenceAllAIElementsAIRevertedTest = false;
  static const bool aIPresenceAILayerOnlyAIPresentTest = true;
  static const bool aIPresenceAILayerOnlyAIRevertedTest = false;
  static const bool aIPresenceNoAIAIPresentAISlug = false;
  static const bool aIPresenceNoAIAIPresentAIBackground = false;
  static const bool aIPresenceNoAIAIPresentAIBorder = false;
  static const bool aIPresenceNoAIAIPresentAIAura = false;
  static const bool aIPresenceNoAIAIPresentAIRevertButton = false;
  static const bool aIPresenceNoAIAIRevertedAISlug = false;
  static const bool aIPresenceNoAIAIRevertedAIBackground = false;
  static const bool aIPresenceNoAIAIRevertedAIBorder = false;
  static const bool aIPresenceNoAIAIRevertedAIAura = false;
  static const bool aIPresenceNoAIAIRevertedAIRevertButton = false;
  static const bool aIPresenceAllAIElementsAIPresentAISlug = true;
  static const bool aIPresenceAllAIElementsAIPresentAIBackground = true;
  static const bool aIPresenceAllAIElementsAIPresentAIBorder = true;
  static const bool aIPresenceAllAIElementsAIPresentAIAura = true;
  static const bool aIPresenceAllAIElementsAIPresentAIRevertButton = false;
  static const bool aIPresenceAllAIElementsAIRevertedAISlug = false;
  static const bool aIPresenceAllAIElementsAIRevertedAIBackground = false;
  static const bool aIPresenceAllAIElementsAIRevertedAIBorder = false;
  static const bool aIPresenceAllAIElementsAIRevertedAIAura = false;
  static const bool aIPresenceAllAIElementsAIRevertedAIRevertButton = true;
  static const bool aIPresenceAILayerOnlyAIPresentAISlug = false;
  static const bool aIPresenceAILayerOnlyAIPresentAIBackground = true;
  static const bool aIPresenceAILayerOnlyAIPresentAIBorder = true;
  static const bool aIPresenceAILayerOnlyAIPresentAIAura = true;
  static const bool aIPresenceAILayerOnlyAIPresentAIRevertButton = false;
  static const bool aIPresenceAILayerOnlyAIRevertedAISlug = false;
  static const bool aIPresenceAILayerOnlyAIRevertedAIBackground = false;
  static const bool aIPresenceAILayerOnlyAIRevertedAIBorder = false;
  static const bool aIPresenceAILayerOnlyAIRevertedAIAura = false;
  static const bool aIPresenceAILayerOnlyAIRevertedAIRevertButton = false;
  static const bool aIPresenceNoAIAIPresentNoAISkeleton = true;
  static const bool aIPresenceNoAIAIPresentAISpacerDataTable = true;
  static const bool aIPresenceNoAIAIRevertedAISpacerDataTable = true;
  static const bool aIPresenceAllAIElementsAIPresentAISpacerDataTable = false;
  static const bool aIPresenceAllAIElementsAIRevertedAISpacerDataTable = true;
  static const bool aIPresenceAILayerOnlyAIPresentAISpacerDataTable = false;
  static const bool aIPresenceAILayerOnlyAIRevertedAISpacerDataTable = true;
}

/// AI - User type · User
abstract final class AIUserType {
  static const Color lightThemeChatPromptBackground = Color(0xFFFFFFFF);
  static const Color lightThemeChatPromptBorder = Color(0xFFFFFFFF);
  static const Color lightThemeChatPromptBorderStart = Color(0xFFFFFFFF);
  static const Color lightThemeChatPromptBorderEnd = Color(0xFFFFFFFF);
  static const Color lightThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const Color darkThemeChatPromptBackground = Color(0xFFFFFFFF);
  static const Color darkThemeChatPromptBorder = Color(0xFFFFFFFF);
  static const Color darkThemeChatPromptBorderStart = Color(0xFFFFFFFF);
  static const Color darkThemeChatPromptBorderEnd = Color(0xFFFFFFFF);
  static const Color darkThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const bool showForUser = true;
  static const bool showForNonUser = false;
}

/// AI - User type · Non-user
abstract final class AIUserTypeNonUser {
  static const Color lightThemeChatPromptBackground = Color(0xFFFFFFFF);
  static const Color lightThemeChatPromptBorder = Color(0xFFFFFFFF);
  static const Color lightThemeChatPromptBorderStart = Color(0xFFFFFFFF);
  static const Color lightThemeChatPromptBorderEnd = Color(0xFFFFFFFF);
  static const Color lightThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const Color darkThemeChatPromptBackground = Color(0xFFFFFFFF);
  static const Color darkThemeChatPromptBorder = Color(0xFFFFFFFF);
  static const Color darkThemeChatPromptBorderStart = Color(0xFFFFFFFF);
  static const Color darkThemeChatPromptBorderEnd = Color(0xFFFFFFFF);
  static const Color darkThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const bool showForUser = false;
  static const bool showForNonUser = true;
}

/// AI presence · No AI
abstract final class AIPresence {
  static const bool noAISkeleton = true;
}

/// AI presence · All AI elements
abstract final class AIPresenceAllAIElements {
}

/// AI presence · AI layer only
abstract final class AIPresenceAILayerOnly {
}

/// AI revert · AI present
abstract final class AIRevert {
  static const bool allAIElementsTest = false;
  static const bool aILayerOnlyTest = true;
  static const bool noAIAIRevertButton = false;
  static const bool noAIAISlug = false;
  static const bool noAIAIBackground = false;
  static const bool noAIAIBorder = false;
  static const bool noAIAIAura = false;
  static const bool alIAIElementsAISlug = true;
  static const bool alIAIElementsAIBackground = true;
  static const bool alIAIElementsAIBorder = true;
  static const bool alIAIElementsAIAura = true;
  static const bool alIAIElementsAIRevertButton = false;
  static const bool aILayerOnlyAISlug = false;
  static const bool aILayerOnlyAIBackground = true;
  static const bool aILayerOnlyAIBorder = true;
  static const bool aILayerOnlyAIAura = true;
  static const bool aILayerOnlyAIRevertButton = false;
  static const bool noAIAISpacerDataTable = true;
  static const bool alIAIElementsAISpacerDataTable = false;
  static const bool aILayerOnlyAISpacerDataTable = false;
}

/// AI revert · AI reverted
abstract final class AIRevertAIReverted {
  static const bool allAIElementsTest = false;
  static const bool aILayerOnlyTest = false;
  static const bool noAIAIRevertButton = false;
  static const bool noAIAISlug = false;
  static const bool noAIAIBackground = false;
  static const bool noAIAIBorder = false;
  static const bool noAIAIAura = false;
  static const bool alIAIElementsAISlug = false;
  static const bool alIAIElementsAIBackground = false;
  static const bool alIAIElementsAIBorder = false;
  static const bool alIAIElementsAIAura = false;
  static const bool alIAIElementsAIRevertButton = true;
  static const bool aILayerOnlyAISlug = false;
  static const bool aILayerOnlyAIBackground = false;
  static const bool aILayerOnlyAIBorder = false;
  static const bool aILayerOnlyAIAura = false;
  static const bool aILayerOnlyAIRevertButton = false;
  static const bool noAIAISpacerDataTable = true;
  static const bool alIAIElementsAISpacerDataTable = true;
  static const bool aILayerOnlyAISpacerDataTable = true;
}

/// AI Chat Modality · Floating
abstract final class AIChatModality {
  static const bool showOnFloating = true;
  static const bool showOnDocked = false;
  static const bool showOnDockedLeft = false;
  static const bool showOnDockedRight = false;
  static const bool showOnSpotlight = false;
  static const bool hideOnFloating = false;
  static const bool hideOnDocked = true;
  static const bool hideOnDockedLeft = true;
  static const bool hideOnDockedRight = true;
  static const bool hideOnSpotlight = true;
}

/// AI Chat Modality · Docked Left
abstract final class AIChatModalityDockedLeft {
  static const bool showOnFloating = false;
  static const bool showOnDocked = true;
  static const bool showOnDockedLeft = true;
  static const bool showOnDockedRight = false;
  static const bool showOnSpotlight = false;
  static const bool hideOnFloating = true;
  static const bool hideOnDocked = false;
  static const bool hideOnDockedLeft = false;
  static const bool hideOnDockedRight = true;
  static const bool hideOnSpotlight = true;
}

/// AI Chat Modality · Docked Right
abstract final class AIChatModalityDockedRight {
  static const bool showOnFloating = false;
  static const bool showOnDocked = true;
  static const bool showOnDockedLeft = false;
  static const bool showOnDockedRight = true;
  static const bool showOnSpotlight = false;
  static const bool hideOnFloating = true;
  static const bool hideOnDocked = false;
  static const bool hideOnDockedLeft = true;
  static const bool hideOnDockedRight = false;
  static const bool hideOnSpotlight = true;
}

/// AI Chat Modality · Spotlight
abstract final class AIChatModalitySpotlight {
  static const bool showOnFloating = false;
  static const bool showOnDocked = false;
  static const bool showOnDockedLeft = false;
  static const bool showOnDockedRight = false;
  static const bool showOnSpotlight = true;
  static const bool hideOnFloating = true;
  static const bool hideOnDocked = true;
  static const bool hideOnDockedLeft = true;
  static const bool hideOnDockedRight = true;
  static const bool hideOnSpotlight = false;
}
