--INSERIR TIMES
EXEC INSERIR_TIME_FUTEBOL 'PALMEIRAS', 'PAL'
EXEC INSERIR_TIME_FUTEBOL 'SAO PAULO', 'SAO'
EXEC INSERIR_TIME_FUTEBOL 'SANTOS', 'SAN'
EXEC INSERIR_TIME_FUTEBOL 'CORINTHIANS', 'COR'
EXEC INSERIR_TIME_FUTEBOL 'FERROVIARIA', 'FEO'


--SELECT * FROM TIME_FUTEBOL

EXEC INSERIR_CAMPEONATO 2000, 'PAULISTA'

--PARTIDA PALMEIRAS 
EXEC INSERIR_JOGO 'PALMEIRAS', 'SANTOS', 1
EXEC ATUALIZAR_GOLS 3,2,1
EXEC INSERIR_JOGO 'PALMEIRAS', 'CORINTHIANS', 1
EXEC ATUALIZAR_GOLS 2,2,2
EXEC INSERIR_JOGO 'PALMEIRAS', 'SAO PAULO', 1
EXEC ATUALIZAR_GOLS 1,2,3
EXEC INSERIR_JOGO 'PALMEIRAS', 'FERROVIARIA', 1
EXEC ATUALIZAR_GOLS 6,2,4
EXEC INSERIR_JOGO 'SANTOS','PALMEIRAS', 1
EXEC ATUALIZAR_GOLS 2,2,5
EXEC INSERIR_JOGO 'CORINTHIANS','PALMEIRAS', 1
EXEC ATUALIZAR_GOLS 2,2,6
EXEC INSERIR_JOGO 'SAO PAULO','PALMEIRAS', 1
EXEC ATUALIZAR_GOLS 1,2,7
EXEC INSERIR_JOGO 'FERROVIARIA','PALMEIRAS', 1
EXEC ATUALIZAR_GOLS 2,2,8

--PARTIDAS SANTOS
EXEC INSERIR_JOGO 'SANTOS', 'CORINTHIANS', 1
EXEC ATUALIZAR_GOLS 1,2,9
EXEC INSERIR_JOGO 'SANTOS', 'SAO PAULO', 1
EXEC ATUALIZAR_GOLS 4,2,10
EXEC INSERIR_JOGO 'SANTOS', 'FERROVIARIA', 1
EXEC ATUALIZAR_GOLS 3,3,11
EXEC INSERIR_JOGO 'CORINTHIANS','SANTOS', 1
EXEC ATUALIZAR_GOLS 4,2,12
EXEC INSERIR_JOGO 'SAO PAULO','SANTOS', 1
EXEC ATUALIZAR_GOLS 3,1,13
EXEC INSERIR_JOGO 'FERROVIARIA','SANTOS', 1
EXEC ATUALIZAR_GOLS 3,0,14

--PARTIDAS CORINTHIAS
EXEC INSERIR_JOGO 'CORINTHIANS', 'SAO PAULO', 1
EXEC ATUALIZAR_GOLS 2,3,15
EXEC INSERIR_JOGO 'CORINTHIANS', 'FERROVIARIA', 1
EXEC ATUALIZAR_GOLS 1,3,16
EXEC INSERIR_JOGO 'SAO PAULO','CORINTHIANS', 1
EXEC ATUALIZAR_GOLS 0,0,17
EXEC INSERIR_JOGO 'FERROVIARIA','CORINTHIANS', 1
EXEC ATUALIZAR_GOLS 1,0,18


--PARTIDAS SAO PAULO 
EXEC INSERIR_JOGO 'SAO PAULO','FERROVIARIA', 1
EXEC ATUALIZAR_GOLS 0,2,19 
EXEC INSERIR_JOGO 'FERROVIARIA','SAO PAULO', 1
EXEC ATUALIZAR_GOLS 1,1,20


SELECT * FROM JOGO
SELECT * FROM TIME_FUTEBOL



--QUEM É O CAMPEÃO NO FINAL DO CAMPEONATO? 
EXEC BUSCAR_VENCEDOR_CAMPEONATO

--COMO FAREMOS PARA VERIFICAR OS 5 PRIMEIROS TIMES DO CAMPEONATO?
EXEC LISTA_TOP_5

--QUEM É O TIME QUE MAIS FEZ GOLS NO CAMPEONATO?
EXEC BUSCAR_TIME_COM_MAIOR_QNT_GOLS

--QUEM É O TIME QUE TOMOU MAIS GOLS NO CAMPEONATO?
EXEC BUSCAR_TIME_QUE_TOMOU_MAIS_GOLS

--QUAL É O JOGO QUE TEVE MAIS GOLS?
EXEC BUSCAR_PARTIDA_COM_MAIS_GOLS

--QUAL É O MAIOR NUMERO DE GOLS QUE CADA TIME FEZ EM UM UNICO JOGO?
EXEC BUSCAR_MAIOR_QNT_GOLS_TIME_PARTIDA