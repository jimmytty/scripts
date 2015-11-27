CREATE OR REPLACE FUNCTION cpf_format(cpf TEXT)
RETURNS TEXT AS $$
-- Função para (re)formatar CPFs
-- Aviso: Esta função não valida CPF.
-- v0.02
-- by Ronaldo Ferreira de Lima aka jimmy <jimmy.tty@gmail.com>
DECLARE
    cpf_length CONSTANT INTEGER := 11;
    arr                 TEXT[];
    cpf_fmt             TEXT;
    aleatorio           TEXT;   -- first eigth digits
    regiao_fiscal       TEXT;   -- ninth digit
    digito              TEXT;   -- last two digits
BEGIN

    cpf_fmt := TRANSLATE(cpf, TRANSLATE(cpf, '0123456789', ''), '');

    IF LENGTH(cpf_fmt) = 0 OR LENGTH(cpf_fmt) > cpf_length THEN
        RETURN NULL;
    END IF;

    cpf_fmt := LPAD(cpf_fmt, cpf_length, '0');

    arr:= ARRAY[
         SUBSTRING(cpf_fmt, 1, 8)
        ,SUBSTRING(cpf_fmt, 9, 1)
        ,SUBSTRING(cpf_fmt, 10, 2)
    ];

    aleatorio := CONCAT(
         SUBSTRING(arr[1], 1,3)
        ,'.'
        ,SUBSTRING(arr[1], 4,7)
        ,'.'
        ,SUBSTRING(arr[1], 8)
    );
    regiao_fiscal := arr[2];
    digito        := arr[3];

    cpf_fmt := FORMAT('%s%s-%s', aleatorio, regiao_fiscal, digito);

    RETURN cpf_fmt;

END
$$ LANGUAGE PLPGSQL IMMUTABLE;
