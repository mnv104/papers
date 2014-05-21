import os, sys
import rubber

class Module(rubber.rules.latex.Module):
    def __init__(self, doc, dict):
        hg = os.popen("hg id -int")
        id = hg.read().strip()
        if hg.close() or not len(id):
            rubber.msg.error("failed to execute 'hg id'")
            sys.exit(2)
        doc.cmdline.insert(0, "\\def\\hgid{%s}" % id)
