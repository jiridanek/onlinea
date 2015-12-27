import glob
import os

try:
    from typing import List
except:
    class FakeType:
        def __getitem__(self, item):
            pass
    List = FakeType()

from qansw import QANSW, Question, merge_t_answers_by_idmd5
import json

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


def normalize_answers(answers):
    for a in answers.keys():
        for o, v in enumerate(answers[a]['odpovedi']):
            answers[a]['odpovedi'][o]['hodnota'] = normalize(v['hodnota'])


def normalize(s: str):
    s = s.lower()
    s = s.translate(str.maketrans('ěščřžýáíéóůú', 'escrzyaieouu'))
    s = s.translate(str.maketrans('"´', "''", '.,?!'))
    s = s.strip()
    s = deduplicate_spaces(s)
    return s


def deduplicate_spaces(string: str):
    return ' '.join(string.split())


def remove_duplicate_answers(answers):
    for a in answers.keys():
        odpovedi = []
        hodnoty = {}
        for o, v in enumerate(answers[a]['odpovedi']):
            hodnota = answers[a]['odpovedi'][o]['hodnota']
            if hodnota in hodnoty:
                hodnoty[hodnota] += 1
            else:
                hodnoty[hodnota] = 1
                odpovedi.append(answers[a]['odpovedi'][o])
        for i, odpoved in enumerate(odpovedi):
            odpoved['count'] = hodnoty[odpoved['hodnota']]

        answers[a]['odpovedi'] = odpovedi


def partitioned_by_file(questions: dict) -> dict:
    sada = {}
    for question in questions.values():
        if not question['sada'] in sada:
            sada[question['sada']] = []
        sada[question['sada']].append(question)
    return sada


def print_qas(questiontexts: List[Question], questions: list):
    tmp = []
    for question in questions:
        oks = []
        noks = []
        for answer in question['odpovedi']:
            if 'body' not in answer or answer['body'].startswith('nok'):
                noks.append(answer)
            else:
                oks.append(answer)
        ratio = sum(map(lambda x: x['count'], noks)) / (sum(map(lambda x: x['count'], oks)) + 1)
        tmp.append((ratio, question, oks, noks))
    for ratio, question, oks, noks in sorted(tmp, key=lambda x: x[0], reverse=True):
        print('<b>', ratio, '</b>')
        print_qas_(questiontexts, question, oks, noks)


def print_qas_(questiontexts, question, oks, noks):
        for text in questiontexts:
            if text.idmd5 == question['idmd5']:
                print('<pre>', text.text, '</b></pre>')
                break
        print('<h3>NOK:</h3>')
        for nok in sorted_answers(noks):
            print_a(nok)
        print('<h3>OK:</h3>')
        for ok in sorted_answers(oks):
            print_a(ok)
        print('<hr>')


def sorted_answers(answers):
    return sorted(answers, key=lambda x: x['count'], reverse=True)


def print_a(answer):
    print('<b>', answer['count'], '</b>', answer['id'], answer['hodnota'], '<br>')


def print_report(texts, normalized_answers):
    remove_duplicate_answers(normalized_answers)

    #print(json.dumps(c, indent=4))

    d = partitioned_by_file(normalized_answers)
    for f, p in d.items():
        print('<h2>', f,'</h2>')
        print_qas(texts, p)


def main():
    texts = []
    answers = []

    # for file_path in glob.glob('semester/xml/01_L3.xml'):
    for file_path in glob.glob('/home/jirka/onlinea/odpovedi/**/*.qansw', recursive=True):
        # print(file_path)
        # raise(halt)
        qansw = QANSW(file_path)
        texts.extend(qansw.questions())
        answers.extend(qansw.t_answers_unmerged())

    merged = merge_t_answers_by_idmd5(answers)
    normalize_answers(merged)

    print_report(texts, merged)

main()


# odpovedi = []
# with open(os.path.join(file_dir, file_path)) as fp:
#     tree = ET.fromstring(fp.read())
#     for odpoved in tree.findall('.//ODP'):
#         poradi = int(odpoved.attrib['POR'])
#         odpovedi.append(odpoved.attrib['HOD'])
