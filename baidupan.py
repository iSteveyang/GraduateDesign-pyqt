import progressbar
from baidupcsapi import PCS

class ProgressBar():
    def __init__(self):
        self.first_call = True
    def __call__(self, *args, **kwargs):
        if self.first_call:
            self.widgets = [progressbar.Percentage(), ' ', progressbar.Bar(marker=progressbar.RotatingMarker('>')),
                            ' ', progressbar.ETA()]
            self.pbar = progressbar.ProgressBar(widgets=self.widgets, maxval=kwargs['size']).start()
            self.first_call = False

        if kwargs['size'] <= kwargs['progress']:
            self.pbar.finish()
        else:
            self.pbar.update(kwargs['progress'])


pcs = PCS('username','password')
test_file = open('bigfile.pdf','rb').read()
ret = pcs.upload('/',test_file,'bigfile.pdf',callback=ProgressBar())
