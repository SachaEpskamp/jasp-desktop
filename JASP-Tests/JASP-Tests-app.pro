
QT += core gui webkit webkitwidgets svg network testlib

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

windows:CONFIG += c++11
linux:CONFIG += c++11
linux:CONFIG += -pipe

DESTDIR = ..

TARGET = JASPTests
CONFIG += console
CONFIG -= app_bundle
TEMPLATE = app

INCLUDEPATH += ../JASP-Desktop/ \
	../JASP-Common/ \
	../JASP-Engine/

   macx:INCLUDEPATH += ../../boost_1_54_0
windows:INCLUDEPATH += ../../boost_1_54_0

PRE_TARGETDEPS += ../libJASP-Desktop.a
LIBS += -L.. -lJASP-Desktop


PRE_TARGETDEPS += ../libJASP-Common.a
PRE_TARGETDEPS += ../libicu-connector.a
LIBS += -L.. -lJASP-Common

#
# For code page conversion.
 linux:LIBS += -licu-connector -licuuc -licudata
  macx:LIBS +=

windows:LIBS += -lboost_filesystem-mt -lboost_system-mt -larchive.dll
   macx:LIBS += -lboost_filesystem-mt -lboost_system-mt -larchive -lz
  linux:LIBS += -lboost_filesystem    -lboost_system    -larchive -lrt

macx:ICON = icon.icns
windows:RC_FILE = icon.rc

windows:LIBS += -lole32 -lole

QMAKE_CXXFLAGS += -Wno-c++11-extensions
QMAKE_CXXFLAGS += -Wno-unused-parameter
QMAKE_CXXFLAGS += -Wno-c++11-long-long
QMAKE_CXXFLAGS += -Wno-c++11-extra-semi

QMAKE_CXXFLAGS += -DBOOST_USE_WINDOWS_H

linux {
    _R_HOME = $$(R_HOME)
    isEmpty(_R_HOME):_R_HOME = /usr/lib/R
    QMAKE_CXXFLAGS += -D\'R_HOME=\"$$_R_HOME\"\'
}


SOURCES += \
    main.cpp \
    textfileread_test.cpp \
    osf_test.cpp

HEADERS += \
    AutomatedTests.h \
    textfileread_test.h \
    osf_test.h

HELP_PATH = $${PWD}/../Docs/help
RESOURCES_PATH = $${PWD}/../Resources

win32 {

    RESOURCES_PATH_DEST = $${OUT_PWD}/../Resources/

    RESOURCES_PATH ~= s,/,\\,g
    RESOURCES_PATH_DEST ~= s,/,\\,g

    copyres.commands  += $$quote(cmd /c xcopy /S /I /Y $${RESOURCES_PATH} $${RESOURCES_PATH_DEST})
}

macx {

    RESOURCES_PATH_DEST = $${OUT_PWD}/../../Resources/

    copyres.commands += $(MKDIR) $$RESOURCES_PATH_DEST ;
    copyres.commands += cp -R $$RESOURCES_PATH/* $$RESOURCES_PATH_DEST ;
}

linux {

    RESOURCES_PATH_DEST = $${OUT_PWD}/../Resources/

    copyres.commands += $(MKDIR) $$RESOURCES_PATH_DEST ;
    copyres.commands += cp -R $$RESOURCES_PATH/* $$RESOURCES_PATH_DEST ;
}

! equals(PWD, $${OUT_PWD}) {

    QMAKE_EXTRA_TARGETS += copyres
    POST_TARGETDEPS     += copyres
}
