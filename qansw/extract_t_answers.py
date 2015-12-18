
"""CREATE TABLE otazka (
    id character(32) PRIMARY KEY,
    text text,
    ctime timestamp DEFAULT CURRENT_TIMESTAMP
);"""

"""CREATE TABLE odpoved (
    otazka character(32) FOREIGN KEY otazka(id)
    jdoc jsond
    body text
    ctime timestamp DEFAULT CURRENT_TIMESTAMP
);"""

from qansw import *

file_path = '01_L21.xml'

odpovednik = {'otazky': [], 'pruchody': []}


file_dir = 'semester/xml'
r = parse_t_answers(file_dir)

print(r)


# odpovedi = []
# with open(os.path.join(file_dir, file_path)) as fp:
#     tree = ET.fromstring(fp.read())
#     for odpoved in tree.findall('.//ODP'):
#         poradi = int(odpoved.attrib['POR'])
#         odpovedi.append(odpoved.attrib['HOD'])
