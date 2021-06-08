# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'mainWindow.ui'
#
# Created by: PyQt5 UI code generator 5.12.2
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_MainForm(object):
    def setupUi(self, MainForm):
        MainForm.setObjectName("MainForm")
        MainForm.resize(640, 480)
        self.verticalLayoutWidget = QtWidgets.QWidget(MainForm)
        self.verticalLayoutWidget.setGeometry(QtCore.QRect(350, 320, 231, 151))
        self.verticalLayoutWidget.setObjectName("verticalLayoutWidget")
        self.buttonLayout = QtWidgets.QVBoxLayout(self.verticalLayoutWidget)
        self.buttonLayout.setContentsMargins(0, 0, 0, 0)
        self.buttonLayout.setObjectName("buttonLayout")
        self.upload = QtWidgets.QPushButton(self.verticalLayoutWidget)
        self.upload.setFocusPolicy(QtCore.Qt.ClickFocus)
        self.upload.setObjectName("upload")
        self.buttonLayout.addWidget(self.upload)
        self.download = QtWidgets.QPushButton(self.verticalLayoutWidget)
        self.download.setFocusPolicy(QtCore.Qt.ClickFocus)
        self.download.setObjectName("download")
        self.buttonLayout.addWidget(self.download)
        self.verticalLayoutWidget_2 = QtWidgets.QWidget(MainForm)
        self.verticalLayoutWidget_2.setGeometry(QtCore.QRect(50, 320, 231, 151))
        self.verticalLayoutWidget_2.setObjectName("verticalLayoutWidget_2")
        self.buttonLayout_2 = QtWidgets.QVBoxLayout(self.verticalLayoutWidget_2)
        self.buttonLayout_2.setContentsMargins(0, 0, 0, 0)
        self.buttonLayout_2.setObjectName("buttonLayout_2")
        self.showF = QtWidgets.QPushButton(self.verticalLayoutWidget_2)
        self.showF.setFocusPolicy(QtCore.Qt.ClickFocus)
        self.showF.setObjectName("showF")
        self.buttonLayout_2.addWidget(self.showF)
        self.compareF = QtWidgets.QPushButton(self.verticalLayoutWidget_2)
        self.compareF.setFocusPolicy(QtCore.Qt.ClickFocus)
        self.compareF.setObjectName("compareF")
        self.buttonLayout_2.addWidget(self.compareF)
        self.showLabel = QtWidgets.QLabel(MainForm)
        self.showLabel.setGeometry(QtCore.QRect(120, 40, 401, 231))
        self.showLabel.setText("")
        self.showLabel.setScaledContents(True)
        self.showLabel.setWordWrap(True)
        self.showLabel.setObjectName("showLabel")

        self.retranslateUi(MainForm)
        self.download.clicked.connect(MainForm.downloadFile)
        self.upload.clicked.connect(MainForm.uploadFile)
        self.compareF.clicked.connect(MainForm.compareFile)
        self.showF.clicked.connect(MainForm.showFile)
        QtCore.QMetaObject.connectSlotsByName(MainForm)

    def retranslateUi(self, MainForm):
        _translate = QtCore.QCoreApplication.translate
        MainForm.setWindowTitle(_translate("MainForm", "基于区块链的云存储模块"))
        self.upload.setToolTip(_translate("MainForm", "选择个人信息文件以便于上传"))
        self.upload.setText(_translate("MainForm", "Upload file"))
        self.download.setToolTip(_translate("MainForm", "下载个人信息文件"))
        self.download.setText(_translate("MainForm", "Download file"))
        self.showF.setToolTip(_translate("MainForm", "展示云端个人信息文件"))
        self.showF.setText(_translate("MainForm", "Show file"))
        self.compareF.setToolTip(_translate("MainForm", "比较个人信息文件"))
        self.compareF.setText(_translate("MainForm", "Comepare file"))


