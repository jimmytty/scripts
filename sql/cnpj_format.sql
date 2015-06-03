CREATE OR REPLACE FUNCTION cnpj_format(cnpj TEXT)
RETURNS TEXT AS $$
-- Função para (re)formatar CNPJs
-- Aviso: Esta função não valida CNPJ.
-- v0.01
-- by Ronaldo Ferreira de Lima aka jimmy <jimmy.tty@gmail.com>
DECLARE
    cnpj_length CONSTANT INTEGER := 14;
    arr                  TEXT[];
    cnpj_fmt             TEXT;
    raiz                 TEXT;  -- first eight digits
    sufixo               TEXT;  -- (slash) four digits
    digito               TEXT;  -- (hyphen) two digits
BEGIN

    cnpj_fmt := TRANSLATE(cnpj, TRANSLATE(cnpj, '0123456789', ''), '');

    IF LENGTH(cnpj_fmt) = 0 OR LENGTH(cnpj_fmt) > cnpj_length THEN
        RETURN NULL;
    END IF;

    cnpj_fmt := LPAD(cnpj_fmt, cnpj_length, '0');

    arr    := REGEXP_MATCHES(cnpj_fmt, '^(\d{8})(\d{4})(\d{2})$');
    raiz   :=
        ARRAY_TO_STRING(
            REGEXP_MATCHES(arr[1], '^(\d{2})(\d{3})(\d{3})$'),
            '.'
        );
    sufixo := arr[2];
    digito := arr[3];

    cnpj_fmt := FORMAT('%s/%s-%s', raiz, sufixo, digito);

    RETURN cnpj_fmt;

END
$$ LANGUAGE PLPGSQL IMMUTABLE;
