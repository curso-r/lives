# %%
import requests
import pandas as pd

# %%

# conversationId:
# dadosConsulta.pesquisaLivre: league of legends
# tipoNumero: UNIFICADO
# numeroDigitoAnoUnificado:
# foroNumeroUnificado:
# dadosConsulta.nuProcesso:
# dadosConsulta.nuProcessoAntigo:
# classeTreeSelection.values:
# classeTreeSelection.text:
# assuntoTreeSelection.values:
# assuntoTreeSelection.text:
# agenteSelectedEntitiesList:
# contadoragente: 0
# contadorMaioragente: 0
# cdAgente:
# nmAgente:
# dadosConsulta.dtInicio:
# dadosConsulta.dtFim: 13/03/2024
# varasTreeSelection.values:
# varasTreeSelection.text:
# dadosConsulta.ordenacao: DESC

# %%
query_dict = {
  "conversationId": "",
  "dadosConsulta.pesquisaLivre": "league of legends",
  "tipoNumero": "UNIFICADO",
  "numeroDigitoAnoUnificado": "",
  "foroNumeroUnificado": "",
  "dadosConsulta.nuProcesso": "",
  "dadosConsulta.nuProcessoAntigo": "",
  "classeTreeSelection.values": "",
  "classeTreeSelection.text": "",
  "assuntoTreeSelection.values": "",
  "assuntoTreeSelection.text": "",
  "agenteSelectedEntitiesList": "",
  "contadoragente": 0,
  "contadorMaioragente": 0,
  "cdAgente": "",
  "nmAgente": "",
  "dadosConsulta.dtInicio": "",
  "dadosConsulta.dtFim": "13/03/2024",
  "varasTreeSelection.values": "",
  "varasTreeSelection.text": "",
  "dadosConsulta.ordenacao": "DESC"
}

u = 'https://esaj.tjsp.jus.br/cjpg/pesquisar.do'

r0 = requests.get(u, params=query_dict)
# %%
# %%
with open('resultados-tjsp-requests.html', 'w') as f:
  f.write(r0.text)
# %%

import os

# create folder livetjsp/requests
os.makedirs('livetjsp/requests', exist_ok=True)

def baixar_pagina(pag):
  f_save = f'livetjsp/requests/{pag}.html'
  param_pagina = {'pagina': pag, 'conversationId': ''}
  u = 'https://esaj.tjsp.jus.br/cjpg/trocarDePagina.do'
  r = requests.get(u, params=param_pagina, cookies=r0.cookies)
  with open(f_save, 'w') as f:
    f.write(r.text)

# %%
paginas = 3
for pag in range(1, paginas+1):
  baixar_pagina(pag)
# %%
