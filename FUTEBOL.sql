CREATE DATABASE FUTEBOL;


CREATE TABLE TIME_FUTEBOL
(
    NOME VARCHAR (50) NOT NULL,
    APELIDO VARCHAR (10) NOT NULL,
    DATA_CRIACAO DATE DEFAULT GETDATE(),
    PONTUACAO INT DEFAULT 0,


    CONSTRAINT PK_TIME_FUTEBOL PRIMARY KEY (NOME),
    CONSTRAINT UN_TIME_FUTEBOL UNIQUE (APELIDO)
);
GO

CREATE TABLE CAMPEONATO
(

    ID INT NOT NULL IDENTITY(1,1),
    ANO INT NOT NULL,
    NOME VARCHAR (20) NOT NULL,
    VENCEDOR_CAMPEONATO VARCHAR (50),

    CONSTRAINT PK_CAMPEONATO PRIMARY KEY (ID),
    CONSTRAINT UN_CAMPEONATO UNIQUE (ANO, NOME),

);
GO

CREATE TABLE JOGO
(
    PARTIDA INT NOT NULL IDENTITY(1,1),
    TIME_CASA VARCHAR (50) NOT NULL,
    TIME_VISITANTE VARCHAR (50) NOT NULL,
    QNT_GOLS_TIME_CASA INT DEFAULT 0,
    QNT_GOLS_TIME_VISITANTE INT DEFAULT 0,
    GANHADOR_PARTIDA VARCHAR (50) NULL,
    CAMPEONATO INT NOT NULL,



    CONSTRAINT PK_JOGO PRIMARY KEY (PARTIDA),
    CONSTRAINT FK_TIME_CASA FOREIGN KEY (TIME_CASA) REFERENCES TIME_FUTEBOL(NOME),
    CONSTRAINT FK_TIME_VISITANTE FOREIGN KEY (TIME_VISITANTE) REFERENCES TIME_FUTEBOL(NOME),
    CONSTRAINT FK_GANHADOR_JOGO FOREIGN KEY (GANHADOR_PARTIDA) REFERENCES TIME_FUTEBOL(NOME),
    CONSTRAINT FK_CAMPEONATO FOREIGN KEY (CAMPEONATO) REFERENCES CAMPEONATO(ID)
);
GO



--INSERCAO DOS TIMES

CREATE OR ALTER PROC INSERIR_TIME_FUTEBOL
    @NOME VARCHAR (50),
    @APELIDO VARCHAR (10)
AS
BEGIN
    INSERT INTO TIME_FUTEBOL
        ([NOME],[APELIDO])
    VALUES
        (
            @NOME,
            @APELIDO
        );
END;
GO



--CRIACAO CAMPEONATO

CREATE OR ALTER PROC INSERIR_CAMPEONATO
    @ANO INT,
    @NOME VARCHAR (20)
AS
BEGIN
    INSERT INTO CAMPEONATO
        ([ANO],[NOME])
    VALUES
        (
            @ANO,
            @NOME
        );
END;
GO




--INSERCAO DAS PARTIDAS 

CREATE OR ALTER PROC INSERIR_JOGO
    @TIME_CASA VARCHAR (50),
    @TIME_VISITANTE VARCHAR (50),
    @CAMPEONATO INT
AS
BEGIN
    INSERT INTO JOGO
        ([TIME_CASA],[TIME_VISITANTE], [CAMPEONATO])
    VALUES
        (
            @TIME_CASA,
            @TIME_VISITANTE,
            @CAMPEONATO
  
        );
END;
GO

--CADASTROS DE GOLS NA TABELA DO JOGO 

CREATE OR ALTER PROC ATUALIZAR_GOLS
    @QNT_GOLS_TIME_CASA INT,
    @QNT_GOLS_TIME_VISITANTE INT,
    @PARTIDA INT
