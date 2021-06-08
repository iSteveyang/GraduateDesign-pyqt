import sys
import os
import time
import subprocess
import threading
import random
import pickle
# import dill
from bypy import ByPy
from umbral import pre, keys, signing
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import *
# from PyQt5.QtCore import QThread, pyqtSignal
from mainWindow import Ui_MainForm

global capsule
global alices_public_key
global bobs_public_key
global alices_verifying_key
global bobs_private_key
global kfrags


class ThreadSelect(threading.Thread):
    def __init__(self, func, args=()):
        super(ThreadSelect, self).__init__()
        self.func = func
        self.args = args

    def run(self):
        self.func(self.args)


class MyThread(threading.Thread):
    def __init__(self, func):
        super(MyThread, self).__init__()
        self.func = func

    def run(self):
        self.func()


class My_Form(QtWidgets.QWidget, Ui_MainForm):
    def __init__(self):
        super(My_Form, self).__init__()
        self.setupUi(self)
        self.cwd = os.getcwd()  # 获取当前程序文件位置
        self.showLabel.setText("Welcome =。=")

    def uplF(self):
        bp = ByPy()
        bp.upload()
        self.showLabel.setText("Upload successful")

    def uploadFile(self):
        self.showLabel.setText("Please waiting for uploading...")
        choice = QMessageBox.question(self, '重加密选择', '是否进行重加密?\n（因百度云限制，云端重加密变为本地模拟）',
                                      QMessageBox.Yes | QMessageBox.No)  # 1
        if choice == QMessageBox.Yes:                           # 2
            self.selectT(self.reEncrypt)
        elif choice == QMessageBox.No:                          # 4
            self.selectT(self.copyF)

    def selectT(self, func):
        file = self.selectF()
        if file is None:
            pass
        else:
            t = ThreadSelect(func, file)
            t.start()
            self.showLabel.setText("Your file is uploading. Please wait.")

    def selectF(self):
        fileName_choose, filetype = QFileDialog.getOpenFileName(
            self,  "选取文件", self.cwd, "All Files (*);;Text Files (*.txt)")
        if fileName_choose == "":
            print("\n取消选择")
            self.showLabel.setText("Cancel !!")
            return

        print("\n你选择的文件为:")
        print(fileName_choose)
        print("文件筛选器类型: ", filetype)
        return fileName_choose

    def reEncrypt(self, file):
        fileName_choose = file

        global alices_public_key
        global bobs_public_key
        global alices_verifying_key
        global bobs_private_key
        # Generate umbral keys for Alice.
        alices_private_key = keys.UmbralPrivateKey.gen_key()
        alices_public_key = alices_private_key.get_pubkey()

        alices_signing_key = keys.UmbralPrivateKey.gen_key()
        alices_verifying_key = alices_signing_key.get_pubkey()
        alices_signer = signing.Signer(alices_signing_key)

        # Generate Umbral keys for Bob.
        bobs_private_key = keys.UmbralPrivateKey.gen_key()
        bobs_public_key = bobs_private_key.get_pubkey()

        self.setDir()
        with open(fileName_choose, 'rb') as f:
            fr = f.read()
            global capsule
            # Encrypt data with Alice's public key.
            ciphertext, capsule = pre.encrypt(alices_public_key, fr)
        with open('sql.encrypt', 'wb') as fe:
            fe.write(ciphertext)

        global kfrags
        # Alice generates "M of N" re-encryption key fragments (or "KFrags") for Bob.
        # In this example, 10 out of 20.
        kfrags = pre.generate_kfrags(delegating_privkey=alices_private_key,
                                     signer=alices_signer,
                                     receiving_pubkey=bobs_public_key,
                                     threshold=10,
                                     N=20)
        kfrags = random.sample(kfrags,  # All kfrags from above
                               10)      # M - Threshold

        with open('sql.cfrags', 'w') as cf:
            for i in range(len(kfrags)):
                cf.write(str(kfrags[i])+'\n')
        # with open('sql.capsule','wb') as handle:
        #     pickle.dump(capsule, handle, protocol=pickle.HIGHEST_PROTOCOL)

        # Upload
        self.uplF()
        # Output key
        # with open('../key/s.key','wb') as sk:
        #     pickle.dump(alices_public_key, sk, protocol=pickle.HIGHEST_PROTOCOL)
        with open('../key/key.txt', 'w') as ck:
            ck.write(str(alices_public_key)+'\n')
            ck.write(str(alices_verifying_key)+'\n')
            ck.write(str(bobs_private_key)+'\n')
            ck.write(str(bobs_public_key)+'\n')

    def copyF(self, file):
        fileName_choose = file

        self.setDir()
        subprocess.Popen(['cp ' + fileName_choose + ' ./'],
                         stdout=subprocess.PIPE, shell=True).communicate()

        self.uplF()

    def downloadFile(self):
        self.showLabel.setText("Please waiting for downloading...")
        dl = MyThread(self.downlF)
        dl.start()
        time.sleep(1)
        choice = QMessageBox.question(self, '解密选择', '是否进行解密?',
                                      QMessageBox.Yes | QMessageBox.No)  # 1

        if choice == QMessageBox.Yes:                           # 2
            file = self.selectF()
            if file is None:
                pass
            else:
                t = ThreadSelect(self.reDecrypt, file)
                t.start()
                self.showLabel.setText("Your file is redecrypto. Please wait.")

        elif choice == QMessageBox.No:                          # 4
            subprocess.Popen(['open ~/PycharmProjects/test/info'],
                             stdout=subprocess.PIPE, shell=True)

    def downlF(self):
        self.setDir()
        bp = ByPy()
        bp.download()
        self.showLabel.setText("Download successful")

    def reDecrypt(self, file):
        fileName_choose = file
        # Input key
        with open(fileName_choose, 'r') as cdk:
            content = cdk.readlines()
            alices_public_key1 = content[0][:len(content[0])-1]
            alices_verifying_key1 = content[1][:len(content[1])-1]
            bobs_private_key1 = content[2][:len(content[2])-1]
            bobs_public_key1 = content[3][:len(content[3])-1]

        kfrags1 = list()
        cfrags = list()

        with open('sql.cfrags', 'r') as cps:
            contentC = cps.readlines()
            for i in range(len(contentC)):
                kfrags1.append(contentC[i][:len(contentC[i])-1])
                # print(cfrags[i])
        with open('sql.encrypt', 'rb') as enp:
            ciphertext = enp.read()

        # with open('sql.capsule','rb') as handle:
        #     capsule = pickle.load(handle)
        global capsule
        global alices_public_key
        global bobs_public_key
        global alices_verifying_key
        global bobs_private_key
        global kfrags
        # Bob receives a capsule through a side channel (s3, ipfs, Google cloud, etc)
        bobs_capsule = capsule
        # Bob collects the resulting `cfrags` from several Ursulas.
        # Bob must gather at least `threshold` `cfrags` in order to activate the capsule.
        bobs_capsule.set_correctness_keys(delegating=alices_public_key,
                                          receiving=bobs_public_key,
                                          verifying=alices_verifying_key)

        for kfrag in kfrags:
            cfrag = pre.reencrypt(kfrag=kfrag, capsule=bobs_capsule)
            cfrags.append(cfrag)  # Bob collects a cfrag

        assert len(cfrags) == 10

        # Bob activates and opens the capsule
        for cfrag in cfrags:
            bobs_capsule.attach_cfrag(cfrag)

        bob_cleartext = pre.decrypt(ciphertext=ciphertext,
                                    capsule=bobs_capsule,
                                    decrypting_key=bobs_private_key)
        with open('../decrypto/clear.sql', 'wb') as ctx:
            ctx.write(bob_cleartext)

        subprocess.Popen(['open ~/PycharmProjects/test/decrypto'],
                         stdout=subprocess.PIPE, shell=True)

    def myT(self, func):
        t = MyThread(func)
        t.start()

    def showFile(self):
        self.showLabel.setText("Please waiting for look...")
        self.myT(self.showFi)

    def showFi(self):
        output = subprocess.Popen(
            ['bypy list'], stdout=subprocess.PIPE, shell=True).communicate()
        self.showLabel.setText(str(output[0], encoding="utf-8"))

    def compareFile(self):
        self.showLabel.setText("Please waiting for compare...")
        self.myT(self.compF)

    def compF(self):
        output = subprocess.Popen(['cd ~/PycharmProjects/test/info && bypy compare'],
                                  stdout=subprocess.PIPE, shell=True).communicate()
        self.showLabel.setText(str(output[0], encoding="utf-8"))

    def setDir(self):
        module_path = os.path.dirname(__file__)
        filename = module_path + '/info'
        os.chdir(filename)


if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    myqt_form = My_Form()
    myqt_form.show()
    sys.exit(app.exec_())
