# http://jinja.pocoo.org/docs/templates/#whitespace-control

from jinja2 import Environment, FileSystemLoader
env = Environment(loader=FileSystemLoader('templates'))

qref = env.get_template('qref.xml')
qdef = env.get_template('qdef.html')
qdesc = env.get_template('qdesc.xml')


def format_qdef(jdoc):
    for q in jdoc['questions']:
        q['correct1'] = q['options'].index(q['answer']) + 1
    return qdef.render(quiz=jdoc)


"""
<IMPL_BODY_OK>1</IMPL_BODY_OK>
<SKLADAT_OPAKOVANE>ano_totez</SKLADAT_OPAKOVANE>
<MAXIMALNI_POCET_PRUCHODU>1</MAXIMALNI_POCET_PRUCHODU>
<SUMA_DO_BLOKU>nejlepsi</SUMA_DO_BLOKU>
"""
def format_qdesc(jdoc, qdef):
    return qdesc.render(quiz=jdoc, qdef=qdef)


def format_qref(qdesc):
    return qref.render(qdesc=qdesc)

# # to save the results
# with open("my_new_file.html", "wb") as fh:
#     fh.write(output_from_parsed_template)

# # https://stackoverflow.com/questions/98135/how-do-i-use-django-templates-without-the-rest-of-django
# # https://docs.djangoproject.com/en/dev/ref/templates/api/#configuring-the-template-system-in-standalone-mode
# django.conf.settings.configure(DEBUG=True, TEMPLATE_DEBUG=True)


# @register.filter("truncate_url")
# def truncate_chars(value: str, max_length: int):
#     strip_prefix_step(value, max_length)
#     return value
#
#
# def strip_prefix_step(value, max_length):
#     if len(value) > max_length:
#         for prefix in ['http://', 'https://', '//']:
#                 if value.startswith(prefix):
#                     value = value[len(prefix):]
#



# class Answer:
#     def __init__(self):
#         text = ''
#
# class Question:
#     def __init__(self):
#         text = ''
#         answers = []
#         correct = Answer()
#
#     s = 'my "testing \string'
#     print('"{}"'.format(quote(s)))