AS
BEGIN

    UPDATE JOGO
     SET 
        QNT_GOLS_TIME_CASA = @QNT_GOLS_TIME_CASA, 
        QNT_GOLS_TIME_VISITANTE = @QNT_GOLS_TIME_VISITANTE 

    WHERE PARTIDA = @PARTIDA
END;
GO


--COLOCACAO DO GANHARDOR DA PARTIDA 

CREATE OR ALTER TRIGGER TGR_GANHADOR_PARTIDA ON JOGO AFTER UPDATE
AS
BEGIN
    DECLARE 
     @PARTIDA INT,
     @CAMPEONATO INT, 
     @TIME_CASA VARCHAR(50), 
     @TIME_VISITANTE VARCHAR (50),
     @QNT_GOLS_TIME_CASA INT, 
     @QNT_GOLS_TIME_VISITANTE INT,
     @GANHADOR_PARTIDA VARCHAR (50)

    SELECT
        @PARTIDA = PARTIDA,
        @CAMPEONATO = CAMPEONATO,
        @TIME_CASA = TIME_CASA,
        @TIME_VISITANTE = TIME_VISITANTE,
        @QNT_GOLS_TIME_CASA = QNT_GOLS_TIME_CASA,
        @QNT_GOLS_TIME_VISITANTE = QNT_GOLS_TIME_VISITANTE,
        @GANHADOR_PARTIDA = GANHADOR_PARTIDA
    FROM INSERTED

    IF (@GANHADOR_PARTIDA IS NULL)
    BEGIN
        IF(@QNT_GOLS_TIME_CASA > @QNT_GOLS_TIME_VISITANTE)
        BEGIN
            SET @GANHADOR_PARTIDA = @TIME_CASA
            UPDATE JOGO SET GANHADOR_PARTIDA = @GANHADOR_PARTIDA WHERE PARTIDA = @PARTIDA
        END;
        IF(@QNT_GOLS_TIME_VISITANTE > @QNT_GOLS_TIME_CASA)
        BEGIN
            SET @GANHADOR_PARTIDA = @TIME_VISITANTE
            UPDATE JOGO SET GANHADOR_PARTIDA = @GANHADOR_PARTIDA WHERE PARTIDA = @PARTIDA
        END;
    END
END;
GO


--TRIGGER PARA ATUALIZAR PONTOS DOS TIMES APOS PARTIDA

CREATE OR ALTER TRIGGER TGR_PONTUACAO ON JOGO AFTER UPDATE
AS
BEGIN
    DECLARE  
    @TIME_CASA VARCHAR(50), 
    @TIME_VISITANTE VARCHAR (50), 
    @QNT_GOLS_TIME_CASA INT, 
    @QNT_GOLS_TIME_VISITANTE INT,
    @PONTUACAO_CASA INT,
    @PONTUACAO_VISITANTE INT,
    @GANHADOR_PARTIDA VARCHAR (50)

    SELECT
        @TIME_CASA = TIME_CASA,
        @TIME_VISITANTE = TIME_VISITANTE,
        @QNT_GOLS_TIME_CASA = QNT_GOLS_TIME_CASA,
        @QNT_GOLS_TIME_VISITANTE = QNT_GOLS_TIME_VISITANTE,
        @GANHADOR_PARTIDA = GANHADOR_PARTIDA
    FROM INSERTED

    SELECT
        @PONTUACAO_CASA = PONTUACAO
    FROM TIME_FUTEBOL
    WHERE NOME = @TIME_CASA

    SELECT
        @PONTUACAO_VISITANTE = PONTUACAO
    FROM TIME_FUTEBOL
    WHERE NOME = @TIME_VISITANTE

    IF(@GANHADOR_PARTIDA IS NULL)
    BEGIN
        IF(@QNT_GOLS_TIME_CASA > @QNT_GOLS_TIME_VISITANTE)
        BEGIN
            SET @PONTUACAO_CASA = 3 + @PONTUACAO_CASA
            UPDATE TIME_FUTEBOL SET PONTUACAO = @PONTUACAO_CASA WHERE NOME = @TIME_CASA
        END;

        IF(@QNT_GOLS_TIME_VISITANTE > @QNT_GOLS_TIME_CASA)
        BEGIN

            SET @PONTUACAO_VISITANTE = 5 + @PONTUACAO_VISITANTE
            UPDATE TIME_FUTEBOL SET PONTUACAO = @PONTUACAO_VISITANTE WHERE NOME = @TIME_VISITANTE
        END;
        IF(@QNT_GOLS_TIME_VISITANTE = @QNT_GOLS_TIME_CASA)
            BEGIN
            SET @PONTUACAO_CASA = 1 + @PONTUACAO_CASA
            SET @PONTUACAO_VISITANTE = 1 + @PONTUACAO_VISITANTE
            UPDATE TIME_FUTEBOL SET PONTUACAO = @PONTUACAO_CASA WHERE NOME = @TIME_CASA
            UPDATE TIME_FUTEBOL SET PONTUACAO = @PONTUACAO_VISITANTE WHERE NOME = @TIME_VISITANTE
        END
    END
