CREATE OR REPLACE FUNCTION cpf_format(cpf TEXT)
RETURNS TEXT AS $$
-- Função para (re)formatar CPFs
-- Aviso: Esta função não valida CPF.
-- v0.03
-- by Ronaldo Ferreira de Lima aka jimmy <jimmy.tty@gmail.com>
DECLARE
    cpf_length CONSTANT INTEGER := 11;
    arr                 INTEGER[];
    cpf_num             BIGINT;
    cpf_fmt             TEXT;
BEGIN

    cpf_fmt := TRANSLATE(cpf, TRANSLATE(cpf, '0123456789', ''), '');
    cpf_num := cpf_fmt::BIGINT;

    IF cpf_num = 0 OR cpf_num > 1e11 THEN
        RETURN NULL;
    END IF;

    arr[1]  := TRUNC( cpf_num / 1e8 );
    cpf_num := cpf_num - arr[1] * 1e8;
    arr[2]  := TRUNC(cpf_num / 1e5);
    cpf_num := cpf_num - arr[2] * 1e5;
    arr[3]  := TRUNC(cpf_num / 1e2);
    cpf_num := cpf_num - arr[3] * 1e2;
    arr[4]  := cpf_num;

    cpf_fmt := CONCAT(
         LPAD(arr[1]::TEXT, 3, '0')
        ,'.'
        ,LPAD(arr[2]::TEXT, 3, '0')
        ,'.'
        ,LPAD(arr[3]::TEXT, 3, '0')
        ,'-'
        ,LPAD(arr[4]::TEXT, 2, '0')
    );

    RETURN cpf_fmt;

END
$$ LANGUAGE PLPGSQL IMMUTABLE;
