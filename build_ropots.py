 
# walk directory tree

# keep qdesc object, create copies in a stack, add to it, pop when going up

# do if else decisions based on 
#     - what files are there
#          - put this dir name to file name
#     - config files?

# produce output: qdef, qref in tb; qref outside; audiofiles somewhere else # this is a TODO, as far as I can remember
# make sure links all match

import copy
import os
import os.path
import shutil
import xml.dom.minidom
import xml.etree.ElementTree as ET

from ismu.misc import escape_filename_is_mu_new

ISPREFIX = "https://is.muni.cz/auth/"
COURSENAME = "ONLINE_A"
TERMNAME = "podzim2015"
DEPLOYROOT = "/el/1441/{}/{}/".format(TERMNAME, COURSENAME)


#ODP = "odp"
#TB = "tb"
#AUX = "aux"

ROOT = "tb"
BUILD = "build" 
  
# shortens l from prefix, leaves .suffix be
class ISMangler:
  def __init__(self, l, isfile=True):
    self.l = l
    self.isfile = isfile
    self.mangler = {}
    self.mangles = {}
  def mangle(self, s):
    if s in self.mangler:
      return self.mangler[s]
    else:
      t = s.split('.')
      prefix = s
      suffix = ""
      if self.isfile and len(t) > 1:
        prefix = '.'.join(t[:-1])
        suffix = "." + t[-1]
      prefix = escape_filename_is_mu_new(prefix[:self.l])
      candidate = prefix + suffix
      for i in range(1, 10):
        if candidate in self.mangles:
          candidate = prefix + str(i) + suffix
        else:
          self.mangler[s] = candidate
          self.mangles[candidate] = True
          return candidate
    raise Error("mangle " + s)

is_mangle_file = ISMangler(30).mangle
is_mangle_dir = ISMangler(15, isfile=False).mangle
def is_mangle_dirs(path):
  return '/'.join([is_mangle_dir(s) for s in path.split('/')])

class Qdesc:
  def __init__(self):
    self.kv = {}
  def new(self):
    return self
  def copy(self):
    new = Qdesc()
    for k, v in self.kv.items():
      new.kv[k] = copy.deepcopy(v) # TODO: cut the chase_?
    return new
  def add_file(self, filepath):
    if not (filepath.endswith("qdesc.xml") or filepath.endswith(".qdesc")):
      return
    tree = ET.parse(filepath)
    root = tree.getroot()
    self.add(root)
  def add(self, root):
    for el in root:
      print(el) #print(root.findall("*"))
      if el.tag == "SADY_OTAZEK":            # append
        if not el.tag in self.kv:
          self.kv[el.tag] = []
        self.kv[el.tag].append(el.attrib)
      elif el.tag == "PRAVA":                # overwrite
        self.kv[el.tag] = el.attrib
      else:
        self.kv[el.tag] = el.text
  def to_xml(self, nazev, qrefdir, qdefdir):
    tb = ET.TreeBuilder()
    tb.start("ISMU-EL-QUESTDESC")
    tb.start("VERZE")
    tb.data("1.1")
    tb.end("VERZE")
    if not "TEST_NAZEV" in self.kv:
      tb.start("TEST_NAZEV")
      tb.data(nazev)
      tb.end("TEST_NAZEV")
    tb.start("QREFSL")
    tb.data(qrefdir)
    tb.end("QREFSL")
    for k,v in self.kv.items():
      if isinstance(v, dict):
        print(v)
        tb.start(k, v)
        tb.end(k)
      elif isinstance(v, list):
        for vi in v:
          if "URL" in vi:
            if vi["URL"] == "_.qdef":
              vi["URL"] = nazev + ".qdef" # must not mangle twice is_mangle_file(nazev + ".qdef")
            head, tail = os.path.split(vi["URL"])
            # qdefdir seems to be mangled
            vi["URL"] = os.path.join('/', qdefdir, is_mangle_dirs(head), is_mangle_file(tail))
          tb.start(k, vi)
          tb.end(k)
      elif isinstance(v, str):
        tb.start(k)
        tb.data(v)
        tb.end(k)
      else:
        print("err")
    tb.end("ISMU-EL-QUESTDESC")
    return tb.close()
        
class Context:
  def __init__(self):
    self.dirpath = None
    self.modules = {}
  def new(self, dirpath):
    self.dirpath = dirpath
    self.modules = {"qdesc": Qdesc()}
    return self
  def copy(self, dirpath):
    new = Context()
    new.dirpath = dirpath
    for k,v in self.modules.items():
      new.modules[k] = v.copy()
    return new
  def add_file(self, filepath):
    for module in self.modules.values():
      module.add_file(filepath)

zkratka = 200000
def is_folder(dirname, content, subfolders):
  global zkratka
  uzly = []
  for name, fname in content:
    zkratka += 1
    uzly.append(("  <uzel>\n"
    "    <nazev>{}</nazev>\n"
    "    <zkratka_pro_url>{}</zkratka_pro_url>\n"
    "    <objekt>\n"
    #"      <mime_type>text/x-ismu-el-questref1</mime_type>\n"
    "      <kodovani>i</kodovani>\n"
    "      <jmeno_souboru>{}</jmeno_souboru>\n"
    "    </objekt>\n"
    "  </uzel>").format(name, zkratka, fname))
  for name, fname in subfolders:
    uzly.append(("  <uzel>\n"
    "    <nazev>{}</nazev>\n"
    "    <zkratka_pro_url>{}</zkratka_pro_url>\n"
    "  </uzel>").format(name, fname))
  is_folder = """<?xml version="1.0" encoding="utf-8"?>
<slozka>
  <tento_uzel>
    <nazev>{}</nazev>
  </tento_uzel>
{}
</slozka>""".format(dirname, "\n".join(uzly))
  return is_folder