END;
GO


--LISTA DOS 5 PRIMEIROS TIMES DO CAMPEONATO

CREATE OR ALTER PROC LISTA_TOP_5
 @CAMPEONATO INT 
AS
BEGIN
   SELECT TOP(5)
            TF.NOME,
            TF.PONTUACAO,
            SUM(J.QNT_GOLS_TIME_CASA) + SUM(J.QNT_GOLS_TIME_VISITANTE) AS TOTAL_DE_GOLS,
            J.CAMPEONATO
        FROM CAMPEONATO AS CAMP
            JOIN JOGO AS J ON J.CAMPEONATO = CAMP.ID
            JOIN TIME_FUTEBOL AS TF ON TF.NOME = J.TIME_CASA
        GROUP BY TF.NOME, TF.PONTUACAO, J.CAMPEONATO
        ORDER BY TF.PONTUACAO DESC, TOTAL_DE_GOLS DESC, J.CAMPEONATO DESC
END; 
GO

-- VENCEDOR DO CAMPEONATO
CREATE OR ALTER PROCEDURE VENCEDOR_CAMPEONATO
    @CAMPEONATO INT
AS
BEGIN

    UPDATE CAMPEONATO 
    SET VENCEDOR_CAMPEONATO = CAMPEAO.NOME
    FROM(
        SELECT TOP(1)
            TF.NOME,
            TF.PONTUACAO,
            SUM(J.QNT_GOLS_TIME_CASA) + SUM(J.QNT_GOLS_TIME_VISITANTE) AS TOTAL_DE_GOLS,
            J.CAMPEONATO
        FROM CAMPEONATO AS CAMP
            JOIN JOGO AS J ON J.CAMPEONATO = CAMP.ID
            JOIN TIME_FUTEBOL AS TF ON TF.NOME = J.TIME_CASA
        GROUP BY TF.NOME, TF.PONTUACAO, J.CAMPEONATO
        ORDER BY TF.PONTUACAO DESC, TOTAL_DE_GOLS DESC, J.CAMPEONATO DESC
    ) AS CAMPEAO
    
WHERE CAMPEAO.CAMPEONATO = ID

END;
GO

--TIME QUE FEZ MAIS GOLS NO CAMPEONADO

CREATE OR ALTER PROC BUSCAR_TIME_COM_MAIOR_QNT_GOLS
    @CAMPEONATO INT
AS
BEGIN
    DECLARE 
    @QNT_GOLS_TIME_CASA INT,
    @QNT_GOLS_TIME_VISITANTE INT

    SELECT TOP (1)
        SUM(QNT_GOLS_TIME_CASA) + SUM(QNT_GOLS_TIME_VISITANTE) AS TOTAL_DE_GOLS,
        TIME_CASA,
        CAMPEONATO
    FROM JOGO
    WHERE CAMPEONATO = @CAMPEONATO
    GROUP BY TIME_CASA, CAMPEONATO
    ORDER BY TOTAL_DE_GOLS DESC

