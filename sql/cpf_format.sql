CREATE OR REPLACE FUNCTION cpf_format(cpf TEXT)
RETURNS TEXT AS $$
-- Função para (re)formatar CPFs
-- Aviso: Esta função não valida CPF.
-- v0.01
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

    arr := REGEXP_MATCHES(cpf_fmt, '^(\d{8})(\d)(\d{2})$');

    aleatorio :=
        ARRAY_TO_STRING(
            REGEXP_MATCHES(arr[1], '^(\d{3})(\d{3})(\d{2})$'),
            '.'
        );
    regiao_fiscal := arr[2];
    digito := arr[3];

    cpf_fmt := FORMAT('%s%s-%s', aleatorio, regiao_fiscal, digito);

    RETURN cpf_fmt;

END
$$ LANGUAGE PLPGSQL IMMUTABLE;
