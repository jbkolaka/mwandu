// Variables exported from FigCraft.
// Module: Ai

import 'dart:ui';

import 'package:mwandu/core/shared/styles/colors.style.dart';

/// AI · Mode
abstract final class AI {
  static const Color userTypeNonUserLightThemeChatPromptBorder = CColors.white0;
  static const Color userTypeNonUserLightThemeChatPromptBorderStart = CColors.gray10;
  static const Color userTypeNonUserLightThemeChatPromptBorderEnd = CColors.gray10;
  static const Color userTypeNonUserDarkThemeChatPromptBackground = CColors.gray100;
  static const Color userTypeNonUserDarkThemeChatPromptBorder = CColors.gray100;
  static const Color userTypeNonUserDarkThemeChatPromptBorderStart = CColors.gray90;
  static const Color userTypeNonUserDarkThemeChatPromptBorderEnd = CColors.gray90;
  static const Color chatBubbleUser = CColors.white0;
  static const Color userTypeNonUserLightThemeChatPromptBackground = CColors.white0;
  static const Color chatBubbleAgent = CColors.white0;
  static const Color chatBubbleAgentBorder = CColors.white0;
  static const Color chatAvatarBot = CColors.white0;
  static const Color chatAvatarAgent = CColors.white0;
  static const Color chatAvatarUser = CColors.white0;
  static const Color chatPromptBorderStart = CColors.white0;
  static const Color chatPromptBorderEnd = CColors.white0;
  static const Color chatShellLightThemeChatPromptBackground = CColors.white0;
  static const Color chatShellLightThemeChatPromptBorder = CColors.white0;
  static const Color chatShellLightThemeChatPromptBorderStart = CColors.gray10;
  static const Color chatShellLightThemeChatPromptBorderEnd = CColors.gray10;
  static const Color userTypeUserLightThemeChatAvatarBot = CColors.blue60;
  static const Color userTypeUserLightThemeChatAvatarAgent = CColors.gray100;
  static const Color userTypeUserLightThemeChatAvatarUser = CColors.gray100;
  static const Color chatShellDarkThemeChatPromptBackground = CColors.gray100;
  static const Color chatShellDarkThemeChatPromptBorder = CColors.gray100;
  static const Color chatShellDarkThemeChatPromptBorderStart = CColors.gray90;
  static const Color chatShellDarkThemeChatPromptBorderEnd = CColors.gray90;
  static const Color userTypeUserDarkThemeChatBubble = CColors.gray80;
  static const Color userTypeUserDarkThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const Color userTypeUserDarkThemeChatAvatarBot = CColors.blue50;
  static const Color userTypeUserDarkThemeChatAvatarAgent = CColors.gray10;
  static const Color userTypeUserDarkThemeChatAvatarUser = CColors.gray10;
  static const Color userTypeNonUserLightThemeChatBubbleBorder = CColors.gray20;
  static const Color userTypeNonUserLightThemeChatBubble = CColors.white0;
  static const Color userTypeNonUserLightThemeChatAvatarBot = CColors.blue60;
  static const Color userTypeNonUserLightThemeChatAvatarAgent = CColors.gray100;
  static const Color userTypeNonUserLightThemeChatAvatarUser = CColors.gray100;
  static const Color userTypeNonUserDarkThemeChatBubble = CColors.gray90;
  static const Color userTypeNonUserDarkThemeChatBubbleBorder = CColors.gray70;
  static const Color userTypeNonUserDarkThemeChatAvatarBot = CColors.blue50;
  static const Color userTypeNonUserDarkThemeChatAvatarAgent = CColors.gray10;
  static const Color userTypeNonUserDarkThemeChatAvatarUser = CColors.gray10;
  static const Color userTypeUserLightThemeChatBubble = CColors.gray20;
  static const Color userTypeUserLightThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const Color userTypeUserLightThemeChatBubbleHover = Color(0xFFD1D1D1);
  static const Color userTypeUserLightThemeChatBubbleActive = CColors.gray40;
  static const Color userTypeUserDarkThemeChatBubbleHover = Color(0xFF474747);
  static const Color userTypeUserDarkThemeChatBubbleActive = CColors.gray60;
  static const Color userTypeNonUserLightThemeChatBubbleHover = CColors.gray10;
  static const Color userTypeNonUserLightThemeChatBubbleActive = CColors.gray20;
  static const Color userTypeNonUserDarkThemeChatBubbleHover = Color(0xFF333333);
  static const Color userTypeNonUserDarkThemeChatBubbleActive = CColors.gray70;
  static const Color aISlugLightThemeEnabledAISlugGradientBackground = CColors.gray100;
  static const Color aISlugLightThemeEnabledAISlugGradientStop1 = CColors.gray40;
  static const Color aISlugLightThemeEnabledAISlugGradientStop2 = CColors.white0;
  static const Color aISlugLightThemeHoverAISlugGradientBackgroundHover = Color(0xFF292929);
  static const Color aISlugLightThemeHoverAISlugGradientStop1Hover = Color(0xFFD1D1D1);
  static const Color aISlugLightThemeHoverAISlugGradientStop2Hover = CColors.white0;
  static const Color aISlugDarkThemeEnabledAISlugGradientBackground = CColors.gray50;
  static const Color aISlugDarkThemeEnabledAISlugGradientStop1 = CColors.gray10;
  static const Color aISlugDarkThemeEnabledAISlugGradientStop2 = CColors.white0;
  static const Color aISlugDarkThemeHoverAISlugGradientBackgroundHover = Color(0xFF999999);
  static const Color aISlugDarkThemeHoverAISlugGradientStop1Hover = CColors.white0;
  static const Color aISlugDarkThemeHoverAISlugGradientStop2Hover = CColors.white0;
  static const Color aISlugLightThemeEnabledAISlugSolidBackground = CColors.gray70;
  static const Color aISlugLightThemeHoverAISlugSolidBackgroundHover = Color(0xFF5E5E5E);
  static const Color aISlugDarkThemeEnabledAISlugSolidBackground = CColors.gray30;
  static const Color aISlugDarkThemeHoverAISlugSolidBackgroundHover = Color(0xFFD1D1D1);
  static const Color aISkeletonLightThemeAISkeletonBackground = CColors.blue20;
  static const Color aISkeletonLightThemeAISkeletonElement = CColors.blue30;
  static const Color aISkeletonDarkThemeAISkeletonBackground = Color(0x8078A9FF);
  static const Color aISkeletonDarkThemeAISkeletonElement = Color(0x4D78A9FF);
  static const Color chatShellLightThemeChatShellBackground = CColors.white0;
  static const Color chatShellLightThemeChatHeaderBackground = CColors.white0;
  static const Color chatShellDarkThemeChatShellBackground = CColors.gray90;
  static const Color chatShellDarkThemeChatHeaderBackground = CColors.gray90;
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
  static const Color lightThemeChatPromptBackground = CColors.white0;
  static const Color lightThemeChatPromptBorder = CColors.white0;
  static const Color lightThemeChatPromptBorderStart = CColors.white0;
  static const Color lightThemeChatPromptBorderEnd = CColors.white0;
  static const Color lightThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const Color darkThemeChatPromptBackground = CColors.white0;
  static const Color darkThemeChatPromptBorder = CColors.white0;
  static const Color darkThemeChatPromptBorderStart = CColors.white0;
  static const Color darkThemeChatPromptBorderEnd = CColors.white0;
  static const Color darkThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const bool showForUser = true;
  static const bool showForNonUser = false;
}

/// AI - User type · Non-user
abstract final class AIUserTypeNonUser {
  static const Color lightThemeChatPromptBackground = CColors.white0;
  static const Color lightThemeChatPromptBorder = CColors.white0;
  static const Color lightThemeChatPromptBorderStart = CColors.white0;
  static const Color lightThemeChatPromptBorderEnd = CColors.white0;
  static const Color lightThemeChatBubbleBorder = Color(0x00FFFFFF);
  static const Color darkThemeChatPromptBackground = CColors.white0;
  static const Color darkThemeChatPromptBorder = CColors.white0;
  static const Color darkThemeChatPromptBorderStart = CColors.white0;
  static const Color darkThemeChatPromptBorderEnd = CColors.white0;
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