END;
GO

--TIME QUE TOMOU MAIS GOLS NO CAMPEONATO
CREATE OR ALTER PROC BUSCAR_TIME_QUE_TOMOU_MAIS_GOLS
    @CAMPEONATO INT
AS
BEGIN
    DECLARE
    @QNT_GOLS_TIME_CASA INT,
    @QNT_GOLS_TIME_VISITANTE INT

    SELECT TOP (1)
        TOTAL,
        TIME_FUTEBOL
    FROM
        (
            SELECT
                SUM(QNT_GOLS_TIME_CASA) AS TOTAL,
                CAMPEONATO,
                TIME_VISITANTE AS TIME_FUTEBOL
            FROM JOGO
            WHERE CAMPEONATO = @CAMPEONATO
            GROUP BY TIME_VISITANTE, CAMPEONATO
        UNION
            SELECT
                SUM(QNT_GOLS_TIME_VISITANTE) AS TOTAL,
                CAMPEONATO,
                TIME_CASA AS TIME_FUTEBOL
            FROM JOGO
            WHERE CAMPEONATO = @CAMPEONATO
            GROUP BY TIME_CASA,CAMPEONATO
    ) 
    AS TIME_QUE_MAIS_TOMOU_GOLS
    ORDER BY TOTAL DESC
    
END;
GO

-- PARTIDA QUE TEVE MAIS GOLS DO CAMPEONATO

CREATE OR ALTER PROC BUSCAR_PARTIDA_COM_MAIS_GOLS
    @CAMPEONATO INT
AS
BEGIN
    DECLARE 
    @PARTIDA INT,
    @TIME_CASA VARCHAR(50),
    @TIME_VISITANTE VARCHAR(50),
    @QNT_GOLS_TIME_CASA INT,
    @QNT_GOLS_TIME_VISITANTE INT

    SELECT
        TOP (1)
        PARTIDA,
        TIME_CASA,
        TIME_VISITANTE,
        QNT_GOLS_TIME_CASA + QNT_GOLS_TIME_VISITANTE AS TOTAL_GOLS,
        CAMPEONATO
    FROM JOGO
    WHERE CAMPEONATO = @CAMPEONATO
    ORDER BY TOTAL_GOLS DESC
END;
GO


--MAIOR NUMERO DE GOLS QUE CADA TIME FEZ EM UM ÚNICO JOGO

CREATE OR ALTER PROC BUSCAR_MAIOR_QNT_GOLS_TIME_PARTIDA
    @CAMPEONATO INT
AS
BEGIN
    DECLARE 
    @QNT_GOLS_TIME_VISITANTE INT,
    @QNT_GOLS_TIME_CASA INT,
    @TIME_VISITANTE VARCHAR (50),
    @TIME_CASA VARCHAR (50)

    SELECT 
        MAX(TOTAL) AS TOTAL,
        TIME_FUTEBOL,
        CAMPEONATO
    FROM
    (
        SELECT 
            MAX(QNT_GOLS_TIME_VISITANTE) AS TOTAL,
            TIME_VISITANTE AS TIME_FUTEBOL,
            CAMPEONATO
        FROM JOGO
        GROUP BY TIME_VISITANTE, CAMPEONATO
        UNION
        SELECT 
            MAX(QNT_GOLS_TIME_CASA) AS TOTAL,
            TIME_CASA AS TIME_FUTEBOL,
            CAMPEONATO
        FROM JOGO
        GROUP BY TIME_CASA, CAMPEONATO
    ) 
   AS TIME_GOLEADOR
    WHERE CAMPEONATO = @CAMPEONATO
    GROUP BY TIME_FUTEBOL, CAMPEONATO
    ORDER BY TOTAL DESC

END;
GO