try:
  shutil.rmtree(BUILD)
except:
  pass

try:
  shutil.rmtree(BUILD + '_')
except:
  pass

try:
  os.makedirs(BUILD + '_')
except:
  pass

c = [Context().new("")]
for dirpath, dirnames, filenames in os.walk(ROOT, followlinks=True):
  head, tail = os.path.split(dirpath)
  exercisename = tail
  while len(c) > 1:
    parent = c[-1].dirpath
    print(head)
    if parent != head:
      c.pop()
      print("pop")
    else:
      break
  c.append(c[-1].copy(dirpath))
  print(",".join([i.dirpath for i in c]))
  #print(c, dirpath)
  
  outdirpath = dirpath[len(ROOT)+1:]
  qrefdir = os.path.join(BUILD, outdirpath)
  if "qdesc.xml" not in filenames:
    qrefdir, _ = os.path.split(qrefdir) # '/../' # up one directory
  qdefdir = os.path.join(BUILD, 'tb', outdirpath)
  try:
    os.makedirs(qrefdir)
  except:
    pass
  try:
    os.makedirs(qdefdir)
  except:
    pass
  
  # first get all xmls
  for filename in filenames:
    filepath = os.path.join(dirpath, filename)
    if not filepath.endswith(".qdesc"):
      c[-1].add_file(filepath)
    print(filepath)
    
  # do this later #write is_folder files
  #isfolder = is_folder(exercisename,
                       #[(f, is_mangle(f)) for f in filenames if f.endswith(".qdesc") or f.endswith(".qdef")])
  #with open(os.path.join(qdefdir, "is_folder_info.xml"), "wt") as w:
    #w.write(isfolder)
  
  hasqdesc = []
  for filename in filenames:
    filepath = os.path.join(dirpath, filename)
    outfname = filename
    if outfname.startswith("_."):
      outfname = exercisename + filename[1:]
    #outfilepath = os.path.join(outdirpath, outfname)

    if filename.endswith(".mp3"):
      #shutil.copyfile(filepath, qrefdir + '/' + outfname)
      pass # skip for now
    if filename.endswith(".qdef"):
      #shutil.copyfile(filepath, qdefdir + '/' + outfname)
      with open(filepath, 'rt') as r:
        content = r.read()
        content = content.replace("https://is.muni.cz/auth/el/1441/podzim2014/ONLINE_A/", "https://is.muni.cz/auth/el/1441/jaro2015/ONLINE_A/")
        with open(qdefdir + '/' + outfname, 'wt') as w:
          w.write(content)
    if filename.endswith(".qdesc"):
      hasqdesc.append((filename, outfname))
  for qdesc, outqdesc in hasqdesc:
    cc = c[-1].copy(qdesc)
    cc.add_file(os.path.join(dirpath, qdesc))
    ISqdefdir = DEPLOYROOT + is_mangle_dirs(os.path.join('odp/tb', outdirpath)) # not escape safe
    #ISqrefdir = DEPLOYROOT + is_mangle_dirs(qrefdir) # not escape safe
    root = cc.modules["qdesc"].to_xml(exercisename, os.path.join(DEPLOYROOT, qrefdir), ISqdefdir)
    reparsed = xml.dom.minidom.parseString(ET.tostring(root, encoding="unicode"))
    pretty_xml_as_string = reparsed.toprettyxml(indent="  ")
    #drop first line (encoding)
    pretty_xml_as_string = pretty_xml_as_string[pretty_xml_as_string.find('\n')+1:]
    with open(BUILD + '/tb/' + os.path.join(outdirpath, outqdesc), 'wt') as fd:
      fd.write(pretty_xml_as_string)
      
    # qref
    if qdesc == "_.qdesc":
      qdesc = is_mangle_file(exercisename + '.qdesc')
    mangledfilename = qdesc #is_mangle_file(qdesc) # the DayZ bug ## fuckdayz, doublemangle
    qref = ("<ISMU-EL-QUESTREF>\n"
    "  <QDESC_URL>\n    " + ISqdefdir + '/' + mangledfilename + "\n"
    #"     /el/1441/podzim2014/ONLINE_A/odp/experiments/50542980/qdesc/4._I_can_swim.qdesc"
    "  </QDESC_URL>\n"
    "</ISMU-EL-QUESTREF>")
    with open(os.path.join(qrefdir, outqdesc.replace(".qdesc", ".qref")), "wt") as w:
      w.write(qref)

#is_folder_
for dirpath, dirnames, filenames in os.walk(BUILD, followlinks=True):
  _, tail = os.path.split(dirpath)
  #if dirpath == BUILD:
    #dirnames[:] = [d for d in dirnames if not d == "tb"]
  mangleddirpath = BUILD + '_' + '/' + is_mangle_dirs(dirpath)
  os.makedirs(mangleddirpath)
  for filename in filenames:
    filepath = os.path.join(dirpath, filename)
    mangledfilename = is_mangle_file(filename)
    shutil.copyfile(filepath, mangleddirpath + '/' + mangledfilename)
  
  # drop extension
  isfolder = is_folder(tail,
                      [(os.path.splitext(f)[0], is_mangle_file(f)) for f in filenames],
                      [(f, is_mangle_dir(f)) for f in dirnames]) # folders too
  with open(os.path.join(mangleddirpath, "is_folder_info.xml"), "wt") as w:
    w.write(isfolder)
      
q = Qdesc().new()
q.add_file(ROOT + "/qdesc.xml")
print(q.kv)
print(ET.tostring(q.to_xml("aa", "bb", "dd"), encoding="unicode"))