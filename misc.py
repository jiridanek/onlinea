def escape_filename_is_mu(name: str) -> str:
    name = name.replace('/', '|')

    name = name.replace('"', '')
    name = name.replace("'", '')
    name = name.replace('?', '')
    name = name.replace('!', '')
    name = name.replace(' ', '_')
    name = name.replace(',', '_')
    name = name.replace(':', '_')
    return name[0:30] # IS imposes limit of 38, including file extension

def escape_filename_is_mu_new(name: str) -> str:
    name = name.replace('.', '_')
    name = name.replace('/', '|')

    name = name.replace('"', '')
    name = name.replace("'", '')
    name = name.replace('?', '')
    name = name.replace('!', '')
    name = name.replace(' ', '_')
    name = name.replace(',', '_')
    name = name.replace(':', '_')
    name = name.replace('#', '_')
    name = name.replace('(', '_')
    name = name.replace(')', '_')
    name = name.replace(';', '_')
    name = name.replace('Ó', '_o')
    name = name.replace('|', '_')
    name = name.replace('ü', '_')
    name = name.replace('ß', 'c')
    name = name.replace('é', '_e')
    name = name.replace('ó', '_')
    name = name.replace('¿', '_')
    name = name.replace('–', 'OCo')

    name = name.replace('&', '_')
    name = name.replace('$', '')
    name = name.replace('’', 'OCO')
    name = name.replace('+', '_')
    name = name.replace('´', '_')
    name = name.replace('°', '_')

    name = name.replace('“', 'OCt')
    name = name.replace('”', 'OCL')
    name = name.replace('í', '_s')
    name = name.replace('‘', 'OCs')
    name = name.replace('…', 'OCZ')
    name = name.replace(' ', '_a')  # this is a middle dot

    name = name.replace('聖派翠克節', 'RulS_zs_anuos_C')
    for c in ['İ', '`', '^', ]:
        name = name.replace(c, '_')

    return name[0:30]  # IS imposes limit of 38, including file extension 
