/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/// @file
///     @author Don Gagne <don@thegagnes.com>

#include "QGCPalette.h"
#include "QGCApplication.h"
#include "QGCCorePlugin.h"

#include <QApplication>
#include <QPalette>

QList<QGCPalette*>   QGCPalette::_paletteObjects;

QGCPalette::Theme QGCPalette::_theme = QGCPalette::Dark;

QMap<int, QMap<int, QMap<QString, QColor>>> QGCPalette::_colorInfoMap;

QStringList QGCPalette::_colors;

QGCPalette::QGCPalette(QObject* parent) :
    QObject(parent),
    _colorGroupEnabled(true)
{
    if (_colorInfoMap.isEmpty()) {
        _buildMap();
    }

    // We have to keep track of all QGCPalette objects in the system so we can signal theme change to all of them
    _paletteObjects += this;
}

QGCPalette::~QGCPalette()
{
    bool fSuccess = _paletteObjects.removeOne(this);
    if (!fSuccess) {
        qWarning() << "Internal error";
    }
}

void QGCPalette::_buildMap()
{
    //                                  Advanced Concepts / EDGE visual system
    //                                  Light                 Dark
    //                                  Disabled   Enabled    Disabled   Enabled
    DECLARE_QGC_COLOR(window,               "#e9edf1", "#f4f6f8", "#0b1118", "#101820")
    DECLARE_QGC_COLOR(windowShadeLight,     "#c3cbd3", "#dbe1e7", "#293744", "#24313d")
    DECLARE_QGC_COLOR(windowShade,          "#b2bdc7", "#cbd3da", "#1b2732", "#1a2631")
    DECLARE_QGC_COLOR(windowShadeDark,      "#9ba7b2", "#adb8c2", "#141e27", "#131c25")
    DECLARE_QGC_COLOR(text,                 "#87929d", "#15212c", "#71808d", "#eef3f7")
    DECLARE_QGC_COLOR(warningText,          "#b3261e", "#b3261e", "#ff7474", "#ff7474")
    DECLARE_QGC_COLOR(button,               "#e6ebef", "#ffffff", "#25323d", "#1c2833")
    DECLARE_QGC_COLOR(buttonText,           "#87929d", "#1d2b36", "#71808d", "#eaf0f4")
    DECLARE_QGC_COLOR(buttonHighlight,      "#dce3e8", "#f15a24", "#31414f", "#f15a24")
    DECLARE_QGC_COLOR(buttonHighlightText,  "#22313c", "#ffffff", "#dce5eb", "#ffffff")
    DECLARE_QGC_COLOR(primaryButton,        "#a7b3bc", "#f15a24", "#52616c", "#f15a24")
    DECLARE_QGC_COLOR(primaryButtonText,    "#ffffff", "#ffffff", "#ffffff", "#ffffff")
    DECLARE_QGC_COLOR(textField,            "#ffffff", "#ffffff", "#2a3742", "#202d38")
    DECLARE_QGC_COLOR(textFieldText,        "#7f8c96", "#15212c", "#8d9aa5", "#edf3f6")
    DECLARE_QGC_COLOR(mapButton,            "#64727d", "#15212c", "#52616c", "#edf3f6")
    DECLARE_QGC_COLOR(mapButtonHighlight,   "#64727d", "#f15a24", "#52616c", "#f15a24")
    DECLARE_QGC_COLOR(mapIndicator,         "#64727d", "#f15a24", "#52616c", "#f15a24")
    DECLARE_QGC_COLOR(mapIndicatorChild,    "#64727d", "#5b7c91", "#52616c", "#5b7c91")    DECLARE_QGC_COLOR(colorGreen,           "#009431", "#009431", "#00e04b", "#00e04b")
    DECLARE_QGC_COLOR(colorOrange,          "#b95604", "#b95604", "#de8500", "#de8500")
    DECLARE_QGC_COLOR(colorRed,             "#ed3939", "#ed3939", "#f32836", "#f32836")
    DECLARE_QGC_COLOR(colorGrey,            "#808080", "#808080", "#bfbfbf", "#bfbfbf")
    DECLARE_QGC_COLOR(colorBlue,            "#1a72ff", "#1a72ff", "#536dff", "#536dff")
    DECLARE_QGC_COLOR(alertBackground,      "#eecc44", "#eecc44", "#eecc44", "#eecc44")
    DECLARE_QGC_COLOR(alertBorder,          "#808080", "#808080", "#808080", "#808080")
    DECLARE_QGC_COLOR(alertText,            "#000000", "#000000", "#000000", "#000000")
    DECLARE_QGC_COLOR(missionItemEditor,    "#585858", "#dbfef8", "#585858", "#585d83")
    DECLARE_QGC_COLOR(toolStripHoverColor,  "#585858", "#9D9D9D", "#585858", "#585d83")
    DECLARE_QGC_COLOR(statusFailedText,     "#9d9d9d", "#000000", "#707070", "#ffffff")
    DECLARE_QGC_COLOR(statusPassedText,     "#9d9d9d", "#000000", "#707070", "#ffffff")
    DECLARE_QGC_COLOR(statusPendingText,    "#9d9d9d", "#000000", "#707070", "#ffffff")
    DECLARE_QGC_COLOR(toolbarBackground,    "#edf1f4", "#f8fafb", "#121c25", "#101820")

    // Colors not affecting by theming
    //                                              Disabled    Enabled
    DECLARE_QGC_NONTHEMED_COLOR(brandingPurple,     "#d94b1f", "#f15a24")
    DECLARE_QGC_NONTHEMED_COLOR(brandingBlue,       "#57c7e8", "#57c7e8")
    DECLARE_QGC_NONTHEMED_COLOR(toolStripFGColor,   "#707070", "#ffffff")

    // Colors not affecting by theming or enable/disable
    DECLARE_QGC_SINGLE_COLOR(mapWidgetBorderLight,          "#ffffff")
    DECLARE_QGC_SINGLE_COLOR(mapWidgetBorderDark,           "#000000")
    DECLARE_QGC_SINGLE_COLOR(mapMissionTrajectory,          "#be781c")
    DECLARE_QGC_SINGLE_COLOR(surveyPolygonInterior,         "green")
    DECLARE_QGC_SINGLE_COLOR(surveyPolygonTerrainCollision, "red")
}

void QGCPalette::setColorGroupEnabled(bool enabled)
{
    _colorGroupEnabled = enabled;
    emit paletteChanged();
}

void QGCPalette::setGlobalTheme(Theme newTheme)
{
    // Mobile build does not have themes
    if (_theme != newTheme) {
        _theme = newTheme;
        _signalPaletteChangeToAll();
    }
}

void QGCPalette::_signalPaletteChangeToAll()
{
    // Notify all objects of the new theme
    foreach (QGCPalette* palette, _paletteObjects) {
        palette->_signalPaletteChanged();
    }
}

void QGCPalette::_signalPaletteChanged()
{
    emit paletteChanged();
}
