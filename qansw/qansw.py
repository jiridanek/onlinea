from datetime import datetime
import json
import os
import xml.etree.ElementTree as ET

import sys


def parsexml(f):
    result = []

    et = ET.fromstring(f.read())
    for prochazejici in et.findall('./PROCHAZEJICI'):
        uco = prochazejici.attrib['UCO']
        # print(uco)
        for pruchod in prochazejici.findall('./PRUCHOD'):
            body = None
            zacatek = None
            konec = None
            for akce in pruchod.findall('./AKCE'):
                cas = akce.attrib['CAS']
                typ = akce.attrib['TYP']
                suma = akce.attrib['SUMA']

                cas = datetime.strptime(cas, '%Y%m%d%H%M%S')

                # print("{} {} {} {}".format(uco, cas, typ, suma))

                if body is None or body < suma:
                    body = suma

                if typ == 'a':
                    if zacatek != None and konec != None:
                        #store data
                        trvani = konec - zacatek if konec is not None else None
                        result.append({'uco': uco, 'cas': trvani, 'body': body})
                    zacatek = cas
                    konec = None
                if typ in ['b', 'c']:
                    if konec is None or konec < cas:
                        konec = cas

            if konec is not None and zacatek is not None:
                assert(konec > zacatek)
            trvani = konec - zacatek if konec is not None else None
            result.append({'uco': uco, 'cas': trvani, 'body': body})
    return result


def parse_zaverecny_dotaznik(filedir):
    file_path = 'Zaverecny_dotaznik.xml'
    with open(os.path.join(file_dir, file_path)) as f:
        result = []

        et = ET.fromstring(f.read())
        for prochazejici in et.findall('./PROCHAZEJICI'):
            uco = prochazejici.attrib['UCO']
            #print(uco)
            for pruchod in prochazejici.findall('./PRUCHOD'):
                for akce in pruchod.findall('./AKCE'):
                    if akce.attrib['TYP'] == 'c':
                        odps = {'uco': uco}
                        for odp in akce.findall('./ODP'):
                            por = 'q' + odp.attrib['POR']
                            hod = odp.attrib['HOD']
                            try:
                                int(hod)
                            except ValueError:
                                continue
                            odps[por] = hod
                        result.append(odps)
        with open(os.path.join(file_dir, '..', 'json', 'zaverecny.json'), 'w') as fp:
            json.dump(result, fp)


def parse_cas():
    result = []
    # for file_path in ['howtowork.xml']:
    for file_path in os.listdir(file_dir):
        if not file_path.endswith('.xml'):
            continue
        with open(os.path.join(file_dir, file_path)) as f:
            print(file_path)
            blok = parsexml(f)
            for record in blok:
                record['blok'] = file_path.rstrip('.xml')
                record['cas'] = record['cas'].total_seconds() if record['cas'] is not None else None
            result.extend(blok)

    # print([r for r in result if r['uco']=='374368'])

    with open(os.path.join(file_dir, '..', 'json', 'casy.json'), 'w') as fp:
        json.dump(result, fp)

class Question:
    def __init__(self, idmd5, text):
        self.idmd5 = idmd5
        self.text = text


def merge_t_answers_by_idmd5(answers):
    merged = {}
    for answer in answers:
        if not answer['idmd5'] in merged:
            merged[answer['idmd5']] = answer
        else:
            merged[answer['idmd5']]['odpovedi'].extend(answer['odpovedi'])
    return merged

class QANSW:
    def __init__(self, file_path):
        fp = open(file_path)
        self.tree = ET.fromstring(fp.read())

    def t_answers_unmerged(self):
        result = []
        for pruchod in self.tree.findall('.//PROCHAZEJICI/PRUCHOD'):
            otazky = {}

            for otazka in pruchod.findall('./OTAZKA'):
                poradi = otazka.attrib['PORADI']
                idmd5 = otazka.find('./IDMD5').text
                sada = otazka.find('./SADA').text

                otazky[poradi] = {'idmd5': idmd5, 'sada': sada, 'odpovedi': []}

            for akce in pruchod.findall('./AKCE'):
                odpovedi = {}
                for odpoved in akce.findall('./ODP'):
                    poradi = odpoved.attrib['POR']
                    id = odpoved.attrib['ID']
                    hodnota = odpoved.attrib['HOD']

                    if not poradi in odpovedi:
                        odpovedi[poradi] = []
                    odpovedi[poradi].append({'id': id, 'hodnota': hodnota})

                for bod in akce.findall('./BOD'):
                    poradi = bod.attrib['POR']
                    pocet = bod.attrib['POC']

                    if poradi in odpovedi:
                        # skip last word and nulls
                        for i, ok in enumerate([x for x in pocet.split() if x != 'null'][:-1]):
                            try:
                                odpovedi[poradi][i]['body'] = ok
                            except IndexError:
                                continue
                                idmd5 = otazky[poradi]['idmd5']
                                q = None
                                for qq in self.questions():
                                    if qq.idmd5 == idmd5:
                                        q = qq.text

                                print(pocet, odpovedi[poradi], file=sys.stderr)
                                print("overlapping options in question: ", q, file=sys.stderr)
                                #raise('halt')

                for poradi in otazky.keys():
                    if poradi in odpovedi:
                        otazky[poradi]['odpovedi'].extend(odpovedi[poradi])

            result.extend(list(otazky.values()))
        return result

    def questions(self):
        result = []
        for otazka in self.tree.findall('.//TEXTREG/TEXT'):
            idmd5 = otazka.attrib['IDMD5']
            text = otazka.text
            result.append(Question(idmd5, text))
        return result



